import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Añadido para traducción
import '../models/post.dart'; 

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  // Método para determinar el color del círculo según el tipo de publicación
  Color _getPostTypeColor(String postType) {
    switch (postType) {
      case 'Pelicula':
        return const Color(0xFF002F49); // Azul
      case 'Libro':
        return const Color(0xFF002F49); // Naranja suave
      case 'Evento':
        return const Color(0xFF002F49); // Verde suave
      case 'Música':
        return const Color(0xFF002F49); // Gris
      default:
        return const Color(0xFF002F49); // Gris por defecto
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: const Color(0xFF89AFAF), // Fondo verde claro
      elevation: 5, // Sombra suave
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.author, // Primer el nombre del usuario
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getPostTypeColor(post.postType),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    post.postType.tr, // Tipo de post debajo del nombre
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getPostTypeColor(post.postType),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.content, // Contenido debajo del tipo de post
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // Imagen al final
          if (post.image != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 200, right: 200), // Margen alrededor de la imagen
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8), // Esquinas redondeadas
                child: Image.network(
                  post.image!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Color.fromARGB(194, 162, 204, 204),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}