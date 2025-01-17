import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_application_1/theme_config.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _storage.read('isDarkMode') ?? false;
    Get.changeTheme(ThemeConfig.getTheme(isDarkMode.value));
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // Obtener colores por página
  Color getBackgroundColor(String page) {
    return ThemeConfig.getBackgroundColor(isDarkMode.value, page);
  }

  Color getTextColor(String page) {
    return ThemeConfig.getTextColor(isDarkMode.value, page);
  }

  Color getButtonColor(String page) {
    return ThemeConfig.getButtonColor(isDarkMode.value, page);
  }
  // Funció per obtenir el mode actual (0 per clar, 1 per fosc)
  int getModeStatus() {
    return isDarkMode.value ? 1 : 0;  // 1 per mode fosc, 0 per mode clar
  }
}

  
