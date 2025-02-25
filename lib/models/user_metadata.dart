class UserMetadata {
  final String name;

  UserMetadata({
    required this.name,
  });

  factory UserMetadata.fromMap(Map<String, dynamic> map) {
    return UserMetadata(
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
