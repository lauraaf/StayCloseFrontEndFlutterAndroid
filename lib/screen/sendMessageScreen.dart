/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/messageService.dart';
import '../controllers/userController.dart';

class SendMessageScreen extends StatefulWidget {
  final String receiverUsername;

  SendMessageScreen({required this.receiverUsername});

  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      final chatId = _generateChatId(
        Get.find<UserController>().currentUserName.value,
        widget.receiverUsername,
      );
      final messages = await MessageService.getMessages(chatId);
      setState(() {
        _messages.addAll(messages);
      });
    } catch (e) {
      print('Error al cargar mensajes: $e');
    }
  }

  String _generateChatId(String sender, String receiver) {
    final participants = [sender, receiver];
    participants.sort();
    return participants.join('_');
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
                          senderUsername:
                              Get.find<UserController>().currentUserName.value,
                          receiverUsername: widget.receiverUsername,
                          content: _messageController.text,
                        );
                        setState(() {
                          _messages.add({
                            'sender': Get.find<UserController>()
                                .currentUserName
                                .value,
                            'content': _messageController.text,
                          });
                        });
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

*/

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/messageService.dart';
import '../controllers/userController.dart';

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

  @override
  void initState() {
    super.initState();
    _loadMessages(); // Carga los mensajes al inicializar
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await MessageService.getMessages(
          widget.chatId); // Llama al servicio con el chatId
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
                        setState(() {
                          _messages.add({
                            'sender': Get.find<UserController>()
                                .currentUserName
                                .value,
                            'content': _messageController.text,
                          });
                        });
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


*/

/*

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/messageService.dart';
import '../controllers/userController.dart';

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

  @override
  void initState() {
    super.initState();
    _loadMessages(); // Carga los mensajes al inicializar
  }

  Future<void> _loadMessages() async {
    try {
      final messages =
          await MessageService.getMessages(widget.chatId); // Llama al servicio
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
                        setState(() {
                          _messages.add({
                            'sender': Get.find<UserController>()
                                .currentUserName
                                .value,
                            'content': _messageController.text,
                          });
                        });
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


*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/messageService.dart';
import '../controllers/userController.dart';

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

  @override
  void initState() {
    super.initState();
    _loadMessages(); // Cargar mensajes al inicializar
  }

  Future<void> _loadMessages() async {
    try {
      final messages =
          await MessageService.getMessages(widget.chatId); // Obtener mensajes
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
                        setState(() {
                          _messages.add({
                            'sender': Get.find<UserController>()
                                .currentUserName
                                .value,
                            'content': _messageController.text,
                          });
                        });
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
