
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/contacts/models/model.dart';
import 'package:uuid/uuid.dart';

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
      yield state.copyWith(business: event.business, contact: new Contact());
      yield* getField(event.business);
    } else if (event is GetContactDetail) {
      yield state.copyWith(contact: event.contact, business: event.business);
      yield* getField(event.business);
    } else if (event is AddContactPhotoEvent) {
      yield* uploadContactPhoto(event.file, state.business);
    } else if (event is CreateNewFieldEvent) {

    } else if (event is GetCustomField) {
      yield* getCustomField(event.business);
    }
  }

  Stream<ContactDetailScreenState> getField(String businessId) async* {
    yield state.copyWith(isLoading: true);
    List<Field> fields = [];
    Map<String, dynamic> body = {
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
    add(GetCustomField(business: businessId));
  }

  Stream<ContactDetailScreenState> getCustomField(String businessId) async* {
    yield state.copyWith(isLoading: true);
    Map<String, dynamic> body = {
      'operationName': null,
      'query': 'query (\$businessId: UUID!) {\n  fields(filter: {or: [{businessId: {equalTo: \$businessId}}]}) {\n    nodes {\n      id\n      businessId\n      name\n      type\n      defaultValues\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': businessId
      },
    };
    List<Field> fieldDatas = [];
    dynamic response = await api.getGraphql(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data is Map) {
        dynamic fields = data['fields'];
        if (fields is Map) {
          dynamic nodes = fields['nodes'];
          if (nodes is List) {
            nodes.forEach((element) {
              fieldDatas.add(Field.fromMap(element));
            });
          }
        }
      }
    }
    yield state.copyWith(isLoading: false, customFields: fieldDatas);
  }

  Stream<ContactDetailScreenState> uploadContactPhoto(File file, String businessId) async* {
    yield state.copyWith(uploadPhoto: true, blobName: '');
    dynamic response = await api.postImageToBusiness(file, businessId, token);
    String blob = '';
    if (response != null) {
      blob = response['blobName'];
    }
    Contact contact;
    contact = state.contact;
    List<ContactField> imageFields = state.contact.contactFields.nodes.where((element) {
      return element.field.name == 'imageUrl';
    }).toList();
    if (imageFields.length > 0) {
      int index = state.contact.contactFields.nodes.indexOf(imageFields.first);
      ContactField contactField = state.contact.contactFields.nodes[index];
      contactField.value = '${Env.storage}/images/$blob';
      contact.contactFields.nodes[index] = contactField;
    }
    yield state.copyWith(uploadPhoto: false, blobName: blob, contact: contact);
  }


  Stream<ContactDetailScreenState> getContact(String id) async* {
    Contact contact;
    Map<String, dynamic> body = {
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

  Stream<ContactDetailScreenState> createContact(String type) async* {
    Contact contact;
    String id = Uuid().v4();
    Map<String, dynamic> body = {
      'operationName': 'contact',
      'query': 'mutation (\$id: UUID!, \$businessId: UUID!, \$type: String!) {\n  createContact(input: {contact: {id: \$id, businessId: \$businessId, type: \$type}}) {\n    contact {\n      id\n      businessId\n      type\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': state.business,
        'id': id,
        'type': type,
      },
    };
    dynamic response = await api.getGraphql(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data is Map) {
        dynamic contactData = data['createContact'];
        if (contactData is Map) {
          contact = Contact.fromMap(contactData['contact']);
        }
      }
    }
    yield state.copyWith(isLoading: false,);
  }

  Stream<ContactDetailScreenState> createContactField(String contactId, String fieldId, String value) async* {
    ContactField contactField;
    String id = Uuid().v4();
    Map<String, dynamic> body = {
      'operationName': 'createContactField',
      'query': 'mutation createContactField(\$id: UUID!, \$businessId: UUID!, \$contactId: UUID!, \$fieldId: UUID!, \$value: String!) {\n  createContactField(input: {contactField: {id: \$id, businessId: \$businessId, contactId: \$contactId, fieldId: \$fieldId, value: \$value}}) {\n    contactField {\n      id\n      value\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': state.business,
        'contactId': contactId,
        'fieldId': fieldId,
        'id': id,
        'value': value,
      },
    };
    dynamic response = await api.getGraphql(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data is Map) {
        dynamic createContactField = data['createContactField'];
        if (createContactField is Map) {
          contactField = ContactField.fromMap(createContactField['contactField']);
        }
      }
    }
    yield state.copyWith(isLoading: false);
  }

  Stream<ContactDetailScreenState> createNewField(Field field) async* {
    String id = Uuid().v4();
    Map<String, dynamic> body = {
      'operationName': 'createField',
      'query': 'mutation createField(\$id: UUID!, \$businessId: UUID!, \$name: String!, \$type: String!, \$defaultValues: JSON) {\n  createField(input: {field: {id: \$id, defaultValues: \$defaultValues, businessId: \$businessId, name: \$name, type: \$type}}) {\n    field {\n      id\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': state.business,
        'defaultValues': null,
        'id': id,
        'name': field.name,
        'type': field.type,
      },
    };
    dynamic response = await api.getGraphql(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data is Map) {
      }
    }
    yield state.copyWith(isLoading: false);
  }
}