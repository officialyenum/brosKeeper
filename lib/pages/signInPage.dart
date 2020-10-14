import 'package:brosKeeper/pages/homePage.dart';
import 'package:brosKeeper/pages/signUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // User _user;
  String _email, _password;
  bool hidePassword;
  // checkAuthentication() async {
  //   // ignore: deprecated_member_use
  //   _auth.authStateChanges().listen((user) {
  //     _user = user;
  //   }, onDone: () {
  //     if (_user != null) {
  //       Navigator.pushReplacementNamed(context, '/SignInPage');
  //     }
  //   }, onError: (e) {
  //     print(e.toString());
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = "";
    _password = "";
    hidePassword = true;
    // this.checkAuthentication();
  }

  void navigateToSignUpScreen() {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => SignUpPage()));
    Navigator.of(context).pushNamed('/SignUpPage', arguments: null);
  }

  void signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        // DEPRECATED 0.7.0
        // FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        //         email: _email, password: _password))
        //     .user;
        // UPDATED
        // ignore: deprecated_member_use
        final UserCredential userCredential = await _auth
            .signInWithEmailAndPassword(email: _email, password: _password);
        print(userCredential.user);
        if (userCredential != null) {
          Navigator.of(context).pushReplacementNamed('/Home', arguments: null);
        }
      } catch (e) {
        showError(e.message);
      }
    }
  }

  showError(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        child: Center(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 50.0),
                child: Image(image: AssetImage("assets/images/logo.png")),
                width: 150.0,
                height: 150.0,
              ),
              Container(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (input) => _email = input,
                            validator: (input) => !input.contains('@')
                                ? 'should_be_a_valid_email'
                                : null,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).accentColor),
                              contentPadding: EdgeInsets.all(12),
                              hintText: 'yourname@domain.com',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.7)),
                              prefixIcon: Icon(Icons.alternate_email,
                                  color: Theme.of(context).accentColor),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            onSaved: (input) => _password = input,
                            validator: (input) => input.length < 3
                                ? 'should be more than 3 characters'
                                : null,
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).accentColor),
                              contentPadding: EdgeInsets.all(12),
                              hintText: '••••••••••••',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.7)),
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: Theme.of(context).accentColor),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                color: Theme.of(context).focusColor,
                                icon: Icon(hidePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.7)),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 10.0),
                          padding:
                              EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                          child: RaisedButton(
                            onPressed: signIn,
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text("Sign In",
                                style: Theme.of(context).textTheme.subtitle1),
                          ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: InkWell(
                    child: Text(
                      "Don't have an Account, Please click here to Sign Up",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    onTap: navigateToSignUpScreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
