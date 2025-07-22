//
// Coder                    : Rethabile Eric Siase
// Time taken to complete   : 2 days
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules  
//

import 'package:firebase_flutter/auth/auth_page.dart';
import 'package:firebase_flutter/views/home_page.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String registrationPage = '/register';
  static const String mainPage = '/main';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (_) => const AuthPage(isLogin: true));
      case registrationPage:
        return MaterialPageRoute(builder: (_) => const AuthPage(isLogin: false));
      case mainPage:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MainPage(email: email),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route for ${settings.name}')),
          ),
        );
    }
  }
}