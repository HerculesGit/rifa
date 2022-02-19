import 'package:flutter/material.dart';
import 'package:rifa/core/validators/validator.dart';

class MTextFormField extends StatelessWidget {
  final List<CustomValidator> validators;
  final Function(String? value) onChanged;
  final String hintText;
  final TextInputType? inputType;

  MTextFormField({
    required this.hintText,
    required this.validators,
    required this.onChanged,
    this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      onChanged: onChanged,
      keyboardType: inputType ?? TextInputType.text,
      validator: _validators,
    );
  }

  String? _validators(String? value) {
    String text = value ?? '';
    text = text.trim();

    final mValidators = validators;

    for (var validator in mValidators) {
      if (validator.showTextError(text)) {
        return validator.errorText;
      }
    }

    return null;
  }
}
