import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/ubi.dart';

class UbiCard extends StatelessWidget {
  final UbiModel ubi;

  const UbiCard({Key? key, required this.ubi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(ubi.name);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              
              ubi.name,  // Solo mostrar el nombre de la ubicación
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
