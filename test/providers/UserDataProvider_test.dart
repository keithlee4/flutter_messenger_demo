import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/blocs/model/User.dart';
import 'package:messenger/blocs/provider/Providers.dart';
import 'package:mockito/mockito.dart';

import '../mock/FirebaseMock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('UserDataProvider', () {
    FireStoreMock fireStore = FireStoreMock();
    UserDataProvider userDataProvider = UserDataProvider(fireStoreDb: fireStore);
    CollectionReferenceMock collectionReference = CollectionReferenceMock();
    DocumentSnapshotMock documentSnapshot = DocumentSnapshotMock();
    DocumentReferenceMock documentReference = DocumentReferenceMock();

    test('saveDetailsFromGoogleAuth returns a user with the details from FirebaseUser Object passed', () async {
      when(fireStore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.document(any)).thenReturn(documentReference);
      expect(await documentReference.snapshots().isEmpty, true);
      User user = await userDataProvider.saveDetailsFromGoogleAuth(FirebaseUserMock());
      expect(await documentReference.snapshots().isEmpty, false);
      documentSnapshot = await documentReference.get();
      expect(documentSnapshot.data['uid'], 'uid'); //checking if the data from the passed FirebaseUser object is returned in User
      expect(user.name, 'John Doe');
      expect(user.photoUrl, 'http://www.adityag.me');
    });

    test('saveDetailsFromGoogleAuth if there is not existing image write the image from the firebase user', () async {
      documentReference = DocumentReferenceMock();
      when(fireStore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.document(any)).thenReturn(documentReference);
      expect(await documentReference.snapshots().isEmpty, true);
      User user = await userDataProvider.saveDetailsFromGoogleAuth(FirebaseUserMock());
      expect(user.name, 'John Doe');
      expect(user.photoUrl, 'http://www.adityag.me'); //image from FIrebaseUser object is written;
    });

    test('saveDetailsFromGoogleAuth if there is existing iamge, do not write the image from firebase user', () async {
      documentSnapshot.data['photoUrl'] = 'http://www.google.com'; //create a snapshot first to mock existing user
      documentReference = DocumentReferenceMock(documentSnapshotMock: documentSnapshot);
      when(fireStore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.document(any)).thenReturn(documentReference);
      expect(await documentReference.snapshots().isEmpty, false); //snapshots are not empty because existing user
      User user = await userDataProvider.saveDetailsFromGoogleAuth(FirebaseUserMock());
      expect(await documentReference.snapshots().isEmpty, false);
      expect(user.name, 'John Doe');
      expect(user.photoUrl, 'http://www.google.com'); //for existing user the iamge is not overwritten.
    });

    test('saveProfileDetails saves the details', () async {
      documentReference = DocumentReferenceMock();
      when(fireStore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.document(any)).thenReturn(documentReference);
      expect(await documentReference.snapshots().isEmpty, true);
      User user = await userDataProvider.saveProfileDetails('uid', 'http://www.github.com', 18, 'keithlee4');
      expect(await documentReference.snapshots().isEmpty, false);
      expect(user.age, 18);
      expect(user.username, 'keithlee4');
      expect(user.photoUrl, 'http://www.github.com');
    });

    test('isProfileComplete works properly', () async {
      //set profile data, shuold return profile complete
      documentReference = DocumentReferenceMock(documentSnapshotMock: documentSnapshot);
      documentReference.setData({'username':'keithlee4','age':18});
      when(fireStore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.document(any)).thenReturn(documentReference);
      when(documentSnapshot.exists).thenReturn(true);
      expect(await documentReference.snapshots().isEmpty, false);
      expect(await userDataProvider.isProfileComplete('uid'), true);

      //clear profile data, shuodl return false now
      documentReference = DocumentReferenceMock();
      when(fireStore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.document(any)).thenReturn(documentReference);
      when(documentSnapshot.exists).thenReturn(true);
      expect(await documentReference.snapshots().isEmpty, true);
      expect(await userDataProvider.isProfileComplete('uid'), false);
    });
  });
}