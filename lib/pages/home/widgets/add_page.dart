import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    // Add a welcome message
    chatHistory.add({'text': 'If you want to add plant, type "add: your_plant"', 'source': 'AI'});
  }

  void addBotMessage(String message) {
    chatHistory.add({'text': message, 'source': 'AI'});
  }

  Future<void> sendMessage(String message) async {
    if(message.isNotEmpty){
      final content = Content.text(message);
      setState(() {
        chatHistory.add({'text': message, 'source': 'User'});
        chatHistory.add({'text': '', 'source': 'AI'});
        isStreaming = true;
      });

      String responseText;

      try {
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
        or 
        {
          "name": "Oignon",
          "variety": "Vegetable",
          "description": "The onion is a bulb vegetable, characterized by its pungent taste and layered bulb. It is commonly used in cooking around the world, adding flavor to both raw and cooked dishes.",
          "temp_max": "25",
          "temp_min": "13",
          "water_need": "Moderate"
        }
        or
        {"name":"Rose","variety":"flower","description":"Roses are perennial flowering shrubs known for their beautiful and fragrant flowers. They come in a wide variety of colors, shapes, and sizes, and are popular for gardens, bouquets, and as symbols of love and beauty.","temp_max":"27","temp_min":"7","water_need":"3"}
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

          responseText = formatResponseAsJson(accumulatedResponse);
          try {
            final plantData = jsonDecode(responseText) as Map<String, dynamic>;
            await insertPlantData(plantData);
          } catch (e) {
            print('Erreur lors de l\'insertion des données de la plante: $e');
          }
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
      } catch (e) {
        print('Erreur lors de la génération de contenu: $e');
        responseText = 'Désolé, une erreur est survenue. Veuillez réessayer.';
      }

      setState(() {
        chatHistory.last['text'] = responseText;
        isStreaming = false;
      });
    }
  }

  Future<void> insertPlantData(Map<String, dynamic> plantData) async {
    final supabase = Supabase.instance.client;
    final plantResponse = await supabase.from('plants').insert({
      'name': plantData['name'],
      'variety': plantData['variety'],
      'description': plantData['description'],
    }).select();

    if (plantResponse.isNotEmpty) {
      final plantId = plantResponse.first['id_plant'];

      await supabase.from('plant_indicators').insert({
        'id_plant': plantId,
        'temp_max': plantData['temp_max'],
        'temp_min': plantData['temp_min'],
        'water_need': plantData['water_need'],
      });
    }
  }

  String formatResponseAsJson(String response) {
    String cleanedResponse =
    response.replaceAll(RegExp(r'```|json'), '').trim();

    try {
      final jsonResponse = jsonDecode(cleanedResponse) as Map<String, dynamic>;

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
      print('Erreur lors de la conversion JSON: $e');
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
    if (variety == null) return 'Unknown';
    if (variety.contains('Vegetable')) {
      return 'Vegetable';
    } else if (variety.contains('Fruit')) {
      return 'Fruit';
    } else {
      return 'Flower';
    }
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

  Widget buildMessage(Map<String, String> message) {
    final isUser = message['source'] == 'User';
    final bgColor = isUser ? Colors.blue[50] : Colors.grey[200];
    final textColor = isUser ? Colors.black : Colors.blue;
    final avatar = isUser
        ? CircleAvatar(
      child: Image.asset(
        'assets/images/avatar.png',
        fit: BoxFit.cover,
      ),
    )
        : CircleAvatar(
      child: Image.asset(
        'assets/images/chatbot.png',
        fit: BoxFit.cover,
      ),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: avatar,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message['text'] ?? '',
                    style: TextStyle(color: textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with your friend'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: chatHistory.length,
                    itemBuilder: (context, index) {
                      return buildMessage(chatHistory[index]);
                    },
                  ),
                  if(isStreaming) const LinearProgressIndicator(
                    backgroundColor: Colors.blue,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: promptController,
                    onSubmitted: (value) => sendMessage(value),
                    decoration: const InputDecoration(
                      labelText: 'Enter your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: () {
                    sendMessage(promptController.text);
                    promptController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
