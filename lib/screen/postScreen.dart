//V1.2

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/postsListController.dart';
import 'package:flutter_application_1/controllers/postController.dart';
import 'package:flutter_application_1/Widgets/postCard.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/themeController.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final PostController postController = Get.put(PostController());
  final PostsListController postsListController = Get.put(PostsListController());
  final ScrollController _scrollController = ScrollController();
  String selectedType = 'Todos';

  @override
  void initState() {
    super.initState();
    postsListController.fetchPosts(); // Llamada inicial para obtener posts
    _scrollController.addListener(() {
      // Detectar el final de la lista para cargar más posts
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        postsListController.fetchMorePosts(); // Llamar a fetchMorePosts
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _filterPostsByType(String type) {
    setState(() {
      selectedType = type;
    });
    if (type == 'Todos') {
      postsListController.resetPage(); // Reset de la pagina antes de un nuevo fetch
    } else {
      postController.fetchPostsByType(type);
    }
  }

  /* void _changeTheme() {
    // Cambiar el tema entre oscuro y claro
    final currentTheme = Theme.of(context).brightness;
    if (currentTheme == Brightness.dark) {
      // Si está en modo oscuro, cambiamos a modo claro
      Get.changeTheme(ThemeData.light());
    } else {
      // Si está en modo claro, cambiamos a modo oscuro
      Get.changeTheme(ThemeData.dark());
    }
  }*/

  @override
  Widget build(BuildContext context) {
// Obtener el ThemeController para acceder a la función de cambio de tema
    final ThemeController themeController = Get.find();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Usamos el tamaño predeterminado del AppBar
        child: Obx(() {
          return AppBar(
            title: Text('Foro'.tr, // Traducción dinámica
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Tamaño y estilo fijo del texto
            backgroundColor: themeController.isDarkMode.value
                ? Color(0xFF555A6F) // Color para el modo oscuro
                : Color(0xFF89AFAF), // Color para el modo claro
            toolbarHeight: 70.0, // Altura fija del AppBar
            actions: [
              // Icono para cambiar el tema, antes de los tres puntos
              IconButton(
                icon: Icon(Icons.brightness_6),
                onPressed: () {
                  themeController.toggleTheme(); // Cambiar tema
                }, // Cambiar tema,
                color: Colors
                    .white, // El color debe coincidir con el estilo del tema
              ),
              // Los tres puntos (menú de opciones)
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
              // Botón para mis posts
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _fetchMyPosts();
                  },
                  icon: const Icon(Icons.account_circle),
                  label: Text('Mis Posts'.tr),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    backgroundColor: const Color.fromARGB(187, 255, 255, 255),
                    foregroundColor: const Color.fromARGB(255, 84, 91, 111),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
     body: Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // Augmentar l'amplada del contenedor
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center, // Això centra els botons
              spacing: 8.0, // Espai horitzontal entre els botons
              runSpacing: 8.0, // Espai vertical entre les línies de botons
              children: [
                'Todos',
                'Película',
                'Serie',
                'Libro',
                'Podcast',
                'Música',
                'Otro'
              ].map((type) {
                final isDarkMode = Theme.of(context).brightness == Brightness.dark;
                final buttonColor = isDarkMode ? Color(0xFF555A6F) : Color(0xFF89AFAF);

                return ElevatedButton(
                  onPressed: () {
                    _filterPostsByType(type);
                  },
                  child: Text(
                    type.tr,
                    style: TextStyle(fontSize: 12), // Font més petita
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Més compacte
                    minimumSize: Size(55, 35), // Defineix una mida mínima per al botó
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (postController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (selectedType != 'Todos' && postController.postsByType.isEmpty) {
                return Center(
                  child: Text(
                    "No hay posts disponibles para esta categoría".tr,
                    style: TextStyle(fontSize: 16, color: Color(0xFF89AFAF)),
                  ),
                );
              } else if (selectedType == 'Todos' && postsListController.postList.isEmpty) {
                return Center(
                  child: Text(
                    "No hay posts disponibles".tr,
                    style: TextStyle(fontSize: 16, color: Color(0xFF89AFAF)),
                  ),
                );
              } else {
                var postsToDisplay = selectedType == 'Todos' ? postsListController.postList : postController.postsByType;
                return Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: postsToDisplay.length + 1,
                    itemBuilder: (context, index) {
                      if (index == postsToDisplay.length) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final post = postsToDisplay[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.1, horizontal: 0.1), // Reduir el padding lateral
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
          _showAddPostDialog(context);
        },
        backgroundColor: Color(0xFF89AFAF),
        child: Icon(Icons.add),
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
          child: GetBuilder<PostController>(builder: (controller) {
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
                    padding: const EdgeInsets.all(16.0), //Cambiar widget postCArd
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
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
          }),
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
                      // Dropdown para seleccionar el tipo de post
                      Obx(() {
                        return DropdownButton<String>(
                          value: postController.postType.value.isEmpty
                              ? null
                              : postController.postType.value,
                          hint: Text(
                            'Selecciona el tipo de post'.tr,
                            style: TextStyle(color: Color(0xFF89AFAF)),
                          ),
                          onChanged: (String? newValue) {
                            postController.postType.value = newValue ?? '';
                          },
                          items: <String>[
                            '',
                            'Libro'.tr,
                            'Película'.tr,
                            'Música'.tr,
                            'Serie'.tr,
                            'Podcast'.tr,
                            'Otro'.tr
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.tr),
                            );
                          }).toList(),
                          dropdownColor:
                              Colors.white, // Fondo blanco para el dropdown
                          underline: Container(), // Eliminar línea de subrayado
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
                            postController.createPost();
                            postsListController.fetchPosts(); 
                            Navigator.of(context).pop();
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
