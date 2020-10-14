import 'package:brosKeeper/pages/addContact.dart';
import 'package:brosKeeper/pages/signInPage.dart';
import 'package:brosKeeper/pages/viewContact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  AssetImage image = AssetImage("assets/images/logo.png");
  String username, email;
  User user;
  bool isSignedIn = false;
  checkAuthentication() async {
    // ignore: deprecated_member_use
    _auth.authStateChanges().listen((user) {
      print("MESSAGE: ${user.email}");
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/SignInPage');
      }
    }, onDone: () {
      print("MESSAGE EMAIL: ${user.email}");
      print("MESSAGE USER : " + user.displayName.toString());
    }, onError: (e) {
      print("Error Message : " + e.toString());
    });
  }

  navigateToAddScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddContact()));
    // Navigator.of(context).pushNamed('/AddContactPage', arguments: null);
  }

  navigateToViewScreen(id) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ViewContact()));
    // Navigator.of(context).pushNamed('/AddContactPage', arguments: null);
  }

  getUser() async {
    User authUser = _auth.currentUser;
    await authUser?.reload();
    authUser = _auth.currentUser;

    if (authUser != null) {
      setState(() {
        this.user = authUser;
        this.isSignedIn = true;
      });
    }
    print(authUser);
    print(this.email);
  }

  signOut() async {
    _auth.signOut();
    Navigator.pushReplacementNamed(context, '/SignInPage');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.checkAuthentication();
    this.getUser();
    print(user);
    print(isSignedIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: navigateToAddScreen,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: new AppBar(
        title: new Text(
          "Bro's Keeper",
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        leading: new IconButton(
          icon: new Icon(Icons.logout,
              color: Theme.of(context).textSelectionColor),
          onPressed: signOut,
        ),
        actions: [
          InkWell(
            child: Container(
              margin: EdgeInsets.fromLTRB(0.0, 12.0, 16.0, 12.0),
              height: 30.0,
              width: 30.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: image,
                  )),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed('/Profile', arguments: 4);
            },
          ),
        ],
      ),
      body: Container(
          child: Center(
        child: !isSignedIn
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(50),
                      child: Image(
                        image: image,
                        width: 100.0,
                        height: 100.0,
                      )),
                  Container(
                      padding: EdgeInsets.all(50),
                      child: Text('Hello ${user.email}')),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: RaisedButton(
                      padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                      onPressed: signOut,
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text("Sign Out",
                          style: Theme.of(context).textTheme.subtitle1),
                    ),
                  ),
                ],
              ),
      )),
    );
  }
}
