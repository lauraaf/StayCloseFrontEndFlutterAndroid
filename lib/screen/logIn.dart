import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/userController.dart';
//CLoudinary
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
//GoogleAuthService
import 'package:flutter_application_1/services/googleAuthServices.dart';
import 'package:flutter_application_1/controllers/registerController.dart';

class LogInPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
        backgroundColor: Color(0xFF89AFAF),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(horizontal: 40.0),
          constraints: BoxConstraints(
            maxWidth: 300,
          ),
          decoration: BoxDecoration(
            color: Color.fromARGB(194, 162, 204, 204),
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
                  "Iniciar Sesión",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D40),
                  ),
                ),
                const SizedBox(height: 20),
                //Imatge cloudinary
                CldImageWidget(
                  publicId: 'logo_ounbww',
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: userController.usernameController,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                
                // Password Field with Visibility Toggle
                Obx(() {
                  return TextField(
                    controller: userController.passwordController,
                    cursorColor: Colors.white,
                    obscureText: !userController.isPasswordVisible.value,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          userController.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
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
                        backgroundColor: Color(0xFF89AFAF),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Iniciar Sesión'),
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
                    "Iniciar sesión con Google",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF89AFAF),
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Aun no tienes una cuenta, Registrate",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/register'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF89AFAF),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Registrarse'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}