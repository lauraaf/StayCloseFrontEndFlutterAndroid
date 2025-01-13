import 'package:get/get.dart';
import '../models/message.dart';
import '../services/chatService.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final RxList<Message> messages = <Message>[].obs;

  void connectToChat(
      String chatId, String senderUsername, String receiverUsername) {
    _chatService.connect(senderUsername);
    _chatService.joinChat(chatId);

  _chatService.onReceiveMessage((data) {
  final Message newMessage = Message.fromJson(data);
  messages.add(newMessage);
  print("Mensaje recibido y agregado: ${newMessage.content}");
});


  void loadChatMessages(String senderEmail, String receiverEmail) {
    _chatService.loadUserChats(senderEmail, receiverEmail);

    _chatService.onLoadUniqueChat((data) {
      // Manejo de datos recibidos
      if (data is Map<String, dynamic>) {
        try {
          final Message message = Message.fromJson(data);
          messages.add(message);
        } catch (e) {
          print("Error al procesar el mensaje único en loadChatMessages: $e");
        }
      } else if (data is List) {
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            try {
              final Message message = Message.fromJson(item);
              messages.add(message);
            } catch (e) {
              print(
                  "Error al procesar un mensaje de la lista en loadChatMessages: $e");
            }
          } else {
            print("Formato inesperado en la lista de mensajes: $item");
          }
        }
      } else {
        print("Formato de datos inesperado en loadChatMessages: $data");
      }
    });
  }

  void sendMessage(String chatId, String senderId, String content) {
    _chatService.sendMessage(chatId, senderId, content);
    messages.add(Message(
        senderId: senderId, content: content, timestamp: DateTime.now()));
  }

  @override
  void onClose() {
    _chatService.disconnect();
    super.onClose();
  }
}
