import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/userServices.dart';
import 'package:flutter_application_1/models/user.dart';

class UserListController extends GetxController {
  var isLoading = true.obs;
  var userList = <UserModel>[].obs; // Tipus de llista especificat
  final UserService userService = UserService();
  var currentPage = 1.obs; // Pàgina actual
  var limit = 10.obs; // Nombre d'usuaris a mostrar

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future fetchUsers() async {
    try {
      isLoading(true);
      var users = await userService.getUsers(
          currentPage.value, limit.value); // Passar pàgina i límit
      if (users != null) {
        userList.assignAll(users);
      }
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading(false);
    }
  }

  void setLimit(int newLimit) {
    limit.value = newLimit;
    currentPage.value = 1; // Reinicia la pàgina a 1 quan canvia el límit
    fetchUsers(); // Torna a carregar els usuaris
  }

  void nextPage() {
    currentPage.value++;
    fetchUsers(); // Torna a carregar els usuaris per a la nova pàgina
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchUsers(); // Torna a carregar els usuaris per a la nova pàgina
    }
  }
}
