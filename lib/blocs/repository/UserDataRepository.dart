import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/blocs/model/Contact.dart';
import 'package:messenger/blocs/model/User.dart';
import 'package:messenger/blocs/provider/Providers.dart';

class UserDataRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider();
  Future<bool> isProfileComplete() => userDataProvider.isProfileComplete();

  Future<User> saveDetailsFromGoogleAuth(FirebaseUser firebaseUser) => userDataProvider.saveDetailsFromGoogleAuth(firebaseUser);

  Future<User> saveProfileDetails(String profilePictureUrl, int age, String username) 
          => userDataProvider.saveProfileDetails(profilePictureUrl, age, username);

  Stream<List<Contact>> getContacts() => userDataProvider.getContacts();
  Future<void> addContact(String username) => userDataProvider.addContact(username);
  Future<User> getUser(String username) => userDataProvider.getUser(username);
  Future<String> getUidByUsername(String username) => userDataProvider.getUidByUsername(username);
}