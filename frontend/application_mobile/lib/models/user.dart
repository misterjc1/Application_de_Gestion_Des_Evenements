class User {
  final int id;
  final String email;
  final String name;
  final String type; // 'organizer' ou 'user'
  final List<String> roles;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.type,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'] ?? '',
      type: json['type'] ?? 'user',
      roles: List<String>.from(json['roles'] ?? []),
    );
  }

  bool get isOrganizer => type == 'organizer';
}