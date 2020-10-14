import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username, _email, _password;
  bool hidePassword;

  // checkAuthentication() async {
  //   _auth.authStateChanges().listen((user) {
  //     if (user == null) {
  //       // Navigator.pushReplacementNamed(context, '/');
  //     }
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _username = "";
    _email = "";
    _password = "";
    hidePassword = true;
    // this.checkAuthentication();
  }

  navigateToSignInScreen() {
    Navigator.pushReplacementNamed(context, '/SignInPage');
  }

  signUp() async {
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
            .createUserWithEmailAndPassword(email: _email, password: _password);
        print(userCredential.user);
        if (userCredential != null) {
          userCredential.user.updateProfile(displayName: _username);
          Navigator.of(context).pushReplacementNamed('/', arguments: null);
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
    return Container(
        child: Scaffold(
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
                            onSaved: (input) => _username = input,
                            validator: (input) => input.length > 8
                                ? 'should be less than 8 characters'
                                : null,
                            decoration: InputDecoration(
                              labelText: 'your name',
                              labelStyle: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).accentColor),
                              contentPadding: EdgeInsets.all(12),
                              hintText: 'yourname',
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
                            onPressed: signUp,
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
                    onTap: navigateToSignInScreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
