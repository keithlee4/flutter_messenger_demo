
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuthenticationProvider {
  Future<FirebaseUser> signInWithGoogle();
  Future<void> signOutUser();
  Future<FirebaseUser> getCurrentUser();
  Future<bool> isLoggedIn();
}

//AuthenticationProvider
class AuthenticationProvider extends BaseAuthenticationProvider {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthenticationProvider({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn}):
    firebaseAuth = firebaseAuth ?? FirebaseAuth.instance, googleSignIn = googleSignIn ?? GoogleSignIn();
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