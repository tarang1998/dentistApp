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
    borderSide: const BorderSide(
      color: RawColors.red300,
    ),
    borderRadius: BorderRadius.circular(10),
  );

  static final BoxDecoration pageButtonBox = BoxDecoration(
    color: RawColors.red300,
    borderRadius: BorderRadius.circular(6),
    boxShadow: [
      BoxShadow(
        color: RawColors.grey90.withOpacity(.1),
        blurRadius: 40.0,
        spreadRadius: 0.0,
        offset: const Offset(
          0.0,
          0.0,
        ),
      ),
    ],
  );

  static final BoxDecoration pageDisabledButtonBox = BoxDecoration(
    color: const Color(0xFFD1D3D5),
    borderRadius: BorderRadius.circular(6),
    boxShadow: [
      BoxShadow(
        color: RawColors.grey90.withOpacity(.1),
        blurRadius: 40.0,
        spreadRadius: 0.0,
        offset: const Offset(
          0.0,
          0.0,
        ),
      ),
    ],
  );

  static const TextStyle pageButtonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static final BoxDecoration informationBox = BoxDecoration(
    color: const Color(0xFFF1F2F3),
    borderRadius: BorderRadius.circular(6),
    border: Border.all(
      width: 0.5,
      color: const Color(0xFFE7E9E9),
    ),
  );
}
