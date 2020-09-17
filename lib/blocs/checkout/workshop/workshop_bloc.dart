
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';


class WorkshopScreenBloc extends Bloc<WorkshopScreenEvent, WorkshopScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;
  final GlobalStateModel globalStateModel;

  WorkshopScreenBloc({this.dashboardScreenBloc, this.globalStateModel});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  WorkshopScreenState get initialState => WorkshopScreenState();

  @override
  Stream<WorkshopScreenState> mapEventToState(
      WorkshopScreenEvent event) async* {
    if (event is WorkshopScreenInitEvent) {
      // if (event.business != null) {
      //   yield state.copyWith(
      //     business: event.business,
      //     checkouts: event.checkouts,
      //     defaultCheckout: event.defaultCheckout,
      //   );
      // } else {
      //
      // }
      // yield* fetchConnectInstallations(state.business, isLoading: true);
    } else if (event is PatchCheckoutFlowOrderEvent) {
      yield* patchCheckoutFlowOrder(event.body);
    }
  }

  Stream<WorkshopScreenState> patchCheckoutFlowOrder(Map body) async* {
    // yield state.copyWith(
    //   isUpdating: true,
    //   updatePayflowIndex: 0,
    // );
    // ChannelSetFlow channelSetFlow;
    // dynamic response = await api.patchCheckoutFlowOrder(
    //     token, state.channelSetFlow.id, 'en', body);
    // if (response is Map) {
    //   channelSetFlow = ChannelSetFlow.fromMap(response);
    // }
    // yield state.copyWith(
    //   isUpdating: false,
    //   updatePayflowIndex: -1,
    //   channelSetFlow: channelSetFlow,
    // );
  }

  Stream<WorkshopScreenState> patchCheckoutFlowAddress(Map body) async* {
  //   yield state.copyWith(
  //     isUpdating: true,
  //     updatePayflowIndex: 1,
  //   );
  //   ChannelSetFlow channelSetFlow;
  //   dynamic response = await api.patchCheckoutFlowAddress(
  //       token, state.channelSetFlow.id, '','en', body);
  //   if (response is Map) {
  //     channelSetFlow = ChannelSetFlow.fromMap(response);
  //   }
  //   yield state.copyWith(
  //     isUpdating: false,
  //     updatePayflowIndex: -1,
  //     channelSetFlow: channelSetFlow,
  //   );
  }
}