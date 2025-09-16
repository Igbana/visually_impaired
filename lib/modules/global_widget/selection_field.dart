import 'package:flutter/material.dart';

class SelectionField extends StatelessWidget {
  const SelectionField({super.key,
    required this.options,
    required this.selectedValue,
    this.onValueChanged,
  });

  final List<String> options;
  final String selectedValue;
  final Function(String?)? onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...options.map((option) {
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: selectedValue,
            onChanged: onValueChanged,
          );
        })
      ],
    );
  }
}