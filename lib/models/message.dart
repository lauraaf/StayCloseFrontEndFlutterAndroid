class Message {
  final String senderId;
  final String content;
  final DateTime timestamp;

  Message(
      {required this.senderId, required this.content, required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
