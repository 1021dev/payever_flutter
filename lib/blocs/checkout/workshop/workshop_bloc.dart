import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';

class WorkshopScreenBloc extends Bloc<WorkshopScreenEvent, WorkshopScreenState> {
  final CheckoutScreenBloc checkoutScreenBloc;

  WorkshopScreenBloc({this.checkoutScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  WorkshopScreenState get initialState => WorkshopScreenState();

  @override
  Stream<WorkshopScreenState> mapEventToState(
      WorkshopScreenEvent event) async* {
    if (event is WorkshopScreenInitEvent) {
      if (event.business != null) {
        yield state.copyWith(
          business: event.business,
          channelSetFlow: event.channelSetFlow,
          checkoutFlow: event.checkoutFlow,
          defaultCheckout: event.defaultCheckout,
        );
      }
      print('channelSetFlow :${state.channelSetFlow.billingAddress.id}');
    } else if (event is PatchCheckoutFlowOrderEvent) {
      yield* patchCheckoutFlowOrder(event.body);
    } else if (event is PatchCheckoutFlowAddressEvent) {
      yield* patchCheckoutFlowAddress(event.body);
    } else if (event is PayWireTransferEvent) {
      yield* checkoutPayWireTransfer();
    } else if (event is PayInstantPaymentEvent) {
      yield* checkoutPayInstantPayment();
    } else if (event is EmailValidationEvent) {
      yield* emailValidate(event.email);
    }
  }

  Stream<WorkshopScreenState> patchCheckoutFlowOrder(Map body) async* {
    yield state.copyWith(
      isUpdating: true,
      updatePayflowIndex: body.containsKey('amount') ? 0 : 3,
    );
    ChannelSetFlow channelSetFlow;
    dynamic response = await api.patchCheckoutFlowOrder(
        token, state.channelSetFlow.id, 'en', body);
    if (response is DioError) {
      yield WorkshopScreenStateFailure(error: response.message);
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
      );
    } else if (response is Map) {
      if (body.containsKey('amount'))
        yield WorkshopScreenPayflowStateSuccess();
      channelSetFlow = ChannelSetFlow.fromMap(response);
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
        channelSetFlow: channelSetFlow,
      );
      checkoutScreenBloc.add(UpdateChannelSetFlowEvent(channelSetFlow));
    }
  }

  Stream<WorkshopScreenState> emailValidate(String email) async* {
    yield state.copyWith(
      isUpdating: true,
      updatePayflowIndex: 1,
    );

    dynamic response = await api.checkoutEmailValidation(
        token, email);
    if (response is DioError) {
      yield WorkshopScreenStateFailure(error: response.message);
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
      );
    } else if (response is Map) {
        yield WorkshopScreenPayflowStateSuccess();
      bool isAvailable = response['available'];
      bool isValid = response['valid'];
      yield state.copyWith(
        isUpdating: false,
        isAvailable: isAvailable,
        isValid: isValid,
        updatePayflowIndex: -1,
      );
    }
  }

  Stream<WorkshopScreenState> patchCheckoutFlowAddress(Map body) async* {
    yield state.copyWith(
      isUpdating: true,
      updatePayflowIndex: 2,
    );
    ChannelSetFlow channelSetFlow;
    dynamic response = await api.patchCheckoutFlowAddress(
        token, state.channelSetFlow.id, state.channelSetFlow.billingAddress.id,'en', body);
    if (response is DioError) {
      yield WorkshopScreenStateFailure(error: response.message);
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
      );
    } else if (response is Map) {
      yield WorkshopScreenPayflowStateSuccess();
      channelSetFlow = ChannelSetFlow.fromMap(response);
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
        channelSetFlow: channelSetFlow,
      );
      checkoutScreenBloc.add(UpdateChannelSetFlowEvent(channelSetFlow));
    }
  }

  Stream<WorkshopScreenState> checkoutPayWireTransfer() async* {
    yield state.copyWith(
      isUpdating: true,
      updatePayflowIndex: 3,
    );
    ChannelSetFlow channelSetFlow = state.channelSetFlow;
    Map<String, dynamic> body = {
      'payment_data': {},
      'payment_flow_id': state.channelSetFlow.id,
      'payment_option_id': state.channelSetFlow.paymentOptionId,
      'remember_me': false
    };
    dynamic response = await api.checkoutPayWireTransfer(
        token, body);
    if (response is DioError) {
      yield WorkshopScreenStateFailure(error: response.message);
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
      );
    } else if (response is Map) {
      yield WorkshopScreenPaySuccess();
      channelSetFlow.payment = Payment.fromMap(response);
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
        channelSetFlow: channelSetFlow,
      );
      checkoutScreenBloc.add(UpdateChannelSetFlowEvent(channelSetFlow));
    }
  }

  Stream<WorkshopScreenState> checkoutPayInstantPayment() async* {
    yield state.copyWith(
      isUpdating: true,
      updatePayflowIndex: 3,
    );
    ChannelSetFlow channelSetFlow = state.channelSetFlow;
    Map<String, dynamic> body = {
      'payment_data': {},
      'payment_flow_id': state.channelSetFlow.id,
      'payment_option_id': state.channelSetFlow.paymentOptionId,
      'remember_me': false
    };

    dynamic response = await api.checkoutPayInstantPayment(
        token,'connectionId', body);
    if (response is DioError) {
      yield WorkshopScreenStateFailure(error: response.message);
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
      );
    } else if (response is Map) {
      yield WorkshopScreenPaySuccess();
      channelSetFlow.payment = Payment.fromMap(response);
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
        channelSetFlow: channelSetFlow,
      );
      checkoutScreenBloc.add(UpdateChannelSetFlowEvent(channelSetFlow));
    }
  }
}