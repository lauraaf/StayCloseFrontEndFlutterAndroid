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

/*

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chatController.dart';

class ChatScreen extends StatelessWidget {
  //final String chatId;
  //final String senderId;
  //final String receiverId;
  final String senderUsername;
  final String receiverUsername;
  final ChatController chatController = Get.put(ChatController());

  ChatScreen({
    //required this.chatId,
    //required this.senderId,
    //required this.receiverId,
    required this.senderUsername,
    required this.receiverUsername,
  });

  @override
  Widget build(BuildContext context) {
    chatController.connectToChat(senderUsername, receiverUsername);

    final messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Chat con $receiverUsername')),
      body: 
      Obx(() {
        if (chatController.currentChatId.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        retur Column(
        children: [
          Expanded(
            child:ListView.builder(
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  final isSender = message.senderId == senderUsername;
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
                        chatController.currentChatId.value,
                         senderUsername,
                        messageController.text, 
                        receiverUsername,
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

*/

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chatController.dart';

class ChatScreen extends StatelessWidget {
  final String senderUsername;
  final String receiverUsername;
  final ChatController chatController = Get.put(ChatController());

  ChatScreen({
    required this.senderUsername,
    required this.receiverUsername,
  });

  @override
  Widget build(BuildContext context) {
    // Conectar al chat
    chatController.connectToChat(senderUsername, receiverUsername);

    final messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con $receiverUsername'),
      ),
      body: Obx(() {
        // Verificar si el chatId está disponible
        if (chatController.currentChatId.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Construir la interfaz del chat
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  final isSender = message.senderId == senderUsername;
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
              ),
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
                          chatController.currentChatId.value,
                          senderUsername,
                          messageController.text,
                          receiverUsername,
                        );
                        messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

*/

/*

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chatController.dart';

class ChatScreen extends StatelessWidget {
  final String senderUsername;
  final String receiverUsername;
  final ChatController chatController = Get.put(ChatController());

  ChatScreen({
    required this.senderUsername,
    required this.receiverUsername,
  });

  @override
  Widget build(BuildContext context) {
    // Conectar al chat
    chatController.connectToChat(senderUsername, receiverUsername);

    final messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con $receiverUsername'),
      ),
      body: Obx(() {
        // Verificar si el chatId está disponible
        if (chatController.currentChatId.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Construir la interfaz del chat
        return Column(
          children: [
            // Lista de mensajes
            Expanded(
              child: ListView.builder(
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  final isSender = message.senderId == senderUsername;
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
              ),
            ),
            // Campo de texto para enviar mensajes
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
                          chatController.currentChatId.value,
                          senderUsername,
                          messageController.text,
                          receiverUsername,
                        );
                        messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAttachmentMenu(context);
        },
      ),
    );
  }

  // Método para mostrar el menú de opciones
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
                icon: Icons.photo,
                label: 'Photos',
                onTap: () {
                  // Lógica para enviar fotos
                  Navigator.pop(context);
                  print('Compartir fotos');
                },
              ),
              _buildAttachmentOption(
                context,
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () {
                  // Lógica para abrir cámara
                  Navigator.pop(context);
                  print('Abrir cámara');
                },
              ),
              _buildAttachmentOption(
                context,
                icon: Icons.location_on,
                label: 'Location',
                onTap: () {
                  // Lógica para compartir ubicación
                  Navigator.pop(context);
                  print('Compartir ubicación');
                },
              ),
              _buildAttachmentOption(
                context,
                icon: Icons.contact_page,
                label: 'Contact',
                onTap: () {
                  // Lógica para compartir contacto
                  Navigator.pop(context);
                  print('Compartir contacto');
                },
              ),
              _buildAttachmentOption(
                context,
                icon: Icons.insert_drive_file,
                label: 'Document',
                onTap: () {
                  // Lógica para compartir documento
                  Navigator.pop(context);
                  print('Compartir documento');
                },
              ),
              _buildAttachmentOption(
                context,
                icon: Icons.poll,
                label: 'Poll',
                onTap: () {
                  // Lógica para crear encuesta
                  Navigator.pop(context);
                  print('Crear encuesta');
                },
              ),
              _buildAttachmentOption(
                context,
                icon: Icons.event,
                label: 'Event',
                onTap: () {
                  // Lógica para crear evento
                  Navigator.pop(context);
                  print('Crear evento');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget para cada opción del menú
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
            child: Icon(icon, size: 30),
          ),
          SizedBox(height: 8),
          Text(label),
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
  final String senderUsername;
  final String receiverUsername;
  final ChatController chatController = Get.put(ChatController());

  ChatScreen({
    required this.senderUsername,
    required this.receiverUsername,
  });

  @override
  Widget build(BuildContext context) {
    // Conectar al chat
    chatController.connectToChat(senderUsername, receiverUsername);

    final messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con $receiverUsername'),
      ),
      body: Obx(() {
        // Verificar si el chatId está disponible
        if (chatController.currentChatId.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Construir la interfaz del chat
        return Column(
          children: [
            // Lista de mensajes
            Expanded(
              child: ListView.builder(
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  final isSender = message.senderId == senderUsername;
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
              ),
            ),
            // Caja de entrada de mensaje con botones integrados
            _buildMessageInputBar(context, messageController),
          ],
        );
      }),
    );
  }

  // Barra inferior con caja de entrada de texto y botones
  Widget _buildMessageInputBar(
      BuildContext context, TextEditingController messageController) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
          // Botón para abrir el menú de adjuntos
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.purple),
            onPressed: () {
              _showAttachmentMenu(context);
            },
          ),
          // Caja de texto para escribir mensajes
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Escribe un mensaje...',
                border: InputBorder.none,
              ),
            ),
          ),
          // Botón para enviar mensajes
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                chatController.sendMessage(
                  chatController.currentChatId.value,
                  senderUsername,
                  messageController.text,
                  receiverUsername,
                );
                messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  // Método para mostrar el menú de opciones
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
                icon: Icons.event,
                label: 'Event',
                onTap: () {
                  // Lógica para compartir un evento
                  Navigator.pop(context);
                  print('Compartir evento');
                },
              ),
              _buildAttachmentOption(
                context,
                icon: Icons.location_on,
                label: 'Location',
                onTap: () {
                  // Lógica para compartir una localización
                  Navigator.pop(context);
                  print('Compartir localización');
                },
              ),
              _buildAttachmentOption(
                context,
                icon: Icons.insert_drive_file,
                label: 'Document',
                onTap: () {
                  // Lógica para compartir un documento
                  Navigator.pop(context);
                  print('Compartir documento');
                },
              ),
              _buildAttachmentOption(
                context,
                icon: Icons.article,
                label: 'Post',
                onTap: () {
                  // Lógica para compartir un post
                  Navigator.pop(context);
                  print('Compartir post');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget para cada opción del menú
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
            backgroundColor: Colors.purple.shade100,
            child: Icon(icon, color: Colors.purple, size: 30),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.purple),
          ),
        ],
      ),
    );
  }
}
