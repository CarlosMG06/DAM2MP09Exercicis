import 'package:flutter/material.dart';

class AppTheme {
  static const Color bg       = Color(0xFF222222);
  static const Color surface  = Color(0xFF333333);
  static const Color primary  = Color(0xFFFF9900);
  static const Color secondary = Color(0xFF0099FF);
  static const Color success  = Color(0xFF66FF66);
  static const Color error    = Color(0xFFFF6666);
  static const Color text     = Color(0xFFFFFFFF);
  static const Color textSub  = Color(0xFF999999);

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: surface,
      tertiary: success,
      error: error,
    ),
    useMaterial3: false,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: text,
  );
  
  static const TextStyle label = TextStyle(
    fontSize: 12,
    color: textSub,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 13,
    color: text,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    color: textSub,
  );
}