import 'package:flutter_application_1/models/post.dart';
import 'package:dio/dio.dart';

class PostService {
  //final String baseUrl = "http://127.0.0.1:3000"; // URL de tu backend web
  //final String baseUrl = "http://147.83.7.155:3000"; // URL de tu backend en producción
  final String baseUrl = "http://10.0.2.2:3000"; // URL de tu backend Android
  final Dio dio = Dio(); // Instancia de Dio para realizar solicitudes HTTP
  var statusCode;
  var data;

  // Función para crear una nueva experiencia
  Future<int> createPost(PostModel newPost) async {
    print('createExperience');
    try {
      // Enviar solicitud POST para crear una nueva experiencia
      Response response = await dio.post(
        '$baseUrl/api/posts',
        data: newPost.toJson(),
      );

      // Guardar datos de la respuesta
      data = response.data.toString();
      statusCode = response.statusCode;
      print('Data: $data');
      print('Status code: $statusCode');

      // Verificar el código de estado
      if (statusCode == 201) {
        print('201');
        return 201;
      } else if (statusCode == 400) {
        print('400');
        return 400;
      } else if (statusCode == 500) {
        print('500');
        return 500;
      } else {
        print('-1');
        return -1;
      }
    } catch (e) {
      print('Error creating post: $e');
      return -1;
    }
  }

  // Función para obtener la lista de posts
  Future<List<PostModel>> getPosts(int page, int limit) async {
    print('getPosts');
    try {
      // Enviar solicitud GET para obtener los posts
      var res = await dio.get('$baseUrl/api/posts/getPosts/$page/$limit');
      print(res);
      List<dynamic> responseData = res.data;
      print(responseData);
      // Convertir la respuesta en una lista de postModel
      List<PostModel> posts = responseData
          .map((data) => PostModel.fromJson(data))
          .toList();

      return posts;
    } catch (e) {
      print('Error fetching post: $e');
      throw e;
    }
  }


  // Función para editar una experiencia existente
  Future<int> editPost(PostModel updatedPost, String id) async {
    print('editPost');
    try {
      // Enviar solicitud PUT para actualizar una experiencia
      Response response = await dio.put(
        '$baseUrl/api/posts/$id',
        data: updatedPost.toJson(),
      );

      // Guardar datos de la respuesta
      data = response.data.toString();
      statusCode = response.statusCode;
      print('Data: $data');
      print('Status code: $statusCode');

      // Verificar el código de estado
      if (statusCode == 201) {
        print('201');
        return 201;
      } else if (statusCode == 400) {
        print('400');
        return 400;
      } else if (statusCode == 500) {
        print('500');
        return 500;
      } else {
        print('-1');
        return -1;
      }
    } catch (e) {
      print('Error editing post: $e');
      return -1;
    }
  }

  // Función para eliminar un post por id
  Future<int> deletePostById(String id) async {
    print('deletePostById');
    try {
      // Enviar solicitud DELETE utilizando el id como parámetro en la URL
      Response response = await dio.delete('$baseUrl/api/posts/$id');

      // Guardar datos de la respuesta
      data = response.data.toString();
      statusCode = response.statusCode;
      print('Data: $data');
      print('Status code: $statusCode');

      // Verificar el código de estado
      if (statusCode == 200) {
        print('Post deleted successfully');
        return 200; // Código de éxito
      } else if (statusCode == 404) {
        print('Post not found');
        return 404; // Código de error si no se encuentra el post
      } else if (statusCode == 500) {
        print('Server error');
        return 500; // Código de error del servidor
      } else {
        print('Unexpected error');
        return -1; // Código de error inesperado
      }
    } catch (e) {
      print('Error deleting post: $e');
      return -1; // En caso de un error durante la solicitud
    }
  }

  // Función para obtener los posts de un autor específico
  Future<List<PostModel>> getPostsByAuthor(String id) async {
    try {
      // Enviar solicitud GET con el autor como parámetro de consulta
      var res = await dio.get('$baseUrl/api/posts/authorPosts/$id');
      
      List<dynamic> responseData = res.data;

      // Convertir la respuesta en una lista de PostModel
      return responseData.map((data) => PostModel.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching posts by author: $e');
      throw e;
    }
  }
  
  // Función para obtener la lista de posts por tipo
  Future<List<PostModel>> getPostsByType(String type) async {
    print('getPostsByType');
    try {
      // Enviar solicitud GET para obtener los posts
      var res = await dio.get('$baseUrl/api/posts/type/$type');
      print(res);
      List<dynamic> responseData = res.data;
      print(responseData);
      // Convertir la respuesta en una lista de postModel
      List<PostModel> posts = responseData
          .map((data) => PostModel.fromJson(data))
          .toList();

      return posts;
    } catch (e) {
      print('Error fetching posts: $e');
      throw e;
    }
  }
}
