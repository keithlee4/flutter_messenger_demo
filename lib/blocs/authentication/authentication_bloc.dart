import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/blocs/model/User.dart';
import 'package:messenger/blocs/repository/AuthenticationRepository.dart';
import 'package:messenger/blocs/repository/StorageRepository.dart';
import 'package:messenger/blocs/repository/UserDataRepository.dart';
import 'package:messenger/config/Paths.dart';
import './bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;

  AuthenticationBloc({
    this.authenticationRepository,
    this.userDataRepository,
    this.storageRepository})
    : assert(authenticationRepository != null),
      assert(userDataRepository != null),
      assert(storageRepository != null);

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    print(event);
    switch (event.runtimeType) {
      case AppLaunched: {
        yield* mapAppLaunchedToState();
      }
      break;
      case ClickedGoogleLogin: {
        yield* mapClickedGoogleLoginToState();
      }
      break;
      case LoggedIn: {
        yield* mapLoggedInToState((event as LoggedIn).user);
      }
      break;
      case PickedProfilePicture: {
        yield ReceivedProfilePicture((event as PickedProfilePicture).file);
      }
      break;
      case SaveProfile: {
        SaveProfile state = event;
        yield* mapSaveProfileToState(state.profileImage, state.age, state.username);
      }
      break;
      case ClickedLogout: {
        yield* mapLoggedOutToState();
      }
      break;
    }
  }

  Stream<AuthenticationState> mapAppLaunchedToState() async* {
    try {
      yield AuthInProgress();
      final isSignedIn = await authenticationRepository.isLoggedIn();
      if (isSignedIn) {
        final user = await authenticationRepository.getCurrentUser();
        bool isProfileComplete = await userDataRepository.isProfileComplete();
        if (isProfileComplete) {
          yield ProfileUpdated();
        }else {
          yield Authenticated(user);
          add(LoggedIn(user));
        }
      }else {
        yield UnAuthenticated();
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      yield UnAuthenticated();
    }
  }

  Stream<AuthenticationState> mapClickedGoogleLoginToState() async* {
    yield AuthInProgress();
    try {
      //Might raise some exception while logging in
      FirebaseUser firebaseUser = await authenticationRepository.signInWithGoogle();
      bool isProfileComplete = await userDataRepository.isProfileComplete();
      print(isProfileComplete);
      if (isProfileComplete) {
        yield ProfileUpdated();
      }else {
        yield Authenticated(firebaseUser);
        add(LoggedIn(firebaseUser));
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      yield UnAuthenticated();
    }
  }

  Stream<AuthenticationState> mapLoggedInToState(FirebaseUser firebaseUser) async* {
    yield ProfileUpdateInProgress();
    User user = await userDataRepository.saveDetailsFromGoogleAuth(firebaseUser);
    yield PreFillData(user);
  }

  Stream<AuthenticationState> mapSaveProfileToState(File profileImage, int age, String username) async* {
    yield ProfileUpdateInProgress();
    String profilePictureUrl = await storageRepository.uploadImage(profileImage, Paths.profilePicturePath);
    // FirebaseUser user = await authenticationRepository.getCurrentUser();
    await userDataRepository.saveProfileDetails(profilePictureUrl, age, username);
    yield ProfileUpdated();
  }

  Stream<AuthenticationState> mapLoggedOutToState() async* {
    yield UnAuthenticated();
    authenticationRepository.signOutUser();
  }
}
