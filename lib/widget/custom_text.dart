import 'package:flutter/cupertino.dart';

import '../constant/style_guide.dart';

Widget customText(
  String text,
  int size,
  Color fontColor,
  bool isBold,
) {
  return Text(
    text,
    style: TextStyle(
        fontSize: size.toDouble(),
        color: fontColor,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
  );
}
