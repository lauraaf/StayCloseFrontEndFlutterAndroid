import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Variable observable per controlar el tema
  RxBool isDarkMode = false.obs;

  // Canviar el tema
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // Funció per obtenir el mode actual (0 per clar, 1 per fosc)
  int getModeStatus() {
    return isDarkMode.value ? 1 : 0;  // 1 per mode fosc, 0 per mode clar
  }
  
}
