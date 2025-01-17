/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/connectedUser.dart';
import '../services/chatService.dart';
import '../controllers/userController.dart';
import '../screen/chatScreen.dart';
import 'package:flutter_application_1/controllers/userController.dart';
import '../controllers/chatController.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ChatService _chatService = ChatService();
  final UserController _userController = Get.find<UserController>();
  final ChatController chatController = Get.put(ChatController());

  List<ConnectedUser> connectedUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    String loggedInUsername = _userController.currentUserName.value;
   
    _chatService.connect(loggedInUsername);

    // Escuchar usuarios conectados
    _chatService.onConnectedUsers((data) {
      if (!mounted) return;
      setState(() {
        connectedUsers = data
            .map<ConnectedUser>((user) => ConnectedUser.fromJson(user))
            .toSet()
            .toList(); // Evitar duplicados
            print('Usuarios conectados recibidos: $data');

      });
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _chatService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios Conectados'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : connectedUsers.isEmpty
              ? Center(child: Text('No hay usuarios conectados'))
              : ListView.builder(
                  itemCount: connectedUsers.length,
                  itemBuilder: (context, index) {
                    final user = connectedUsers[index];
                    return ListTile(
                      title: Text(user.username),
                      onTap: () async {
                        String senderId = _userController.currentUserName.value;
                        String receiverId = user.username;
                        //String chatId = '${senderId}_$receiverId';
                         try {
                                 // Llama a la función del controlador para iniciar el chat
                              await chatController.startChat(senderId, receiverId);

                                 // Luego navega al ChatScreen
                             Navigator.push(
                                context,
                              MaterialPageRoute(
        builder: (context) => ChatScreen(
          senderUsername: senderId,
          receiverUsername: receiverId,
        ),
      ),
    );
  } catch (e) {
    print('Error al iniciar el chat: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No se pudo iniciar el chat')),
    );
  }
                        
                      },
                    );
                  },
                ),
    );
  }
}

*/

/*

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/userController.dart';
import 'chatScreen.dart';

class UserListScreen extends StatelessWidget {
  final UserController _userController = Get.put(UserController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _userController.fetchConnectedUsers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios Conectados'),
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
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _userController.searchUser(value);
                }
              },
            ),
          ),
          // Resultados de búsqueda
          Obx(() {
            if (_userController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else if (_userController.searchResults.isNotEmpty) {
              return Expanded(
                child: ListView.builder(
                  itemCount: _userController.searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _userController.searchResults[index];
                    return ListTile(
                      title: Text(user.username),
                      subtitle: Text(user.email),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              senderUsername:
                                  _userController.currentUserName.value,
                              receiverUsername: user.username,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          }),
          Divider(),
          // Lista de usuarios conectados
          Expanded(
            child: Obx(() {
              if (_userController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (_userController.connectedUsers.isEmpty) {
                return Center(child: Text('No hay usuarios conectados.'));
              } else {
                return ListView.builder(
                  itemCount: _userController.connectedUsers.length,
                  itemBuilder: (context, index) {
                    final user = _userController.connectedUsers[index];
                    return ListTile(
                      title: Text(user.username),
                      subtitle: Text(user.email),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              senderUsername:
                                  _userController.currentUserName.value,
                              receiverUsername: user.username,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}

*/

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/userController.dart';
import 'sendMessageScreen.dart';

class SearchUserScreen extends StatelessWidget {
  final UserController _userController = Get.put(UserController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Usuario'),
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
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _userController
                      .searchUser(value); // Llama al método de búsqueda
                }
              },
            ),
          ),

          // Resultados de búsqueda
          Obx(() {
            if (_userController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
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
                      onTap: () {
                        String senderId = _userController.currentUserName.value;
                        String receiverId = user.username;

                        // Navegar al ChatScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendMessageScreen(
                              receiverUsername: user.username,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            } else if (_searchController.text.isNotEmpty) {
              return Center(child: Text('No se encontraron usuarios.'));
            } else {
              return Container(); // Mostrar vacío si no hay búsqueda activa
            }
          }),
        ],
      ),
    );
  }
}

*/

/*

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/userController.dart';
import '../services/chatService.dart';
import 'chatScreen.dart';
import 'sendMessageScreen.dart';

class SearchUserScreen extends StatelessWidget {
  final UserController _userController = Get.put(UserController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Usuario'),
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
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _userController
                      .searchUser(value); // Llama al método de búsqueda
                }
              },
            ),
          ),

          // Resultados de búsqueda
          Obx(() {
            if (_userController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
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
                        String senderId = _userController.currentUserName.value;
                        String receiverId = user.username;

                        try {
                          // Llama al servicio para obtener o crear el chat
                          final chatId = await ChatService.createOrGetChat(
                            sender: senderId,
                            receiver: receiverId,
                          );

                          // Navegar a la pantalla del chat
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                chatId: chatId,
                                senderUsername: senderId,
                                receiverUsername: receiverId,
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
              return Center(child: Text('No se encontraron usuarios.'));
            } else {
              return Container(); // Mostrar vacío si no hay búsqueda activa
            }
          }),
        ],
      ),
    );
  }
}

*/

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/userController.dart';
import '../services/chatService.dart';
import 'chatScreen.dart';

class SearchUserScreen extends StatelessWidget {
  final UserController _userController = Get.put(UserController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Usuario'),
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
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _userController
                      .searchUser(value); // Llama al método de búsqueda
                }
              },
            ),
          ),

          // Resultados de búsqueda
          Obx(() {
            if (_userController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
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
                        String senderId = _userController.currentUserName.value;
                        String receiverId = user.username;

                        try {
                          // Llama al servicio para obtener o crear el chat
                          final chatId = await ChatService.createOrGetChat(
                            sender: senderId,
                            receiver: receiverId,
                          );

                          // Navegar a la pantalla del chat
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                chatId: chatId,
                                senderUsername: senderId,
                                receiverUsername: receiverId,
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
              return Center(child: Text('No se encontraron usuarios.'));
            } else {
              return Container(); // Mostrar vacío si no hay búsqueda activa
            }
          }),
        ],
      ),
    );
  }
}


*/

/*

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/sendMessageScreen.dart';
import 'package:get/get.dart';
import '../controllers/userController.dart';
import '../controllers/chatController.dart'; // Importa el controlador de Chat
import 'chatScreen.dart';
import 'sendMessageScreen.dart';

class SearchUserScreen extends StatelessWidget {
  final UserController _userController = Get.put(UserController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Usuario'),
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
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _userController
                      .searchUser(value); // Llama al método de búsqueda
                }
              },
            ),
          ),

          // Resultados de búsqueda
          Obx(() {
            if (_userController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
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
                        // Obtener el ID del usuario actual y del usuario seleccionado
                        final sender =
                            Get.find<UserController>().currentUserName.value;
                        final receiver = user.username;

                        // Obtener el ChatController
                        final ChatController chatController =
                            Get.put(ChatController());

                        try {
                          // Llama al método para obtener o crear el chat
                          await chatController.getOrCreateChat(
                              sender: sender, receiver: receiver);

                          if (chatController.chatId.isNotEmpty) {
                            // Navegar a la pantalla del chat con el chatId
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SendMessageScreen(
                                  chatId: chatController
                                      .chatId.value, // Pasar el chatId obtenido
                                  senderUsername: sender,
                                  receiverUsername: receiver,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          Get.snackbar("Error", "No se pudo iniciar el chat");
                        }
                      },
                    );
                  },
                ),
              );
            } else if (_searchController.text.isNotEmpty) {
              return Center(child: Text('No se encontraron usuarios.'));
            } else {
              return Container(); // Mostrar vacío si no hay búsqueda activa
            }
          }),
        ],
      ),
    );
  }
}

*/

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/userController.dart';
import '../controllers/chatController.dart'; // ChatController centraliza la lógica
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
                  _userController
                      .searchUser(value); // Llama al método de búsqueda
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
                       final sender = Get.find<UserController>().currentUserName.value;
                       final receiver = user.username;

                        try {
                          // Llama al servicio para obtener o crear el chat
                             final chatId = await ChatService.createOrGetChat(
                              sender: sender,
                              receiver: receiver,
                          );
                            // Navegar a SendMessageScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SendMessageScreen(
                                  receiverUsername: receiverId,
                                  chatId: chatController
                                      .chatId.value, // Usa el chatId obtenido
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

*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/userController.dart';
import '../controllers/chatController.dart'; // Importar el controlador del chat
import 'sendMessageScreen.dart';

class UserListScreen extends StatelessWidget {
  final UserController _userController =
      Get.put(UserController()); // Instancia del controlador de usuarios
  final ChatController _chatController =
      Get.put(ChatController()); // Instancia del controlador de chat
  final TextEditingController _searchController =
      TextEditingController(); // Controlador del campo de búsqueda

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
                  _userController
                      .searchUser(value); // Llama al método para buscar usuario
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
                          // Inicia la creación o búsqueda del chat
                          await _chatController.getOrCreateChat(
                            sender: sender,
                            receiver: receiver,
                          );

                          // Si se obtiene un chatId, navegar a la pantalla del chat
                          if (_chatController.chatId.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SendMessageScreen(
                                  receiverUsername: receiver,
                                  chatId: _chatController
                                      .chatId.value, // Pasa el chatId
                                ),
                              ),
                            );
                          } else {
                            Get.snackbar(
                              "Error",
                              "No se pudo obtener el chatId",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        } catch (e) {
                          Get.snackbar(
                            "Error",
                            "No se pudo iniciar el chat",
                            snackPosition: SnackPosition.BOTTOM,
                          );
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
