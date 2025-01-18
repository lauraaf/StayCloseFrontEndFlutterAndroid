import 'package:intl/intl.dart';

class Message {
  final String senderId;
  final String content;
  final DateTime timestamp;
  final String receiverId;

  Message({
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.receiverId,
  });

//Creamos un mensaje desde un JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['sender'], //para verificar que el campo exista ?? ''
      receiverId: json['receiver'], //para verificar que el campo exista ?? ''
      content: json['content'], //para verificar que el campo exista ?? ''
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
  //Convertir mensaje a JSON
  Map<String, dynamic> toJson() {
    return {
      'sender': senderId,
      'receiver': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  //Hora

  String get formattedTime {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(timestamp);
  }
}
