import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController promptController = TextEditingController();
  late GenerativeModel model;
  List<Map<String, String>> chatHistory = [];
  bool isStreaming = false;
  final generationConfig = GenerationConfig(
    maxOutputTokens: 200,
    temperature: 0.2,
  );

  @override
  void initState() {
    super.initState();
    model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: 'AIzaSyDP05oAHevBU4iWKt5DZiMrM6nIhmcdyq4',
      generationConfig: generationConfig,
    );
  }

  void addBotMessage(String message) {
    chatHistory.add({'text': message, 'source': 'AI'});
  }

  Future<void> sendMessage(String message) async {
    final content = Content.text(message);

    setState(() {
      chatHistory.add({'text': message, 'source': 'User'});
      chatHistory.add({'text': '...', 'source': 'AI'});
      isStreaming = true;
    });

    String responseText;

    if (message.startsWith('add:')) {
      final plantName = message.substring(4).trim();
      final prompt = '''
      I need detailed information about the plant "$plantName". 
      Please provide the following details in JSON format:
      {
        "name": "Name of the Plant",
        "variety": "fruit or vegetable, choose between",
        "description": "Description of the Plant",
        "temp_max": "Maximum Ideal Temperature in general",
        "temp_min": "Minimum Ideal Temperature in general",
        "water_need": "Water Needs, choose between these in general"
      }
      Example:
      {
        "name": "Tomato",
        "variety": "Fruit",
        "description": "Medium-sized, round red fruit with a slightly tangy flavor.",
        "temp_max": 25,
        "temp_min": 16,
        "water_need": "Moderate|Low|Regular|Minimal"
      } 
      or ```json
      {
        "name": "Oignon",
        "variety": "Vegetable",
        "description": "The onion is a bulb vegetable, characterized by its pungent taste and layered bulb. It is commonly used in cooking around the world, adding flavor to both raw and cooked dishes.",
        "temp_max": "25",
        "temp_min": "13",
        "water_need": "Moderate"
      }
      ```
      If you cannot find specific information, state 'Information not available'.
      ''';

      final response = model.generateContentStream([Content.text(prompt)]);
      String accumulatedResponse = '';
      await for (final chunk in response) {
        accumulatedResponse += chunk.text ?? '';
        setState(() {
          chatHistory.last['text'] = '$accumulatedResponse...';
        });
      }

      //print('AI Response: $accumulatedResponse');

      responseText = formatResponseAsJson(accumulatedResponse);
    } else {
      final response = model.generateContentStream([content]);
      String accumulatedResponse = '';
      await for (final chunk in response) {
        accumulatedResponse += chunk.text ?? '';
        setState(() {
          chatHistory.last['text'] = '$accumulatedResponse...';
        });
      }
      responseText = accumulatedResponse;
    }

    setState(() {
      chatHistory.last['text'] = responseText;
      isStreaming = false;
    });
  }

  String formatResponseAsJson(String response) {
    String cleanedResponse = response.replaceAll(RegExp(r'```|json'), '').trim();

    try {
      final jsonResponse = jsonDecode(cleanedResponse) as Map<String, dynamic>;

      // Clean and map the response fields
      final plantInfo = {
        'name': jsonResponse['name'] ?? 'Unknown',
        'variety': simplifyVariety(jsonResponse['variety']) ?? 'Unknown',
        'description': jsonResponse['description'] ?? 'Unknown',
        'temp_max': formatTemperature(jsonResponse['temp_max']),
        'temp_min': formatTemperature(jsonResponse['temp_min']),
        'water_need': convertWaterNeed(jsonResponse['water_need'])
      };

      return jsonEncode(plantInfo);
    } catch (e) {
      print('Error parsing JSON response: $e');
      return jsonEncode({
        'name': 'Unknown',
        'variety': 'Unknown',
        'description': 'Unknown',
        'temp_max': 'Unknown',
        'temp_min': 'Unknown',
        'water_need': 'Unknown'
      });
    }
  }

  String simplifyVariety(String? variety) {
    // Simplify variety to 'Fruit' or 'Vegetable'
    if (variety == null) return 'Unknown';
    return variety.contains('Vegetable') ? 'Vegetable' : 'Fruit';
  }

  String formatTemperature(dynamic temperature) {
    if (temperature == null) return 'Unknown';
    return temperature.toString();
  }

  String convertWaterNeed(String? waterNeed) {

    if (waterNeed == null) return 'Unknown';

    // Simplified scale from 0 to 5
    if (waterNeed.contains('Regular')) return '4';
    if (waterNeed.contains('Moderate')) return '3';
    if (waterNeed.contains('Low')) return '2';
    if (waterNeed.contains('Minimal')) return '1';
    return '0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with mIAly'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true, // Start from bottom
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: chatHistory.length,
                    itemBuilder: (context, index) {
                      final message = chatHistory[index];
                      final isUser = message['source'] == 'User';
                      final bgColor = isUser ? Colors.blue[50] : Colors.grey[200];
                      final textColor = isUser ? Colors.black : Colors.blue;
                      final icon = isUser ? Icons.person : Icons.chat_bubble_outline_rounded;

                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(icon, color: textColor, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    message['text']!,
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 80), // Spacer for extra space at the bottom
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: promptController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) {
                      if (value.isNotEmpty && !isStreaming) {
                        sendMessage(value);
                        promptController.clear();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (promptController.text.isNotEmpty && !isStreaming) {
                            sendMessage(promptController.text);
                            promptController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
