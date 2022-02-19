import 'package:flutter/material.dart';
import 'package:rifa/core/contants/styles.dart';

class Loading extends StatelessWidget {
  final bool smallLoading;
  final Color? color;

  Loading({this.smallLoading = false, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: smallLoading ? 22.0 : null,
      width: smallLoading ? 22.0 : null,
      child: CircularProgressIndicator(
        color: color ?? kAccentColor,
        strokeWidth: smallLoading ? 3.0 : 4.0,
      ),
    );
  }
}
