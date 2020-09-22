import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:http/http.dart' as http;

class WorkshopScreenBloc
    extends Bloc<WorkshopScreenEvent, WorkshopScreenState> {
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
    } else if (event is PatchCheckoutFlowOrderEvent) {
      yield* patchCheckoutFlowOrder(event.body);
    } else if (event is PatchCheckoutFlowAddressEvent) {
      yield* patchCheckoutFlowAddress(event.body);
    } else if (event is PayWireTransferEvent) {
      yield* checkoutPayWireTransfer();
    } else if (event is PayInstantPaymentEvent) {
      yield* checkoutPayInstantPayment(event.body);
    } else if (event is EmailValidationEvent) {
      yield* emailValidate(event.email);
    } else if (event is GetPrefilledLinkEvent) {
      yield* getPrefilledLink(event.isCopyLink);
    } else if (event is GetPrefilledQRCodeEvent) {
      yield* getPrefilledQrcode();
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
      if (body.containsKey('amount')) yield WorkshopScreenPayflowStateSuccess();
      channelSetFlow = ChannelSetFlow.fromJson(response);
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

    dynamic response = await api.checkoutEmailValidation(token, email);
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
        token,
        state.channelSetFlow.id,
        state.channelSetFlow.billingAddress.id,
        'en',
        body);
    if (response is DioError) {
      yield WorkshopScreenStateFailure(error: response.message);
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
      );
    } else if (response is Map) {
      yield WorkshopScreenPayflowStateSuccess();
      channelSetFlow = ChannelSetFlow.fromJson(response);
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
    dynamic response = await api.checkoutPayWireTransfer(token, body);
    if (response is DioError) {
      yield WorkshopScreenStateFailure(error: response.message);
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
      );
    } else if (response is Map) {
      // yield WorkshopScreenPaySuccess();
      channelSetFlow.payment = Payment.fromJson(response['payment']);
      yield state.copyWith(
        isUpdating: false,
        isPaid: true,
        updatePayflowIndex: -1,
        channelSetFlow: channelSetFlow,
      );
      checkoutScreenBloc.add(UpdateChannelSetFlowEvent(channelSetFlow));
      Future.delayed(const Duration(milliseconds: 500))
          .then((value) => state.copyWith(isPaid: false));
    }
  }

  Stream<WorkshopScreenState> checkoutPayInstantPayment(
      Map<String, dynamic> body) async* {
    yield state.copyWith(
      isUpdating: true,
      updatePayflowIndex: 3,
    );
    ChannelSetFlow channelSetFlow = state.channelSetFlow;
    Map<String, dynamic> paymentVariants =
        checkoutScreenBloc.state.paymentVariants;
    String connectId = paymentVariants['instant_payment'].variants.first.uuid;
    dynamic response =
        await api.checkoutPayInstantPayment(token, connectId, body);
    if (response is DioError) {
      yield WorkshopScreenStateFailure(
          error: response.response.data['message']);
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
      );
    } else if (response is Map) {
      yield WorkshopScreenPaySuccess();
      channelSetFlow.payment = Payment.fromJson(response);
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
        channelSetFlow: channelSetFlow,
      );
      checkoutScreenBloc.add(UpdateChannelSetFlowEvent(channelSetFlow));
    }
  }

  Stream<WorkshopScreenState> getPrefilledLink(bool isCoplyLink) async* {
    Map<String, dynamic> data = {
      'flow': state.channelSetFlow.toJson(),
      'force_choose_payment_only_and_submit': false,
      'force_no_header': false,
      'force_no_order': true,
      'force_payment_only': false,
      'generate_payment_code': true,
      'open_next_step_on_init': false,
    };
    yield state.copyWith(isLoadingQrcode: true);
    dynamic qrcodelinkResponse = await api.getChannelSetQRcode(token, data);
    if (qrcodelinkResponse is Map) {
      String id = qrcodelinkResponse['id'];
      String prefilledLink = 'https://checkout.payever.org/pay/restore-flow-from-code/$id';
      yield state.copyWith(isLoadingQrcode: !isCoplyLink,
          prefilledLink: prefilledLink);
      if (isCoplyLink) {
        Clipboard.setData(ClipboardData(
            text:prefilledLink));
        Fluttertoast.showToast(msg: 'Copied Prefilled Link.');
      } else {
        add(GetPrefilledQRCodeEvent());
      }
    } else {
      yield state.copyWith(isLoadingQrcode: false);
    }
  }

  Stream<WorkshopScreenState> getPrefilledQrcode() async* {
    if (state.prefilledLink == null || state.prefilledLink.isEmpty) {
      Fluttertoast.showToast(msg: 'Something wrong.');
      return;
    }

    dynamic response = await api.postGenerateTerminalQRCode(
      GlobalUtils.activeToken.accessToken,
      state.business,
      checkoutScreenBloc.dashboardScreenBloc.state.activeBusiness.name,
      '$imageBase${checkoutScreenBloc.dashboardScreenBloc.state.activeTerminal.logo}',
      checkoutScreenBloc.dashboardScreenBloc.state.activeTerminal.id,
      state.prefilledLink,
    );

    String imageData;
    if (response is Map) {
      dynamic form = response['form'];
      String contentType =
          form['contentType'] != null ? form['contentType'] : '';
      dynamic content = form['content'] != null ? form['content'] : null;
      if (content != null) {
        List<dynamic> contentData = content[contentType];
        for (int i = 0; i < contentData.length; i++) {
          dynamic data = content[contentType][i];
          if (data['data'] != null) {
            List<dynamic> list = data['data'];
            for (dynamic w in list) {
              if (w[0]['type'] == 'image') {
                imageData = w[0]['value'];
              }
            }
          }
        }
      }
    }
    http.Response qrResponse;
    if (imageData != null) {
      var headers = {
        HttpHeaders.authorizationHeader:
            'Bearer ${GlobalUtils.activeToken.accessToken}',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
      };
      print('url => $imageData');
      qrResponse = await http.get(
        imageData,
        headers: headers,
      );
    }
    yield state.copyWith(isLoadingQrcode: false,qrForm: response, qrImage: qrResponse.bodyBytes);
    await Future.delayed(const Duration(milliseconds: 500));
    yield state.copyWith(qrForm: null, qrImage: null);
  }
}
