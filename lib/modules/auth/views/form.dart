import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visually_impaired/modules/auth/controllers/auth_controller.dart';
import 'package:visually_impaired/modules/global_widget/text_field.dart';

class FormPage extends StatelessWidget {
  const FormPage({super.key, required this.label, required this.hint});

  final String label, hint;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: Get.textTheme.displayLarge,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          controller: controller.nameController,
          hintText: hint,
          style: Get.textTheme.headlineMedium,
        ),
      ],
    );
  }
}


