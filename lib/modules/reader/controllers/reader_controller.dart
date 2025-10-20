import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
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
  Timer? _readerTimer;
  final Duration _delay = const Duration(seconds: 3);
  final Duration _readerDelay = const Duration(seconds: 1);
  late LLMRepository _llmRepo;

  @override
  void onInit() async {
    super.onInit();
    Get.find<SpeechService>().startListening();
    readDoc(1);
    Get.find<SpeechService>().streamData.listen((data) {
      print(data.liveResponse);
      if (data.liveResponse.contains("wait")) {
        Get.find<SpeechService>().interrupt();
        print("Interrupted");
      }
      Get.log(
          'Live Text: ${data.liveResponse}, Final Text: ${data.entireResponse}, isListening: ${data.isListening}',
          isError: data.isListening);
      // if (data.liveResponse != lastWords.value) done(data.liveResponse);
      lastWords.value = data.liveResponse;
      isListening.value = data.isListening;
    });
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

  void readDoc(int page) async {
    final Uint8List bytes = await loadPdfAsset('assets/doc/CIT101.pdf');
    final PdfDocument document = PdfDocument(inputBytes: bytes);

    // Readt the text, remove all line breaks and split by spaces
    List textItems = PdfTextExtractor(document)
        .extractText(startPageIndex: 3, endPageIndex: 4)
        .replaceAll("\n", "")
        .split(" ");
    // Final text
    String text = "";

    // Removing blank items in text
    for (String txt in textItems) {
      if (txt.isBlank ?? false) txt = ".";
      for (String i in txt.split("")) {
        if (i.isBlank ?? false) txt = txt.replaceAll(i, "");
      }
      text += txt == "." ? "." : " $txt";
    }

    // Split text into Lines.
    final List<String> sentences = text.split(".");
    for (String sentence in sentences) {
      Get.find<SpeechService>().interruptibleSpeak(sentence);
      _readerTimer?.cancel();
      _readerTimer = Timer(_readerDelay, () async {
        // if (text.isNotEmpty) {
        //   Get.log('Thinking');
        //   isListening.value = false;
        //   try {
        //     Get.find<SpeechService>().stopListening();
        //   } catch (e) {
        //     null;
        //   }
        //   Get.find<LLMService>().loading.value = true;
        //   await _llmRepo.respond(text, getScreen(), getActions()).then((resp) {
        //     action(resp);
        //     Get.log('Responded');
        //     Get.find<LLMService>().loading.value = false;
        //     isListening.value = true;
        //     try {
        //       Get.find<SpeechService>().startListening();
        //     } catch (e) {
        //       null;
        //     }
        //   });
        // }
        _timer = null;
      });
    }
  }

  Future<Uint8List> loadPdfAsset(String assetPath) async {
    return await DefaultAssetBundle.of(Get.context!).load(assetPath).then(
          (data) => data.buffer.asUint8List(),
        );
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
      case "REMEMBER_PASS":
        remember.toggle();
        break;
      case "GO_BACK":
        pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
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
}
