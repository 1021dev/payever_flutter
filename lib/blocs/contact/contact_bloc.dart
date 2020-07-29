import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';

import 'contact.dart';

class ContactScreenBloc extends Bloc<ContactScreenEvent, ContactScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;

  ContactScreenBloc({this.dashboardScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  ContactScreenState get initialState => ContactScreenState();

  @override
  Stream<ContactScreenState> mapEventToState(ContactScreenEvent event) async* {
    if (event is ContactScreenInitEvent) {
      yield state.copyWith(business: event.business);
      yield* fetchContactInstallations(event.business);
    }
  }

  Stream<ContactScreenState> fetchContactInstallations(String business) async* {
  }

}