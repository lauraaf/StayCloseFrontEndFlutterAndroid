import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/postsListController.dart';
import 'package:flutter_application_1/controllers/postController.dart';
import 'package:flutter_application_1/Widgets/postCard.dart';
import 'package:get/get.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final PostsListController postsListController = Get.put(PostsListController());
  final PostController postController = Get.put(PostController());

  String selectedType = 'Todos';

  @override
  void initState() {
    super.initState();
    postsListController.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Foro de Posts',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(137, 175, 175, 1),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                _fetchMyPosts();
              },
              icon: const Icon(Icons.account_circle),
              label: const Text("Els meus posts"),
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
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['Todos', 'Pelicula', 'Serie', 'Libro', 'Podcast', 'Música']
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
                  return const Center(child: CircularProgressIndicator());
                } else if (postsListController.postList.isEmpty) {
                  return const Center(
                    child: Text(
                      "No hay posts disponibles",
                      style: TextStyle(fontSize: 16, color: Color(0xFF89AFAF)),
                    ),
                  );
                } else {
                  List filteredPosts = postsListController.postList.where((post) {
                    return selectedType == 'Todos' || post.postType == selectedType;
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
          _showAddPostDialog(context);
        },
        backgroundColor: const Color(0xFF89AFAF),
        child: const Icon(Icons.add),
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
                          'Error al cargar los posts: ${snapshot.error}',
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
                          const Text(
                            'Mis Posts',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF89AFAF),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (myPosts.isEmpty)
                            const Center(
                              child: Text(
                                "No tienes posts todavía.",
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
                              child: const Text('Cerrar'),
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
                      const Center(
                        child: Text(
                          'Nuevo Post',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF89AFAF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: postController.ownerController,
                        decoration: const InputDecoration(
                          labelText: 'Autor',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: postController.descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        return DropdownButton<String>(
                          value: postController.postType.value.isEmpty
                              ? null
                              : postController.postType.value,
                          hint: const Text(
                            'Selecciona el tipo de post',
                            style: TextStyle(color: Color(0xFF89AFAF)),
                          ),
                          onChanged: (String? newValue) {
                            postController.postType.value = newValue ?? '';
                          },
                          items: <String>[
                            'Libro',
                            'Película',
                            'Podcast',
                            'Música',
                            'Serie',
                            'Otro'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          dropdownColor: Colors.white,
                          underline: Container(),
                        );
                      }),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await postController.pickImage();
                        },
                        child: const Text('Seleccionar Imagen'),
                      ),
                      const SizedBox(height: 16),
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
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            postController.createPost();
                            postsListController.fetchPosts();
                                Get.find<PostController>().clearFields();

                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF89AFAF),
                          ),
                          child: const Text('Crear Post'),
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
