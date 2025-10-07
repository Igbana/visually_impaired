import 'dart:async';
import 'package:get/get.dart';
import '../views/register.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:visually_impaired/common/helper.dart';
import 'package:visually_impaired/models/message.dart';
import 'package:visually_impaired/services/llm_service.dart';
import 'package:visually_impaired/services/speech_service.dart';
import 'package:visually_impaired/modules/auth/views/login.dart';
import 'package:visually_impaired/repositories/llm_repository.dart';
import 'package:visually_impaired/modules/auth/controllers/actions.dart';

class AuthController extends GetxController {
  AuthController() {
    _llmRepo = LLMRepository();
    screens = [
      const SplashView(),
      LoginView(controller: this),
      RegisterView(controller: this),
      const SuccessView(),
    ];
  }

  final hidePassword = true.obs;
  final loading = false.obs;
  final remember = false.obs;
  final pageIndex = 0.obs;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final deptController = TextEditingController();
  final userIdController = TextEditingController();
  final pageController = PageController();
  final waveController = IOS9SiriWaveformController(
    amplitude: 1,
    color1: Colors.red,
    color2: Colors.green,
    color3: Colors.blue,
    speed: 0.15,
  );

  late List screens;
  final screenIndex = 0.obs;
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

  @override
  void onInit() async {
    super.onInit();
    await _llmRepo.respond("Hi", getScreen(), getActions());
    Get.find<SpeechService>().startListening();
    Get.find<SpeechService>().streamData.listen((data) {
      Get.log('''Live Text: ${data.liveResponse},
        Final Text: ${data.entireResponse},
        isListening: ${data.isListening}
        ''', isError: data.isListening);
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
        action(await _llmRepo.respond(text, getScreen(), getActions()));
        Get.log('Responded');
        Get.find<LLMService>().loading.value = false;
        Get.find<SpeechService>().startListening();
      }
      _timer = null;
    });
  }

  void action(BotMessage message) async {
    switch (message.action) {
      case "LOGIN":
        if (screenIndex.value != 1) {
          screenIndex.value = 1;
          await _llmRepo.respond("NEWPAGE", getScreen(), getActions());
        } else {
          login();
        }
        break;
      case "SIGNUP":
        if (screenIndex.value != 2) {
          screenIndex.value = 2;
          await _llmRepo.respond("NEWPAGE", getScreen(), getActions());
        } else {
          register();
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
        pageIndex.value += 1;
        break;
      case "ENTER_PHONE":
        phoneController.text = message.input;
        pageIndex.value += 1;
        break;
      case "ENTER_DEPARTMENT":
        deptController.text = message.input;
        screenIndex.value += 1;
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
      return ScreenAction.splash;
    } else if (screenIndex.value == 1) {
      return ScreenAction.login;
    } else if (screenIndex.value == 2) {
      return ScreenAction.signup(pageIndex.value);
    } else {
      return [];
    }
  }

  String getScreen() {
    if (screenIndex.value == 0) {
      return "WELCOME";
    } else if (screenIndex.value == 1) {
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
      await Get.find<SpeechService>().speak("User ID is required");
      return;
    } else if (userIdController.text.length < 6) {
      await Get.find<SpeechService>()
          .speak("User ID must be at least 6 characters");
      return;
    } else {
      screenIndex.value = 3;
    }
  }

  void register() async {
    if (pageIndex.value == 0 && nameController.text.isEmpty) {
      Get.find<SpeechService>().speak("Full name is required");
    } else if (pageIndex.value == 1 && phoneController.text.isEmpty) {
      Get.find<SpeechService>().speak("Phone number is required");
      return;
    } else if (pageIndex.value == 2 && deptController.text.isEmpty) {
      Get.find<SpeechService>().speak("Department is required");
      return;
    } else {
      screenIndex.value = 3;
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

class SuccessView extends StatelessWidget {
  const SuccessView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            Lottie.asset('assets/congratulations.json'),
            Text(
              "Congratulations, You have successfully registered",
              style: Get.textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            Lottie.asset('assets/congratulations.json'),
            Text(
              "Hello, Welcome to VI Assistant",
              style: Get.textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
