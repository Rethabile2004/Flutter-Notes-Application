//
// Coder                    : Rethabile Eric Siase
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules
//

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/models/app_user.dart';
import 'package:firebase_flutter/routes/app_router.dart';
import 'package:firebase_flutter/services/auth_service.dart';
import 'package:firebase_flutter/views/user_infromation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditDialog(BuildContext context, AppUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF5E6EFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Profile', style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 340,
          child: UserInformationForm(
            initialName: user.name,
            initialSurname: user.surname,
            initialPhoneNumber: user.phoneNumber,
            userId: FirebaseAuth.instance.currentUser!.uid,
            onSubmit: (name, surname, phone) async {
              await Provider.of<AuthService>(context, listen: false)
                  .updateUserInfo(name, surname, phone);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFF6D7BFF),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF5E6EFF), Color(0xFF3D4EFF)],
            ),
          ),
          child: SafeArea(
            child: FutureBuilder<AppUser?>(
              future: authService.getUserData(authService.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('User not found', style: TextStyle(color: Colors.white)));
                }

                final user = snapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // Avatar
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 90, color: const Color(0xFF6D7BFF)),
                      ),
                      const SizedBox(height: 24),

                      // Name
                      Text(
                        "${user.name} ${user.surname}",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Email
                      Text(
                        user.email,
                        style: const TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                      const SizedBox(height: 40),

                      // Info Cards
                      _InfoCard(label: "Phone Number", value: user.phoneNumber),
                      _InfoCard(label: "Student Number", value: user.studentNumber),
                      _InfoCard(label: "Country", value: "South Africa"),
                      _InfoCard(label: "Member Since", value: "November 2025"),

                      const SizedBox(height: 48),

                      // Edit Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          ),
                          onPressed: () => _showEditDialog(context, user),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          ),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            if (context.mounted) {
                              Navigator.pushReplacementNamed(context, RouteManager.loginPage);
                            }
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        // ignore: deprecated_member_use
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}