import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/welcome/welcome_event.dart';
import 'package:payever/blocs/welcome/welcome_state.dart';
import 'package:payever/commons/utils/env.dart';

class WelcomeScreenBloc extends Bloc<WelcomeScreenEvent, WelcomeScreenState> {
  WelcomeScreenBloc();

  ApiService api = ApiService();
  String uiKit = '${Env.commerceOs}/assets/ui-kit/icons-png/';

  @override
  WelcomeScreenState get initialState => WelcomeScreenState();

  @override
  Stream<WelcomeScreenState> mapEventToState(WelcomeScreenEvent event) async* {
    if (event is ToggleEvent) {
      yield* toggleStatus(event.type, event.businessId);
    }
  }

  Stream<WelcomeScreenState> toggleStatus(String type, String businessId) async* {
  }
}