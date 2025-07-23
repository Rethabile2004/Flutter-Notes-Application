//
// Coder               : Rethabile Eric Siase
// Time taken to complete   : 2 days
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) notes  
//

import 'package:flutter/material.dart';

class NoteForm extends StatefulWidget {
  final String? noteId;
  final String? initialName;
  final String? initialDescription;
  final Function(String name, String description) onSubmit;

  const NoteForm({
    super.key,
    this.noteId,
    this.initialName,
    this.initialDescription,
    required this.onSubmit,
  });

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null) _nameController.text = widget.initialName!;
    if (widget.initialDescription != null) _descriptionController.text = widget.initialDescription!;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Note Title',hintText: 'Software Engineering || Notes'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Focus on unit 2 for the main test',border:OutlineInputBorder() ),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit(
                  _nameController.text.trim(),
                  _descriptionController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: Text(widget.noteId == null ? 'Add Note' : 'Update Note'),
          ),
        ],
      ),
    );
  }
}