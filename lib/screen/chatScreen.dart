/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chatController.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String senderUsername;
  final String receiverUsername;
  final ChatController chatController = Get.put(ChatController());

  ChatScreen({
    required this.chatId,
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
                icon: Icons.location_on,
                label: 'Localización',
                onTap: () {
                  // Lógica para compartir localización
                  Navigator.pop(context);
                  print('Compartir localización');
                },
              ),
              _buildAttachmentOption(
                context,
                icon: Icons.home,
                label: 'En Casa',
                onTap: () {
                  // Lógica para indicar "En Casa"
                  Navigator.pop(context);
                  print('Indicar que está en casa');
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

*/
