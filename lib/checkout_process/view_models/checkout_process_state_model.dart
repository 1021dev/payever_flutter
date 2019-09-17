import 'package:flutter/material.dart';
import 'package:payever/checkout_process/checkout_process.dart';
import 'package:payever/checkout_process/models/payment_option.dart';
import 'package:payever/checkout_process/views/custom_elements/checkout_section_view.dart';
import 'package:provider/provider.dart';
import '../models/flow_object.dart';
import '../views/views.dart';
import '../../commons/models/models.dart';
import '../../pos/view_models/view_models.dart';
import '../views/payments/payments.dart';

class CheckoutProcessStateModel extends ChangeNotifier {
  CheckoutProcessStateModel();

  String _addressDescription;
  String get addressDescription => _addressDescription;
  setAddressDescription(String address) => _addressDescription = address;

  setAddressDescriptionAuto() => _addressDescription = "${_checkoutUser.street}, ${_checkoutUser.city}, ${_checkoutUser.country}";

  CheckoutStructure _checkoutStructure;
  CheckoutStructure get checkoutStructure => _checkoutStructure;
  setcheckoutStructure(checkoutStructure) {
    _checkoutStructure = checkoutStructure;
  }

  List<CheckoutPaymentOption> _paymentOption = List();
  List<CheckoutPaymentOption> get paymentOption => _paymentOption;
  setPaymentOption(List<CheckoutPaymentOption> paymentOption) => _paymentOption = paymentOption ;

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

  StepperController stepperController;

  setTabController(StepperController _stepperController) =>
      stepperController = _stepperController;

  final Map<String, Widget> sectionMap = {
    "order": CheckoutOrderSection(),
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
                    sectionIndexMap["order"] + 1, checkoutProcessStateModel);
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
                    checkoutProcessStateModel);
            },
          );
        break;
      case "user":
        return userOK = ValueNotifier(false)
          ..addListener(
            () {
              if (userOK.value)
                stepperController.setIndex(
                    sectionIndexMap["user"] + 1, checkoutProcessStateModel);
            },
          );
        break;
      case "address":
        return addressOK = ValueNotifier(false)
          ..addListener(
            () {
              if (addressOK.value)
                stepperController.setIndex(
                    sectionIndexMap["address"] + 1, checkoutProcessStateModel);
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
    "sofort":Sofort(),
  };

  Map<String, int> paymentIndexMap = Map();

  ValueNotifier<String> paymentActionText = ValueNotifier("");

  setPaymentActionText(int index){
    paymentActionText.value = actionsText[paymentOption[index].slug];
    print("Payment Action : $paymentActionText");
  }

  final Map<String,String> actionsText ={
    "paypal":Language.getCheckoutStrings("actions.redirect_to_paypal"),
    "pos-santander-invoice-de":"pos santander",
    "credit-card":"card",
  };
}
