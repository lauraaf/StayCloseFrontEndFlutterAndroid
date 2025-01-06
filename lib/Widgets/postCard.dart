import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Añadido para traducción
import '../models/post.dart'; // Ajusta la ruta según la ubicación de tu modelo

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  // Método para determinar el color del círculo según el tipo de publicación
  Color _getPostTypeColor(String postType) {
    switch (postType) {
      case 'Pelicula': // <== Eliminado `.tr`
        return const Color(0xFF002F49); // Rojo suave
      case 'Libro':
        return const Color(0xFF002F49); // Naranja suave
      case 'Evento':
        return const Color(0xFF002F49); // Azul suave
      case 'Música':
        return const Color(0xFF002F49); // Verde suave
      default:
        return const Color(0xFF002F49); // Gris
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Columna para el texto (autor, descripción, fecha)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Autor
                  Text(
                    post.author,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Contenido
                  Text(
                    post.content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Fecha
                  if (post.postDate != null)
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        '${post.postDate!.toLocal()}'.split(' ')[0],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Tipo de Publicación en un "círculo" (con bordes)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), // Bordes redondeados
                        border: Border.all(
                          color: _getPostTypeColor(post.postType), // Color de borde
                          width: 2,
                        ),
                      ),
                      child: Text(
                        post.postType.tr, // Traducción dinámica
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getPostTypeColor(post.postType),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Añadir espacio entre el texto y la imagen
            const SizedBox(width: 12), // Añade espacio entre el contenido y la imagen
            // Imagen alineada a la derecha
            if (post.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  post.image!,
                  fit: BoxFit.cover,
                  height: 200,
                  width: 250,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Color.fromARGB(194, 162, 204, 204),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
