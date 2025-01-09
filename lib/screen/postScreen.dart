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

    String selectedType = 'Todos';


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
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                _fetchMyPosts();
              },
              icon: const Icon(Icons.account_circle),
              label:  Text('Mis Posts'.tr),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                backgroundColor: const Color.fromARGB(187, 255, 255, 255),
                foregroundColor: const Color.fromARGB(255, 84, 91, 111),
              ),
            ),
          ),

        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6, // Ancho del contenedor
          padding: const EdgeInsets.all(16.0),
          child: Column(
          children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['Todos'.tr, 'Película'.tr, 'Serie'.tr, 'Libro'.tr, 'Podcast', 'Música'.tr]
                    .map((type) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedType = type;
                      });
                    },
                    child: Text(type),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedType == type
                          ? const Color.fromRGBO(137, 175, 175, 1)
                          : const Color.fromARGB(255, 178, 178, 178),
                      foregroundColor: Colors.white,  // Cambia el color del texto a blanco
                      textStyle: const TextStyle(
                      color: Colors.white,  // Asegura que el color del texto sea blanco
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (postsListController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (postsListController.postList.isEmpty) {
                  return Center(
                    child: Text(
                      "No hay posts disponibles".tr,
                      style: TextStyle(fontSize: 16, color: Color(0xFF89AFAF)),
                    ),
                  );
                } else {
                  List filteredPosts = postsListController.postList.where((post) {
                    return selectedType == 'Todos'.tr || post.postType == selectedType; //Hem de poder traduir el selectedType, per que el filtre funcioni amb la traducció
                  }).toList();

                  return Expanded(
                    child: ListView.builder(
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = filteredPosts[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: PostCard(post: post),
                        );
                      },
                    ),
                  );
                }
              }),
            ],
          ),
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

  void _fetchMyPosts() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: GetBuilder<PostController>(
            init: postController,
            builder: (controller) {
              return FutureBuilder(
                future: postController.fetchMyPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          'Error al cargar los posts: ${snapshot.error}'.tr,
                          style: const TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ),
                    );
                  } else {
                    final myPosts = snapshot.data ?? [];
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mis Posts'.tr,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF89AFAF),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (myPosts.isEmpty)
                            Center(
                              child: Text(
                                "No tienes posts todavía.".tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF89AFAF),
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: ListView.builder(
                                itemCount: myPosts.length,
                                itemBuilder: (context, index) {
                                  final post = myPosts[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: PostCard(post: post),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF89AFAF),
                              ),
                              child: Text('Cerrar'.tr),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            },
          ),
        );
      },
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