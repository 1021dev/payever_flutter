
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/contacts/models/model.dart';

import 'contact_detail.dart';

class ContactDetailScreenBloc extends Bloc<ContactDetailScreenEvent, ContactDetailScreenState> {
  final ContactScreenBloc contactScreenBloc;
  ContactDetailScreenBloc({this.contactScreenBloc});
  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  ContactDetailScreenState get initialState => ContactDetailScreenState();

  @override
  Stream<ContactDetailScreenState> mapEventToState(ContactDetailScreenEvent event) async* {
    if (event is ContactDetailScreenInitEvent) {
      yield state.copyWith(business: event.business);
      yield* getField(event.business);
    } else if (event is GetContactDetail) {
      yield state.copyWith(contact: event.contact);
    } else if (event is AddContactPhotoEvent) {
      yield* uploadContactPhoto(event.file, state.business);
    }
  }

  Stream<ContactDetailScreenState> getField(String businessId) async* {
    yield state.copyWith(isLoading: true);
    List<Field> fields = [];
    Map body = {
      'operationName': null,
      'query': '{\n  fields(filter: {or: [{businessId: {isNull: true}}]}) {\n    nodes {\n      id\n      businessId\n      name\n      type\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': businessId
      },
    };
    dynamic response = await api.getGraphql(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data is Map) {
        dynamic field = data['field'];
        if (field is Map) {
          dynamic nodes = field['nodes'];
          if (nodes is List) {
            nodes.forEach((element) {
              fields.add(Field.fromMap(element));
            });
          }
        }
      }
    }

    yield state.copyWith(isLoading: false, formFields: fields);
  }

  Stream<ContactDetailScreenState> getFieldData(String businessId) async* {
    yield state.copyWith(isLoading: true);
    Map body = {
      'operationName': null,
      'query': 'query (\$businessId: UUID!) {\n  fields(filter: {or: [{businessId: {equalTo: \$businessId}}]}) {\n    nodes {\n      id\n      businessId\n      name\n      type\n      defaultValues\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': businessId
      },
    };
    dynamic response = await api.getGraphql(token, body);
    yield state.copyWith(isLoading: false);
  }

  Stream<ContactDetailScreenState> uploadContactPhoto(File file, String businessId) async* {
    yield state.copyWith(uploadPhoto: true, blobName: '');
    dynamic response = await api.uploadImageToProducts(file, businessId, token);
    String blob = '';
    if (response != null) {
      blob = response['blobName'];
    }
    yield state.copyWith(uploadPhoto: false, blobName: blob);
  }


  Stream<ContactDetailScreenState> getContact(String id) async* {
    Contact contact;
    Map body = {
      'operationName': 'contact',
      'query': 'query contact(\$id: UUID!) {\n  contact(id: \$id) {\n    id\n    businessId\n    type\n    contactFields {\n      nodes {\n        id\n        value\n        fieldId\n        field {\n          id\n          name\n          defaultValues\n          type\n          __typename\n        }\n        __typename\n      }\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'id': id
      },
    };
    dynamic response = await api.getGraphql(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data is Map) {
        dynamic contactData = data['contact'];
        if (contactData is Map) {
          contact = Contact.fromMap(contactData);
        }
      }
    }
    yield state.copyWith(isLoading: false, contact: contact);
  }


}