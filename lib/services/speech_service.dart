import 'dart:async';
import 'package:flutter/foundation.dart';
import 'llm_service.dart';
import 'package:get/get.dart';
import '../models/speech_data.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_tts/flutter_tts_web.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService extends GetxService {
  SpeechService() {
    flutterTts = FlutterTts();
    speech = SpeechToText();
  }

  late FlutterTts flutterTts;
  late SpeechToText speech;

  final ttsState = TtsState.stopped.obs;

  final isListening = false.obs;
  bool isAvailable = false;
  String liveResponse = '';
  String entireResponse = '';
  String chunkResponse = '';

  void clearResponse() {
    liveResponse = '';
    entireResponse = '';
    chunkResponse = '';
  }

  Future<SpeechService> init() async {
    await initTts();
    await initSTT();
    return this;
  }

  final _streamcontroller = StreamController<SpeechData>.broadcast();
  Stream<SpeechData> get streamData => _streamcontroller.stream;

  @override
  void onClose() {
    _streamcontroller.close();
    super.onClose();
  }

  Future<void> initSTT() async {
    isAvailable = await speech.initialize(
      onStatus: (status) async {
        if ((status == "done" || status == "notListening") &&
            isListening.value &&
            Get.find<SpeechService>().ttsState.value == TtsState.stopped &&
            Get.find<LLMService>().loading.value) {
          await speech.stop();
          if (chunkResponse != '') {
            entireResponse = '$entireResponse $chunkResponse';
          }
          chunkResponse = '';
          liveResponse = '';

          _streamcontroller.sink.add(SpeechData(
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
      debugPrint("Playing");
      ttsState.value = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      debugPrint("Complete");
      ttsState.value = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
      debugPrint("Cancel");
      ttsState.value = TtsState.stopped;
    });

    flutterTts.setPauseHandler(() {
      debugPrint("Paused");
      ttsState.value = TtsState.paused;
    });

    flutterTts.setContinueHandler(() {
      debugPrint("Continued");
      ttsState.value = TtsState.continued;
    });

    flutterTts.setErrorHandler((msg) {
      debugPrint("error: $msg");
      ttsState.value = TtsState.stopped;
    });
  }

  Future<void> speak(String text) async {
    debugPrint("[DEBUG] Speak is called");
    if (isListening.value) {
      await speech.stop();
      isListening.value = false;
    }
    if (text.isNotEmpty && text != "null") {
      debugPrint("[BOT] $text");
      await flutterTts.speak(text);
    }
  }

  void interruptibleSpeak(String text) => flutterTts.speak(text);
  void interrupt() => flutterTts.stop();

  Future<void> stop() async {
    try {
      debugPrint("[DEBUG] Shutup is called");
      await speech.stop();
      debugPrint("[DEBUG] Shutup");
      isListening.value = true;
    } catch (e) {
      print("Wasn't able to shutup");
    }
  }

  void startListening() async {
    debugPrint("[DEBUG] Listen is called");
    if (isAvailable) {
      isListening.value = true;
      liveResponse = '';
      chunkResponse = '';
      _streamcontroller.sink.add(SpeechData(
        liveResponse: liveResponse,
        entireResponse: entireResponse,
        isListening: isListening.value,
      ));
      await speech.stop();
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        await speech.listen(
          listenOptions: SpeechListenOptions(
            listenMode: ListenMode.dictation,
            onDevice: true,
          ),
          onResult: (result) {
            liveResponse = result.recognizedWords;
            debugPrint("[DEBUG] Final result? ${result.finalResult}");
            if (result.finalResult) {
              chunkResponse = result.recognizedWords;
            }
            _streamcontroller.sink.add(SpeechData(
              liveResponse: liveResponse,
              entireResponse: entireResponse,
              isListening: isListening.value,
            ));
          },
        );
      } catch (e) {
        debugPrint("[ERROR] $e");
      }
    } else {
      debugPrint('Ultra Speech ERROR : Speech recognition not available');
    }
  }

  void stopListening() {
    isListening.value = false;
    speech.stop();
    entireResponse = '$entireResponse $chunkResponse';
    _streamcontroller.sink.add(SpeechData(
      liveResponse: liveResponse,
      entireResponse: entireResponse,
      isListening: isListening.value,
    ));
  }
}
