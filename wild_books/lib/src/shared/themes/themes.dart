import 'package:flutter/material.dart';
import 'package:wild_books/src/shared/themes/color_schemes.g.dart';

ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    appBarTheme: AppBarTheme(
        centerTitle: true, backgroundColor: darkColorScheme.primaryContainer),
    segmentedButtonTheme: SegmentedButtonThemeData(style: ButtonStyle(
      textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(fontSize: 12);
        }
        return const TextStyle(fontSize: 15);
      }),
    )));

ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    appBarTheme: AppBarTheme(
        centerTitle: true, backgroundColor: lightColorScheme.primaryContainer),
    segmentedButtonTheme: SegmentedButtonThemeData(style: ButtonStyle(
      textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(fontSize: 12);
        }
        return const TextStyle(fontSize: 15);
      }),
    )));
