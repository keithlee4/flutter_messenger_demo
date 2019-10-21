import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messenger/blocs/model/User.dart';
import 'package:messenger/config/Paths.dart';

abstract class BaseAuthenticationProvider {
  Future<FirebaseUser> signInWithGoogle();
  Future<void> signOutUser();
  Future<FirebaseUser> getCurrentUser();
  Future<bool> isLoggedIn();
}

abstract class BaseUserDataProvider {
  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user);
  Future<User> saveProfileDetails(String uid, String profileImageUrl, int age, String username);
  Future<bool> isProfileComplete(String uid);
}

abstract class BaseStorageProvider {
  Future<String> uploadImage(File file, String path);
}

//AuthenticationProvider
class AuthenticationProvider extends BaseAuthenticationProvider {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  AuthenticationProvider({this.firebaseAuth, this.googleSignIn});
  @override
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount account = await googleSignIn.signIn();
    final GoogleSignInAuthentication authentication = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken
    );

    await firebaseAuth.signInWithCredential(credential);
    return firebaseAuth.currentUser();
  }

  @override
  Future<void> signOutUser() async {
    return Future.wait([firebaseAuth.signOut(), googleSignIn.signOut()]);
  }

  @override
  Future<FirebaseUser> getCurrentUser() async {
    return firebaseAuth.currentUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await firebaseAuth.currentUser();
    return user != null;
  }
}

//UserDatProvider
class UserDataProvider extends BaseUserDataProvider {
  Firestore fireStoreDb = Firestore.instance;
  UserDataProvider({this.fireStoreDb});
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

//StorageProvider
class StorageProvider extends BaseStorageProvider {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  StorageProvider({this.firebaseStorage});
  @override
  Future<String> uploadImage(File file, String path) async {
    StorageReference reference = firebaseStorage.ref().child(path);
    StorageUploadTask uploadTask = reference.putFile(file);
    StorageTaskSnapshot result = await uploadTask.onComplete;
    String url = await result.ref.getDownloadURL();
    print(url);
    return url;
  }
}