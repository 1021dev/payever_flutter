import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/switcher/switcher_event.dart';
import 'package:payever/blocs/switcher/switcher_state.dart';
import 'package:payever/commons/utils/env.dart';

class SwitcherScreenBloc extends Bloc<SwitcherScreenEvent, SwitcherScreenState> {
  SwitcherScreenBloc();

  ApiService api = ApiService();
  String uiKit = '${Env.commerceOs}/assets/ui-kit/icons-png/';

  @override
  SwitcherScreenState get initialState => SwitcherScreenState();

  @override
  Stream<SwitcherScreenState> mapEventToState(
      SwitcherScreenEvent event) async* {
    if (event is SwitcherScreenInitialEvent) {
      yield* fetchBusiness();
    }
  }

  Stream<SwitcherScreenState> fetchBusiness() async* {

    yield state.copyWith(isLoading: true);

  }
}