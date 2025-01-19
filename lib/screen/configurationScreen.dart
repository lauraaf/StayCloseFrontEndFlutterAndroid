import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/userController.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/userServices.dart';

class ConfiguracionScreen extends StatefulWidget {
  @override
  _ConfiguracionScreenState createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  String? _userId;

  final UserController userController = Get.find<UserController>();
  final UserService userService = Get.find<UserService>();

  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _provinceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('user_id');
    });

    if (_userId != null) {
      await _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    await userController.fetchUser(_userId!);
    if (userController.user.value != null) {
      setState(() {
        _usernameController.text = userController.user.value!.username;
        _nameController.text = userController.user.value!.name;
        _emailController.text = userController.user.value!.email;

        if (userController.user.value!.home != null) {
          final homeParts = userController.user.value!.home!.split(", ");
          if (homeParts.length == 3) {
            _streetController.text = homeParts[0];
            _numberController.text = homeParts[1];
            _provinceController.text = homeParts[2];
          }
        }
      });
    }
  }

  void _saveConfiguration() async {
    final updatedUser = UserModel(
      username: _usernameController.text.trim(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: userController.user.value!.password,
      actualUbication: userController.user.value!.actualUbication,
      inHome: userController.user.value!.inHome,
      admin: userController.user.value!.admin,
      disabled: userController.user.value!.disabled,
      avatar: userController.uploadedImageUrl.value,
      home:
          "${_streetController.text.trim()}, ${_numberController.text.trim()}, ${_provinceController.text.trim()}",
    );

    await userService.editUser(updatedUser, _userId!, _passController.text.trim());
    Get.snackbar('Éxito'.tr, 'Configuración guardada correctamente'.tr);
    Navigator.pop(context);
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Estás Seguro?'.tr),
          content: Text('¿Estás seguro de que deseas eliminar tu cuenta?'.tr),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'.tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteUser();
              },
              child: Text('Eliminar'.tr),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser() async {
    if (_userId != null) {
      final success = await userService.deleteUser(_userId!);
      if (success == 200) {
        Get.snackbar('Éxito'.tr, 'Usuario eliminado correctamente'.tr);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Get.offAllNamed('/login');
      } else {
        Get.snackbar('Error'.tr, 'No se pudo eliminar el usuario'.tr);
      }
    }
  }

  void _onAvatarPressed() {
    userController.pickImage();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : const Color(0xFFE5E5E5),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width > 600 ? 600 : double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _onAvatarPressed,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    child: Obx(() {
                      return userController.selectedImage.value != null
                          ? ClipOval(
                              child: Image.memory(
                                userController.selectedImage.value!,
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              ),
                            )
                          : Icon(Icons.person, size: 60, color: Colors.white);
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField('Nombre de Usuario', _usernameController),
                const SizedBox(height: 16),
                _buildTextField('Nombre Completo', _nameController),
                const SizedBox(height: 16),
                _buildAddressFields(),
                const SizedBox(height: 16),
                _buildTextField('Correo Electrónico', _emailController),
                const SizedBox(height: 16),
                _buildTextField('Contraseña', _passController, obscureText: true),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveConfiguration,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text('Guardar'.tr),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _showDeleteConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text('Eliminar Cuenta'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label.tr,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildAddressFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dirección de tu casa'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildTextField('Calle', _streetController)),
            const SizedBox(width: 8),
            Expanded(child: _buildTextField('Número', _numberController)),
            const SizedBox(width: 8),
            Expanded(child: _buildTextField('Provincia', _provinceController)),
          ],
        ),
      ],
    );
  }
}
