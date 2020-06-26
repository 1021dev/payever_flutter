import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';

import '../bloc.dart';

class PosScreenBloc extends Bloc<PosScreenEvent, PosScreenState> {
  PosScreenBloc();
  ApiService api = ApiService();

  @override
  PosScreenState get initialState => PosScreenState();

  @override
  Stream<PosScreenState> mapEventToState(PosScreenEvent event) async* {
    if (event is PosScreenInitEvent) {
      yield* fetchPos();
    }
  }

  Stream<PosScreenState> fetchPos() async* {
  }

}