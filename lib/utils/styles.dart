
import 'package:flutter/cupertino.dart';
import 'package:food_serving_app/utils/color_res.dart';

// ignore: non_constant_identifier_names
TextStyle AppTextStyle({
  FontWeight weight,
  double size,
  Color textColor,
  TextDecoration textDecoration,
}) {
  return TextStyle(
    fontWeight: weight ?? FontWeight.normal,
    fontSize: size ?? 16,
    color: textColor ?? ColorRes.white,
    decoration: textDecoration ?? TextDecoration.none,
  );
}
