//
// Coder                    : Rethabile Eric Siase
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules
//

import 'package:firebase_flutter/auth/auth_page.dart';
import 'package:firebase_flutter/auth/complete_profile_page.dart';
import 'package:firebase_flutter/views/home_page.dart';
import 'package:firebase_flutter/views/main_layout.dsrt.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String registrationPage = '/register';
  static const String mainPage = '/main';
  static const String completeProfilePage = '/completeProfilePage';
  static const String mainLayout = '/mainLayout';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (_) => const AuthPage(isLogin: true));

      case registrationPage:
        return MaterialPageRoute(
          builder: (_) => const AuthPage(isLogin: false),
        );

      case mainPage:
        return MaterialPageRoute(builder: (_) => MainPage());
      case mainLayout:
        final email = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => MainLayout(email: email));

      case completeProfilePage:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder:
              (_) => CompleteProfilePage(
                uid: args["uid"],
                email: args["email"],
                name: args["name"],
              ),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(child: Text('No route for ${settings.name}')),
              ),
        );
    }
  }
}
