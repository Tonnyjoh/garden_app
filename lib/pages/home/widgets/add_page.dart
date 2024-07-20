import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController promptController = TextEditingController();
  late GenerativeModel model;
  List<Map<String, String>> chatHistory = [];

  @override
  void initState() {
    super.initState();
    model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: 'AIzaSyDP05oAHevBU4iWKt5DZiMrM6nIhmcdyq4', // Replace with your API key
      generationConfig: GenerationConfig(maxOutputTokens: 100),
    );
    // Initial welcome messages
  }

  void addBotMessage(String message) {
    chatHistory.add({'text': message, 'source': 'AI'});
  }

  Future<void> sendMessage(String message) async {
    final content = Content.text(message);
    final response = await model.generateContent([content]);

    // Example filtering: Remove any mention of 'badword' in the response
    final filteredResponse = response.text?.replaceAll('badword', '***');

    setState(() {
      chatHistory.add({'text': message, 'source': 'User'});
      chatHistory.add({'text': filteredResponse as String, 'source': 'AI'});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with AI'),
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
                      final alignment = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                      final bgColor = isUser ? Colors.blue[50] : Colors.grey[200];
                      final textColor = isUser ? Colors.black : Colors.blue;
                      final icon = isUser ? Icons.person : Icons.chat_bubble;

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
                  SizedBox(height: 80), // Spacer for extra space at the bottom
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
                      if (value.isNotEmpty) {
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
                          if (promptController.text.isNotEmpty) {
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
