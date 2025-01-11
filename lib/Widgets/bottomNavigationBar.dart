import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/navigationController.dart';

class BottomNavScaffold extends StatelessWidget {
  final Widget child;
  final NavigationController navController = Get.put(NavigationController());

  BottomNavScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    // Variables de tipo String asignadas en tiempo de ejecución
    final homeLabel = 'Home'.tr;
    final foroLabel = 'Foro'.tr;
    final mapLabel = 'Mapa'.tr;
    final calendarLabel = 'Calendario'.tr;
    final chatLabel = 'Chat'.tr;
    final profileLabel = 'Perfil'.tr;

    return Scaffold(
      body: child,
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navController.selectedIndex.value,
          //onTap: navController.navigateTo,
          onTap: (index) {
            if (index == 4) {
              // Índice correspondiente al chat
              Get.toNamed('/chat'); // Navegar a la lista de usuarios
            } else {
              navController.navigateTo(index); // Navegar a otras pantallas
            }
          },
          selectedItemColor:
              Color(0xFF89AFAF), // Verde claro (estética del Home)
          unselectedItemColor: Color(
              0xFF4D6F6F), // Verde oscuro/gris para elementos no seleccionados
          backgroundColor:
              Color(0xFFE0F7FA), // Fondo azul claro (coherente con Home)
          elevation: 5, // Sombra suave para el diseño
          type: BottomNavigationBarType
              .fixed, // Fija para mantener los elementos en su lugar
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label:
                  homeLabel, // Usamos la variable en lugar de .tr en una constante
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.app_registration_sharp),
              label:
                  foroLabel, // Usamos la variable en lugar de .tr en una constante
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              label:
                  mapLabel, // Usamos la variable en lugar de .tr en una constante
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label:
                  calendarLabel, // Usamos la variable en lugar de .tr en una constante
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum_outlined),
              label:
                  chatLabel, // Usamos la variable en lugar de .tr en una constante
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label:
                  profileLabel, // Usamos la variable en lugar de .tr en una constante
            ),
          ],
        ),
      ),
    );
  }
}
