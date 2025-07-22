//
// Coder                    : Rethabile Eric Siase
// Time taken to complete   : 2 days
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules
//

import 'package:firebase_flutter/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'email_formfield.dart';
import 'password_formfield.dart';

// AuthPage widget handles both login and registration
class AuthPage extends StatefulWidget {
  final bool isLogin; // Determines if the page is for login or registration
  const AuthPage({super.key, required this.isLogin});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController =
      TextEditingController(); // Controller for email input
  final _passwordController =
      TextEditingController(); // Controller for password input
  final TextEditingController _surnameController =
      TextEditingController(); // Controller for surname input (registration only)
  final TextEditingController _studentNumberController =
      TextEditingController(); // Controller for student number input (registration only)
  final TextEditingController _phoneNumberController =
      TextEditingController(); // Controller for phone number input (registration only)
  final _nameController =
      TextEditingController(); // Controller for name input (registration only)
  bool _isLoading = false; // Loading state
  final _mainFormKey = GlobalKey<FormState>(); // For email & password
  final _detailsFormKey =
      GlobalKey<FormState>(); // For the personal details in dialog

  Future<void> _showPersonalDetailsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Personal Details"),
          content: SizedBox(
            height: 320,
            width: 290,
            child: Form(
              key: _detailsFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator:
                        (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _surnameController,
                    decoration: const InputDecoration(labelText: 'Surname'),
                    validator:
                        (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _studentNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Student Number',
                    ),
                    validator:
                        (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                    validator:
                        (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // close dialog
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed:
                  _isLoading
                      ? null
                      : () {
                        if (_detailsFormKey.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          _submit(context);
                        }
                      },
              child:
                  _isLoading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : const Text('Register'),
            ),
          ],
        );
      },
    );
  }

  // Method to handle form submission
  Future<void> _submit(BuildContext context) async {
    if (!_mainFormKey.currentState!.validate()) return; // Validate the form

    setState(() => _isLoading = true); // Set loading state

    try {
      final authService = Provider.of<AuthService>(context, listen: false);

      if (widget.isLogin) {
        // Login logic
        await authService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        // Navigate to the main page after successful login
        Navigator.pushReplacementNamed(
          context,
          RouteManager.mainPage,
          arguments: _emailController.text.trim(),
        );
      } else {
        // Registration logic
        await authService.register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
          _surnameController.text.trim(),
          _studentNumberController.text.trim(),
          _phoneNumberController.text.trim(),
        );
        // Navigate back to the login page after successful registration
        Navigator.pushReplacementNamed(context, RouteManager.loginPage);
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false); // Reset loading state
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _mainFormKey,
          child: ListView(
            children: [
              SizedBox(height: 30),
              if (widget.isLogin)
                // Show loading indicator if logging in
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/welcome.png'),
                ),
              if (!widget.isLogin)
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/passwd.png'),
                ),
              SizedBox(height: 120),
              if (!widget.isLogin)
                // Title for registration
                const Text(
                  'Create an Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              if (widget.isLogin)
                // Title for login
                const Text(
                  'Login to Your Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              // Email input field
              EmailFormField(controller: _emailController),
              const SizedBox(height: 16),
              // Password input field
              PasswordFormField(controller: _passwordController),
              const SizedBox(height: 24),
              // Submit button
              ElevatedButton(
                // onPressed: _isLoading ? null : () => _submit(context),
                onPressed: () {
                  if (!_mainFormKey.currentState!.validate()) {
                    return;
                  } else if (!widget.isLogin) {
                    _showPersonalDetailsDialog(context);
                  } else {
                    _submit(context);
                  }
                },
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Text(widget.isLogin ? 'Login' : 'Register'),
              ),
              // Toggle between login and registration
              TextButton(
                onPressed:
                    () => Navigator.pushReplacementNamed(
                      context,
                      widget.isLogin
                          ? RouteManager.registrationPage
                          : RouteManager.loginPage,
                    ),
                child: Text(
                  widget.isLogin
                      ? 'Create an account'
                      : 'Already have an account?',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// This code defines an authentication page that allows users to either log in or register.
// It uses a form with validation for email and password inputs, and conditionally shows a name input field for registration.
// The page handles form submission, showing loading indicators and error messages as needed.
