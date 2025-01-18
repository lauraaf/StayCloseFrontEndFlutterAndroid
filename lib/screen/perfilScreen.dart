//V1.2

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/userServices.dart';
import 'package:flutter_application_1/controllers/userController.dart'; // Controlador para crear el post
import 'configurationScreen.dart'; // Importamos la nueva pantalla de configuración
import 'package:flutter_application_1/controllers/themeController.dart';


class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String? _username;
  String? _email;
  String? _avatarUrl; // Variable per guardar l'URL de l'avatar
  String? _userId; // Guardem l'ID del usuari per fer la petició

  final UserService userService = Get.put(UserService());

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Carrega l'ID del usuari
  }

  // Càrrega l'ID del usuari des de SharedPreferences
  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      await _loadUserData(userId); // Crida a carregar les dades de l'usuari
    }
  }

  // Càrrega les dades del usuari des del servei
  Future<void> _loadUserData(String userId) async {
    try {
      var user = await userService.getUser(userId); // Obtenim el model d'usuari
      if (user != null) {
        setState(() {
          _username = user.username;
          _email = user.email;
          _avatarUrl = user.avatar; // Agafem l'URL de l'avatar
        });
      } else {
        print('No s\'han pogut carregar les dades de l\'usuari.');
      }
    } catch (e) {
      print('Error carregant les dades de l\'usuari: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  // Obtener el ThemeController para acceder a la función de cambio de tema
  final ThemeController themeController = Get.find();
  
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight), // Usamos el tamaño predeterminado del AppBar
      child: Obx(() {
        return AppBar(
          title: Text('Perfil'.tr, // Traducción dinámica
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Tamaño y estilo fijo del texto
            backgroundColor: themeController.isDarkMode.value
                ? Color(0xFF555A6F) // Color para el modo oscuro
                : Color(0xFF89AFAF), // Color para el modo claro
            toolbarHeight: 70.0, // Altura fija del AppBar
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: () {
                themeController.toggleTheme(); // Cambiar tema
              },
              color: Colors.white, // El color debe coincidir con el estilo del tema
            ),
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
    body: Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: _avatarUrl != null
                    ? NetworkImage(_avatarUrl!) // Si hi ha URL, carrega l'avatar
                    : null,
                backgroundColor: Colors.grey[300],
                child: _avatarUrl == null
                    ? Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(height: 20),
              Text(
                _username ?? 'Nombre del Usuario'.tr,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF89AFAF),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _email ?? 'usuario@example.com'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 200,
                child: _buildProfileButton(context, 'Configuración'.tr),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: _buildProfileButton(context, 'Cerrar Sesión'.tr),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildProfileButton(BuildContext context, String text) {
  final ThemeController themeController = Get.find();
  return Obx(() {
    return ElevatedButton(
      onPressed: () => _onButtonPressed(context, text),
      style: ElevatedButton.styleFrom(
        backgroundColor: themeController.isDarkMode.value
            ? Color(0xFF555A6F) // Color de fondo para el modo oscuro
            : Color(0xFF89AFAF), // Color de fondo para el modo claro
        foregroundColor: themeController.isDarkMode.value
            ? Colors.white // Color del texto para el modo oscuro
            : Colors.black, // Color del texto para el modo claro
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  });
}


  void _onButtonPressed(BuildContext context, String route) {
    if (route == 'Cerrar Sesión'.tr) {
      _logOut(context);
    } else if (route == 'Configuración'.tr) {
      _showConfiguracionDialog(context);
    } else {
      print('Navegando a $route'.tr);
    }
  }

  void _showConfiguracionDialog(BuildContext context) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(16),
            width: 700,
            height: 800,
            child: ConfiguracionScreen(),
          ),
        );
      },
    );

    if (result != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username'.tr, result['username'.tr] ?? '');
      await prefs.setString('email'.tr, result['email'.tr] ?? '');

      setState(() {
        _username = result['username'.tr];
        _email = result['email'.tr];
      });
    }
  }

  void closeWithResult(BuildContext context, String newUsername, String newEmail) {
    Navigator.of(context).pop({'username'.tr: newUsername, 'email'.tr: newEmail});
  }

  void _logOut(BuildContext context) async {
    try {
      await userService.logOut();
      Get.snackbar('Éxito'.tr, 'Has cerrado sesión correctamente'.tr);

      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error'.tr, 'Hubo un problema al cerrar sesión'.tr);
    }
  }
}
