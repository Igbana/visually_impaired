import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/message.dart';

class LLMService {
  final loading = false.obs;

  Future<LLMService> init() async {
    return this;
  }

  Future<BotMessage> getResponse(String body) async {
    const apiKey = "AIzaSyDcIqGkzrc2ZejrhsdWZpYKKF2EniOaAIM";
    final uri = Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent')
        .replace(queryParameters: {
      'key': apiKey,
    });
    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      final Map data = json.decode(response.body);
      return BotMessage.fromJson(
          json.decode(data['candidates'][0]['content']['parts'][0]['text']));
    } else {
      throw Exception('Failed to load symbols');
    }
  }
}
