/* import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket _socket;

  void connect() {
    _socket = IO.io(
      'http://localhost:3000', // Reemplaza con la URL de tu backend
      IO.OptionBuilder()
          .setTransports(['websocket']) // Solo WebSocket
          .enableAutoConnect()
          .build(),
    );

    _socket.onConnect((_) {
      print('Conectado al servidor de chat');
    });

    _socket.onDisconnect((_) {
      print('Desconectado del servidor de chat');
    });
  }

  void joinChat(String chatId) {
    _socket.emit('joinChat', chatId);
    print('Unido al chat $chatId');
  }

  void sendMessage(String chatId, String senderId, String content) {
    _socket.emit('sendMessage', {
      'chatId': chatId,
      'sender': senderId,
      'content': content,
    });
  }

  void onReceiveMessage(Function(dynamic) callback) {
    _socket.on('receiveMessage', callback);
  }

  void loadUserChats(String senderEmail, String receiverEmail) {
    _socket.emit('load_user_chats', {
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
    });
  }

  void onLoadUniqueChat(Function(dynamic) callback) {
    _socket.on('loadUniqueChat', callback);
  }

  void disconnect() {
    _socket.disconnect();
  }
}

*/
/*
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

class ChatService {
  late IO.Socket _socket;

  void connect(String username) {
    _socket = IO.io(
      'http://127.0.0.1:3000', // Reemplaza con la URL de tu backend
      IO.OptionBuilder()
          .setTransports(['websocket']) // Solo WebSocket
          .enableAutoConnect()
          .setQuery({'username': username})
          .build(),
    );

    // Evento de conexión
    _socket.onConnect((_) {
      print('Conectado al servidor de chat');

      // Emitir evento para registrar al usuario como conectado
      _socket.emit('userConnected', {
        // 'email': email,
        'username': username,
      });
      /*

      // Solicitar lista de usuarios conectados
      _socket.emit('getConnectedUsers');
    });*/

      // Evento de desconexión
      _socket.onDisconnect((_) {
        print('Desconectado del servidor de chat');
      });
    });

    // Escuchar usuarios conectados
    /*
  void onConnectedUsers(Function(List<dynamic>) callback) {
  _socket.on('connectedUsers', (data) {
    print('Usuarios conectados recibidos: $data');
    if (data is String) {
      try {
        final decodedData = jsonDecode(data) as List<dynamic>;
        callback(decodedData);
      } catch (e) {
        print('Error al decodificar usuarios conectados: $e');
      }
    } else if (data is List<dynamic>) {
      callback(data);
    } else {
      print('Formato de datos inesperado: $data');
    }
  });
}
*/
/*
  void onConnectedUsers(Function(dynamic) callback) {
    _socket.on('connectedUsers', (data) {
      print('Usuarios conectados recibidos: $data');

      try {
        // Declarar la lista decodificada
        List<dynamic> decodedData;

        // Verificar si data es un String JSON
        if (data is String) {
          decodedData = jsonDecode(data) as List<dynamic>;
        }
        // Verificar si data ya es una lista
        else if (data is List<dynamic>) {
          decodedData = data;
        }
        // Manejar formatos inesperados
        else {
          print('Formato de datos inesperado: $data');
          return;
        }

        // Ejecutar el callback con los datos decodificados
        callback(decodedData);
      } catch (e) {
        print('Error al decodificar usuarios conectados: $e');
      }
    });
  }
  */

    void onConnectedUsers(Function(dynamic) callback) {
      _socket.on('connectedUsers', (data) {
        callback(data);
        print('Usuarios conectados recibidos : $data');
      });
    }

    // Unirse a un chat
    void joinChat(String chatId) {
      _socket.emit('joinChat', chatId);
      print('Unido al chat $chatId');
    }

    // Enviar un mensaje
    void sendMessage(String chatId, String senderId, String content) {
      _socket.emit('sendMessage', {
        'chatId': chatId,
        'sender': senderId,
        'content': content,
      });
    }

    // Escuchar recepción de mensajes
    void onReceiveMessage(Function(dynamic) callback) {
      _socket.on('receiveMessage', callback);
    }

    // Cargar chats de usuario
    void loadUserChats(String senderEmail, String receiverEmail) {
      _socket.emit('load_user_chats', {
        'senderEmail': senderEmail,
        'receiverEmail': receiverEmail,
      });
    }

    // Escuchar mensajes cargados de un chat único
    void onLoadUniqueChat(Function(dynamic) callback) {
      _socket.on('loadUniqueChat', callback);
    }

    // Desconectar el socket
    void disconnect() {
      _socket.disconnect();
    }
  }
}
*/

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket _socket;

  /// Conectar al servidor de chat
  void connect(String username) {
    _socket = IO.io(
      'http://127.0.0.1:3000', // Cambiar a la URL de tu backend
      IO.OptionBuilder()
          .setTransports(['websocket']) // Usar WebSocket
          .enableAutoConnect()
          .setQuery({'username': username}) // Enviar el username al conectar
          .build(),
    );

    // Evento de conexión
    _socket.onConnect((_) {
      print('Conectado al servidor de chat como $username');
      _socket.emit('userConnected', {'username': username});
    });

    // Evento de desconexión
    _socket.onDisconnect((_) {
      print('Desconectado del servidor de chat');
    });

    // Manejo de errores
    _socket.onError((data) {
      print('Error en el socket: $data');
    });

    // Manejo de reconexión
    _socket.onReconnect((_) {
      print('Reconectado al servidor de chat');
    });
  }

  /// Escuchar usuarios conectados
  void onConnectedUsers(Function(List<dynamic>) callback) {
    _socket.on('connectedUsers', (data) {
      print('Usuarios conectados recibidos: $data');
      if (data is List<dynamic>) {
        callback(data);
      } else {
        print('Formato de datos inesperado: $data');
      }
    });
  }

  /// Unirse a un chat
  void joinChat(String chatId) {
    _socket.emit('joinChat', {'chatId': chatId});
    print('Unido al chat $chatId');
  }

  /// Enviar un mensaje
  void sendMessage(String chatId, String senderId, String content) {
    _socket.emit('sendMessage', {
      'chatId': chatId,
      'sender': senderId,
      'content': content,
    });
    print('Mensaje enviado al chat $chatId');
  }

  /// Escuchar recepción de mensajes
  void onReceiveMessage(Function(dynamic) callback) {
    _socket.on('receiveMessage', (data) {
      print('Mensaje recibido: $data');
      callback(data);
    });
  }

  /// Cargar chats de usuario
  void loadUserChats(String senderEmail, String receiverEmail) {
    _socket.emit('load_user_chats', {
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
    });
  }

  /// Escuchar mensajes cargados de un chat único
  ///
  /*
  void onLoadUniqueChat(Function(List<dynamic>) callback) {
    _socket.on('loadUniqueChat', (data) {
      print('Chats cargados: $data');
      if (data is List<dynamic>) {
        callback(data);
      } else {
        print('Formato de datos inesperado para los chats: $data');
      }
    });
  }

  */

  void onLoadUniqueChat(Function(dynamic) callback) {
    _socket.on('messagesLoaded', (data) {
      if (data is List<dynamic>) {
        callback(data);
      } else if (data is Map<String, dynamic>) {
        callback([data]); // Convertir un solo mensaje en una lista
      } else {
        print('Formato inesperado en mensajes cargados: $data');
      }
    });
  }

  /// Desconectar el socket
  void disconnect() {
    _socket.disconnect();
    print('Socket desconectado');
  }
}
