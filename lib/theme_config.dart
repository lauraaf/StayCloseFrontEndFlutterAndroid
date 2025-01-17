import 'package:flutter/material.dart';

class ThemeConfig {
  static ThemeData getTheme(bool isDarkMode) {
    return isDarkMode ? darkTheme : lightTheme;
  }

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF296868),
    scaffoldBackgroundColor: Color(0xFFE0F7FA),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF296868),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
    ),
    cardTheme: CardTheme(color: Colors.white, shadowColor: Colors.grey),
    buttonTheme: ButtonThemeData(buttonColor: Color(0xFF296868), textTheme: ButtonTextTheme.primary),
    iconTheme: IconThemeData(color: Colors.teal),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[900],
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
    ),
    cardTheme: CardTheme(color: Colors.grey[800], shadowColor: Colors.black),
    buttonTheme: ButtonThemeData(buttonColor: Colors.grey[700], textTheme: ButtonTextTheme.primary),
    iconTheme: IconThemeData(color: Colors.white70),
  );

  // 🔹 Colores específicos por pantalla
  static Color getBackgroundColor(bool isDarkMode, String page) {
    switch (page) {
      case 'home':
        return isDarkMode ? Colors.black : Colors.white;
      case 'profile':
        return isDarkMode ? Color(0xFF1E1E1E) : Color(0xFFF5F5F5);
      case 'map':
        return isDarkMode ? Color(0xFF2A2A2A) : Colors.blue[100]!;
      case 'calendar':
        return isDarkMode ? Colors.grey[900]! : Colors.white;
      default:
        return isDarkMode ? Colors.black : Colors.white;
    }
  }

  static Color getTextColor(bool isDarkMode, String page) {
    switch (page) {
      case 'home':
        return isDarkMode ? Colors.white : Colors.black;
      case 'profile':
        return isDarkMode ? Colors.white70 : Colors.black87;
      default:
        return isDarkMode ? Colors.white : Colors.black;
    }
  }

  static Color getButtonColor(bool isDarkMode, String page) {
    switch (page) {
      case 'profile':
        return isDarkMode ? Colors.redAccent : Colors.blueAccent;
      case 'map':
        return isDarkMode ? Colors.greenAccent : Colors.teal;
      default:
        return isDarkMode ? Colors.grey[700]! : Colors.blue;
    }
  }
}
