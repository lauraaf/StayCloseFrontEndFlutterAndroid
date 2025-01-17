import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/messageService.dart';
import '../controllers/userController.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SendMessageScreen extends StatefulWidget {
  final String receiverUsername;
  final String chatId; // Recibe el chatId

  SendMessageScreen({
    required this.receiverUsername,
    required this.chatId,
  });

  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; // Lista de mensajes
  late IO.Socket _socket; // Declaración de la variable para el socket

  @override
  void initState() {
    super.initState();
    _connectToSocket(); // Conectar al servidor
    _loadMessages(); // Cargar mensajes al inicializar
  }

  @override
  void dispose() {
    _socket.disconnect(); // Desconectar al salir
    super.dispose();
  }

  Future<void> _connectToSocket() async {
    // Configurar el cliente de Socket.IO
    _socket = IO.io(
      'http://127.0.0.1:3000', // URL del servidor backend
      IO.OptionBuilder()
          .setTransports(['websocket']) // Usar WebSocket
          .disableAutoConnect() // Deshabilitar autoconexión
          .build(),
    );

    _socket.connect(); // Conectarse al servidor

    // Unirse al chat actual
    _socket.emit('joinChat', widget.chatId);

    // Escuchar mensajes nuevos
    _socket.on('newMessage', (data) {
      print('Mensaje recibido: $data');
      setState(() {
        _messages.add(data); // Agregar el mensaje a la lista
      });
    });

    _socket.onConnect((_) {
      print('Conectado al servidor de WebSocket');
    });

    _socket.onDisconnect((_) {
      print('Desconectado del servidor de WebSocket');
    });
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await MessageService.getMessages(
          widget.chatId); // Obtener mensajes llamada al servidor
      setState(() {
        _messages.addAll(messages);
      });
    } catch (e) {
      print('Error al cargar mensajes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con ${widget.receiverUsername}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSender = message['sender'] ==
                    Get.find<UserController>().currentUserName.value;
                return Align(
                  alignment:
                      isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isSender ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      message['content'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu mensaje aquí...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      try {
                        await MessageService.sendMessage(
                          chatId: widget.chatId, // Usa el chatId actual
                          senderUsername:
                              Get.find<UserController>().currentUserName.value,
                          receiverUsername: widget.receiverUsername,
                          content: _messageController.text,
                        );
                        _messageController.clear();
                      } catch (e) {
                        Get.snackbar("Error", "No se pudo enviar el mensaje");
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
