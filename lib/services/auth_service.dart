//
// Coder                    : Rethabile Eric Siase
// Time taken to complete   : 2 days
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) notes
//

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter/models/notes.dart';
import 'package:flutter/material.dart';
import '../models/app_user.dart';

// AuthService class handles authentication and user data management
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Firebase Authentication instance
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance

  // Getter to access the currently authenticated user
  User? get currentUser => _auth.currentUser;

  // Method to log in a user with email and password
  Future<User?> login(String email, String password) async {
    try {
      // Sign in the user with email and password
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Return the signed-in user
    } on FirebaseAuthException catch (e) {
      throw _authError(e.code); // Handle authentication errors
    }
  }

  // Method to register a new user
  Future<User?> register(
    String email,
    String password,
    String name,
    String surname,
    String studentNumber,
    String phoneNumber,
  ) async {
    try {
      // Create a new user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create an AppUser object with additional user data
      AppUser appUser = AppUser(
        email: email,
        name: name,
        createdAt: DateTime.now(),
        surname: surname,
        studentNumber: studentNumber,
        phoneNumber: phoneNumber,
      );

      // Save the user data to Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(appUser.toFirestore());

      return userCredential.user; // Return the newly created user
    } on FirebaseAuthException catch (e) {
      throw _authError(e.code); // Handle authentication errors
    }
  }

  // Method to handle authentication errors
  String _authError(String description) {
    switch (description) {
      case 'invalid-email':
        return 'Invalid CUT email address'; // Custom error message for invalid email
      case 'weak-password':
        return 'Password must be 8+ chars with @ symbol'; // Custom error message for weak password
      default:
        return 'Authentication failed'; // Default error message
    }
  }

  // Method to get user data from Firestore
  Future<AppUser?> getUserData(String uid) async {
    // Fetch the document from Firestore
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      // Convert the document data to an AppUser object
      return AppUser.fromFirestore(doc.data() as Map<String, dynamic>);
    }
    return null; // Return null if the document does not exist
  }

  // Note Collection Reference
  CollectionReference get _notesCollection =>
      _firestore.collection('notes');

  // Add a new Note
  Future<void> addNote(String name, String description) async {
    if (currentUser == null) throw Exception('User not authenticated');

    await _notesCollection.add({
      'name': name, // Store the Note name
      'description': description, // Store the Note description
      'studentId':
          currentUser!.uid, // Store the current user's ID from Firebase Auth
      'createdAt': DateTime.now(), // Store the current date and time
    });
    notifyListeners();
  }

  // Update a user infromation
  Future<void> updateNote(
    String name,
    String surname,
    String phoneNumber,
  ) async {
    await _notesCollection.doc(currentUser!.uid).update({
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber,
    });
    notifyListeners();
  }

  // Method to update user profile information
  Future<void> updateUserInfo(
    String name,
    String surname,
    String phoneNumber,
  ) async {
    if (currentUser == null) throw Exception('User not authenticated');

    // Update the user document in the 'users' collection
    await _firestore.collection('users').doc(currentUser!.uid).update({
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber,
    });

    notifyListeners(); // Notify UI to update if needed
  }

  // Delete a Note
  Future<void> deleteNote(String noteId) async {
    await _notesCollection.doc(noteId).delete();
    notifyListeners();
  }

  // Get all notes for current user
  Stream<List<Note>> getNotes() {
    if (currentUser == null) throw Exception('User not authenticated');
    // Listen to the notes collection for the current user
    // and order by createdAt in descending order
    // Map the snapshot to a list of Note objects
    // using the fromFirestore method
    // and return the list as a stream
    // This allows real-time updates to the Note list
    // whenever there are changes in the Firestore collection
    // The stream will emit a new list of notes whenever there are changes
    return _notesCollection
        .where('studentId', isEqualTo: currentUser!.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList(),
        );
  }
}
