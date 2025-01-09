import 'package:get/get.dart';
import '../models/message.dart';
import '../services/chatService.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final RxList<Message> messages = <Message>[].obs;

  void connectToChat(String chatId) {
    _chatService.connect();
    _chatService.joinChat(chatId);

    _chatService.onReceiveMessage((data) {
      final Message message = Message(
          senderId: "", content: data, timestamp: DateTime(3, 12, 2025));
      //Message.fromJson(data);
      print("niuevo Mensaje $data");
      messages.add(message);
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
