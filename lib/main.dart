import 'package:brosKeeper/pages/addContact.dart';
import 'package:brosKeeper/pages/editContact.dart';
import 'package:brosKeeper/pages/homePage.dart';
import 'package:brosKeeper/pages/signInPage.dart';
import 'package:brosKeeper/pages/signUpPage.dart';
import 'package:brosKeeper/pages/viewContact.dart';
import 'package:brosKeeper/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bros Keeper',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/Home',
      // home: HomePage(),
      routes: <String, WidgetBuilder>{
        "/Home": (context) => HomePage(),
        "/SignInPage": (context) => SignInPage(),
        "/SignUpPage": (context) => SignUpPage(),
        "/AddContactPage": (context) => AddContact(),
        "/EditContactPage": (context) => EditContact(),
        "/ViewContactPage": (context) => ViewContact(),
      },
    );
  }
}
