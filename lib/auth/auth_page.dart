import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter/auth/input_formfield.dart';
import 'package:firebase_flutter/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'email_formfield.dart';
import 'password_formfield.dart';

class AuthPage extends StatefulWidget {
  final bool isLogin;
  const AuthPage({super.key, required this.isLogin});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _studentNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  bool _isLoading = false;
  final _mainFormKey = GlobalKey<FormState>();
  // final _detailsFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light, // White status bar icons
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFF6D7BFF), // Exact blue from screenshot
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
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Form(
                    key: _mainFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo - Heart with stars (replace with your asset if different)
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 60,
                            color: Color(0xFF6D7BFF),
                          ),
                        ),
                        const SizedBox(height: 48),
              
                        // Welcome Text
                        Text(
                          widget.isLogin ? "Welcome Back" : "Create Account",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.isLogin
                              ? "Sign in to continue"
                              : "Fill in your details to get started",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 48),
                        if (!widget.isLogin)
                          InputFormfield(
                            controller: _nameController,
                            hintText: "First name",
                            prefixIcon: Icons.person,
                          ),
                        const SizedBox(height: 16),
                        if (!widget.isLogin)
                          InputFormfield(
                            controller: _surnameController,
                            hintText: "Surname",
                            prefixIcon: Icons.person_outline,
                          ),
                        const SizedBox(height: 16),
                        if (!widget.isLogin)
                          InputFormfield(
                            controller: _studentNumberController,
                            hintText: "Student Number",
                            prefixIcon: Icons.key,
                          ),
                        const SizedBox(height: 16),
                        if (!widget.isLogin)
                          InputFormfield(
                            controller: _phoneNumberController,
                            hintText: "Phone number",
                            prefixIcon: Icons.phone,
                          ),
                        const SizedBox(height: 16),
                        EmailFormField(controller: _emailController),
                        const SizedBox(height: 16),
              
                        // Password Field
                        PasswordFormField(controller: _passwordController),
                        if (widget.isLogin) ...[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => _showForgotPasswordDialog(context),
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
              
                        // Main Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF6D7BFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                            ),
                            onPressed:
                                _isLoading
                                    ? null
                                    : () {
                                      if (!_mainFormKey.currentState!.validate())
                                        return;
                                      if (!widget.isLogin) {
                                        _submit(context);
                                      } else {
                                        _submit(context);
                                      }
                                    },
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF6D7BFF),
                                        ),
                                      ),
                                    )
                                    : Text(
                                      widget.isLogin ? "Sign In" : "Next",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                        // if (widget.isLogin)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Row(
                            children: [
                              Expanded(child: Divider(color: Colors.white38)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "or continue with",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.white38)),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _socialButton(
                              asset: 'assets/google.png',
                              onTap: () async {
                                final auth = Provider.of<AuthService>(
                                  context,
                                  listen: false,
                                );
              
                                try {
                                  final result = await auth.signInWithGoogle();
                                  final user = result.user;
              
                                  final doc =
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(user!.uid)
                                          .get();
              
                                  if (doc.exists) {
                                    // Profile already created
                                    Navigator.pushReplacementNamed(
                                      context,
                                      RouteManager.mainLayout,
                                      arguments: user.email,
                                    );
                                  } else {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      RouteManager.completeProfilePage,
                                      arguments: {
                                        "email": user.email,
                                        "name": user.displayName ?? "",
                                        "uid": user.uid,
                                      },
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              },
                            ),
                            const SizedBox(width: 20),
                            _socialButton(
                              asset: 'assets/facebook.png',
                              onTap: () async {
                                final auth = Provider.of<AuthService>(
                                  context,
                                  listen: false,
                                );
                                try {
                                  await auth.signInWithFacebook();
                                  Navigator.pushReplacementNamed(
                                    context,
                                    RouteManager.mainLayout,
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
              
                        const SizedBox(height: 40),
              
                        // Toggle Link
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
                                ? "Don't have an account? Sign Up"
                                : "Already have an account? Sign In",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Replace your shitty _socialButton with this:
  Widget _socialButton({required String asset, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Center(child: Image.asset(asset, width: 32, height: 32)),
      ),
    );
  }

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
          RouteManager.mainLayout,
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

  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Reset Password"),
            content: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "Enter your email"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter your email")),
                    );
                    return;
                  }

                  try {
                    final authService = Provider.of<AuthService>(
                      context,
                      listen: false,
                    );
                    await authService.resetPassword(email);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Password reset link sent to your email"),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                },
                child: const Text("Send Reset Link"),
              ),
            ],
          ),
    );
  }
}
