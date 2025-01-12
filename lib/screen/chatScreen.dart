/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chatController.dart';

class ChatScreen extends StatelessWidget {
  final ChatController _chatController = Get.put(ChatController());
  final String chatId = "12345"; // Reemplaza con el ID del chat
  final String userId =
      "currentUserId"; // Reemplaza con el ID del usuario actual

  ChatScreen() {
    _chatController.connectToChat(chatId);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: _chatController.messages.length,
                  itemBuilder: (context, index) {
                    final message = _chatController.messages[index];
                    final isMe = message.senderId == userId;
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(message.content),
                      ),
                    );
                  },
                )),
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
                  onPressed: () {
                    final content = _messageController.text.trim();
                    if (content.isNotEmpty) {
                      _chatController.sendMessage(chatId, userId, content);
                      _messageController.clear();
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
  final ChatController _chatController = Get.put(ChatController());
  final String chatId = "12345"; // Reemplaza con el ID del chat
  final String userId =
      "currentUserId"; // Reemplaza con el ID del usuario actual

  ChatScreen() {
    _chatController.connectToChat(chatId);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: _chatController.messages.length,
                  itemBuilder: (context, index) {
                    final message = _chatController.messages[index];
                    final isMe = message.senderId == userId;
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isMe ? "Yo" : message.senderId,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(message.content),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "${message.timestamp.hour}:${message.timestamp.minute}",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
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
                  onPressed: () {
                    final content = _messageController.text.trim();
                    if (content.isNotEmpty) {
                      _chatController.sendMessage(chatId, userId, content);
                      _messageController.clear();
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
import '../models/message.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String senderId;
  final String receiverId;
  final ChatController _chatController = Get.put(ChatController());

  ChatScreen({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    _chatController.connectToChat(chatId);
    _chatController.loadChatMessages(senderId, receiverId);

    final TextEditingController _messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: _chatController.messages.length,
                itemBuilder: (context, index) {
                  final Message message = _chatController.messages[index];
                  return Align(
                    alignment: message.senderId == senderId
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: message.senderId == senderId
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
              );
            }),
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
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _chatController.sendMessage(
                        chatId,
                        senderId,
                        _messageController.text,
                      );
                      _messageController.clear();
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
  final String chatId;
  final String senderId;
  final String receiverId;
  final ChatController _chatController = Get.put(ChatController());

  ChatScreen({
  
    required this.chatId,
    required this.senderId,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    _chatController.connectToChat(chatId,senderId, receiverId);

    final TextEditingController _messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con $receiverId'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: _chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = _chatController.messages[index];
                  return Align(
                    alignment: message.senderId == senderId
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: message.senderId == senderId
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
              );
            }),
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
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _chatController.sendMessage(
                        chatId,
                        senderId,
                        _messageController.text,
                      );
                      _messageController.clear();
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
  final String chatId;
  final String senderId;
  final String receiverId;
  final ChatController _chatController = Get.put(ChatController());

  ChatScreen({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    _chatController.connectToChat(chatId, senderId, receiverId);

    final TextEditingController _messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con $receiverId'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: _chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = _chatController.messages[index];
                  return Align(
                    alignment: message.senderId == senderId
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: message.senderId == senderId
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
              );
            }),
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
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _chatController.sendMessage(
                        chatId,
                        senderId,
                        _messageController.text,
                      );
                      _messageController.clear();
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

    _chatService.onReceiveMessage((data) {
      setState(() {
        _messages.add(Message.fromJson(data));
      });
    });

    _chatService.onLoadMessages((data) {
      setState(() {
        _messages.addAll(data.map<Message>((msg) => Message.fromJson(msg)));
      });
    });

    _chatService.connect(widget.senderId);
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
        _messageController.text,
      );
      setState(() {
        _messages.add(Message(
          senderId: widget.senderId,
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
