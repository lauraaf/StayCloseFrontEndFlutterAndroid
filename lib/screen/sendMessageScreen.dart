import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/messageService.dart';
import '../controllers/userController.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:geolocator/geolocator.dart'; // Importar Geolocator
import 'package:url_launcher/url_launcher.dart'; // Importar URL Launcher

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
    _socket.onDisconnect((_) => print('Desconectado del servidor de WebSocket'));
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

  Future<void> _sendLocation() async {
    try {
      // Obtener la ubicación actual
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Crear el enlace de Google Maps
      String locationLink =
          'https://www.google.com/maps?q=${position.latitude},${position.longitude}';

      // Enviar el mensaje con el texto "¡Estoy Aquí!" y el enlace de ubicación
      await MessageService.sendMessage(
        chatId: widget.chatId,
        senderUsername: Get.find<UserController>().currentUserName.value,
        receiverUsername: widget.receiverUsername,
        content: '¡Estoy Aquí! <a href="$locationLink">¡Estoy Aquí!</a>', // Mensaje con el enlace
      );

      print('Ubicación enviada: $locationLink');
    } catch (e) {
      print('Error al obtener la ubicación: $e');
      Get.snackbar('Error', 'No se pudo obtener la ubicación');
    }
  }

  // Método para abrir el enlace de Google Maps
  Future<void> _openMap(String url) async {
    if (await canLaunch(url)) {
      await launch(url); // Abrir el enlace en Google Maps
    } else {
      Get.snackbar("Error", "No se pudo abrir el enlace");
    }
  }

  Future<void> _sendHomeStatus() async {
    print('Enviando estado "En Casa"...');
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        await MessageService.sendMessage(
          chatId: widget.chatId,
          senderUsername: Get.find<UserController>().currentUserName.value,
          receiverUsername: widget.receiverUsername,
          content: _messageController.text,
        );
        _messageController.clear();
      } catch (e) {
        Get.snackbar("Error", "No se pudo enviar el mensaje");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con ${widget.receiverUsername}'),
        backgroundColor: Color(0xFF89AFAF),
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
                      color:
                          isSender ? Color(0xFF89AFAF) : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: message['content'].contains('<a href="')
                        ? GestureDetector(
                            onTap: () => _openMap(
                                message['content'].substring(
                                    message['content'].indexOf('"') + 1,
                                    message['content'].lastIndexOf('"'))),
                            child: Text(
                              '¡Estoy Aquí!',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        : Text(
                            message['content'],
                            style: TextStyle(color: Colors.black87),
                          ),
                  ),
                );
              },
            ),
          ),
          _buildMessageInputBar(context),
        ],
      ),
    );
  }

  Widget _buildMessageInputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Color(0xFF89AFAF)),
            onPressed: () {
              _showAttachmentMenu(context);
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Escribe un mensaje...',
                border: InputBorder.none,
              ),
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Color(0xFF89AFAF)),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _showAttachmentMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildAttachmentOption(
                context,
                icon: Icons.location_on,
                label: 'Localización',
                onTap: () {
                  Navigator.pop(context);
                  _sendLocation();
                },
              ),
              _buildAttachmentOption(
                context,
                icon: Icons.home,
                label: 'En Casa',
                onTap: () {
                  Navigator.pop(context);
                  _sendHomeStatus();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFF89AFAF).withOpacity(0.2),
            child: Icon(icon, color: Color(0xFF89AFAF), size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Color(0xFF89AFAF), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
