/*import 'package:get/get.dart';
import '../models/message.dart';
import '../services/chatService.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final RxList<Message> messages = <Message>[].obs;

  void connectToChat(
      String chatId, String senderUsername, String receiverUsername) {
    _chatService.connect(senderUsername);
    _chatService.joinChat(chatId);

    _chatService.onReceiveMessage((data) {
      final Message message = Message.fromJson(data);
      //Message.fromJson(data);
      print("niuevo Mensaje $data");
      messages.add(message);
    });

    /*

    _chatService.onReceiveMessage((data) {
      final Message message = Message.fromJson(data);
      print("niuevo Mensaje $data");
      messages.add(message);
    });
    */
  }

  void loadChatMessages(String senderEmail, String receiverEmail) {
    _chatService.loadUserChats(senderEmail, receiverEmail);

    _chatService.onLoadUniqueChat((data) {
      final Message message = Message.fromJson(data);
      messages.add(message);
    });
  }

  void sendMessage(String chatId, String senderId, String content) {
    _chatService.sendMessage(chatId, senderId, content);
    messages.add(Message(
        senderId: senderId, content: content, timestamp: DateTime.now()));
  }

  @override
  void onClose() {
    _chatService.disconnect();
    super.onClose();
  }
}

*/
/*
import 'package:get/get.dart';
import '../models/message.dart';
import '../services/chatService.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final RxList<Message> messages = <Message>[].obs;

  void connectToChat(
      String chatId, String senderUsername, String receiverUsername) {
    _chatService.connect(senderUsername);
    _chatService.joinChat(chatId);

    _chatService.onReceiveMessage((data) {
      // Validar si `data` es un mapa o una lista
      if (data is Map<String, dynamic>) {
        // Crear un mensaje único
        final Message message = Message.fromJson(data);
        messages.add(message);
        print("Nuevo mensaje recibido: $data");
      } else if (data is List<dynamic>) {
        // Procesar lista de mensajes
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            final Message message = Message.fromJson(item);
            messages.add(message);
          } else {
            print("Formato de mensaje inesperado: $item");
          }
        }
      } else {
        print("Formato de datos inesperado: $data");
      }
    });
  }

  void loadChatMessages(String senderEmail, String receiverEmail) {
    _chatService.loadUserChats(senderEmail, receiverEmail);

    _chatService.onLoadUniqueChat((data) {
      print("Datos recibidos: $data");
      print("Tipo de datos: ${data.runtimeType}");

      // Validar si `data` es un mapa o una lista
      if (data is Map<String, dynamic>) {
        try {
          final Message message = Message.fromJson(data);
          messages.add(message);
        } catch (e) {
          print("Error al procesar el mensaje: $e");
        }
      } else if (data is List<dynamic>) {
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            try {
              final Message message = Message.fromJson(item);
              messages.add(message);
            } catch (e) {
              print("Error al procesar el mensaje: $e");
            }
          } else {
            print("Formato de mensaje inesperado: $item");
          }
        }
      } else {
        print("Formato de datos inesperado: $data");
      }
    });
  }

  void sendMessage(String chatId, String senderId, String content) {
    _chatService.sendMessage(chatId, senderId, content);
    messages.add(Message(
        senderId: senderId, content: content, timestamp: DateTime.now()));
  }

  @override
  void onClose() {
    _chatService.disconnect();
    super.onClose();
  }
}
*/

//19.29
/*


import 'package:get/get.dart';
import '../models/message.dart';
import '../services/chatService.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final RxList<Message> messages = <Message>[].obs;

  void connectToChat(
      String chatId, String senderUsername, String receiverUsername) {
    _chatService.connect(senderUsername);
    _chatService.joinChat(chatId);

    _chatService.onReceiveMessage((data) {
      // Validar el tipo de `data` y procesarlo adecuadamente
      if (data is Map<String, dynamic>) {
        try {
          final Message message = Message.fromJson(data);
          messages.add(message);
          print("Nuevo mensaje recibido: $data");
        } catch (e) {
          print("Error al procesar el mensaje único: $e");
        }
      } else if (data is List) {
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            try {
              final Message message = Message.fromJson(item);
              messages.add(message);
            } catch (e) {
              print("Error al procesar un mensaje de la lista: $e");
            }
          } else {
            print("Formato inesperado en la lista de mensajes: $item");
          }
        }
      } else {
        print("Formato de datos inesperado: $data");
      }
    });
  }

  void loadChatMessages(String senderEmail, String receiverEmail) {
    _chatService.loadUserChats(senderEmail, receiverEmail);

    _chatService.onLoadUniqueChat((data) {
      print("Datos recibidos en loadChatMessages: $data");
      print("Tipo de datos: ${data.runtimeType}");

      // Validar el tipo de `data` y procesarlo adecuadamente
      if (data is Map<String, dynamic>) {
        try {
          final Message message = Message.fromJson(data);
          messages.add(message);
        } catch (e) {
          print("Error al procesar el mensaje único en loadChatMessages: $e");
        }
      } else if (data is List) {
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            try {
              final Message message = Message.fromJson(item);
              messages.add(message);
            } catch (e) {
              print(
                  "Error al procesar un mensaje de la lista en loadChatMessages: $e");
            }
          } else {
            print("Formato inesperado en la lista de mensajes: $item");
          }
        }
      } else {
        print("Formato de datos inesperado en loadChatMessages: $data");
      }
    });
  }

  void sendMessage(String chatId, String senderId, String content) {
    _chatService.sendMessage(chatId, senderId, content);
    messages.add(Message(
        senderId: senderId, content: content, timestamp: DateTime.now()));
  }

  @override
  void onClose() {
    _chatService.disconnect();
    super.onClose();
  }
}
*/

import 'package:get/get.dart';
import '../models/message.dart';
import '../services/chatService.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final RxList<Message> messages = <Message>[].obs;

  void connectToChat(
      String chatId, String senderUsername, String receiverUsername) {
    _chatService.connect(senderUsername);
    _chatService.joinChat(chatId);

    _chatService.onReceiveMessage((data) {
      // Manejo de datos recibidos
      if (data is Map<String, dynamic>) {
        try {
          final Message message = Message.fromJson(data);
          messages.add(message);
          print("Mensaje recibido: $data");
        } catch (e) {
          print("Error al procesar el mensaje único: $e");
        }
      } else if (data is List) {
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            try {
              final Message message = Message.fromJson(item);
              messages.add(message);
            } catch (e) {
              print("Error al procesar un mensaje de la lista: $e");
            }
          } else {
            print("Formato inesperado en la lista de mensajes: $item");
          }
        }
      } else {
        print("Formato de datos inesperado: $data");
      }
    });
  }

  void loadChatMessages(String senderEmail, String receiverEmail) {
    _chatService.loadUserChats(senderEmail, receiverEmail);

    _chatService.onLoadUniqueChat((data) {
      // Manejo de datos recibidos
      if (data is Map<String, dynamic>) {
        try {
          final Message message = Message.fromJson(data);
          messages.add(message);
        } catch (e) {
          print("Error al procesar el mensaje único en loadChatMessages: $e");
        }
      } else if (data is List) {
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            try {
              final Message message = Message.fromJson(item);
              messages.add(message);
            } catch (e) {
              print(
                  "Error al procesar un mensaje de la lista en loadChatMessages: $e");
            }
          } else {
            print("Formato inesperado en la lista de mensajes: $item");
          }
        }
      } else {
        print("Formato de datos inesperado en loadChatMessages: $data");
      }
    });
  }

  void sendMessage(String chatId, String senderId, String content) {
    _chatService.sendMessage(chatId, senderId, content);
    messages.add(Message(
        senderId: senderId, content: content, timestamp: DateTime.now()));
  }

  @override
  void onClose() {
    _chatService.disconnect();
    super.onClose();
  }
}
