
import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/connect/models/connect.dart';

import 'connect_detail.dart';

class ConnectDetailScreenBloc extends Bloc<ConnectDetailScreenEvent, ConnectDetailScreenState> {
  final ConnectScreenBloc connectScreenBloc;
  ConnectDetailScreenBloc({this.connectScreenBloc});
  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  ConnectDetailScreenState get initialState => ConnectDetailScreenState();

  @override
  Stream<ConnectDetailScreenState> mapEventToState(ConnectDetailScreenEvent event) async* {
    if (event is ConnectDetailScreenInitEvent) {
      yield state.copyWith(business: event.business, editConnect: event.connectModel.integration);
      yield* getConnectDetail(event.business);
    } else if (event is AddReviewEvent) {
      yield* addReview(event.title, event.text, event.rate);
    }
  }

  Stream<ConnectDetailScreenState> getCategoryDetails(ConnectIntegration integration) async* {
    yield state.copyWith(categoryConnects: []);
    List<ConnectModel> connectInstallations = [];
    dynamic categoryResponse = await api.getConnectIntegrationByCategory(token, state.business, integration.category);
    if (categoryResponse is List) {
      categoryResponse.forEach((element) {
        ConnectModel cm = ConnectModel.toMap(element);
        if (cm.integration.id != integration.id) {
          connectInstallations.add(cm);
        }
      });
    }

    yield state.copyWith(categoryConnects: connectInstallations);
  }

  Stream<ConnectDetailScreenState> addReview(String title, String text, num rate) async* {
    if (title != null) {
      dynamic response = await api.patchConnectRating(token, state.editConnect.name, rate);
    } else {
      dynamic response = await api.patchConnectWriteReview(token, state.editConnect.name, title, text, rate);
    }
    yield state.copyWith(isReview: true);
    getConnectDetail(state.editConnect.name);
    yield state.copyWith(isReview: false);
  }

  Stream<ConnectDetailScreenState> getConnectDetail(String name) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.getConnectDetail(token, name);
    ConnectIntegration model = ConnectIntegration.toMap(response);
    yield state.copyWith(isLoading: false, editConnect: model);
    getCategoryDetails(state.editConnect);
  }
}