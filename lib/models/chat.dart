class Chat {
  final String id;
  final List<String> participants;

  Chat({required this.id, required this.participants});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'],
      participants: List<String>.from(json['participants']),
    );
  }
}
