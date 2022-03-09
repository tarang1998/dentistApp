import 'package:dentalApp/core/designSystem/fundamentals/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const headingTextStyle = TextStyle(
    fontSize: 22,
    letterSpacing: 1,
    fontWeight: FontWeight.w600,
  );

  static const subHeadingTextStyle = TextStyle(
    color: RawColors.red300,
    fontSize: 20,
    letterSpacing: 1,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle inputFieldTitleTextStyle = TextStyle(
    color: RawColors.grey70,
    fontSize: 18,
    letterSpacing: 1,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle hintTextStyle =
      TextStyle(color: RawColors.grey30, fontSize: 16);

  static final OutlineInputBorder textFieldInputEnabledBorder =
      OutlineInputBorder(
    borderSide: const BorderSide(color: RawColors.grey20),
    borderRadius: BorderRadius.circular(10),
  );

  static final OutlineInputBorder textFieldInputFocusedBorder =
      OutlineInputBorder(
    borderSide: const BorderSide(color: RawColors.red300, width: 0.5),
    borderRadius: BorderRadius.circular(10),
  );
}
