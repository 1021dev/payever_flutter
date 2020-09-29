import 'dart:convert';
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
      yield* fetchInitData(
          event.business, event.defaultCheckout, event.channelSet);
    } else if (event is PatchCheckoutFlowOrderEvent) {
      yield* patchCheckoutFlowOrder(event.body);
    } else if (event is PatchCheckoutFlowAddressEvent) {
      yield* patchCheckoutFlowAddress(event.body);
    } else if (event is PayWireTransferEvent) {
      yield* payWireTransfer();
    } else if (event is PayInstantPaymentEvent) {
      yield* payByThirdParty(event.paymentMethod, event.body);
    } else if (event is EmailValidationEvent) {
      yield* emailValidate(event.email);
    } else if (event is GetPrefilledLinkEvent) {
      yield* getPrefilledLink(event.isCopyLink);
    } else if (event is GetPrefilledQRCodeEvent) {
      yield* getPrefilledQrcode();
    } else if (event is RefreshWorkShopEvent) {
      yield state.copyWith(isLoading: true);
      ChannelSetFlow channelSetFlow;
      dynamic response =
      await api.getCheckoutFlow(token, 'en', state.channelSet.id);
      if (response is Map) {
        channelSetFlow = ChannelSetFlow.fromJson(response);
      }
      await api.checkoutFlowStorage(token, channelSetFlow.id);
      yield state.copyWith(
        channelSetFlow: channelSetFlow,
        isLoading: false,
      );
    } else if (event is PayflowLoginEvent) {
      yield* login(event.email, event.password);
    } else if (event is PayCreditPaymentEvent) {
      yield* payByCreditCard(event.body);
    }
  }

  Stream<WorkshopScreenState> fetchInitData(String businessId,
      Checkout defaultCheckout, ChannelSet channelSet) async* {
    yield state.copyWith(
      isLoading: true,
      business: businessId,
      channelSet: channelSet,
      defaultCheckout: defaultCheckout,
    );
    dynamic response =
        await api.getCheckoutFlow(token, 'en', channelSet.id);
    ChannelSetFlow channelSetFlow;
    if (response is Map) {
      channelSetFlow = ChannelSetFlow.fromJson(response);
    }
    await api.checkoutFlowStorage(token, channelSetFlow.id);
    yield state.copyWith(
      channelSetFlow: channelSetFlow,
      isLoading: false,
    );
  }

  String getDefaultLanguage() {
    Lang defaultLang;
    List<Lang> langList = state.defaultCheckout.settings.languages.where((
        element) => element.active).toList();
    if (langList.length > 0) {
      defaultLang = langList.first;
    }
    return defaultLang != null ? defaultLang.code : 'en';
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
    }
  }

  Stream<WorkshopScreenState> emailValidate(String email) async* {
    yield state.copyWith(
      isCheckingEmail: true,
    );

    dynamic response = await api.checkoutEmailValidation(token, email);
    if (response is DioError) {
      yield WorkshopScreenStateFailure(error: response.message);
      yield state.copyWith(
        isCheckingEmail: false,
      );
    } else if (response is Map) {
      bool isAvailable = response['available'];
      bool isValid = response['valid'];
      yield state.copyWith(
        isCheckingEmail: false,
        isAvailable: isAvailable,
        isValid: isValid,
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

      bool selectedPaymentOption = false;
      if (channelSetFlow.paymentOptionId == null) {
        selectedPaymentOption = false;
      } else {
        channelSetFlow.paymentOptions.forEach((element) {
          if (element.id == channelSetFlow.paymentOptionId) {
            selectedPaymentOption = true;
          }
        });
      }
      if (!selectedPaymentOption) {
        add(PatchCheckoutFlowOrderEvent(body: {'payment_option_id': '${channelSetFlow.paymentOptions.first.id}'}));
      }
    }
  }

  Stream<WorkshopScreenState> payWireTransfer() async* {
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
      Future.delayed(const Duration(milliseconds: 500))
          .then((value) => state.copyWith(isPaid: false));
    }
  }
  Stream<WorkshopScreenState> payByCreditCard(Map<String, dynamic>cardJson) async* {
    yield state.copyWith(
      isUpdating: true,
      updatePayflowIndex: 3,
    );
    dynamic response = await api.getStripKey(token, state.channelSetFlow.id);
    if (response is DioError) {
      Fluttertoast.showToast(msg: 'Failed getting Stripe key.');
      return;
    }
    String key = response['key'];
    Map<String, dynamic> body = {
      'card': json.encode(cardJson),
      // 'key': key,
    };
    dynamic response1 = await api.getStripToken(body, key);
    if (response1 is DioError) {
      Fluttertoast.showToast(msg: 'Failed getting Stripe token.');
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
      );
      return;
    }
    String tokenId = response1['id'];
    Map<String, dynamic> paymentDetails = body['paymentDetails'];
    paymentDetails['tokenId'] = tokenId;
    body['paymentDetails'] = paymentDetails;
    yield state.copyWith(
      isUpdating: false,
      updatePayflowIndex: -1,
    );
    add(PayInstantPaymentEvent(paymentMethod: GlobalUtils.PAYMENT_STRIPE, body: body));
  }

  Stream<WorkshopScreenState> payByThirdParty(String paymentMethod, Map<String, dynamic> body) async* {
    yield state.copyWith(
      isUpdating: true,
      updatePayflowIndex: 3,
    );

    Map<String, dynamic> paymentVariants =
        checkoutScreenBloc.state.paymentVariants;
    String connectId = paymentVariants[paymentMethod].variants.first.uuid;
    dynamic response = await api.payByThirdParty(token, connectId, body);

    if (response is DioError) {
      yield WorkshopScreenStateFailure(
          error: response.error);
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
      );
    } else if (response is Map) {
      PayResult payResult = PayResult.fromJson(response);
      dynamic response1 = await api.payMarkAsFinished(token, state.channelSetFlow.id, 'en');
      ChannelSetFlow channelSetFlow = ChannelSetFlow.fromJson(response1);
      Map<String, dynamic>body = {'paymentId': payResult.id};
      dynamic updateResponse = await api.payUpdateStatus(token, connectId, body);
      payResult = PayResult.fromJson(updateResponse);
      // channelSetFlow.payment = payResult.payment;
      yield state.copyWith(
        isUpdating: false,
        isPaid: true,
        channelSetFlow: channelSetFlow,
        payResult: payResult,
        updatePayflowIndex: -1,
      );
      Future.delayed(const Duration(milliseconds: 500))
          .then((value) => state.copyWith(isPaid: false));
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
      String prefilledLink = '${Env.wrapper}/pay/restore-flow-from-code/$id';
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

  Stream<WorkshopScreenState> login(String email, String password) async* {
    yield state.copyWith(
      isUpdating: true,
      updatePayflowIndex: 1,
    );
    try {
      print('email => $email');
      print('password => $password');
      dynamic loginObj = await api.login(email, password);
      if (loginObj is DioError) {
        yield state.copyWith(
          isUpdating: false,
          updatePayflowIndex: -1,
        );
        print(onError.toString());
        Fluttertoast.showToast(msg: loginObj.toString());
      } else {
        Token tokenData = Token.map(loginObj);
        GlobalUtils.setCredentials(email: email, password: password, tokenData: tokenData);
        token = tokenData.accessToken;
        await api.peAuthToken(token);
        await api.peRefreshToken(tokenData.refreshToken);
        await api.peAuthToken1(token);
        await api.peRefreshToken1(token);
        await api.checkoutAuthorization(token, state.channelSetFlow.id);
        dynamic userResponse = await api.getUser(token);
        User user = User.map(userResponse);
        yield WorkshopScreenPayflowStateSuccess();
        yield state.copyWith(
          user:user,
          isUpdating: false,
          updatePayflowIndex: -1,
        );
        checkoutScreenBloc.token = token;
      }
    } catch (error){
      print(onError.toString());
      yield state.copyWith(
        isUpdating: false,
        updatePayflowIndex: -1,
      );
      yield WorkshopScreenStateFailure(error: error.toString());
    }
  }
}
