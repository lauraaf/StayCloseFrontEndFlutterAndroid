/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/messageService.dart';
import '../controllers/userController.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SendMessageScreen extends StatefulWidget {
  final String receiverUsername;
  final String chatId;

  SendMessageScreen({
    required this.receiverUsername,
    required this.chatId,
  });

  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  late IO.Socket _socket;
  bool _showMenu = false;

  @override
  void initState() {
    super.initState();
    _connectToSocket();
    _loadMessages();
  }

  @override
  void dispose() {
    _socket.disconnect();
    super.dispose();
  }

  Future<void> _connectToSocket() async {
    _socket = IO.io(
      'http://127.0.0.1:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket.connect();
    _socket.emit('joinChat', widget.chatId);

    _socket.on('newMessage', (data) {
      setState(() {
        _messages.add(data);
      });
    });

    _socket.onConnect((_) => print('Conectado al servidor de WebSocket'));
    _socket
        .onDisconnect((_) => print('Desconectado del servidor de WebSocket'));
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await MessageService.getMessages(widget.chatId);
      setState(() {
        _messages.addAll(messages);
      });
    } catch (e) {
      print('Error al cargar mensajes: $e');
    }
  }

  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
    });
  }

  Future<void> _sendLocation() async {
    // Aquí agregarías lógica para enviar la ubicación
    print('Enviando ubicación...');
  }

  Future<void> _sendHomeStatus() async {
    // Aquí agregarías lógica para enviar el estado "En casa"
    print('Enviando estado "En Casa"...');
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
          if (_showMenu) _buildOptionsMenu(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildOptionsMenu() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildOptionButton(Icons.location_on, 'Localización', _sendLocation),
          _buildOptionButton(Icons.home, 'En Casa', _sendHomeStatus),
          _buildOptionButton(Icons.camera_alt, 'Cámara', () {
            print('Abrir cámara...');
          }),
          _buildOptionButton(Icons.photo, 'Galería', () {
            print('Abrir galería...');
          }),
        ],
      ),
    );
  }

  Widget _buildOptionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.blue),
          onPressed: onTap,
        ),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _showMenu ? Icons.close : Icons.add,
              color: Colors.blue,
            ),
            onPressed: _toggleMenu,
          ),
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
                    chatId: widget.chatId,
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
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/messageService.dart';
import '../controllers/userController.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SendMessageScreen extends StatefulWidget {
  final String receiverUsername;
  final String chatId;

  SendMessageScreen({
    required this.receiverUsername,
    required this.chatId,
  });

  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  late IO.Socket _socket;
  bool _showMenu = false;

  @override
  void initState() {
    super.initState();
    _connectToSocket();
    _loadMessages();
  }

  @override
  void dispose() {
    _socket.disconnect();
    super.dispose();
  }

  Future<void> _connectToSocket() async {
    _socket = IO.io(
      'http://127.0.0.1:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket.connect();
    _socket.emit('joinChat', widget.chatId);

    _socket.on('newMessage', (data) {
      setState(() {
        _messages.add(data);
      });
    });

    _socket.onConnect((_) => print('Conectado al servidor de WebSocket'));
    _socket
        .onDisconnect((_) => print('Desconectado del servidor de WebSocket'));
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await MessageService.getMessages(widget.chatId);
      setState(() {
        _messages.addAll(messages);
      });
    } catch (e) {
      print('Error al cargar mensajes: $e');
    }
  }

  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
    });
  }

  Future<void> _sendLocation() async {
    // Lógica para enviar ubicación
    print('Enviando ubicación...');
  }

  Future<void> _sendHomeStatus() async {
    // Lógica para enviar el estado "En Casa"
    print('Enviando estado "En Casa"...');
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
          if (_showMenu) _buildOptionsMenu(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildOptionsMenu() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildOptionButton(Icons.location_on, 'Localización', _sendLocation),
          _buildOptionButton(Icons.home, 'En Casa', _sendHomeStatus),
        ],
      ),
    );
  }

  Widget _buildOptionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.blue),
          onPressed: onTap,
        ),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _showMenu ? Icons.close : Icons.add,
              color: Colors.blue,
            ),
            onPressed: _toggleMenu,
          ),
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
                    chatId: widget.chatId,
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
    );
  }
}
