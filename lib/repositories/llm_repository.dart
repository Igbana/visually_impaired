import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:visually_impaired/models/message.dart';
import 'package:visually_impaired/prompts/auth.dart';
import 'package:visually_impaired/services/llm_service.dart';
import 'package:visually_impaired/services/speech_service.dart';

class LLMRepository {
  late LLMService llmService;
  late SpeechService speechService;
  final List<Message> messages = [];

  LLMRepository() {
    llmService = Get.find<LLMService>();
    speechService = Get.find<SpeechService>();
  }

  Future<BotMessage> respond(
    String message,
    String screen,
    List<String> actions,
  ) async {
    messages.clear();
    print("Respond is called");
    messages.insert(
        0,
        UserMessage(
          text: message,
        ));
    try {
      final message =
          await llmService.getResponse(getGeminiPrompt(screen, actions));
      return message;
    } catch (e) {
      Get.log(e.toString()); // Speak out the error
      messages.removeLast();
      await speechService.speak(e.toString());
    }
    return BotMessage();
  }

  void shutUp() {
    // messages.clear();
  }

  String getGeminiPrompt(String screen, List<String> actions,
          {Uint8List? pdf}) =>
      json.encode({
        "contents": [...messages.reversed.map((e) => e.toJson())],
        "systemInstruction": {
          "role": "user",
          "parts": [
            pdf != null
                ? {
                    "inline_data": {
                      "mime_type": "application/pdf",
                      "data": base64Encode(pdf!)
                    }
                  }
                : null,
            {"text": prompt(screen, actions)}
          ]
        },
        "generationConfig": {
          "temperature": 0,
          "topK": 64,
          "topP": 0.95,
          "maxOutputTokens": 8192,
          "responseMimeType": "application/json",
          "responseSchema": {
            "type": "object",
            "properties": {
              "action": {"type": "string"},
              "input": {"type": "string"},
              "message": {"type": "string"}
            }
          }
        }
      });
}
