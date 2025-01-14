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
    _socket.on('receiveMessage', (data) {
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

  // Desconectar
  void disconnect() {
    if (_isConnected) {
      _socket.disconnect();
      _isConnected = false;
      print('Desconectado del servidor.');
    }
  }
}
