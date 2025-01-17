import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_1/controllers/eventController.dart';

class CalendarScreen extends StatelessWidget {
  final EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE6E6),
      appBar: AppBar(
        title: Text("Calendario".tr),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Calendario
              Obx(() => Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFB2D5D5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 01, 01),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: eventController.focusedDay.value,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      selectedDayPredicate: (day) =>
                          isSameDay(eventController.selectedDay.value, day),
                      onDaySelected: eventController.onDaySelected,
                      onPageChanged: (focusedDay) {
                        eventController.focusedDay.value = focusedDay;
                      },
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: Color(0xFF89AFAF),
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Color(0xFF89AFAF),
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
                        leftChevronIcon:
                            Icon(Icons.chevron_left, color: Colors.black),
                        rightChevronIcon:
                            Icon(Icons.chevron_right, color: Colors.black),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: Colors.black),
                        weekendStyle: TextStyle(color: Colors.black),
                      ),
                      eventLoader: (day) =>
                          eventController.getEventsForDay(day),
                    ),
                  )),
              SizedBox(height: 16),
              // Lista de eventos para el día seleccionado
              Obx(() {
                final selectedEvents = eventController
                    .getEventsForDay(eventController.selectedDay.value);
                return Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFB2D5D5),
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
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      selectedEvents.isEmpty
                          ? Center(
                              child: Text(
                                "No hay eventos para este día.".tr,
                                style: TextStyle(color: Colors.black54),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(event.description.tr),
                                  trailing: Text(
                                    "${event.eventDate.hour}:${event.eventDate.minute.toString().padLeft(2, '0')}",
                                    style: TextStyle(color: Colors.black54),
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
        backgroundColor: Color(0xFF89AFAF),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<EventController>(
          builder: (eventController) {
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
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: eventController.descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Descripción'.tr,
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Text("Selecciona la fecha del evento:".tr),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030, 12, 31),
                          );
                          if (pickedDate != null) {
                            // Formato YYYY-MM-DD
                            eventController.dateController.text =
                                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF89AFAF),
                        ),
                        child: Text('Seleccionar Fecha'.tr),
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
          },
        );
      },
    );
  }
}
