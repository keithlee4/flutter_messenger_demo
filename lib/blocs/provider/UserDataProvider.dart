import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/blocs/model/Contact.dart';
import 'package:messenger/blocs/model/User.dart';
import 'package:messenger/config/Constants.dart';
import 'package:messenger/config/Paths.dart';
import 'package:messenger/utils/Exceptions.dart';
import 'package:messenger/utils/SharedObjects.dart';

abstract class BaseUserDataProvider {
  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user);
  Future<User> saveProfileDetails(
      String profileImageUrl, int age, String username);
  Future<bool> isProfileComplete();
  Stream<List<Contact>> getContacts();
  Future<void> addContact(String username);
  Future<User> getUser(String username);
  Future<String> getUidByUsername(String username);
}

//UserDatProvider
class UserDataProvider extends BaseUserDataProvider {
  final Firestore fireStoreDb;
  UserDataProvider({Firestore fireStoreDb})
      : fireStoreDb = fireStoreDb ?? Firestore.instance;
  @override
  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user) async {
    DocumentReference ref =
        fireStoreDb.collection(Paths.usersPath).document(user.uid);
    final bool userExists = !(await ref.snapshots().isEmpty);
    var data = {'uid': user.uid, 'email': user.email, 'name': user.displayName};

    if (!userExists) {
      //if user entry exists then we would not want to override the photo
      data['photoUrl'] = user.photoUrl;
    }

    ref.setData(data, merge: true);
    final DocumentSnapshot currentDocument = await ref.get();
    return User.fromFirestore(currentDocument);
  }

  @override
  Future<User> saveProfileDetails(
      String profileImageUrl, int age, String username) async {
    String uid = SharedObjects.prefs.get(Constants.sessionUid);
    DocumentReference mapReference =
        fireStoreDb.collection(Paths.usersPath).document(username);
    var mapData = {'uid': uid};
    mapReference.setData(mapData);

    DocumentReference ref =
        fireStoreDb.collection(Paths.usersPath).document(uid);
    var data = {'photoUrl': profileImageUrl, 'age': age, 'username': username};

    ref.setData(data, merge: true);
    final DocumentSnapshot currentDocument = await ref.get();
    return User.fromFirestore(currentDocument);
  }

  @override
  Future<bool> isProfileComplete() async {
    DocumentReference ref = fireStoreDb
        .collection(Paths.usersPath)
        .document(SharedObjects.prefs.get(Constants.sessionUid));
    final DocumentSnapshot currentDocument = await ref.get();
    return currentDocument != null &&
        currentDocument.exists &&
        currentDocument.data.containsKey('age') &&
        currentDocument.data.containsKey('username');
  }

  @override
  Stream<List<Contact>> getContacts() {
    CollectionReference userRef = fireStoreDb.collection(Paths.usersPath);
    DocumentReference ref =
        userRef.document(SharedObjects.prefs.get(Constants.sessionUid));
    return ref.snapshots().transform(
        StreamTransformer<DocumentSnapshot, List<Contact>>.fromHandlers(
            handleData: (documentSnapshot, sink) async {
      List<String> contacts;
      if (documentSnapshot.data['contacts'] == null) {
        ref.updateData({'contacts': []});
        contacts = List();
      } else {
        contacts = List.from(documentSnapshot.data['contacts']);
      }

      List<Contact> contactList = List();
      for (String username in contacts) {
        print(username);
        String uid = await getUidByUsername(username);
        DocumentSnapshot contactSnapshot = await userRef.document(uid).get();
        Contact contact = Contact.fromFirestore(contactSnapshot);
        contactList.add(contact);
      }

      sink.add(contactList);
    }));
  }

  @override
  Future<void> addContact(String username) async {
    //Only to make sure the user exists;
    await getUser(username);
    DocumentReference ref = fireStoreDb
        .collection(Paths.usersPath)
        .document(SharedObjects.prefs.get(Constants.sessionUid));

    DocumentSnapshot documentSnapshot = await ref.get();
    var contactsDataFromSnapshot = documentSnapshot.data['contacts'];
    List<String> contacts = contactsDataFromSnapshot != null
        ? List.from(contactsDataFromSnapshot)
        : List();

    if (contacts.contains(username)) {
      throw ContactAlreadyExistsException();
    } else {
      contacts.add(username);
      ref.updateData({'contacts': contacts});
    }
  }

  @override
  Future<User> getUser(String username) async {
    String uid = await getUidByUsername(username);
    DocumentReference ref =
        fireStoreDb.collection(Paths.usersPath).document(uid);
    DocumentSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      return User.fromFirestore(snapshot);
    } else {
      throw UserNotFoundException();
    }
  }

  @override
  Future<String> getUidByUsername(String username) async {
    DocumentReference ref =
        fireStoreDb.collection(Paths.usernameUidMapPath).document(username);
    DocumentSnapshot documentSnapshot = await ref.get();
    if (documentSnapshot != null &&
        documentSnapshot.exists &&
        documentSnapshot.data['uid'] != null) {
      return documentSnapshot.data['uid'];
    } else {
      throw UsernameMappingUndefinedException();
    }
  }
}
