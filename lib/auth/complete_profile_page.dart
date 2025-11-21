import 'package:firebase_flutter/routes/app_router.dart';
import 'package:firebase_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompleteProfilePage extends StatefulWidget {
  final String uid;
  final String email;
  final String name;

  const CompleteProfilePage({
    super.key,
    required this.uid,
    required this.email,
    required this.name,
  });

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _surname = TextEditingController();
  final _student = TextEditingController();
  final _phone = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complete Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _surname,
                decoration: const InputDecoration(labelText: "Surname"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _student,
                decoration: const InputDecoration(labelText: "Student Number"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(labelText: "Phone Number"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  // final userData = {
                  //   "email": widget.email,
                  //   "name": widget.name,
                  //   "surname": _surname.text.trim(),
                  //   "studentNumber": _student.text.trim(),
                  //   "phoneNumber": _phone.text.trim(),
                  //   "createdAt": DateTime.now(),
                  // };
                  var provider = Provider.of<AuthService>(
                    context,
                    listen: false,
                  );
                  provider.createUserCollection(
                    widget.name,
                    _surname.text.trim(),
                    widget.email,
                    _phone.text.trim(),
                    _student.text.trim(),
                    widget.uid,
                  );

                  /**
 * 
 String email,
    String password,
    String name,
    String surname,
    String studentNumber,
    String phoneNumber,
 */
                  // await FirebaseFirestore.instance
                  //     .collection("users")
                  //     .doc(widget.uid)
                  //     .set(userData);
                  Navigator.pushReplacementNamed(
                    context,
                    RouteManager.mainPage,
                    arguments: widget.email,
                  );

                  // Navigator.pushReplacementNamed(
                  //   context,
                  //   RouteManager.mainPage,
                  // );
                },
                child: const Text("Finish"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
