import 'package:brosKeeper/pages/homePage.dart';
import 'package:brosKeeper/pages/signInPage.dart';
import 'package:brosKeeper/pages/signUpPage.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/SignInPage':
        return MaterialPageRoute(builder: (_) => SignInPage());
      case '/SignUpPage':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      default:
        return MaterialPageRoute(
            builder: (_) =>
                Scaffold(body: SafeArea(child: Text('Route Error'))));
    }
  }
}
