import 'package:firebase_flutter/views/user_infromation_form.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String? initialName, initialSurname, initialPhoneNumber, userId;

  final Function(String name, String surname, String phoneNumber) onSubmit;
  const Profile({
    super.key,
    this.initialName,
    this.initialSurname,
    this.initialPhoneNumber,
    this.userId,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserInformationForm(
        onSubmit: (String name, String surname, String phoneNumber) {},
      ),
    );
  }
}
