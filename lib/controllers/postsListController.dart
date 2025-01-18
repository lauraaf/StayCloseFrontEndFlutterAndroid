import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Añadimos ScrollController
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/services/postServices.dart';

class PostsListController extends GetxController {
  var isLoading = true.obs;
  var postList = <PostModel>[].obs;
  final PostService postService = PostService();
  int _page = 1; // Página inicial
  ScrollController scrollController =
      ScrollController(); // Controlador de Scroll

  @override
  void onInit() {
    super.onInit();
    fetchPosts(); // Llamada inicial para obtener posts

    // Agregar un listener al ScrollController para detectar cuando se llega al final
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchMorePosts(); // Llamar a fetchMorePosts cuando se llega al final
      }
    });
  }

  // Método para obtener las publicaciones
  Future<void> fetchPosts() async {
    try {
      isLoading(true); // Establecemos el estado de carga a true
      var posts =
          await postService.getPosts(_page, 10); // Enviar `page` y `limit` aquí
      if (posts != null && posts.isNotEmpty) {
        postList.assignAll(posts); // Asignamos las publicaciones a la lista
      }
    } catch (e) {
      print("Error fetching posts: $e");
    } finally {
      isLoading(
          false); // Establecemos el estado de carga a false una vez que termine
    }
  }

  // Método para cargar más publicaciones (scroll infinito)
  Future<void> fetchMorePosts() async {
    if (isLoading.value)
      return; // Evitamos llamadas duplicadas mientras se carga
    try {
      _page++; // Incrementamos la página antes de cargar más posts
      isLoading(true); // Establecemos el estado de carga a true
      var newPosts =
          await postService.getPosts(_page, 10); // Enviar `page` y `limit` aquí
      if (newPosts != null && newPosts.isNotEmpty) {
        postList
            .addAll(newPosts); // Añadimos las nuevas publicaciones a la lista
      } else {
        _page--; // Si no se obtienen nuevas publicaciones, reseñamos la página
      }
    } catch (e) {
      print("Error fetching more posts: $e");
      _page--; // También retrocedemos en caso de error
    } finally {
      isLoading(
          false); // Establecemos el estado de carga a false una vez que termine
    }
  }

  // Método para editar una experiencia
  Future<void> editPost(String id, PostModel updatedPost) async {
    // Cambié a PostModel
    try {
      isLoading(true); // Establecemos el estado de carga a true
      var statusCode = await postService.editPost(updatedPost, id);
      if (statusCode == 201) {
        Get.snackbar('Éxito', 'Post actualizado con éxito');
        await fetchPosts(); // Recargamos la lista de experiencias después de editar
      } else {
        Get.snackbar('Error', 'Error al actualizar la experiencia');
      }
    } catch (e) {
      print("Error editing experience: $e");
    } finally {
      isLoading(
          false); // Establecemos el estado de carga a false una vez que termine
    }
  }

  // Método para eliminar un post utilizando el id
  Future<void> postToDelete(String postId) async {
    try {
      isLoading(true); // Establecemos el estado de carga a true

      // Buscamos el post en la lista local utilizando el id
      var postToDelete = postList.firstWhere(
        (post) => post.id == postId, // Usamos 'id' para buscar el post
      );

      if (postToDelete != null) {
        // Llamada al servicio para eliminar el post utilizando el id
        var statusCode = await postService
            .deletePostById(postToDelete.id); // Usamos 'id' para eliminar

        if (statusCode == 200) {
          // Aseguramos que el código de éxito sea 200
          Get.snackbar('Éxito', 'Post eliminado con éxito');
          fetchPosts(); // Recargamos la lista de posts después de eliminar
        } else {
          Get.snackbar('Error', 'Error al eliminar el post');
        }
      } else {
        Get.snackbar('Error', 'No se encontró el post a eliminar');
      }
    } catch (e) {
      print("Error deleting post: $e");
    } finally {
      isLoading(
          false); // Establecemos el estado de carga a false una vez que termine
    }
  }

  @override
  void onClose() {
    scrollController
        .dispose(); // Asegurarse de limpiar el controlador de scroll
    super.onClose();
  }

  // Método para reiniciar la página cuando filtramos por tipo
  void resetPage() {
    _page = 1; // Reiniciamos la página a 1
    fetchPosts(); // Recargar publicaciones desde la primera página
  }
}
