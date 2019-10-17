import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/blocs/model/User.dart';
import 'package:messenger/blocs/provider/Providers.dart';

class UserDataRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider();
  Future<bool> isProfileComplete(String uid) => userDataProvider.isProfileComplete(uid);

  Future<User> saveDetailsFromGoogleAuth(FirebaseUser firebaseUser) => userDataProvider.saveDetailsFromGoogleAuth(firebaseUser);

  Future<User> saveProfileDetails(String uid, String profilePictureUrl, int age, String username) 
          => userDataProvider.saveProfileDetails(uid, profilePictureUrl, age, username);
}