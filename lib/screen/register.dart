import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/registerController.dart';
import 'package:flutter_application_1/controllers/themeController.dart'; // Importar el ThemeController

class RegisterPage extends StatelessWidget {
  final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    // Accede al ThemeController para obtener el estado del tema
    final ThemeController themeController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrarse'.tr),
        // Cambiar el color de fondo del AppBar dependiendo del tema
        backgroundColor: themeController.isDarkMode.value
            ? Color(0xFF555A6F) // Color para el modo oscuro
            : Color(0xFF89AFAF), // Color para el modo claro
        actions: [
          // Menú para cambiar idioma
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
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(horizontal: 40.0),
          constraints: BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            // Cambiar color de fondo según el tema
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
                  "Crear una cuenta".tr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode.value
                        ? Color(0xFFE0F7FA) // Texto para el modo oscuro
                        : Color(0xFF004D40), // Texto para el modo claro
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: registerController.usernameController,
                  cursorColor: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario'.tr,
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
                TextField(
                  controller: registerController.nameController,
                  cursorColor: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                  decoration: InputDecoration(
                    labelText: 'Nombre'.tr,
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
                TextField(
                  controller: registerController.emailController,
                  cursorColor: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico'.tr,
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
                    controller: registerController.passwordController,
                    cursorColor: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                    obscureText: !registerController.isPasswordVisible.value,
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
                          registerController.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: themeController.isDarkMode.value
                              ? Colors.white
                              : Colors.black,
                        ),
                        onPressed: () {
                          registerController.togglePasswordVisibility();
                        },
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 10),

                // Campo de confirmación de contraseña
                Obx(() {
                  return TextField(
                    controller: registerController.confirmPasswordController,
                    cursorColor: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                    obscureText: !registerController.isConfirmPasswordVisible.value,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Contraseña'.tr,
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
                          registerController.isConfirmPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: themeController.isDarkMode.value
                              ? Colors.white
                              : Colors.black,
                        ),
                        onPressed: () {
                          registerController.toggleConfirmPasswordVisibility();
                        },
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),
                Obx(() {
                  if (registerController.isLoading.value) {
                    return CircularProgressIndicator();
                  } else {
                    return ElevatedButton(
                      onPressed: registerController.signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeController.isDarkMode.value
                            ? Color(0xFF555A6F) // Color para el modo oscuro
                            : Color(0xFF89AFAF), // Color para el modo claro
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Registrarse'.tr),
                    );
                  }
                }),
                const SizedBox(height: 10),
                Obx(() {
                  if (registerController.errorMessage.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        registerController.errorMessage.value,
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
