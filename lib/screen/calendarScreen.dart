//V1.2
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_1/controllers/eventController.dart';
import 'package:flutter_application_1/controllers/themeController.dart';

class CalendarScreen extends StatelessWidget {
  final EventController eventController = Get.put(EventController());
  
  @override
  Widget build(BuildContext context) {
    // Obtener el ThemeController para acceder a la función de cambio de tema
    final ThemeController themeController = Get.find();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Usamos el tamaño predeterminado del AppBar
        child: Obx(() {
          return AppBar(
            title: Text("Calendario".tr,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Tamaño y estilo fijo del texto),
            backgroundColor: themeController.isDarkMode.value
                ? Color(0xFF555A6F) // Color para el modo oscuro
                : Color(0xFF89AFAF), // Color para el modo claro
            actions: [
              // Icono para cambiar el tema
              IconButton(
                icon: Icon(Icons.brightness_6),
                onPressed: () {
                  themeController.toggleTheme(); // Cambiar tema
                },
                color: Colors.white,
              ),
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
          );
        }),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Calendario
              Obx(() {
                return Container(
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode.value ? Color(0xFF444444) : Color(0xFFB2D5D5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 01, 01),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: eventController.focusedDay.value,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    selectedDayPredicate: (day) => isSameDay(eventController.selectedDay.value, day),
                    onDaySelected: eventController.onDaySelected,
                    onPageChanged: (focusedDay) {
                      eventController.focusedDay.value = focusedDay;
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: themeController.isDarkMode.value ? Color(0xFF89AFAF) : Color(0xFF89AFAF),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: themeController.isDarkMode.value ? Color(0xFF89AFAF) : Color(0xFF89AFAF),
                        shape: BoxShape.circle,
                      ),
                      defaultDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      weekendDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        color: Colors.purpleAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                      rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.black),
                      weekendStyle: TextStyle(color: Colors.black),
                    ),
                    eventLoader: (day) => eventController.getEventsForDay(day),
                  ),
                );
              }),
              SizedBox(height: 16),
              // Lista de eventos para el día seleccionado
              Obx(() {
                final selectedEvents = eventController.getEventsForDay(eventController.selectedDay.value);
                return Container(
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode.value ? Color(0xFF444444) : Color(0xFFB2D5D5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Eventos del día seleccionado".tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      selectedEvents.isEmpty
                          ? Center(
                              child: Text(
                                "No hay eventos para este día.".tr,
                                style: TextStyle(color: themeController.isDarkMode.value ? Colors.white54 : Colors.black54),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: selectedEvents.length,
                              itemBuilder: (context, index) {
                                final event = selectedEvents[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    event.name.tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    event.description.tr,
                                    style: TextStyle(
                                      color: themeController.isDarkMode.value ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  trailing: Text(
                                    "${event.eventDate.hour}:${event.eventDate.minute.toString().padLeft(2, '0')}",
                                    style: TextStyle(color: themeController.isDarkMode.value ? Colors.white70 : Colors.black54),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    _showAddEventDialog(context);
  },
  backgroundColor: Theme.of(context).brightness == Brightness.dark
      ? Colors.grey[800]  // Color para modo oscuro
      : Color(0xFF89AFAF), // Color para modo claro
  child: Icon(
    Icons.add,
    color: Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Ícono blanco en modo oscuro
        : Colors.black, // Ícono negro en modo claro
  ),
),

    );
  }

  void _showAddEventDialog(BuildContext context) {
        final ThemeController themeController = Get.find();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<EventController>(builder: (eventController) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Nuevo Evento'.tr,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF89AFAF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: eventController.nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre'.tr,
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                          color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: eventController.descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Descripción'.tr,
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                          color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: eventController.dateController,
                      decoration: InputDecoration(
                        labelText: 'Fecha (YYYY-MM-DD)'.tr,
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                          color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: eventController.creatorController,
                      decoration: InputDecoration(
                        labelText: 'Creador'.tr,
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                          color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await eventController.createEvent();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF89AFAF),
                        ),
                        child: Text('Crear Evento'.tr),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
