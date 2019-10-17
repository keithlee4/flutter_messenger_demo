import 'dart:io';

import 'package:messenger/blocs/provider/Providers.dart';

class StorageRepository {
  BaseStorageProvider storageProvider = StorageProvider();
  Future<String> uploadImage(File profileImage, String path) => storageProvider.uploadImage(profileImage, path);
}