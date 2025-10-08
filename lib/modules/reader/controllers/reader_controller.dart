import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:visually_impaired/common/helper.dart';
import 'package:visually_impaired/models/message.dart';
import 'package:visually_impaired/services/llm_service.dart';
import 'package:visually_impaired/services/speech_service.dart';
import 'package:visually_impaired/repositories/llm_repository.dart';
import 'package:visually_impaired/modules/auth/controllers/actions.dart';

class ReaderController extends GetxController {
  ReaderController() {
    _llmRepo = LLMRepository();
    screens = [];
  }

  final hidePassword = true.obs;
  final loading = false.obs;
  final remember = false.obs;
  final pageIndex = 0.obs;

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
    // done("NEWPAGE");
    //   Get.find<SpeechService>().startListening();
    //   Get.find<SpeechService>().streamData.listen((data) {
    //     Get.log(
    //         'Live Text: ${data.liveResponse}, Final Text: ${data.entireResponse}, isListening: ${data.isListening}',
    //         isError: data.isListening);
    //     if (data.liveResponse != lastWords.value) done(data.liveResponse);
    //     lastWords.value = data.liveResponse;
    //     isListening.value = data.isListening;
    //   });
  }

  void done(String text) {
    _timer?.cancel();
    _timer = Timer(_delay, () async {
      if (text.isNotEmpty) {
        Get.log('Thinking');
        isListening.value = false;
        try {
          Get.find<SpeechService>().stopListening();
        } catch (e) {
          null;
        }
        Get.find<LLMService>().loading.value = true;
        // action(await _llmRepo.respond(text, getScreen(), getActions()));
        // Get.log('Responded');
        // Get.find<LLMService>().loading.value = false;
        // isListening.value = true;
        // Get.find<SpeechService>().startListening();
        await _llmRepo.respond(text, getScreen(), getActions()).then((resp) {
          action(resp);
          Get.log('Responded');
          Get.find<LLMService>().loading.value = false;
          isListening.value = true;
          try {
            Get.find<SpeechService>().startListening();
          } catch (e) {
            null;
          }
        });
      }
      _timer = null;
    });
  }

  void action(BotMessage message) {
    switch (message.action) {
      case "LOGIN":
        if (screenIndex.value != 1) {
          screenIndex.value = 1;
          done("NEWPAGE");
        }
        break;
      case "SIGNUP":
        if (screenIndex.value != 2) {
          screenIndex.value = 2;
          pageIndex.value = 0;
          done("NEWPAGE");
        }
        break;
      case "FORGOT_PASS":
        sendResetLink();
        break;
      case "REMEMBER_PASS":
        remember.toggle();
        break;
      case "GO_BACK":
        pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
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

  void sendResetLink() async {}

  void openTos() {
    Helper.openUrl("https://www.facebook.com");
  }

  void openPrivacy() {
    Helper.openUrl("https://www.google.com");
  }
}
