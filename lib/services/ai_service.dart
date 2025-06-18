import 'package:emotion_music_app/core/ai_model.dart';
import 'package:emotion_music_app/core/secret_key.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  late GenerativeModel model;
  late ChatSession chat;

  List<Content> conversationHistory = [];

  final String _modelName = aiModel;
  AiService() {
    model = GenerativeModel(model: _modelName, apiKey: SecretKey.apiKey);

    chat = model.startChat();
  }
}
