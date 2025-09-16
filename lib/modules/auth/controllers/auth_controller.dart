import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:visually_impaired/common/helper.dart';
import 'package:visually_impaired/models/message.dart';
import 'package:visually_impaired/modules/auth/views/login.dart';
import 'package:visually_impaired/repositories/llm_repository.dart';
import 'package:visually_impaired/services/llm_service.dart';
import 'package:visually_impaired/services/speech_service.dart';
import '../views/register.dart';

class AuthController extends GetxController {
  final hidePassword = true.obs;
  final loading = false.obs;
  final remember = false.obs;
  final pageIndex = 0.obs;

  final userIdController = TextEditingController();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final stateController = TextEditingController();
  final difficultyLevel = "Beginner".obs;
  final difficultyLevels = [
    "Beginner",
    "Intermediate",
    "Advanced",
  ];
  final speechSpeed = "".obs;
  final speechSpeeds = [
    "Slow",
    "Medium",
    "Fast",
  ];
  final feedbackType = "".obs;
  final feedbackTypes = [
    "Immediate corrections",
    "Gentle hints first",
    "Detailed explanations after mistakes",
  ];

  final pageController = PageController();
  final waveController = IOS9SiriWaveformController(
    amplitude: 1,
    color1: Colors.red,
    color2: Colors.green,
    color3: Colors.blue,
    speed: 0.15,
  );

  late List screens;
  final screenIndex = 2.obs;

  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  final isListening = false.obs;
  final lastWords = ''.obs;
  final lastError = ''.obs;
  String lastStatus = '';

  Timer? _timer;
  final Duration _delay = const Duration(seconds: 3);
  late LLMRepository _llmRepo;

  AuthController() {
    _llmRepo = LLMRepository();
    screens = [
      LoginView(controller: this),
      RegisterView(controller: this),
      Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Lottie.asset('assets/congratulations.json'),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Congratulations, You have successfully registered",
                    style: Get.textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  void onInit() async {
    // await initSpeechState();
    super.onInit();
    Get.find<SpeechService>().stream.listen((data) {
      Get.log(
          'Live Text: ${data.liveResponse}, Final Text: ${data.entireResponse}, isListening: ${data.isListening}');
      if (data.liveResponse != lastWords.value) done(data.liveResponse);
      lastWords.value = data.liveResponse;
      isListening.value = data.isListening;
    });
  }

  void done(String text) {
    _timer?.cancel();
    _timer = Timer(_delay, () async {
      if (text.isNotEmpty) {
        Get.log('Thinking');
        Get.find<LLMService>().loading.value = true;
        Get.find<SpeechService>().stopListening();
        // await Future.delayed(Duration(seconds: 20));
        action(await _llmRepo.respond(text, getScreen(), getActions()));
        Get.log('Responded');
        Get.find<LLMService>().loading.value = false;
        Get.find<SpeechService>().startListening();
      }
      _timer = null;
    });
  }

  void action(BotMessage message) {
    switch (message.action) {
      case "LOGIN":
        if (screenIndex.value == 0) {
          login();
        } else {
          screenIndex.value = 0;
        }
        break;
      case "SIGNUP":
        if (screenIndex.value == 1) {
          register();
        } else {
          screenIndex.value = 1;
        }
        break;
      case "FORGOT_PASS":
        sendResetLink();
        break;
      case "REMEMBER_PASS":
        remember.toggle();
        break;
      case "ENTER_USER_ID":
        userIdController.text = message.input;
        break;
      case "ENTER_FULL_NAME":
        nameController.text = message.input;
        break;
      case "ENTER_PHONE":
        phoneController.text = message.input;
        break;
      case "ENTER_STATE":
        stateController.text = message.input;
        break;
      case "TERMS":
        openTos();
        break;
      case "PRIVACY":
        openPrivacy();
        break;
    }
  }

  List<String> getActions() {
    if (screenIndex.value == 0) {
      return [
        "LOGIN (Log the user in)",
        "SIGNUP (Go to register screen)",
        "ENTER_USER_ID (Insert user id)",
        "FORGOT_PASS (Forgot your password)",
        "REMEMBER_PASS (Toggle remember password)",
        "TERMS (View terms of service)",
        "PRIVACY (View privacy policy)",
      ];
    } else {
      return [
        "LOGIN (Go to login screen)",
        "SIGNUP (Register the user)",
        "ENTER_FULL_NAME (Insert user full name)",
        "ENTER_PHONE (Insert user phone number)",
        "ENTER_STATE (Insert user state of origin)",
        "TERMS (View terms of service)",
        "PRIVACY (View privacy policy)",
      ];
    }
  }

  String getScreen() {
    if (screenIndex.value == 0) {
      return "LOGIN";
    } else {
      return "SIGNUP";
    }
  }

  void test() async {
    // screenIndex.value = 1;
    // final bot = BotMessage();
    // bot.action = "SIGNUP";
    // action(bot);
    // action(await _llmRepo.respond("Hello, I want to login. My userid is 18908, sorry 1234567"));
  }

  void login() async {
    if (userIdController.text.isEmpty) {
      Get.find<SpeechService>().speak("User ID is required");
      return;
    } else if (userIdController.text.length < 6) {
      Get.find<SpeechService>().speak("User ID must be at least 6 characters");
      return;
    } else {
      screenIndex.value = 2;
    }
  }

  void register() async {
    if (nameController.text.isEmpty) {
      Get.find<SpeechService>().speak("Full name is required");
      return;
    } else if (phoneController.text.isEmpty) {
      Get.find<SpeechService>().speak("Phone number is required");
      return;
    } else if (stateController.text.isEmpty) {
      Get.find<SpeechService>().speak("State of origin is required");
      return;
    } else {
      screenIndex.value = 2;
    }
  }

  void sendResetLink() async {}

  void openTos() {
    Helper.openUrl("https://www.facebook.com");
  }

  void openPrivacy() {
    Helper.openUrl("https://www.google.com");
  }
}
