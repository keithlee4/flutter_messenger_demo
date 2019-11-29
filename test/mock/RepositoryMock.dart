import 'package:messenger/blocs/repository/AuthenticationRepository.dart';
import 'package:messenger/blocs/repository/StorageRepository.dart';
import 'package:messenger/blocs/repository/UserDataRepository.dart';
import 'package:mockito/mockito.dart';

class AuthenticationRepositoryMock extends Mock implements AuthenticationRepository {}
class UserDataRepositoryMock extends Mock implements UserDataRepository {}
class StorageRepositoryMock extends Mock implements StorageRepository {}
