// views/user_information_form.dart
import 'package:flutter/material.dart';

class UserInformationForm extends StatefulWidget {
  final String? initialName;
  final String? initialSurname;
  final String? initialPhoneNumber;
  final String? userId;
  final Function(String name, String surname, String phoneNumber) onSubmit;

  const UserInformationForm({
    super.key,
    this.initialName,
    this.initialSurname,
    this.initialPhoneNumber,
    this.userId,
    required this.onSubmit,
  });

  @override
  State<UserInformationForm> createState() => _UserInformationFormState();
}

class _UserInformationFormState extends State<UserInformationForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _surnameController = TextEditingController(text: widget.initialSurname);
    _phoneNumberController = TextEditingController(text: widget.initialPhoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // First Name
          TextFormField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontSize: 17),
            decoration: InputDecoration(
              hintText: 'Rethabile',
              hintStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.person_outline, color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            ),
            validator: (v) => v?.trim().isEmpty == true ? 'First name required' : null,
          ),
          const SizedBox(height: 20),

          // Surname
          TextFormField(
            controller: _surnameController,
            style: const TextStyle(color: Colors.white, fontSize: 17),
            decoration: InputDecoration(
              hintText: 'Siase',
              hintStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.person, color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            ),
            validator: (v) => v?.trim().isEmpty == true ? 'Surname required' : null,
          ),
          const SizedBox(height: 20),

          // Phone Number
          TextFormField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white, fontSize: 17),
            decoration: InputDecoration(
              hintText: '+27 81 234 5678',
              hintStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.phone_outlined, color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            ),
            validator: (v) {
              if (v?.trim().isEmpty == true) return 'Phone number required';
              if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(v!.trim())) {
                return 'Enter a valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF3D4EFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                elevation: 8,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit(
                    _nameController.text.trim(),
                    _surnameController.text.trim(),
                    _phoneNumberController.text.trim(),
                  );
                  // Navigator.pop handled by parent dialog
                }
              },
              child: Text(
                widget.userId == null ? 'Complete Profile' : 'Update Information',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}