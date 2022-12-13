import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomTheme {

  static ThemeData get lightTheme => ThemeData(
    primarySwatch: MaterialColor(kThemeColor.value, primaryColorMap),
  );

  // now its not necessary, so just avoid dark mood
  static ThemeData get darkTheme => ThemeData(
    primarySwatch: MaterialColor(kThemeColor.value, primaryColorMap),
  );
}