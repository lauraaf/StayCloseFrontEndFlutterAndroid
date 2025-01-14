/*import 'package:flutter/material.dart';
import '../services/chatService.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String senderId;
  final String receiverId;

  ChatScreen({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _chatService.joinChat(widget.chatId);

//escucha los mensajes entrantes 
    _chatService.onReceiveMessage((data) {
      setState(() {
        if (data['chatId'] == widget.chatId) {
          _messages.add(Message.fromJson(data));
        }
      });
    });

    _chatService.onLoadMessages((data) {
      setState(() {
        _messages.addAll(data.map<Message>((msg) => Message.fromJson(msg)));
      });
    });

  //  _chatService.connect(widget.senderId);
  }

  @override
  void dispose() {
    _chatService.disconnect();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _chatService.sendMessage(
        widget.chatId,
        widget.senderId,
        widget.receiverId,
        _messageController.text,
      );
      setState(() {
        _messages.add(Message(
          senderId: widget.senderId,
          receiverId: widget.receiverId,
          content: _messageController.text,
          timestamp: DateTime.now(),
        ));
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con ${widget.receiverId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.senderId == widget.senderId
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: message.senderId == widget.senderId
                          ? Colors.blue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(color: Colors.white),
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
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import '../services/chatService.dart';
import '../models/message.dart';
import '../controllers/chatController.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String senderId;
  final String receiverId;

  ChatScreen({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Conectar el socket con el senderId
    _chatService.connect(widget.senderId);

    // Unirse al chat actual
    _chatService.joinChat(widget.chatId);

    // Escuchar mensajes entrantes
    _chatService.onReceiveMessage((data) {
      setState(() {
        if (data['chatId'] == widget.chatId) {
          _messages.add(Message.fromJson(data));
        }
      });
    });

    // Cargar mensajes históricos del chat actual
    _chatService.onLoadMessages((data) {
      setState(() {
        _messages.addAll(data.map<Message>((msg) => Message.fromJson(msg)));
      });
    });
  }

  @override
  void dispose() {
    // Desconectar el socket al salir de la pantalla
    _chatService.disconnect();
    super.dispose();
  }

  // Método para enviar un mensaje
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      // Llamar al servicio para enviar un mensaje
      _chatService.sendMessage(
        widget.chatId,
        widget.senderId,
        _messageController.text,
        widget.receiverId,
      );

      // Agregar el mensaje enviado a la lista local
      setState(() {
        _messages.add(Message(
          senderId: widget.senderId,
          receiverId: widget.receiverId,
          content: _messageController.text,
          timestamp: DateTime.now(),
        ));
      });

      // Limpiar el campo de texto
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con ${widget.receiverId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.senderId == widget.senderId
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: message.senderId == widget.senderId
                          ? Colors.blue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(color: Colors.white),
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
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chatController.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String senderId;
  final String receiverId;
  final ChatController chatController = Get.put(ChatController());

  ChatScreen({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    chatController.connectToChat(chatId, senderId);

    final messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Chat con $receiverId')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  final isSender = message.senderId == senderId;
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
                        message.content,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      chatController.sendMessage(
                        chatId,
                        senderId,
                        messageController.text,
                        receiverId,
                      );
                      messageController.clear();
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
