/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/userServices.dart';
import 'package:flutter_application_1/models/user.dart';

class UserListController extends GetxController {
  var isLoading = true.obs;
  var userList = <UserModel>[].obs; // Tipus de llista especificat
  final UserService userService = UserService();
  var currentPage = 1.obs; // Pàgina actual
  var limit = 10.obs; // Nombre d'usuaris a mostrar

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future fetchUsers() async {
    try {
      isLoading(true);
      var users = await userService.getUsers(
          currentPage.value, limit.value); // Passar pàgina i límit
      if (users != null) {
        userList.assignAll(users);
      }
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading(false);
    }
  }

  void setLimit(int newLimit) {
    limit.value = newLimit;
    currentPage.value = 1; // Reinicia la pàgina a 1 quan canvia el límit
    fetchUsers(); // Torna a carregar els usuaris
  }

  void nextPage() {
    currentPage.value++;
    fetchUsers(); // Torna a carregar els usuaris per a la nova pàgina
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchUsers(); // Torna a carregar els usuaris per a la nova pàgina
    }
  }
}

*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/userController.dart';
import '../services/chatService.dart';
import 'sendMessageScreen.dart';

class SearchUserScreen extends StatelessWidget {
  final UserController _userController = Get.put(UserController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Usuario'),
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por username...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _userController.searchUser(value); // Buscar usuarios
                }
              },
            ),
          ),
          // Resultados de búsqueda
          Obx(() {
            if (_userController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (_userController.searchResults.isNotEmpty) {
              return Expanded(
                child: ListView.builder(
                  itemCount: _userController.searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _userController.searchResults[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(user.username[0].toUpperCase()),
                      ),
                      title: Text(user.username),
                      subtitle: Text(user.email),
                      onTap: () async {
                        final sender = _userController.currentUserName.value;
                        final receiver = user.username;

                        try {
                          // Llamar al servicio para obtener o crear el chat
                          final chatId = await ChatService.createOrGetChat(
                            sender: sender,
                            receiver: receiver,
                          );

                          // Navegar a la pantalla de mensajes
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SendMessageScreen(
                                receiverUsername: receiver,
                                chatId: chatId, // Pasar el chatId recibido
                              ),
                            ),
                          );
                        } catch (e) {
                          Get.snackbar("Error", "No se pudo iniciar el chat");
                        }
                      },
                    );
                  },
                ),
              );
            } else if (_searchController.text.isNotEmpty) {
              return const Center(child: Text('No se encontraron usuarios.'));
            } else {
              return Container(); // Mostrar vacío si no hay búsqueda activa
            }
          }),
        ],
      ),
    );
  }
}
