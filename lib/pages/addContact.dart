import 'package:brosKeeper/models/contactModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _image;
  String fileName;
  final picker = ImagePicker();
  AssetImage profile = AssetImage("assets/images/logo.png");

  String _cUserName = "";
  String _cFirstName = "";
  String _cLastName = "";
  String _cPhone = "";
  String _cEmail = "";
  String _cAddress = "";
  String _cPhotoUrl = "empty";
  String _cTwitter = "";
  String _cStatus = "";

  saveContact(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        print(_cUserName);
        print(_cFirstName);
        print(_cLastName);
        print(_cPhone);
        print(_cEmail);
        print(_cAddress);
        print(_cTwitter);
        print(_cStatus);
        if (_cUserName.isNotEmpty &&
            _cFirstName.isNotEmpty &&
            _cLastName.isNotEmpty &&
            _cPhone.isNotEmpty &&
            _cEmail.isNotEmpty &&
            _cAddress.isNotEmpty &&
            _cTwitter.isNotEmpty &&
            _cStatus.isNotEmpty) {
          Contact contact = Contact(
              cUserName: _cUserName,
              cFirstName: _cFirstName,
              cLastName: _cLastName,
              cPhone: _cPhone,
              cEmail: _cEmail,
              cAddress: _cAddress,
              cPhotoUrl: _cPhotoUrl,
              cTwitter: _cTwitter,
              cStatus: _cStatus);

          await _databaseReference.push().set(contact.toJson());
          navigatToLastScreen(context);
        } else {
          print(_cUserName);
          print(_cFirstName);
          print(_cLastName);
          print(_cPhone);
          print(_cEmail);
          print(_cAddress);
          print(_cTwitter);
          print(_cStatus);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("field required"),
                content: Text("All fields are required"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("close"))
                ],
              );
            },
          );
        }
      } catch (e) {
        print(e.message);
      }
    }
  }

  Future<void> pickImage() async {
    // ignore: deprecated_member_use
    final file = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 100, maxWidth: 100);
    if (file == null) {
      return;
    }
    setState(() {
      _image = file;
      fileName = path.basename(file.path);
      print("FILE : " + file.toString());
      uploadImage(_image, fileName);
    });
  }

  // void pickImage() async {
  //   // File file = ImagePicker().getImage(source: ImageSource.gallery,maxHeight: 200, maxWidth: 200)
  //   final ImagePicker picker = ImagePicker();
  //   final PickedFile pickedFile = await picker.getImage(
  //       source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
  //   try {
  //     _image = File(pickedFile.path);
  //     String fileName = basename(_image.path);
  //     uploadImage(_image, fileName);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  uploadImage(File file, String fileName) async {
    StorageReference _storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    _storageReference.putFile(file).onComplete.then((value) async {
      var downloadUrl = await value.ref.getDownloadURL();
      setState(() {
        _cPhotoUrl = downloadUrl;
      });
    });
  }

  navigatToLastScreen(context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: InkWell(
                        onTap: () {
                          pickImage();
                        },
                        child: Center(
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: _cPhotoUrl == "empty"
                                      ? profile
                                      : NetworkImage(_cPhotoUrl),
                                )),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => _cUserName = input,
                        validator: (input) => input.length > 8
                            ? 'should be less than 8 characters'
                            : null,
                        decoration: InputDecoration(
                          labelText: 'User Name',
                          labelStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'your username',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.person,
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
                        onSaved: (input) => _cFirstName = input,
                        validator: (input) => input.length > 25
                            ? 'should be less than 25 characters'
                            : null,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'your first name',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.person,
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
                        onSaved: (input) => _cLastName = input,
                        validator: (input) => input.length > 25
                            ? 'should be less than 25 characters'
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'your last name',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.person,
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
                        onSaved: (input) => _cEmail = input,
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
                        keyboardType: TextInputType.phone,
                        onSaved: (input) => _cPhone = input,
                        validator: (input) => input.length > 12
                            ? 'Not A VALID PHONE NUMBER'
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'your phone number',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.phone,
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
                        keyboardType: TextInputType.streetAddress,
                        onSaved: (input) => _cAddress = input,
                        validator: (input) =>
                            input.length > 255 ? 'Address is to long' : null,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          labelStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'your addres',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.home,
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
                        onSaved: (input) => _cTwitter = input,
                        validator: (input) => input.length > 25
                            ? 'should be less than 25 characters'
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Twitter Handle',
                          labelStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'your twitter handle',
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
                        onSaved: (input) => _cStatus = input,
                        validator: (input) =>
                            !input.contains("red") ? 'input must be red' : null,
                        decoration: InputDecoration(
                          labelText: 'Enter Your Status',
                          labelStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText:
                              'red->danger, yellow->uncomfortable, green->Ok',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.stacked_line_chart,
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
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 10.0),
                      padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                      child: RaisedButton(
                        onPressed: () {
                          saveContact(context);
                        },
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text("Add Contact",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}
