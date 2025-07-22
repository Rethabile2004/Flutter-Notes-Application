//
// Coder                    : Rethabile Eric Siase
// Time taken to complete   : 2 days
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules  
//

// This class represents a user in the application.
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String email; // User's email address
  final String name; // User's name
  final String surname; // User's surname
  final String studentNumber; // User's student number
  final String phoneNumber; // User's phone number
  final DateTime createdAt; // Timestamp of when the user was created

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
