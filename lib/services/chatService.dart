import 'package:socket_io_client/socket_io_client.dart' as IO;

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

  void disconnect() {
    _socket.disconnect();
  }
}
