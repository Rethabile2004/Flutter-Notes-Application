//
// Coder                    : Rethabile Eric Siase
// Time taken to complete   : 2 days
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) notes
//

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/models/app_user.dart';
import 'package:firebase_flutter/models/notes.dart';
import 'package:firebase_flutter/routes/app_router.dart';
import 'package:firebase_flutter/services/auth_service.dart';
import 'package:firebase_flutter/views/notes_screen.dart';
import 'package:firebase_flutter/views/user_infromation_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Redesigned Home Screen showing user info and list of notes.
/// Allows the user to add, edit, or delete notes with a refreshed UI layout.
class MainPage extends StatelessWidget {
  final String email;

  const MainPage({super.key, required this.email});
  // Show user profile info in a dialog with an option to update it
  void _userInfoUpdate(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (context) => FutureBuilder<AppUser?>(
            future: authService.getUserData(authService.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final user = snapshot.data;
              if (user == null) {
                return const Center(child: Text('User not found'));
              }

              return AlertDialog(
                icon: const Icon(Icons.person, size: 80),
                title: const Text('Profile Information'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${user.name} ${user.surname}'),
                    Text('Email: ${user.email}'),
                    Text('Phone: ${user.phoneNumber}'),
                  ],
                ),
                
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _editUserInfo(context, user);
                    },
                    child: const Text('Edit Info'),
                  ),
                ],
              );
            },
          ),
    );
  }

  // Show form to edit user info
  void _editUserInfo(BuildContext context, AppUser user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
            title: const Text('Edit Information'),
            content: SizedBox(
              height: 250,
              width: 250,
              child: UserInformationForm(
                initialName: user.name,
                initialSurname: user.surname,
                initialPhoneNumber: user.phoneNumber,
                userId: FirebaseAuth.instance.currentUser!.uid,
                onSubmit: (name, surname, phoneNumber) {
                  Provider.of<AuthService>(
                    context,
                    listen: false,
                  ).updateUserInfo(name, surname, phoneNumber);
                },
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home, color: Colors.white),
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, RouteManager.loginPage);
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddNoteDialog(context),
        label: const Text('Add Note'),
        icon: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<AppUser?>(
          future: authService.getUserData(authService.currentUser!.uid),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!userSnapshot.hasData) {
              return const Center(child: Text('User not found'));
            }

            final user = userSnapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  User Info Card
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () => _userInfoUpdate(context),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    leading: const CircleAvatar(
                      radius: 25,
                      child: Icon(Icons.person),
                    ),
                    trailing: Icon(Icons.edit, color: Colors.blue[900]),
                    title: Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(email),
                  ),
                ),

                const SizedBox(height: 24),

                // 🧾 Notes Title
                const Text(
                  'Your Notes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                // 📋 Notes List
                Expanded(child: _buildNotesList(context)),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Displays the note list as styled cards with edit and delete actions.
  Widget _buildNotesList(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<List<Note>>(
      stream: authService.getNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final notes = snapshot.data ?? [];

        if (notes.isEmpty) {
          return const Center(child: Text('No notes added yet'));
        }

        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                title: Text(
                  note.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'description: ${note.description}',
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.green),
                      onPressed: () => _showEditNoteDialog(context, note),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteNote(context, note.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Opens a dialog to add a new note
  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Note'),
            content: SizedBox(
              height: 280,
              child: NoteForm(
                onSubmit: (name, description) {
                  Provider.of<AuthService>(
                    context,
                    listen: false,
                  ).addNote(name, description);
                },
              ),
            ),
          ),
    );
  }

  /// Opens a dialog to edit an existing note
  void _showEditNoteDialog(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Note'),
            content: SizedBox(
              height: 310,
              child: NoteForm(
                noteId: note.id,
                initialName: note.name,
                initialDescription: note.description,
                onSubmit: (name, description) {
                  Provider.of<AuthService>(
                    context,
                    listen: false,
                  ).updateNote(note.id, name, description);
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  /// Opens a confirmation dialog before deleting a note
  Future<void> _deleteNote(BuildContext context, String noteId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this note?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await Provider.of<AuthService>(context, listen: false).deleteNote(noteId);
    }
  }
}
