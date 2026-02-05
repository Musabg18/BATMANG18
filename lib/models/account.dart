class Account {
  const Account({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.role,
  });

  final int id;
  final String name;
  final String email;
  final String passwordHash;
  final String role; // "player" or "scout"

  factory Account.fromMap(Map<String, Object?> map) {
    return Account(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      passwordHash: map['password_hash'] as String,
      role: map['role'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password_hash': passwordHash,
      'role': role,
    };
  }
}
