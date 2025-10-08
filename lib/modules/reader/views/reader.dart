import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:visually_impaired/modules/reader/controllers/reader_controller.dart';

class Reader extends StatelessWidget {
  const Reader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReaderController>();
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                controller.pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 12),
            const Text("CIT101.pdf"),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(child: SfPdfViewer.asset('doc/CIT101.pdf')),
      ],
    );
  }
}
