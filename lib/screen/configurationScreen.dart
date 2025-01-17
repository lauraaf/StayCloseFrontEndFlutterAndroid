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
  String? _username;
  String? _email;

  final UserController userController = Get.find<UserController>();
  final UserService userService = Get.find<UserService>();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _homeController = TextEditingController();

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
        // No se establece el texto del _passController para no mostrar la contraseña
        _homeController.text = userController.user.value!.home;
      });
    } else {
      Get.snackbar('Error'.tr, 'No se pudo obtener los datos del usuario'.tr);
    }
  }

  void _saveConfiguration() async {
    String newUsername = _usernameController.text.trim();
    String newName = _nameController.text.trim();
    String newEmail = _emailController.text.trim();
    String newPassword = _passController.text.trim();
    String newHomeAddress = _homeController.text.trim();

    if (newUsername.isEmpty || newEmail.isEmpty || newPassword.isEmpty) {
      Get.snackbar('Error'.tr, 'Los campos no pueden estar vacíos'.tr);
    } else if (_userId == null) {
      Get.snackbar('Error'.tr, 'No se pudo obtener la ID del usuario'.tr);
    } else {
      // Subir la imagen a Cloudinary si es necesario
      if (userController.selectedImage.value != null) {
        await userController.uploadImageToCloudinary();
      }

      // Obtener la URL de la imagen subida
      String avatarUrl = userController.uploadedImageUrl.value;

      // Actualizar los datos del usuario con la nueva imagen, si hay
      UserModel updatedUser = UserModel(
        username: newUsername.isNotEmpty ? newUsername : userController.user.value!.username,
        name: newName.isNotEmpty ? newName : userController.user.value!.name,
        email: newEmail.isNotEmpty ? newEmail : userController.user.value!.email,
        password: userController.user.value!.password, // No actualizamos la contraseña aquí
        actualUbication: userController.user.value!.actualUbication,
        inHome: userController.user.value!.inHome,
        admin: userController.user.value!.admin,
        disabled: userController.user.value!.disabled,
        avatar: avatarUrl.isNotEmpty ? avatarUrl : userController.user.value!.avatar, // Usar la URL de la imagen
        home: newHomeAddress.isNotEmpty ? newHomeAddress : userController.user.value!.home,
      );

      // Guardar los cambios
      await userService.editUser(updatedUser, _userId!, newPassword); // Pasa la contraseña al servicio

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', newUsername);
      await prefs.setString('email', newEmail);

      setState(() {
        _username = newUsername;
        _email = newEmail;
      });

      Get.snackbar('Éxito'.tr, 'Configuración guardada correctamente'.tr);
      Navigator.pop(context);
    }
  }

  Future<void> _deleteUser() async {
    if (_userId != null) {
      int success = await userService.deleteUser(_userId!);
      if (success == 200) {
        Get.snackbar('Éxito'.tr, 'Usuario eliminado correctamente'.tr);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('user_id');
        await prefs.remove('user_data');
        await userService.logOut();

        Get.offAllNamed('/login');
      } else {
        Get.snackbar('Error'.tr, 'No se pudo eliminar el usuario'.tr);
      }
    } else {
      Get.snackbar('Error'.tr, 'ID de usuario no disponible'.tr);
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Estas Seguro?'.tr),
          content: Text('¿Estás seguro de que deseas eliminar tu cuenta? Esta acción es irreversible.'.tr),
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

  void _onAvatarPressed() {
    userController.pickImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 600,
              decoration: BoxDecoration(
                color: Color(0xFF89AFAF),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Configuración de Perfil".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 700,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar centrado y con función al presionarlo
                    GestureDetector(
                      onTap: _onAvatarPressed,
                      child: Center(
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey[300],
                          child: Obx(() {
                            return userController.selectedImage.value != null
                                ? ClipOval(
                                    child: Image.memory(
                                      userController.selectedImage.value!, // Accede al valor de selectedImage
                                      fit: BoxFit.cover,
                                      width: 160,
                                      height: 160,
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Colors.white,
                                  );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de Usuario'.tr,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre Completo'.tr,
                        border: OutlineInputBorder(),
                      ),
                    ),const SizedBox(height: 16),
                    TextField(
                      controller: _homeController,
                      decoration: InputDecoration(
                        labelText: 'Dirección de tu casa'.tr,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico'.tr,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña'.tr,
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveConfiguration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF89AFAF),
                        foregroundColor: Colors.white,
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
          ],
        ),
      ),
    );
  }
}