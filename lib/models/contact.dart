class Contact {
  final int? id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final String contactNum;
  final String? userId;

  Contact({
    this.id,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.email,
    required this.contactNum,
    this.userId,
  });

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      firstName: map['first_name'],
      middleName: map['middle_name'] ?? '',
      lastName: map['last_name'],
      email: map['email'],
      contactNum: map['contact_num'],
      userId: map['user_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'first_name': firstName,
      if (middleName != null) 'middle_name': middleName,
      'last_name': lastName,
      'email': email,
      'contact_num': contactNum,
      if (userId != null) 'user_id': userId,
    };
  }
}
