import 'package:firebase_database/firebase_database.dart';

class Contact {
  String cId;
  String cUserName;
  String cFirstName;
  String cLastName;
  String cPhone;
  String cEmail;
  String cAddress;
  String cPhotoUrl;
  String cTwitter;
  String cStatus;

  // constructor for Add
  Contact(
      {this.cUserName,
      this.cFirstName,
      this.cLastName,
      this.cPhone,
      this.cEmail,
      this.cAddress,
      this.cPhotoUrl,
      this.cTwitter,
      this.cStatus});

  // constructor for Edit
  Contact.withId(
      {this.cId,
      this.cUserName,
      this.cFirstName,
      this.cLastName,
      this.cPhone,
      this.cEmail,
      this.cAddress,
      this.cPhotoUrl,
      this.cTwitter,
      this.cStatus});

  //getters
  String get id => this.cId;
  String get userName => this.cUserName;
  String get firstName => this.cFirstName;
  String get lastName => this.cLastName;
  String get phone => this.cPhone;
  String get email => this.cEmail;
  String get adress => this.cAddress;
  String get photoUrl => this.cPhotoUrl;
  String get twitter => this.cTwitter;
  String get status => this.cStatus;
  //setters

  set userName(String userName) {
    this.cUserName = userName;
  }

  set firstName(String firstName) {
    this.cFirstName = firstName;
  }

  set lastName(String lastName) {
    this.cLastName = lastName;
  }

  set phone(String phone) {
    this.cPhone = phone;
  }

  set email(String email) {
    this.cEmail = email;
  }

  set adress(String adress) {
    this.cAddress = adress;
  }

  set photoUrl(String photoUrl) {
    this.cPhotoUrl = photoUrl;
  }

  set twitter(String twitter) {
    this.cTwitter = twitter;
  }

  set status(String status) {
    this.cStatus = status;
  }

  Contact.fromSnapShot(DataSnapshot snapshot) {
    this.cId = snapshot.key;
    this.cUserName = snapshot.value['username'];
    this.cFirstName = snapshot.value['firstName'];
    this.cLastName = snapshot.value['lastName'];
    this.cPhone = snapshot.value['phone'];
    this.cEmail = snapshot.value['email'];
    this.cAddress = snapshot.value['address'];
    this.cPhotoUrl = snapshot.value['photoUrl'];
    this.cTwitter = snapshot.value['twitter'];
    this.cStatus = snapshot.value['status'];
  }

  Map<String, dynamic> toJson() => {
        "userName": cUserName,
        "firstName": cFirstName,
        "lastName": cLastName,
        "phone": cPhone,
        "email": cEmail,
        "address": cAddress,
        "photoUrl": cPhotoUrl,
        "twitter": cTwitter,
        "status": cStatus,
      };
}
