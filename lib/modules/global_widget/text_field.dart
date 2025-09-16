import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key,
    required this.controller,
    this.labelText,
    required this.hintText,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.suffixIcon,
    this.focusNode,
    this.style,
    this.padding,
    this.keyboardType,
    this.maxLines,
    this.inputFormatters});

  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final bool obscureText, enabled, readOnly;
  final EdgeInsets? padding;
  final TextStyle? style;
  final int? maxLines;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      readOnly: readOnly,
      focusNode: focusNode,
      style: style,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: style?.copyWith(color: Colors.grey) ?? const TextStyle(color: Colors.grey),
          contentPadding: padding ??
              const EdgeInsets.all(10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey)),
          suffixIcon: suffixIcon),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.enabled});

  final TextEditingController controller;
  final String labelText, hintText;
  final bool enabled;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: obscureText,
      labelText: widget.labelText,
      hintText: widget.hintText,
      suffixIcon: IconButton(
        icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,),
        onPressed: () {
          setState(() {
            obscureText = !obscureText;
          });
        },
      ),
    );
  }
}
