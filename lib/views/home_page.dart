//
// Coder                    : Rethabile Eric Siase
// Time taken to complete   : 2 days
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) notes
//

import 'package:firebase_flutter/models/app_user.dart';
import 'package:firebase_flutter/models/notes.dart';
import 'package:firebase_flutter/routes/app_router.dart';
import 'package:firebase_flutter/services/auth_service.dart';
import 'package:firebase_flutter/views/notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Add Note Dialog
  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('New Note', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 340,
          height: 280,
          child: NoteForm(
            onSubmit: (name, desc) {
              Provider.of<AuthService>(context, listen: false).addNote(name, desc);
              Navigator.pop(context);
              Navigator.pushNamed(context,RouteManager.mainLayout);
            },
          ),
        ),
      ),
    );
  }

  // Edit Note Dialog
  void _showEditNoteDialog(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Note', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 340,
          height: 310,
          child: NoteForm(
            noteId: note.id,
            initialName: note.name,
            initialDescription: note.description,
            onSubmit: (name, desc) {
              Provider.of<AuthService>(context, listen: false).updateNote(note.id, name, desc);
              Navigator.pop(context);
              Navigator.pushNamed(context,RouteManager.mainLayout);
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ],
      ),
    );
  }

  // Delete Confirmation
  Future<void> _deleteNote(BuildContext context, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Note?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await Provider.of<AuthService>(context, listen: false).deleteNote(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF6D7BFF),
          elevation: 10,
          onPressed: () => _showAddNoteDialog(context),
          label: const Text('Add Note', style: TextStyle(fontWeight: FontWeight.bold)),
          icon: const Icon(Icons.add),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF5E6EFF), Color(0xFF3D4EFF)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Header
                  FutureBuilder<AppUser?>(
                    future: authService.getUserData(authService.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator(color: Colors.white)));
                      }
                      final user = snapshot.data!;
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.white,
                            child: Text(
                              "${user.name[0]}${user.surname[0]}".toUpperCase(),
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6D7BFF)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome back, ${user.name}",
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                Text(
                                  user.email,
                                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Notes Title
                  const Text(
                    "Your Notes",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  // Notes List
                  Expanded(
                    child: StreamBuilder<List<Note>>(
                      stream: authService.getNotes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Colors.white));
                        }
                        if (snapshot.hasError) return const Center(child: Text('Error loading notes', style: TextStyle(color: Colors.white70)));
                        final notes = snapshot.data ?? [];
                        if (notes.isEmpty) {
                          return const Center(
                            child: Text(
                              "No notes yet.\nTap + to create one!",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, color: Colors.white70),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, i) {
                            final note = notes[i];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.2)),
                              ),
                              child: ListTile(
                                title: Text(note.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                                subtitle: Text(note.description, style: const TextStyle(color: Colors.white70)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}