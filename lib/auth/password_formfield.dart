//
// Coder                    : Rethabile Eric Siase
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules
//

import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;

  const PasswordFormField({
    super.key,
    required this.controller,
    this.hintText = "Password",
    this.prefixIcon = Icons.lock_outline,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(widget.prefixIcon, color: Colors.white70),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
        filled: true,
        // ignore: deprecated_member_use
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        if (value.length < 8) return 'Password must be at least 8 characters';
        return null;
      },
    );
  }
}