import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/ubi.dart';

class UbiCard extends StatelessWidget {
  final UbiModel ubi;

  const UbiCard({Key? key, required this.ubi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),  // Limitar el ancho máximo
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),  // Menos redondeo
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),  // Ajuste de márgenes
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),  // Ajuste de padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre de la ubicación
              Text(
                ubi.name,
                style: const TextStyle(
                  fontSize: 14,  // Tamaño de fuente reducido
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 6),  // Espaciado reducido

              // Dirección
              Row(
                mainAxisSize: MainAxisSize.min,  // Ajuste al tamaño del contenido
                children: [
                  const Icon(Icons.location_on, size: 14, color: Color(0xFF2980B9)),  // Icono más pequeño
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      ubi.address ?? 'Dirección no disponible',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),  // Texto más pequeño
                      overflow: TextOverflow.ellipsis,  // Asegurar que el texto no se desborde
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),  // Espaciado reducido

              // Horario
              Row(
                mainAxisSize: MainAxisSize.min,  // Ajuste al tamaño del contenido
                children: [
                  const Icon(Icons.access_time, size: 14, color: Color(0xFF2980B9)),
                  const SizedBox(width: 5),
                  Text(
                    ubi.horari ?? 'Horario no disponible',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 6),  // Espaciado reducido

              // Tipo
              Row(
                mainAxisSize: MainAxisSize.min,  // Ajuste al tamaño del contenido
                children: [
                  const Icon(Icons.category, size: 14, color: Color(0xFF2980B9)),
                  const SizedBox(width: 5),
                  Text(
                    ubi.tipo ?? 'Tipo no disponible',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 6),  // Espaciado reducido

              // Comentario
              Row(
                mainAxisSize: MainAxisSize.min,  // Ajuste al tamaño del contenido
                children: [
                  const Icon(Icons.comment, size: 14, color: Color(0xFF2980B9)),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      ubi.comentari ?? 'Comentario no disponible',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,  // Evita que el comentario desborde
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),  // Espaciado reducido
            ],
          ),
        ),
      ),
    );
  }
}
