import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/blocs/authentication/bloc.dart';
import 'package:messenger/blocs/model/User.dart';

import '../mock/IOMock.dart';
import '../mock/RepositoryMock.dart';
import '../mock/FirebaseMock.dart';
import 'package:mockito/mockito.dart';
void main() {
  AuthenticationBloc authenticationBloc;

  AuthenticationRepositoryMock authenticationRepository;
  UserDataRepositoryMock userDataRepository;
  StorageRepositoryMock storageRepository;

  FirebaseUserMock firebaseUser;
  User user;
  MockFile file;
  int age;
  String username;
  String profilePictureUrl;

  setUp(() {
    userDataRepository = UserDataRepositoryMock();
    authenticationRepository = AuthenticationRepositoryMock();
    storageRepository = StorageRepositoryMock();
    firebaseUser = FirebaseUserMock();
    user = User();
    file = MockFile();
    age = 23;
    username = 'keith';
    profilePictureUrl = 'http://www.github.com/adityadroid';
    authenticationBloc = AuthenticationBloc(
      userDataRepository: userDataRepository,
      authenticationRepository: authenticationRepository,
      storageRepository: storageRepository
    );
  });

  test('initial state is always Uninitialized', () {
    expect(authenticationBloc.initialState, Uninitialized());
  });

  group('AppLaunched', (){
    test('emits [Uninitialized -> Unauthenticated] when not logged in', () {
      when(authenticationRepository.isLoggedIn())
        .thenAnswer((_) => Future.value(false));

      final expectedStates = [
        Uninitialized(),
        AuthInProgress(),
        UnAuthenticated()
      ];

      expectLater(authenticationBloc, emitsInOrder(expectedStates));
      authenticationBloc.add(AppLaunched());
    });

    test('emits [Uninitialized -> ProfileUpdated] when user is logged in and profile is completed', (){
      when(authenticationRepository.isLoggedIn()).thenAnswer((_) => Future.value(true));
      when(authenticationRepository.getCurrentUser()).thenAnswer((_) => Future.value(FirebaseUserMock()));
      when(userDataRepository.isProfileComplete()).thenAnswer((_) => Future.value(true));
      final expectedStates = [
        Uninitialized(),
        AuthInProgress(),
        ProfileUpdated()
      ];

      expectLater(authenticationBloc, emitsInOrder(expectedStates));
      authenticationBloc.add(AppLaunched());
    });

    test(
      'emits [Uninitialzed -> AuthInProgress -> Authenticated -> ProfileUpdateInProgress -> PrefillData] when user is logged in and profile is not complete',
      (){
        when(authenticationRepository.isLoggedIn()).thenAnswer((_) => Future.value(true));
        when(authenticationRepository.getCurrentUser()).thenAnswer((_) => Future.value((firebaseUser)));
        when(userDataRepository.isProfileComplete()).thenAnswer((_) => Future.value(false));
        final expectedStates = [
          Uninitialized(),
          AuthInProgress(),
          Authenticated(firebaseUser),
          ProfileUpdateInProgress(),
          PreFillData(user)
        ];

        expectLater(authenticationBloc, emitsInOrder(expectedStates));
        authenticationBloc.add(AppLaunched());
      }
    );

    group('ClickedGoogleLogin', (){
      test(
        'emits [AuthInProgress -> ProfileUpdated] when the user clicks Google Login button and after login result, the profile is complete', 
        (){
          when(authenticationRepository.signInWithGoogle()).thenAnswer((_) => Future.value(firebaseUser));
          when(userDataRepository.isProfileComplete()).thenAnswer((_) => Future.value(true));
          final expectedStates = [
            Uninitialized(),
            AuthInProgress(),
            ProfileUpdated()
          ];

          expectLater(authenticationBloc, emitsInOrder(expectedStates));
          authenticationBloc.add(ClickedGoogleLogin());
        }
      );

      test('emits [AuthInProgress -> Authenticated -> ProfileUpdateInProgress -> PreFillData] when ther iser clicks Google Login button and after login result, the profile is found to be incomplete', 
        () {
          when(authenticationRepository.signInWithGoogle()).thenAnswer((_) => Future.value(firebaseUser));
          when(userDataRepository.isProfileComplete()).thenAnswer((_) => Future.value(false));
          final expectedStates = [
            Uninitialized(),
            AuthInProgress(),
            Authenticated(firebaseUser),
            ProfileUpdateInProgress(),
            PreFillData(user)
          ];

          expectLater(authenticationBloc, emitsInOrder(expectedStates));
          authenticationBloc.add(ClickedGoogleLogin());
        }
      );
    });

    group('LoggedIn', () {
      test('emits [ProfileUpdateInProgress -> PreFillData] when trigged, this event is trigged once gauth is done and profile is not complete', 
        () {
          when(userDataRepository.saveDetailsFromGoogleAuth(firebaseUser)).thenAnswer((_) => Future.value(user));
          final expectedStates = [
            Uninitialized(),
            ProfileUpdateInProgress(),
            PreFillData(user)
          ];
          expectLater(authenticationBloc, emitsInOrder(expectedStates));
          authenticationBloc.add(LoggedIn(firebaseUser));
        }
      );
    });

    group('PickedProfilePicture', () {
      test('emits [ReceivedProfilePicture] everytime', () {
        final expectedStates = [Uninitialized(), ReceivedProfilePicture(file)];
        expectLater(authenticationBloc, emitsInOrder(expectedStates));
        authenticationBloc.add(PickedProfilePicture(file));
      });
    });

    group('SaveProfile', () {
      test('emits [ProfileUpdateInProgress -> ProfileUpdated] everytime SaveProfile is dispatched', () {
        when(storageRepository.uploadImage(any, any)).thenAnswer((_) => Future.value(profilePictureUrl));
        when(authenticationRepository.getCurrentUser()).thenAnswer((_) => Future.value(firebaseUser));
        when(userDataRepository.saveProfileDetails(any, any, any)).thenAnswer((_) => Future.value(user));
        final expectedStates = [
          Uninitialized(),
          ProfileUpdateInProgress(),
          ProfileUpdated()
        ];

        expectLater(authenticationBloc, emitsInOrder(expectedStates));
        authenticationBloc.add(SaveProfile(file, age, username));
      });
    });

    group('ClickedLogout', () {
      test('emits [UnAuthenticated] when clicked logout', (){
        final expectedStates = [
          Uninitialized(),
          UnAuthenticated()
        ];
        expectLater(authenticationBloc, emitsInOrder(expectedStates));
        authenticationBloc.add(ClickedLogout());
      });
    });
  });
}