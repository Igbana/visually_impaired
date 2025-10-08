import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visually_impaired/modules/reader/controllers/reader_controller.dart';
import 'package:visually_impaired/modules/reader/views/doc_list.dart';
import 'package:visually_impaired/modules/reader/views/reader.dart';

class ReaderView extends StatelessWidget {
  const ReaderView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final controller = Get.find<ReaderController>();
    return Scaffold(
      body: SingleChildScrollView(
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
                width: size.width * 0.6,
                height: size.height * 0.85,
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
                        children: const [
                          DocList(),
                          Reader(),
                        ],
                      ),
                    ),
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
      ),
    );
  }
}
