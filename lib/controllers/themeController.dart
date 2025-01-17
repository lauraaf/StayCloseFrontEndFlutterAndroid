import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_application_1/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeController extends GetxController {
  final _storage = GetStorage();
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Cargar el estado del tema desde el almacenamiento persistente
    isDarkMode.value = _storage.read('isDarkMode') ?? false;
    Get.changeTheme(ThemeConfig.getTheme(isDarkMode.value)); // Aplicar el tema
  }

  // Cambiar entre el tema claro y oscuro
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.write('isDarkMode', isDarkMode.value); // Guardar el estado del tema
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light); // Cambiar el tema
  }

  // Obtener el estado actual del tema (0 para claro, 1 para oscuro)
  int get modeStatus => isDarkMode.value ? 1 : 0;

  // Obtener los colores por página
  Color getBackgroundColor(String page) {
    return ThemeConfig.getBackgroundColor(isDarkMode.value, page);
  }

  Color getTextColor(String page) {
    return ThemeConfig.getTextColor(isDarkMode.value, page);
  }

  Color getButtonColor(String page) {
    return ThemeConfig.getButtonColor(isDarkMode.value, page);
  }
  void saveTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedTheme = prefs.getBool('isDarkMode');
    if (savedTheme != null) {
      isDarkMode.value = savedTheme;
      Get.changeThemeMode(savedTheme ? ThemeMode.dark : ThemeMode.light);
    }
  }
}
