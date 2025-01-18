//V1.2

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

    // Obtener el tema actual (claro u oscuro)
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
          selectedItemColor: isDarkMode
              ? Colors.tealAccent // Teal claro para el modo oscuro
              : Color(0xFF89AFAF), // Verde claro para el modo claro
          unselectedItemColor: isDarkMode
              ? Colors.grey[500] // Gris más oscuro para el modo oscuro
              : Color(
                  0xFF4D6F6F), // Verde oscuro/gris para elementos no seleccionados en modo claro
          backgroundColor: isDarkMode
              ? Colors.black87 // Fondo oscuro para el modo oscuro
              : Color(0xFFE0F7FA), // Fondo azul claro para el modo claro
          elevation: 5, // Sombra suave para el diseño
          type: BottomNavigationBarType
              .fixed, // Fija para mantener los elementos en su lugar
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: homeLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.app_registration_sharp),
              label: foroLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              label: mapLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: calendarLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum_outlined),
              label: chatLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: profileLabel,
            ),
          ],
        ),
      ),
    );
  }
}
