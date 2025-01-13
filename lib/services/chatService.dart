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
  void sendMessage(String chatId, String senderId, String content) {
    if (!_isConnected) {
      print('Socket no inicializado. Llama a `connect` primero.');
      return;
    }
    _socket.emit('sendMessage', {
      'chatId': chatId,
      'sender': senderId,
      'content': content,
    });
    print('Mensaje enviado al chat $chatId');
  }

  /// Escuchar recepción de mensajes
  void onReceiveMessage(Function(Map<String, dynamic>) callback) {
    if (!_isConnected) {
      print('Socket no inicializado. Llama a `connect` primero.');
      return;
    }
    _socket.on('receiveMessage', (data) {
      print('Mensaje recibido: $data');
      if (data is Map<String, dynamic>) {
        callback(data);
      } else {
        print('Formato inesperado de mensaje recibido: $data');
      }
    });
  }

  /// Escuchar mensajes cargados
  void onLoadMessages(Function(List<dynamic>) callback) {
    _socket.on('messagesLoaded', (data) {
      print('Mensajes cargados: $data');
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
