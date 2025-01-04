import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/postsListController.dart';  // Controlador para la lista de posts
import 'package:flutter_application_1/controllers/postController.dart';  // Controlador para crear el post
import 'package:flutter_application_1/Widgets/postCard.dart';
import 'package:get/get.dart';
import 'dart:io';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final PostsListController postsListController = Get.put(PostsListController());  // Controlador para lista de posts
  final PostController postController = Get.put(PostController());  // Controlador para crear post

  @override
  void initState() {
    super.initState();
    postsListController.fetchPosts();  // Cargar los posts al inicio
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Foro de Posts'.tr,  // Traducción dinámica
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF89AFAF),
        actions: [
          // Botón para cambio de idioma
          PopupMenuButton<String>(
            onSelected: (String languageCode) {
              if (languageCode == 'ca') {
                Get.updateLocale(Locale('ca', 'ES'));
              } else if (languageCode == 'es') {
                Get.updateLocale(Locale('es', 'ES'));
              } else if (languageCode == 'en') {
                Get.updateLocale(Locale('en', 'US'));
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'ca', child: Text('Català')),
                PopupMenuItem(value: 'es', child: Text('Español')),
                PopupMenuItem(value: 'en', child: Text('English')),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6, // Ancho del contenedor
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {  // Usamos Obx para actualizar la UI con GetX
            if (postsListController.isLoading.value) {
              return Center(child: CircularProgressIndicator());  // Indicador de carga
            } else if (postsListController.postList.isEmpty) {
              return Center(
                child: Text(
                  "No hay posts disponibles".tr,
                  style: TextStyle(fontSize: 16, color: Color(0xFF89AFAF)),
                ),
              );  // Mensaje si no hay posts
            } else {
              // Si hay posts, los mostramos
              return ListView.builder(
                itemCount: postsListController.postList.length,  // Cantidad de posts
                itemBuilder: (context, index) {
                  final post = postsListController.postList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: PostCard(post: post),  // Widget para mostrar cada post
                  );
                },
              );
            }
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPostDialog(context);  // Mostrar el cuadro de diálogo para agregar un post
        },
        backgroundColor: Color(0xFF89AFAF),  // Color del botón flotante
        child: Icon(Icons.add),  // Icono de suma
      ),
    );
  }

  // Mostrar el cuadro de diálogo para crear un nuevo post
  void _showAddPostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<PostController>(
          builder: (postController) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Nuevo Post'.tr,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF89AFAF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Campo para el autor (owner)
                      TextField(
                        controller: postController.ownerController,
                        decoration: InputDecoration(
                          labelText: 'Autor'.tr,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Campo para la descripción
                      TextField(
                        controller: postController.descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Descripción'.tr,
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      // Campo para el tipo de post (Dropdown)
                      // Dropdown para seleccionar el tipo de post
                      Obx(() {
                        return DropdownButton<String>(
                          value: postController.postType.value.isEmpty ? null : postController.postType.value,
                          hint: Text(
                            'Selecciona el tipo de post'.tr,
                            style: TextStyle(color: Color(0xFF89AFAF)),
                          ),
                          onChanged: (String? newValue) {
                            postController.postType.value = newValue ?? '';
                          },
                          items: <String>['', 'Libro'.tr, 'Película'.tr, 'Música'.tr, 'Serie'.tr, 'Otro'.tr]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.tr),
                            );
                          }).toList(),
                          dropdownColor: Colors.white,  // Fondo blanco para el dropdown
                          underline: Container(),  // Eliminar línea de subrayado
                        );
                      }),
                      const SizedBox(height: 16),
                      // Botón para seleccionar imagen
                      ElevatedButton(
                        onPressed: () async {
                          await postController.pickImage();
                        },
                        child: Text('Seleccionar Imagen'.tr),
                      ),
                      const SizedBox(height: 16),
                      // Vista previa de la imagen seleccionada
                      if (postController.selectedImage != null)
                        Center(
                          child: Image.memory(
                            postController.selectedImage!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Botón para guardar el post
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Llamar al método para crear el post
                            postController.createPost();
                            postsListController.fetchPosts(); 
                            Navigator.of(context).pop();  // Cerrar el cuadro de diálogo después de crear el post
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF89AFAF),
                          ),
                          child: Text('Crear Post'.tr),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
