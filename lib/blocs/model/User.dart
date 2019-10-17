import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid, documentId, name, username, photoUrl;
  int age;
  User({this.uid, this.documentId, this.name, this.username, this.age, this.photoUrl});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return User(
      uid: data['uid'], 
      documentId: doc.documentID, 
      name: data['name'], 
      username: data['username'], 
      age: data['age'], 
      photoUrl: data['photoUrl']
    );
  }

  @override
  String toString() {
    return '{ uid: $uid, documentId: $documentId, name: $name, username: $username, age: $age, photoUrl: $photoUrl}';
  }
}