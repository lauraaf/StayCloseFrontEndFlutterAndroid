import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/userServices.dart';
import 'package:flutter_application_1/controllers/userController.dart'; // Controlador para crear el post
import 'configurationScreen.dart'; // Importamos la nueva pantalla de configuración

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String? _username;
  String? _email;

  final UserService userService = Get.put(UserService());
  final UserController userController = Get.put(UserController());  // Controlador para crear post

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Cargar los datos del usuario desde SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
      _email = prefs.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'.tr, style: TextStyle(color: Colors.white)), // Traducción dinámica
        backgroundColor: Color(0xFF89AFAF),
        actions: [
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white,
                  ),
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
                  child: _buildProfileButton(context, 'Configuración'.tr), // Traducción dinámica
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: _buildProfileButton(context, 'Cerrar Sesión'.tr), // Traducción dinámica
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () => _onButtonPressed(context, text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF89AFAF),
        foregroundColor: Colors.white,
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
            width: 500,
            height: 500,
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
