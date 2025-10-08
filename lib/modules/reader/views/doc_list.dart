import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visually_impaired/modules/reader/controllers/reader_controller.dart';

class DocList extends StatelessWidget {
  const DocList({super.key});

  @override
  Widget build(BuildContext context) {
    List docList = List.generate(12, (ind) => "CPE ${510 + ind}");
    final controller = Get.find<ReaderController>();
    return ListView.separated(
      itemCount: 12,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            controller.pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Text(docList[index]),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}
