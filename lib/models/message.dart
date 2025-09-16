import 'package:visually_impaired/models/model.dart';

abstract class Message extends Model {
  String? role;

  Message({this.role});

  Message.fromJson(Map<String, dynamic> json);

  @override
  Map<String, dynamic> toJson();
}

class UserMessage extends Message {
  String text = '';
  UserMessage({required this.text}) : super(role: 'user');

  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'parts': [
        {
          "text": text,
        },
      ],
    };
  }
}

class BotMessage extends Message {
  String action = '';
  String input = '';
  String message = '';
  BotMessage() : super(role: 'model');

  BotMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    role = 'model';
    action = stringFromJson(json, 'action');
    input = stringFromJson(json, 'input');
    message = stringFromJson(json, 'message');
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'parts': [
        {
          "text": "{'action': '$action', 'input': '$input', 'message': '$message'}",
        },
      ],
    };
  }
}