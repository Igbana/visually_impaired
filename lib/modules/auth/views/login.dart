import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visually_impaired/modules/global_widget/block_button_widget.dart';
import 'package:visually_impaired/modules/global_widget/text_field.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key, required this.controller});

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
                children: [
                  Expanded(
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: controller.pageController,
                      onPageChanged: (page) =>
                          controller.pageIndex.value = page,
                      children: [
                        CustomTextField(
                            controller: controller.userIdController,
                            labelText: "User ID",
                            hintText: "982516"),
                        PasswordField(
                          labelText: "Password",
                          controller: controller.passwordController,
                          hintText: "Password",
                          enabled: true,
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
        ],
      ),
    );
  }
}
