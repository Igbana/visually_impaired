import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_tts/flutter_tts_web.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../models/speech_data.dart';
import 'llm_service.dart';

class SpeechService extends GetxService {
  late FlutterTts flutterTts;
  late SpeechToText speech;
  final ttsState = TtsState.stopped.obs;
  double volume = 0.8;
  double pitch = 1.1;
  double rate = 0.9;

  final isListening = false.obs;
  bool isAvailable = false;
  String liveResponse = '';
  String entireResponse = '';
  String chunkResponse = '';

  bool isFirstTime = true;

  SpeechService() {
    flutterTts = FlutterTts();
    speech = SpeechToText();
  }

  Future<SpeechService> init() async {
    await initTts();
    await initSTT();

    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    return this;
  }

  final _controller = StreamController<SpeechData>.broadcast();

  Stream<SpeechData> get stream => _controller.stream;

  @override
  void onClose() {
    _controller.close();
    super.onClose();
  }

  Future<void> initSTT() async {
    isAvailable = await speech.initialize(
      onStatus: (status) async {
        // print('Speech recognition status: $status AND is LISTENING STATUS ${isListening}');
        if ((status == "done" || status == "notListening") &&
            isListening.value &&
            Get.find<SpeechService>().ttsState.value == TtsState.stopped &&
            !Get.find<LLMService>().loading.value) {
          await speech.stop();
          if (chunkResponse != '') {
            entireResponse = '$entireResponse $chunkResponse';
          }
          chunkResponse = '';
          liveResponse = '';
          //MAIN CALLBACK HAPPENS
          _controller.sink.add(SpeechData(
            liveResponse: liveResponse,
            entireResponse: entireResponse,
            isListening: isListening.value,
          ));
          startListening();
        }
      },
    );
  }

  Future<void> initTts() async {
    await flutterTts.awaitSpeakCompletion(true);

    flutterTts.setStartHandler(() {
      print("Playing");
      ttsState.value = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      print("Complete");
      ttsState.value = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
      print("Cancel");
      ttsState.value = TtsState.stopped;
    });

    flutterTts.setPauseHandler(() {
      print("Paused");
      ttsState.value = TtsState.paused;
    });

    flutterTts.setContinueHandler(() {
      print("Continued");
      ttsState.value = TtsState.continued;
    });

    flutterTts.setErrorHandler((msg) {
      print("error: $msg");
      ttsState.value = TtsState.stopped;
    });
  }

  Future<void> speak(String text) async {
    // List<dynamic> voices = await flutterTts.getVoices;
    print(text);
    // flutterTts.setVoice(voices[1].cast<Map<String, String>>());

    if (text.isNotEmpty && text != "null") {
      await flutterTts.speak(text);
    }
  }

  void startListening() async {
    if (isFirstTime) {
      await Get.find<SpeechService>().speak(
          "Hello there, I will be your assistant today. "
          "Tell me what action you want to perform, and I would do it for you.");
      isFirstTime = false;
    }
    if (isAvailable) {
      isListening.value = true;
      liveResponse = '';
      chunkResponse = '';
      _controller.sink.add(SpeechData(
        liveResponse: liveResponse,
        entireResponse: entireResponse,
        isListening: isListening.value,
      ));
      await speech.stop(); // Stop listening
      await Future.delayed(const Duration(milliseconds: 50));
      await speech.listen(
        // localeId: 'es_MX',
        listenOptions: SpeechListenOptions(
            listenMode: ListenMode.dictation, onDevice: true),
        // listenFor: const Duration(seconds: 10000),
        onResult: (result) {
          final state = result.recognizedWords;
          liveResponse = state;
          if (result.finalResult) {
            chunkResponse = result.recognizedWords;
          }
          _controller.sink.add(SpeechData(
            liveResponse: liveResponse,
            entireResponse: entireResponse,
            isListening: isListening.value,
          ));
        },
      );
    } else {
      debugPrint('Ultra Speech ERROR : Speech recognition not available');
    }
  }

  void stopListening() {
    speech.stop();
    isListening.value = false;
    entireResponse = '$entireResponse $chunkResponse';
    _controller.sink.add(SpeechData(
      liveResponse: liveResponse,
      entireResponse: entireResponse,
      isListening: isListening.value,
    ));
  }
}
