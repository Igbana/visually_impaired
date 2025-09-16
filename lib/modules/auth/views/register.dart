import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visually_impaired/modules/global_widget/text_field.dart';

import '../../global_widget/block_button_widget.dart';
import '../../global_widget/selection_field.dart';
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
                            // Text(
                            //   "Welcome",
                            //   style: Get.textTheme.displayMedium,
                            // ),
                            // SizedBox(
                            //   height: size.height * 0.03,
                            // ),
                            // CustomTextField(
                            //     controller: controller.nameController,
                            //     labelText: "Full Name",
                            //     hintText: "John Doe"),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            // CustomTextField(
                            //     controller: controller.phoneController,
                            //     labelText: "Phone Number",
                            //     hintText: "08012345678"),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            // CustomTextField(
                            //     controller: controller.stateController,
                            //     labelText: "State of Origin",
                            //     hintText: "Niger State"),
                            /*PasswordField(
                          controller: controller.passwordController,
                          hintText: "Password",
                          enabled: true,
                        ),*/
                            // const SizedBox(
                            //   height: 16,
                            // ),
                            // BlockButtonWidget(
                            //   onPressed: () {
                            //     controller.register();
                            //   },
                            //   color: Get.theme.colorScheme.secondary,
                            //   width: double.infinity,
                            //   padding: const EdgeInsets.symmetric(vertical: 16),
                            //   text: Text(
                            //     "Sign up".tr,
                            //     style: Get.textTheme.titleLarge
                            //         ?.merge(TextStyle(color: Get.theme.primaryColor)),
                            //   ),
                            // ).paddingSymmetric(vertical: 35),
                            // RichText(
                            //     textAlign: TextAlign.center,
                            //     text: TextSpan(children: [
                            //       TextSpan(
                            //           text: "Already have an account?  ",
                            //           style: Get.textTheme.bodySmall),
                            //       TextSpan(
                            //           text: "Sign in",
                            //           style: Get.textTheme.bodySmall?.copyWith(
                            //               decoration: TextDecoration.underline),
                            //           recognizer: TapGestureRecognizer()
                            //             ..onTap = () {
                            //               // openUrl(tos);
                            //               controller.screenIndex.value = 0;
                            //             }),
                            //     ])),
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
                              "What is your state of origin?",
                              style: Get.textTheme.displayLarge,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              controller: controller.stateController,
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
                              "What difficulty level suits you best?",
                              style: Get.textTheme.displayLarge,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Obx(() {
                                return SelectionField(
                                  options: controller.difficultyLevels,
                                  selectedValue: controller.difficultyLevel.value,
                                  onValueChanged: (value) => controller.difficultyLevel.value = value!,
                                );
                              }
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "How fast would you prefer me to talk?",
                              style: Get.textTheme.displayLarge,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Obx(() {
                                return SelectionField(
                                  options: controller.speechSpeeds,
                                  selectedValue: controller.speechSpeed.value,
                                  onValueChanged: (value) => controller.speechSpeed.value = value!,
                                );
                              }
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "What type of feedback helps you learn best?",
                              style: Get.textTheme.displayLarge,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Obx(() {
                                return SelectionField(
                                  options: controller.feedbackTypes,
                                  selectedValue: controller.feedbackType.value,
                                  onValueChanged: (value) => controller.feedbackType.value = value!,
                                );
                              }
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Do you have any other preference you would like me to know?",
                              style: Get.textTheme.headlineMedium,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              controller: controller.phoneController,
                              hintText: "I would like...",
                              style: Get.textTheme.headlineMedium,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
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
                        }
                      ),
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
