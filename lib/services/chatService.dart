/*
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  static final ChatService _instance = ChatService._internal();
  late IO.Socket _socket;
  bool _isConnected = false;

  factory ChatService() {
    return _instance;
  }

  ChatService._internal();

  /// Conectar al servidor de chat

  void connect(String username) {
    if (_isConnected) {
      print('El socket ya está conectado.');
      return;
    }

    _socket = IO.io(
      'http://127.0.0.1:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setQuery({'username': username})
          .build(),
    );

    _socket.onConnect((_) {
      print('Conectado al servidor de chat como $username');
      _socket.emit('userConnected', {'username': username});
      _isConnected = true;
    });

    _socket.onDisconnect((_) {
      print('Desconectado del servidor de chat');
      _isConnected = false;
    });

    _socket.onError((data) {
      print('Error en el socket: $data');
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
    if (!_isConnected) {
      print('Socket no inicializado. Llama a `connect` primero.');
      return;
    }
    _socket.emit('joinChat', chatId);
    print('Unido al chat $chatId');
  }

  /// Enviar un mensaje
  void sendMessage(
      String chatId, String senderId, String content, String receiverId) {
    if (!_isConnected) {
      print('Socket no inicializado. Llama a `connect` primero.');
      return;
    }
    _socket.emit('sendMessage', {
      'chatId': chatId,
      'sender': senderId,
      'content': content,
      'receiver': receiverId,
    });
    print('Mensaje enviado al chat $chatId');
  }

  /// Escuchar recepción de mensajes
  /// //En construccion//
  void onReceiveMessage(Function(Map<String, dynamic>) callback) {
    _socket.on('receiveMessage', (data) {
      print('Mensaje recibido en el cliente: $data');
      if (data is Map<String, dynamic>) {
        callback(data);
      } else {
        print('Formato inesperado de mensaje recibido: $data');
      }
    });
  }

  //fincontruccion//

  //cargar los mensajes entre dos usuarios
  /// Cargar mensajes entre dos usuarios
  void loadUserChats(String senderId, String receiverId) {
    if (!_isConnected) {
      print('Socket no inicializado. Llama a `connect` primero.');
      return;
    }
    _socket.emit('loadUserChats', {
      'senderId': senderId,
      'receiverId': receiverId,
    });
    print('Solicitando mensajes entre $senderId y $receiverId');
  }

  /// Escuchar mensajes cargados
  void onLoadMessages(Function(List<dynamic>) callback) {
    _socket.on('messagesLoaded', (data) {
      print('Mensajes cargados: $data');
      callback(data);
    });
  }

  /// Escuchar carga de un chat único
  void onLoadUniqueChat(Function(dynamic) callback) {
    _socket.on('uniqueChatLoaded', (data) {
      print('Chat único cargado: $data');
      callback(data);
    });
  }

  /// Desconectar el socket
  void disconnect() {
    if (_isConnected) {
      _socket.disconnect();
      _isConnected = false;
      print('Socket desconectado');
    }
  }
}

*/

/* FUNCIONA
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  static final ChatService _instance = ChatService._internal();
  late IO.Socket _socket;
  bool _isConnected = false;

  factory ChatService() => _instance;

  ChatService._internal();

  // Conectar al servidor
  void connect(String username) {
    if (_isConnected) {
      print('Ya conectado al servidor.');
      return;
    }

    _socket = IO.io(
      'http://127.0.0.1:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setQuery({'username': username})
          .build(),
    );

    _socket.onConnect((_) {
      print('Conectado como $username');
      _socket.emit('userConnected', {'username': username});
      _isConnected = true;
    });

    _socket.onDisconnect((_) {
      print('Desconectado del servidor.');
      _isConnected = false;
    });

    _socket.onError((data) {
      print('Error del socket: $data');
    });
  }

  // Escuchar usuarios conectados
  void onConnectedUsers(Function(List<dynamic>) callback) {
    _socket.on('connectedUsers', (data) {
      print('[INFO] Usuarios conectados recibidos: $data');
      if (data is List<dynamic>) {
        callback(data);
      } else {
        print('[ERROR] Formato inesperado: $data');
      }
    });
  }

  // Unirse a un chat
  void joinChat(String chatId) {
    if (!_isConnected) {
      print('Conexión no inicializada. Usa connect primero.');
      return;
    }
    _socket.emit('joinChat', chatId);
    print('Unido al chat $chatId');
  }

  // Enviar mensaje
  void sendMessage(
      String chatId, String senderId, String content, String receiverId) {
    if (!_isConnected) {
      print('Conexión no inicializada.');
      return;
    }
    _socket.emit('sendMessage', {
      'chatId': chatId,
      'sender': senderId,
      'content': content,
      'receiver': receiverId,
    });
  }

  // Escuchar mensajes entrantes
  void onReceiveMessage(Function(Map<String, dynamic>) callback) {
    //Eliminar cualquier escucha previa del evento 'receiveMessage'
    _socket.off('receiveMessage');
    //Registramos una nueva escucha para 'receiveMessage'
    _socket.on('receiveMessage', (data) {
      print('[INFO] Mensaje recibido: $data');
      if (data is Map<String, dynamic>) {
        callback(data);
      } else {
        print('Formato inesperado de mensaje: $data');
      }
    });
  }

  // Cargar historial de mensajes
  void loadUserChats(String senderId, String receiverId) {
    _socket.emit('loadUserChats', {
      'senderId': senderId,
      'receiverId': receiverId,
    });
  }

  void onLoadMessages(Function(List<dynamic>) callback) {
    _socket.on('messagesLoaded', (data) {
      if (data is List) {
        callback(data);
      } else {
        print('Formato inesperado al cargar mensajes: $data');
      }
    });
  }
  */
//fUNCIONA

// Obtener o crear un chat único
/*NOGUNCIONAAAAAA
  void startUniqueChat({
    required String senderUsername,
    required String receiverUsername,
    required Function(String chatId) onSuccess,
    required Function(String error) onError,
  }) {
    if (!_isConnected) {
      print('[ERROR] No conectado al servidor.');
      onError('No conectado al servidor.');
      return;
    }

    _socket.emit('startUniqueChat', {
      'senderUsername': senderUsername,
      'receiverUsername': receiverUsername,
    });

    _socket.on('openChat', (data) {
      print('[INFO] Chat abierto: $data');
      if (data is Map<String, dynamic> && data.containsKey('chatId')) {
        onSuccess(data['chatId']);
      } else {
        onError('[ERROR] Formato de respuesta inesperado.');
      }
    });

    _socket.on('error', (data) {
      print('[ERROR] Error del servidor: $data');
      onError(data.toString());
    });
  }
  //no funciona

  //////Funcionaaaa
  Future<void> startUniqueChat({
    required String senderUsername,
    required String receiverUsername,
    required Function(String chatId) onSuccess,
    required Function(String error) onError,
  }) async {
    if (!_isConnected) {
      print('[ERROR] No conectado al servidor.');
      onError('No conectado al servidor.');
      return;
    }

    // Emitir el evento al servidor
    _socket.emit('startUniqueChat', {
      'senderUsername': senderUsername,
      'receiverUsername': receiverUsername,
    });

    // Escuchar la respuesta del servidor
    _socket.once('openChat', (data) {
      print('[INFO] Chat abierto: $data');
      if (data is Map<String, dynamic> && data.containsKey('chatId')) {
        onSuccess(data['chatId']);
      } else {
        onError('[ERROR] Formato de respuesta inesperado.');
      }
    });

    _socket.once('error', (data) {
      print('[ERROR] Error del servidor: $data');
      onError(data.toString());
    });
  }

  // Desconectar
  void disconnect() {
    if (_isConnected) {
      _socket.disconnect();
      _isConnected = false;
      print('Desconectado del servidor.');
    }
  }
}

*/
/*

import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  static const String baseUrl = "http://127.0.0.1:3000/api/chat";

  // Método para iniciar un chat
  static Future<String> startChat(String sender, String receiver) async {
    final response = await http.post(
      Uri.parse("$baseUrl/start"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "sender": sender,
        "receiver": receiver,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['chatId']; // Devuelve el chatId
    } else {
      throw Exception("Error al iniciar el chat");
    }
  }
}

*/

import 'package:dio/dio.dart';

class ChatService {
  static final Dio _dio =
      Dio(BaseOptions(baseUrl: "http://127.0.0.1:3000/api/chat"));

  // Método para obtener o crear un chat
  static Future<String> createOrGetChat({
    required String sender,
    required String receiver,
  }) async {
    try {
      final response = await _dio.post(
        "/createOrGetChat",
        data: {"sender": sender, "receiver": receiver},
      );

      return response.data['chatId']; // Retornar el chatId
    } catch (e) {
      print("Error al buscar o crear chat: $e");
      throw Exception("No se pudo obtener el chatId");
    }
  }
}
