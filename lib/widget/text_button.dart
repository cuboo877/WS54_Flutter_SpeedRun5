import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun5/constant/style_guide.dart';

class AppTextButton {
  static Widget textbutton(
      Color backgroundColor, String text, int size, onPressed) {
    return TextButton(
        style: TextButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: AppColor.white, fontSize: size.toDouble()),
        ));
  }
}
