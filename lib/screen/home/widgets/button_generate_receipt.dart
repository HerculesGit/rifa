import 'package:flutter/material.dart';
import 'package:rifa/core/contants/styles.dart';

class ButtonGenerateRecipient extends StatelessWidget {
  ButtonGenerateRecipient(
      {required this.enableButton, required this.onPressed});

  final bool enableButton;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final opacity = enableButton ? 1.0 : 0.5;

    return GestureDetector(
      onTap: !enableButton ? null : () => onPressed(),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: kAccentColor.withOpacity(opacity),
          ),
          child: const Text('Generate PDF',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18.0))),
    );
  }
}
