import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:visually_impaired/modules/global_widget/text_field.dart';

import '../../global_widget/block_button_widget.dart';
import '../../global_widget/speech_to_text_ultra.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      bottomNavigationBar: Container(
        height: 40,
        decoration: const BoxDecoration(
            color: Colors.transparent
        ),
        child: Row(
          children: [
            Expanded(
              child: Obx(() {
                return !controller.isListening.value ? const SizedBox.shrink() : SiriWaveform.ios9(
                  controller: controller.waveController,
                  options: const IOS9SiriWaveformOptions(height: 40, width: double.infinity, showSupportBar: false),
                );
              }
              ),
            ),
            const SpeechToTextUltra(),
          ],
        ),
      ),
      body: Obx(() {
        return controller.screens[controller.screenIndex.value];
      }),
    );
  }
}
