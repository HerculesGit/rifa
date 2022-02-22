import 'package:flutter/material.dart';
import 'package:rifa/core/contants/dimens_contants.dart';
import 'package:rifa/core/contants/styles.dart';

class CircleButton extends StatelessWidget {
  final Function() onTap;
  final IconData iconData;

  const CircleButton({
    Key? key,
    required this.onTap,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.all(kLayoutMargin / 2),
            decoration: kCircleDecoration,
            child: Icon(iconData, color: Colors.white)));
  }
}
