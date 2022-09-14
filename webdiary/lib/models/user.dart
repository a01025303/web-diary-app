import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;

  UserModel({this.uid, this.email, this.firstName, this.lastName});

  // Receive data from server
  factory UserModel.fromMap(map) {
    return (UserModel(
      email: map['email'],
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
    ));
  }

  // Send data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName
    };
  }
}
