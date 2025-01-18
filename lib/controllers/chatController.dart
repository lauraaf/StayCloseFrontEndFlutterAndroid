import 'package:get/get.dart';
import '../models/chat.dart';
import '../services/chatService.dart';

class ChatController extends GetxController {
  var isLoading = false.obs; // Indicador de carga
  var chatId = ''.obs; // Almacena el chatId actual
  var userChats = <Chat>[].obs; // Lista de chats existentes

  // Método para obtener o crear un chat
  Future<void> getOrCreateChat({
    required String sender,
    required String receiver,
  }) async {
    // Prevenir solicitudes múltiples simultáneas
    if (isLoading.value) return;
    try {
      isLoading.value = true;

      // Llamada al servicio para obtener o crear el chat
      final result = await ChatService.createOrGetChat(
        sender: sender,
        receiver: receiver,
      );
      if (result.isNotEmpty) {
        chatId.value = result; // Guardar el chatId obtenido
        print("Chat creado u obtenido con ID: $result");
      } else {
        throw Exception("El servicio devolvió un chatId vacío.");
      }
    } catch (e) {
      print("Error al obtener o crear el chat: $e");
      Get.snackbar("Error", "No se pudo obtener o crear el chat");
    } finally {
      isLoading.value = false;
    }
  }

  // Método para obtener los chats del usuario
  Future<void> fetchUserChats(String userId) async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;

      // Llamada al servicio para obtener los chats
      final chats = await ChatService.getUserChats(userId);
      userChats.value = chats;
    } catch (e) {
      print("Error al obtener los chats del usuario: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
