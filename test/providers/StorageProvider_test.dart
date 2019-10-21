import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/blocs/provider/Providers.dart';
import 'package:mockito/mockito.dart';

import '../mock/FirebaseMock.dart';
import '../mock/IOMock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('StorageProvider', () {
    FirebaseStorageMock firebaseStorage = FirebaseStorageMock();
    StorageReferenceMock storageReference = StorageReferenceMock();
    StorageReferenceMock rootReference = StorageReferenceMock(childReference: storageReference);
    StorageReferenceMock fileReference = StorageReferenceMock();
    StorageUplooadTaskMock storageUploadTask = StorageUplooadTaskMock();
    StorageTaskSnapshotMock storageTaskSnapshot = StorageTaskSnapshotMock();
    String resultUrl = 'http://www.adityag.me';
    StorageProvider storageProvider = StorageProvider(firebaseStorage: firebaseStorage);

    test('Testing if uploadimage reutrns a url', () async {
      when(firebaseStorage.ref()).thenReturn(rootReference);
      when(storageReference.putFile(any)).thenReturn(storageUploadTask);
      when(storageUploadTask.onComplete).thenAnswer(
        (_) => Future<StorageTaskSnapshotMock>.value(storageTaskSnapshot)
      );
      when(storageTaskSnapshot.ref).thenReturn(fileReference);
      when(fileReference.getDownloadURL()).thenAnswer((_) => Future<String>.value(resultUrl));

      expect(await storageProvider.uploadImage(MockFile(), ''), resultUrl);
    });
  });
}