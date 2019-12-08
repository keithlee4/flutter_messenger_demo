import 'dart:async';
import 'package:messenger/blocs/contacts/Contacts.dart';
import 'package:bloc/bloc.dart';
import 'package:messenger/blocs/repository/UserDataRepository.dart';
import 'package:messenger/utils/Exceptions.dart';
class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  UserDataRepository userDataRepository;
  StreamSubscription subscription;
  ContactsBloc({this.userDataRepository}) : assert(userDataRepository != null);

  @override
  ContactsState get initialState => InitialContactsState();

  @override
  Stream<ContactsState> mapEventToState(ContactsEvent event) async* {
    if (event is FetchContactsEvent) {
      yield* mapFetchContactsEventToState();
    } else if (event is ReceivedContactsEvent) {
      print('Received');
      yield FetchedContactsState(event.contacts);
    } else if (event is AddContactEvent) {
      yield* mapAddContactEventToState(event.username);
    } else if (event is ClickedContactEvent) {
      yield* mapClickedContactEventToState();
    }
  }

  Stream<ContactsState> mapFetchContactsEventToState() async* {
    try {
      yield FetchingContactsState();
      subscription?.cancel();
      subscription = userDataRepository.getContacts().listen((contacts) {
        print('dispatching $contacts');
        mapEventToState(ReceivedContactsEvent(contacts: contacts));
      });
    } on MessioException catch(exception)  {
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<ContactsState> mapAddContactEventToState(String username) async* {
    try {
      yield AddContactProgressState();
      await userDataRepository.addContact(username);
      yield AddContactSuccessState();
    } on MessioException catch(exception) {
      print(exception.errorMessage());
      yield AddContactFailedState(exception);
    }
  }

  Stream<ContactsState> mapClickedContactEventToState() async * {
    //TODO: Redirect to chat screen
  }
  
  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}