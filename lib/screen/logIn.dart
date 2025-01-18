//V1.2

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:flutter_application_1/controllers/userController.dart';
//GoogleAuthService
import 'package:flutter_application_1/services/googleAuthServices.dart';
import 'package:flutter_application_1/controllers/registerController.dart';
import 'package:flutter_application_1/controllers/themeController.dart'; // Importa el ThemeController

class LogInPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    // Accede al ThemeController para obtener el estado del tema
    final ThemeController themeController = Get.find();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Usamos el tamaño predeterminado del AppBar
        child: Obx(() {
          return AppBar(
            title: Text('Iniciar Sesión'.tr,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Tamaño y estilo fijo del texto)
            // Color de fondo del AppBar dependiendo del tema
            backgroundColor: themeController.isDarkMode.value
                ? Color(0xFF555A6F) // Color para el modo oscuro
                : Color(0xFF89AFAF), // Color para el modo claro
            actions: [
              // Botón para cambiar tema
              IconButton(
                icon: Icon(Icons.brightness_6),
                onPressed: () {
                  themeController.toggleTheme(); // Cambia entre modo oscuro y claro
                },
              ),
              // Botón para cambiar idioma
              PopupMenuButton<String>(
                onSelected: (String languageCode) {
                  if (languageCode == 'ca') {
                    Get.updateLocale(Locale('ca', 'ES'));
                  } else if (languageCode == 'es') {
                    Get.updateLocale(Locale('es', 'ES'));
                  } else if (languageCode == 'en') {
                    Get.updateLocale(Locale('en', 'US'));
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(value: 'ca', child: Text('Català')),
                    PopupMenuItem(value: 'es', child: Text('Español')),
                    PopupMenuItem(value: 'en', child: Text('English')),
                  ];
                },
              ),
            ],
          );
        }),
      ),
      body: Obx(() {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(horizontal: 40.0),
            constraints: BoxConstraints(
              maxWidth: 300,
            ),
            decoration: BoxDecoration(
              // Cambia el color de fondo según el tema
              color: themeController.isDarkMode.value
                  ? Color(0xFF2A2A2A) // Fondo para el modo oscuro
                  : Color(0xFFE0F7FA), // Fondo para el modo claro
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Iniciar Sesión'.tr,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      // Cambia el color del texto "Iniciar Sesión" según el tema
                      color: themeController.isDarkMode.value
                          ? Color(0xFFE0F7FA) // Texto para el modo oscuro
                          : Color(0xFF004D40), // Texto para el modo claro
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Imagen de Cloudinary
                  CldImageWidget(
                    publicId: 'logo_ounbww',
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: userController.usernameController,
                    cursorColor: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                    decoration: InputDecoration(
                      labelText: 'Usuario'.tr,
                      labelStyle: TextStyle(
                          color: themeController.isDarkMode.value
                              ? Colors.white
                              : Colors.black),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: themeController.isDarkMode.value
                                ? Colors.white
                                : Colors.black),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Campo de contraseña con conmutador de visibilidad
                  Obx(() {
                    return TextField(
                      controller: userController.passwordController,
                      cursorColor: themeController.isDarkMode.value
                          ? Colors.white
                          : Colors.black,
                      obscureText: !userController.isPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: 'Contraseña'.tr,
                        labelStyle: TextStyle(
                            color: themeController.isDarkMode.value
                                ? Colors.white
                                : Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            userController.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: themeController.isDarkMode.value
                                ? Colors.white
                                : Colors.black,
                          ),
                          onPressed: () {
                            userController.togglePasswordVisibility();
                          },
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 20),
                  Obx(() {
                    if (userController.isLoading.value) {
                      return CircularProgressIndicator();
                    } else {
                      return ElevatedButton(
                        onPressed: userController.logIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeController.isDarkMode.value
                              ? Color(0xFF555A6F) // Color para el modo oscuro
                              : Color(0xFF89AFAF), // Color para el modo claro
                          foregroundColor: themeController.isDarkMode.value
                              ? Colors.white
                              : Colors.black,
                        ),
                        child: Text('Iniciar Sesión'.tr),
                      );
                    }
                  }),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (userController.errorMessage.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          userController.errorMessage.value,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: registerController.signUpWithGoogle,
                  icon: Image.asset(
                    'assets/icons/google_logo.png', // Ruta de la imagen del logo de Google
                    height: 20,
                  ),
                  label: Text(
                    "Iniciar sesión con Google".tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF89AFAF),
                    foregroundColor: Colors.white,
                  ),
                ),
                  const SizedBox(height: 10),
                  Text(
                    '¿Aún no tienes una cuenta? Regístrate'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: themeController.isDarkMode.value
                          ? Color(0xFFE0F7FA) // Texto para el modo oscuro
                          : Color(0xFF004D40), // Texto para el modo claro
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeController.isDarkMode.value
                          ? Color(0xFF555A6F) // Color para el modo oscuro
                          : Color(0xFF89AFAF), // Color para el modo claro
                      foregroundColor: themeController.isDarkMode.value
                          ? Colors.white
                          : Colors.black,
                    ),
                    child: Text('Registrarse'.tr),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
