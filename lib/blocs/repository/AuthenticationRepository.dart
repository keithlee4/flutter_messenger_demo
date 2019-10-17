
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/blocs/provider/Providers.dart';

class AuthenticationRepository {
  BaseAuthenticationProvider authenticationProvider = AuthenticationProvider();
  Future<bool> isLoggedIn() => authenticationProvider.isLoggedIn();

  Future<FirebaseUser> getCurrentUser() => authenticationProvider.getCurrentUser();

  Future<FirebaseUser> signInWithGoogle() => authenticationProvider.signInWithGoogle();

  Future<void> signOutUser() => authenticationProvider.signOutUser();
}