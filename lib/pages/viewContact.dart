import 'package:brosKeeper/models/contactModel.dart';
import 'package:brosKeeper/pages/editContact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class ViewContact extends StatefulWidget {
  final String id;

  ViewContact({this.id});
  @override
  _ViewContactState createState() => _ViewContactState(id);
}

class _ViewContactState extends State<ViewContact> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  AssetImage profile = AssetImage("assets/images/logo.png");
  String id, username, email;
  _ViewContactState(this.id);
  Contact _contact;
  bool isLoading = false;

  getContact(id) async {
    _databaseReference.child(id).onValue.listen((event) {
      setState(() {
        _contact = Contact.fromSnapShot(event.snapshot);
        isLoading = false;
        print(isLoading);
      });
    });
  }

  signOut() async {
    // _auth.signOut();
    Navigator.pushReplacementNamed(context, '/SignInPage');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getContact(id);
  }

  callAction(String number) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not call $number';
    }
  }

  smsAction(String number) async {
    String url = 'sms:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not sms $number';
    }
  }

  deleteContact() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete?"),
            content: Text("Delete Contact?"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              FlatButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _databaseReference.child(id).remove();
                    navigateToLastScreen();
                  },
                  child: Text("Delete"))
            ],
          );
        });
  }

  navigateToEditScreen(id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditContact(id: id);
    }));
  }

  navigateToLastScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // wrap screen in WillPopScreen widget
    return Scaffold(
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
                    image: profile,
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
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  // header text container
                  Container(
                      height: 200.0,
                      child: Image(
                        //
                        image: _contact.photoUrl == "empty"
                            ? profile
                            : NetworkImage(_contact.photoUrl),
                        fit: BoxFit.contain,
                      )),
                  //name
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.perm_identity),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              "${_contact.firstName} ${_contact.lastName}",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),
                  // phone
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.phone),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              _contact.phone,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),
                  // email
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.email),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              _contact.email,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),
                  // address
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.alternate_email),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              "@${_contact.twitter}",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),
                  // call and sms
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              iconSize: 30.0,
                              icon: Icon(Icons.phone),
                              color: Colors.red,
                              onPressed: () {
                                callAction(_contact.phone);
                              },
                            ),
                            IconButton(
                              iconSize: 30.0,
                              icon: Icon(Icons.message),
                              color: Colors.red,
                              onPressed: () {
                                smsAction(_contact.phone);
                              },
                            )
                          ],
                        )),
                  ),
                  // edit and delete
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              iconSize: 30.0,
                              icon: Icon(Icons.edit),
                              color: Colors.red,
                              onPressed: () {
                                navigateToEditScreen(id);
                              },
                            ),
                            IconButton(
                              iconSize: 30.0,
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                deleteContact();
                              },
                            )
                          ],
                        )),
                  )
                ],
              ),
      ),
    );
  }
}
