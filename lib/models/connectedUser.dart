class ConnectedUser {
  final String username;

  ConnectedUser({required this.username});

  // Método fromJson para construir una instancia a partir de un Map
  factory ConnectedUser.fromJson(Map<String, dynamic> json) {
    return ConnectedUser(username: json['username'] ?? 'username');
  }
}
