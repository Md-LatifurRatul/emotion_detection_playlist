import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:emotion_music_app/model/chat_user_model.dart';
import 'package:emotion_music_app/ui/screens/chat-screen/widgets/model_submit_button.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _textController = TextEditingController();
  final ChatUserModel chatUserModel = ChatUserModel();
  bool isDart = false;
  bool isTTS = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI-Chat'),

        centerTitle: true,
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
            invertColors: isDart,
          ),
        ),
        child: Form(
          key: _formKey,

          child: Column(
            children: [
              _promtOutputText(),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: _textInputField()),
                    const SizedBox(width: 5),
                    ModelSubmitButton(
                      bgColor: Colors.green.shade400,
                      icon: Icon(Icons.mic),
                      onPressed: () {
                        // _startListening();
                      },
                    ),
                    ModelSubmitButton(
                      bgColor: Colors.blue,
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // processWithAiModel();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _promtOutputText() {
    return Expanded(
      child: DashChat(
        currentUser: ChatUserModel.user,
        onSend: (ChatMessage m) {},
        messages: chatUserModel.messages,
        readOnly: true,
      ),
    );
  }

  Widget _textInputField() {
    return TextFormField(
      autofocus: true,
      style: TextStyle(color: Colors.black),
      onFieldSubmitted: (value) {},
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Provide Text";
        }
        return null;
      },
      controller: _textController,
      decoration: InputDecoration(
        hintText: 'Enter the question?',
        suffixIcon: IconButton(
          onPressed: () {
            // _pickImage();
          },
          icon: Icon(Icons.image),
        ),
      ),
    );
  }
}
