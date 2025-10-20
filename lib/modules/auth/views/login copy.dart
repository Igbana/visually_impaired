import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visually_impaired/modules/global_widget/text_field.dart';
import '../../global_widget/block_button_widget.dart';
import '../controllers/auth_controller.dart';

class LoginVie extends StatelessWidget {
  const LoginVie({super.key, required this.controller});

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
                  const EdgeInsets.symmetric(horizontal: 72.0, vertical: 30),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Welcome Back",
                    style: Get.textTheme.displayMedium,
                  ),
                  Text(
                    "Please enter your details",
                    style: Get.textTheme.bodySmall,
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  CustomTextField(
                      controller: controller.userIdController,
                      labelText: "User ID",
                      hintText: "982516"),
                  /*const SizedBox(
                      height: 20,
                    ),
                    PasswordField(
                      controller: controller.passwordController,
                      hintText: "Password",
                      enabled: true,
                    ),*/
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() {
                        return SizedBox.square(
                          dimension: 24,
                          child: Checkbox(
                            value: controller.remember.value,
                            onChanged: (value) {
                              // if (authState != AuthState.idle) return;
                              controller.remember.value = value ?? false;
                            },
                          ),
                        );
                      }),
                      const SizedBox(
                        width: 8,
                      ),
                      Text("Remember for 30 days",
                          style: Get.textTheme.bodySmall),
                      const Spacer(),
                      Text(
                        "Forgot password",
                        style: Get.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BlockButtonWidget(
                    onPressed: () {
                      controller.login();
                    },
                    color: Get.theme.colorScheme.secondary,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    text: Text(
                      "Sign in".tr,
                      style: Get.textTheme.titleLarge
                          ?.merge(TextStyle(color: Get.theme.primaryColor)),
                    ),
                  ).paddingSymmetric(vertical: 35),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Don't have an account?  ",
                            style: Get.textTheme.bodySmall),
                        TextSpan(
                            text: "Sign up",
                            style: Get.textTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                controller.screenIndex.value = 1;
                              }),
                      ])),
                ],
              ),
            ),
          ),
          /*Obx(() {
            return Text(controller.lastWords.value);
          }
          ),*/
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
