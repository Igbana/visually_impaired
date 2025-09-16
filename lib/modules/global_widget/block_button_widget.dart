import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockButtonWidget extends StatelessWidget {
  const BlockButtonWidget({super.key, required this.color, required this.text, required this.onPressed, this.padding, this.width});

  final Color? color;
  final Widget? text;
  final VoidCallback? onPressed;
  final double? width;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: onPressed != null
          ? BoxDecoration(
              boxShadow: [
                BoxShadow(color: color!.withOpacity(0.3), blurRadius: 10, offset: const Offset(5, 8)),
              ],
              // borderRadius: const BorderRadius.all(Radius.circular(20)),
            )
          : null,
      child: MaterialButton(
        onPressed: onPressed,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        color: color,
        disabledElevation: 0,
        disabledColor: Get.theme.focusColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        child: text,
      ),
    );
  }
}
