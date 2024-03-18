import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun5/constant/style_guide.dart';

class Utilitie {
  static void showSnackBar(BuildContext context, String content, int seconds) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: AppColor.black,
      duration: Duration(seconds: seconds),
    ));
  }

  static String randomID() {
    Random random = Random();
    String result = "";
    for (int i = 0; i < 9; i++) {
      result += random.nextInt(9).toString();
    }
    return result;
  }

  static String randomPassword(bool hasLowerCase, bool hasUpperCase,
      bool hasSymbol, bool hasNunmber, String customChars, int length) {
    StringBuffer buffer = StringBuffer();
    StringBuffer resultBuffer = StringBuffer();
    Random random = Random();
    if (hasLowerCase) {
      buffer.write("abcdefghijklmnopqrstuvwxyz");
    }
    if (hasUpperCase) {
      buffer.write("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    }
    if (hasNunmber) {
      buffer.write("0132456789");
    }
    if (hasSymbol) {
      buffer.write("!@#%^&*(){}?<>");
    }
    for (int i = 0; i < length - customChars.length; i++) {
      resultBuffer.write(buffer.toString()[random.nextInt(buffer.length)]);
    }
    String result = resultBuffer.toString();
    int index = random.nextInt(result.length);
    return "${result.substring(0, index)}$customChars${result.substring(index)}";
  }
}
