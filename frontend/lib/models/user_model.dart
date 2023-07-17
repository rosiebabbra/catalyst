import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;
  final Timestamp createdAt;

  const User({
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        userId,
        firstName,
        lastName,
        email,
        phoneNumber,
        password,
        createdAt,
      ];

  static User fromSnapshot(DocumentSnapshot snap) {
    User user = User(
      userId: snap['user_id'],
      firstName: snap['first_name'],
      lastName: snap['last_name'],
      email: snap['email'],
      phoneNumber: snap['phone_number'],
      password: snap['password'],
      createdAt: snap['created_at'],
    );
    return user;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': firstName,
    };
  }

  User copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? password,
    Timestamp? createdAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static List<User> users = [
    User(
      userId: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@email.com',
      phoneNumber: '1234567890',
      password: 'somehashedstuff',
      createdAt: Timestamp.now(),
    ),
    User(
      userId: '2',
      firstName: 'Tamara',
      lastName: 'Jackson',
      email: 'tamara.jackson@email.com',
      phoneNumber: '0987654321',
      password: 'someotherhashedstuff',
      createdAt: Timestamp.now(),
    ),
  ];
}
