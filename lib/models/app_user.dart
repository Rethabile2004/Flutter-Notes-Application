//
// Coder                    : Rethabile Eric Siase
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules
//

import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String email;
  final String name;
  final String surname;
  final String studentNumber;
  final String phoneNumber;
  final DateTime createdAt;

  // Constructor to initialize the AppUser object
  AppUser({
    required this.email,
    required this.name,
    required this.createdAt,
    required this.surname,
    required this.studentNumber,
    required this.phoneNumber,
  });

  // Factory method to create an AppUser from Firestore document data
  factory AppUser.fromFirestore(Map<String, dynamic> data) {
    return AppUser(
      email: data['email'],
      name: data['name'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      surname: data['surname'],
      studentNumber: data['studentNumber'],
      phoneNumber: data['phoneNumber'],
    );
  }

  // Method to convert AppUser to a Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'createdAt': createdAt,
      'surname': surname,
      'studentNumber': studentNumber,
      'phoneNumber': phoneNumber,
    };
  }
}
