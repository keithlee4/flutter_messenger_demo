import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger/blocs/model/Contact.dart';

abstract class ContactsEvent extends Equatable {
  ContactsEvent({List props = const <dynamic>[]}) : super();
  @override
  List<Object> get props => [];
}

class FetchContactsEvent extends ContactsEvent {
  @override
  String toString() => 'FetchContactsEvent';
}

class AddContactEvent extends ContactsEvent {
  final String username;
  AddContactEvent({@required this.username});
  @override
  String toString() => 'AddContactEvent';
}

class ClickedContactEvent extends ContactsEvent {
  @override
  String toString() => 'ClickedContactEvent';
}

class ReceivedContactsEvent extends ContactsEvent {
  final List<Contact> contacts;
  ReceivedContactsEvent({@required this.contacts});
  @override
  String toString() => 'ReceivedContactsEvent';
}
