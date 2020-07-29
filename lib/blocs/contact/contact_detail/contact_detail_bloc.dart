
import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';

import 'contact_detail.dart';

class ContactDetailScreenBloc extends Bloc<ContactDetailScreenEvent, ContactDetailScreenState> {
  final ContactScreenBloc connectScreenBloc;
  ContactDetailScreenBloc({this.connectScreenBloc});
  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  ContactDetailScreenState get initialState => ContactDetailScreenState();

  @override
  Stream<ContactDetailScreenState> mapEventToState(ContactDetailScreenEvent event) async* {
    if (event is ContactDetailScreenInitEvent) {
    }
  }

  Stream<ContactDetailScreenState> getCategoryDetails() async* {
  }

}