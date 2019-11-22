import 'package:flutter/material.dart';
import 'package:payever/checkout_process/checkout_process.dart';
import 'package:payever/checkout_process/models/payment_option.dart';
import 'package:payever/checkout_process/utils/checkout_process_utils.dart';
import 'package:payever/checkout_process/views/custom_elements/checkout_section_view.dart';
import 'package:payever/checkout_process/views/section_order_manual.dart';
import 'package:payever/checkout_process/views/section_order_tester.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/flow_object.dart';
import '../views/views.dart';
import '../../commons/models/models.dart';
import '../../pos/view_models/view_models.dart';
import '../views/payments/payments.dart';

class CheckoutProcessStateModel extends ChangeNotifier {
  CheckoutProcessStateModel();

  Future startCheckout(GlobalStateModel globalStateModel) async {
    var obj = await CheckoutProcessApi().createFlow(
      null,
      [],
      _channelSet,
      globalStateModel.currentBusiness.currency,
      false,
    );
    paymentOption.clear();
    obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_PAYMENT_OPTIONS].forEach(
      (pm) {
        paymentOption.add(
          CheckoutPaymentOption.toMap(pm),
        );
      },
    );

    /// ***
    ///
    /// HardCoded cash payment to test an extra payment method.
    /// after implemented it should be DELETED
    ///
    /// ***

    print("Delete HERE -> checkout_process_state_model.dart");
    paymentOption.add(CheckoutPaymentOption.toMap({
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_ACCEPT_FEE: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_CONTRACT_LENGHT: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_DESCRIPTION_FEE: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_DESCRIPTION_OFFER: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_FIXED_FEE: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_ID: 100,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_IMAGE_P_FILE: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_IMAGE_S_FILE: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_INSTRUCTION_TEXT: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_MAX: 100000,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_MERCHANT_ALLOW_CN: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_MIN: 1,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_NAME: "cash",
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_OPTIONS: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_PAYMENT_METHOD: "cash",
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_RELATED_COUNTRY: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_RELATED_COUNTRY_NAME: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_SETTINGS: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_SLUG: "cash",
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_STATUS: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_THUMBNAIL_1: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_THUMBNAIL_2: null,
      CheckoutProcessUtils.DB_CHECKOUT_P_P_O_VARIABLE_FEE: null,
    }));
    return CheckoutProcessApi().getCheckoutFlow(
      _channelSet,
    );
  }

  ValueNotifier notifier = ValueNotifier(true);
  notify() {
    notifier.value = !notifier.value;
    // notifyListeners();
  }

  String _addressDescription;
  String get addressDescription => _addressDescription;
  setAddressDescription(String address) => _addressDescription = address;

  setAddressDescriptionAuto() => _addressDescription =
      "${_checkoutUser.street}, ${_checkoutUser.city}, ${_checkoutUser.country}";

  CheckoutStructure _checkoutStructure;
  CheckoutStructure get checkoutStructure => _checkoutStructure;
  setcheckoutStructure(checkoutStructure) {
    _checkoutStructure = checkoutStructure;
  }

  List<CheckoutPaymentOption> _paymentOption = List();
  List<CheckoutPaymentOption> get paymentOption => _paymentOption;
  setPaymentOption(List<CheckoutPaymentOption> paymentOption) =>
      _paymentOption = paymentOption;

  CheckoutUser _checkoutUser = CheckoutUser();
  CheckoutUser get checkoutUser => _checkoutUser;
  setCheckoutUser(CheckoutUser checkOutUser) => _checkoutUser = checkoutUser;

  DashboardStateModel dashboardStateModel;
  PosCartStateModel posCartStateModel;
  PosStateModel posStateModel;

  dynamic flowObj;

  FlowObject _currentFlow;
  FlowObject get currentFlow => _currentFlow;
  setCurrentFlow(FlowObject flow) => _currentFlow = flow;

  String _channelSet;
  String get getchannelSet => _channelSet;
  setChannelSet(String channelSet) => _channelSet = channelSet;

  void getChannelSet(BuildContext context) {
    setChannelSet(
        Provider.of<DashboardStateModel>(context).activeTerminal.channelSet);
  }

  ValueNotifier<String> _amount = ValueNotifier("");
  ValueNotifier<String> get amount => _amount;
  setAmount(String amount) => _amount.value = amount;

  ValueNotifier<String> _reference = ValueNotifier("");
  ValueNotifier<String> get reference => _reference;
  setReference(String ref) => _reference.value = ref;

  ValueNotifier<String> _cash = ValueNotifier("");
  ValueNotifier<String> get cash => _cash;
  setCash(String ref) => _cash.value = ref;

  StepperController stepperController;

  setTabController(StepperController _stepperController) =>
      stepperController = _stepperController;

  Future<String> paymentLauncher(
      {bool isEmail, String text, num paymentIndex}) async {
    var _ = await CheckoutProcessApi().postCheckout(
      flowObj["id"],
      getchannelSet,
    );
    var a = await CheckoutProcessApi().patchCheckoutPaymentOption(
      flowObj["id"],
      paymentIndex,
    );
    print(">> ${a["storage"]}");
    // var paymentUrl = await CheckoutProcessApi().postCheckoutPayment(
    //   flowObj["id"],
    //   paymentIndex,
    // );

    var _url = await CheckoutProcessApi().postStorageSimple(
      a,
      true,
      true,
      text,
      isEmail ? "email" : "sms",
      DateTime.now()
          .subtract(
            Duration(
              hours: 1,
            ),
          )
          .add(
            Duration(minutes: 1),
          )
          .toIso8601String(),
      false,
    );
  
    // print(Env.payments + paymentUrl["redirect_url"] +
    //                     "?access_token=${GlobalUtils.activeToken.accessToken}");

    return Env.wrapper + "/pay/restore-flow-from-code/" + _url["id"];
    // return Env.payments + ;
    // paymentUrl["redirect_url"] +
    // "?access_token=${GlobalUtils.activeToken.accessToken}";
  }

  final Map<String, Widget> sectionMap = {
    // "order": CheckoutOrderSection(),
    "order": CheckoutOrderSectionTESTER(),
    "order_manual": CheckoutOrderSectionManual(),
    "send_to_device": CheckoutS2DeviceSection(),
    "user": CheckoutAccountSectionStart(),
    "address": CheckoutShippingSectionStart(),
    "choosePayment": CheckoutPayementSection(),
    "payment": CheckoutTotalSection(),
  };

  String getHeaderString(String title, CheckoutUser checkoutUser) {
    Map<String, String> headerDescriptions = {
      "order": "",
      "send_to_device": "",
      "user": "${checkoutUser.email ?? ""}",
      "address":
          "${Language.getCheckoutStrings(("options." + (checkoutUser?.salutation ?? "")))} ${checkoutUser?.name ?? ""} ${checkoutUser?.lastName ?? ""}\n${checkoutUser?.street ?? ""}\n${checkoutUser?.zipCode ?? ""}, ${checkoutUser?.city ?? ""}\n${checkoutUser?.country ?? ""}",
      "choosePayment": "",
      "payment": "",
    };

    return headerDescriptions[title];
  }

  Map<String, int> sectionIndexMap = Map();

  ValueNotifier<bool> cartOK;
  ValueNotifier<bool> sendToDeviceOK;
  ValueNotifier<bool> userOK;
  ValueNotifier<bool> addressOK;

  ValueNotifier<bool> getSectionOk(
      String title, CheckoutProcessStateModel checkoutProcessStateModel) {
    switch (title) {
      case "order":
        return cartOK = ValueNotifier(false)
          ..addListener(
            () {
              if (cartOK.value)
                stepperController.setIndex(
                  sectionIndexMap["order"] + 1,
                  checkoutProcessStateModel,
                );
            },
          );
        break;
      case "send_to_device":
        return sendToDeviceOK = ValueNotifier(false)
          ..addListener(
            () {
              if (sendToDeviceOK.value)
                stepperController.setIndex(
                  sectionIndexMap["send_to_device"] + 1,
                  checkoutProcessStateModel,
                );
            },
          );
        break;
      case "user":
        return userOK = ValueNotifier(false)
          ..addListener(
            () {
              if (userOK.value)
                stepperController.setIndex(
                  sectionIndexMap["user"] + 1,
                  checkoutProcessStateModel,
                );
            },
          );
        break;
      case "address":
        return addressOK = ValueNotifier(false)
          ..addListener(
            () {
              if (addressOK.value)
                stepperController.setIndex(
                  sectionIndexMap["address"] + 1,
                  checkoutProcessStateModel,
                );
            },
          );
        break;
      case "choosePayment":
        return cartOK;
        break;
      case "payment":
        return cartOK;
        break;
      default:
        return ValueNotifier(false);
    }
  }

  ValueNotifier<bool> shippingValue = ValueNotifier(false);

  ValueNotifier<bool> email = ValueNotifier(true);
  ValueNotifier<bool> salutation = ValueNotifier(true);
  ValueNotifier<bool> name = ValueNotifier(true);
  ValueNotifier<bool> lastname = ValueNotifier(true);
  ValueNotifier<bool> country = ValueNotifier(true);
  ValueNotifier<bool> city = ValueNotifier(true);
  ValueNotifier<bool> street = ValueNotifier(true);
  ValueNotifier<bool> post = ValueNotifier(true);
  ValueNotifier<bool> company = ValueNotifier(false);
  ValueNotifier<bool> phone = ValueNotifier(false);

  void checkShipping() async {
    shippingValue.value = !email.value &&
        !salutation.value &&
        !name.value &&
        !lastname.value &&
        !country.value &&
        !city.value &&
        !street.value &&
        !post.value &&
        !company.value &&
        !phone.value;
  }

  final Map<String, Widget> paymentMap = {
    "paypal": PayPalPayment(),
    "nopayment": NoPayment(),
    "pos-santander-invoice-de": SantanderInvoiceDE(),
    "sofort": Sofort(),
  };

  Map<String, int> paymentIndexMap = Map();

  ValueNotifier<String> paymentActionText = ValueNotifier("");

  setPaymentActionText(int index) {
    paymentActionText.value = actionsText[paymentOption[index].slug];
    print("Payment Action : $paymentActionText");
  }

  final Map<String, String> actionsText = {
    "paypal": Language.getCheckoutStrings("actions.redirect_to_paypal"),
    "pos-santander-invoice-de": "pos santander",
    "credit-card": "card",
  };
}
