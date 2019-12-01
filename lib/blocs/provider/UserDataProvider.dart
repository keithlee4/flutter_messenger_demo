import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/blocs/model/User.dart';
import 'package:messenger/config/Paths.dart';

abstract class BaseUserDataProvider {
  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user);
  Future<User> saveProfileDetails(String uid, String profileImageUrl, int age, String username);
  Future<bool> isProfileComplete(String uid);
}

//UserDatProvider
class UserDataProvider extends BaseUserDataProvider {
  final Firestore fireStoreDb;
  UserDataProvider({Firestore fireStoreDb}): fireStoreDb = fireStoreDb ?? Firestore.instance;
  @override
  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user) async {
    DocumentReference ref = fireStoreDb.collection(Paths.usersPath).document(user.uid);
    final bool userExists = !(await ref.snapshots().isEmpty);
    var data = {
      'uid' : user.uid,
      'email' : user.email,
      'name' : user.displayName
    };

    if (!userExists) {
      //if user entry exists then we would not want to override the photo
      data['photoUrl'] = user.photoUrl;
    }

    ref.setData(data, merge: true);
    final DocumentSnapshot currentDocument = await ref.get();
    return User.fromFirestore(currentDocument);
  }

  @override
  Future<User> saveProfileDetails(String uid, String profileImageUrl, int age, String username) async {
    DocumentReference ref = fireStoreDb.collection(Paths.usersPath).document(uid);
    var data = {
      'photoUrl' : profileImageUrl,
      'age' : age,
      'username' : username
    };

    ref.setData(data, merge: true);
    final DocumentSnapshot currentDocument = await ref.get();
    return User.fromFirestore(currentDocument);
  }

  @override
  Future<bool> isProfileComplete(String uid) async {
    DocumentReference ref = fireStoreDb.collection(Paths.usersPath).document(uid);
    final DocumentSnapshot currentDocument = await ref.get();
    return  currentDocument != null &&
            currentDocument.exists && 
            currentDocument.data.containsKey('age') &&
            currentDocument.data.containsKey('username');
  }
}