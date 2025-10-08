import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visually_impaired/modules/global_widget/text_field.dart';

import '../../global_widget/block_button_widget.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key, required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Row(
              children: [
                Text("Visually Impaired"),
                Spacer(),
                Icon(CupertinoIcons.map)
              ],
            ),
          ),
          Center(
            child: Container(
              width: 500,
              height: size.height * 0.72,
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: controller.pageController,
                      onPageChanged: (page) =>
                          controller.pageIndex.value = page,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "What is your full name?",
                              style: Get.textTheme.displayLarge,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              controller: controller.nameController,
                              hintText: "John Doe",
                              style: Get.textTheme.headlineMedium,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "What is your phone number?",
                              style: Get.textTheme.displayLarge,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              controller: controller.phoneController,
                              hintText: "08012345678",
                              style: Get.textTheme.headlineMedium,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "What is your department?",
                              style: Get.textTheme.displayLarge,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              controller: controller.deptController,
                              hintText: "Computer Engineering",
                              style: Get.textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Obx(() {
                        if (controller.pageIndex.value == 0) {
                          return const SizedBox.shrink();
                        } else {
                          return SizedBox(
                            width: 100,
                            child: BlockButtonWidget(
                              onPressed: () {
                                controller.pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              },
                              color: Get.theme.colorScheme.secondary,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              text: Text(
                                "Prev".tr,
                                style: Get.textTheme.titleLarge?.merge(
                                    TextStyle(color: Get.theme.primaryColor)),
                              ),
                            ),
                          );
                        }
                      }),
                      const Spacer(),
                      Obx(() {
                        if (controller.pageIndex.value == 6) {
                          return const SizedBox.shrink();
                        } else {
                          return SizedBox(
                            width: 100,
                            child: BlockButtonWidget(
                              onPressed: () {
                                // controller.register();
                                controller.pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              },
                              color: Get.theme.colorScheme.secondary,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              text: Text(
                                "Next".tr,
                                style: Get.textTheme.titleLarge?.merge(
                                    TextStyle(color: Get.theme.primaryColor)),
                              ),
                            ),
                          );
                        }
                      }),
                    ],
                  ).paddingSymmetric(vertical: 35)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(style: Get.textTheme.bodySmall, children: [
                TextSpan(
                    text: "Terms of Service",
                    style: Get.textTheme.bodySmall
                        ?.copyWith(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        controller.openTos();
                      }),
                const TextSpan(
                  text: "  |  ",
                ),
                TextSpan(
                    text: "Privacy Policy",
                    style: Get.textTheme.bodySmall
                        ?.copyWith(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        controller.openPrivacy();
                      }),
              ])),
        ],
      ),
    );
  }
}
