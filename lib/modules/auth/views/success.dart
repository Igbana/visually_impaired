import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:visually_impaired/routes/app_routes.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () => Get.toNamed(Routes.READER),
    );
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            Lottie.asset('assets/congratulations.json'),
            Text(
              "Congratulations, You have successfully registered",
              style: Get.textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}