import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/checkout/checkout_bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/workshop/prefilled_qr_screen.dart';
import 'package:payever/checkout/views/workshop/subview/pay_success_view.dart';
import 'package:payever/checkout/views/workshop/subview/payment_select_view.dart';
import 'package:payever/checkout/widgets/workshop_header_item.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/widgets/address_field_group.dart';
import 'package:payever/widgets/googlemap_address_filed.dart';
import 'package:payever/widgets/peronal_name_field.dart';
import 'package:the_validator/the_validator.dart';

import '../../../../theme.dart';
import '../checkout_switch_screen.dart';


class WorkshopView extends StatefulWidget {
  final CheckoutScreenBloc checkoutScreenBloc;
  final WorkshopScreenBloc workshopScreenBloc;
  final GlobalKey formKeyOrder;
  const WorkshopView(
      {this.checkoutScreenBloc, this.workshopScreenBloc, this.formKeyOrder});

  @override
  _WorkshopViewState createState() => _WorkshopViewState();
}

class _WorkshopViewState extends State<WorkshopView> {

  int _selectedSectionIndex = 0;
  bool isOrderApproved = false;
  bool isAccountApproved = false;
  bool isBillingApproved = false;
  bool isSendDeviceApproved = false;
  bool isSelectPaymentApproved = false;

  String currency = '';
  bool editOrder = false;

  double amount = 0;
  String reference;

  String email;
  String password;
  String countryCode;
  String city;
  String street;
  String zipCode;
  String googleAutocomplete;

  String salutation;
  String firstName;
  String lastName;

  String company;
  String phone;

  bool switchCheckout = false;
  bool payflowLogin = false;

  var _formKeyOrder;
  final _formKeyAccount = GlobalKey<FormState>();
  final _formKeyBilling = GlobalKey<FormState>();
  final _formKeyPayment = GlobalKey<FormState>();

  bool fromCheckout = true;

  List<String> titles = [
    'ACCOUNT',
    'BILLING & SHIPPING',
    'ELEGIR METODO DE PAGO',
    'PAYMENT'
  ];
  List<String> values = [
    'Login or enter your email',
    'Add your billing and shipping address',
    'Choose payment option',
    'Your payment option'
  ];
  Map<String, dynamic>cardJson = {};

  WorkshopScreenBloc screenBloc;

  @override
  void initState() {
    fromCheckout = widget.workshopScreenBloc != null;
    if (fromCheckout) {
      screenBloc = widget.workshopScreenBloc;
    } else {
      screenBloc =
      WorkshopScreenBloc(checkoutScreenBloc: widget.checkoutScreenBloc)
        ..add(WorkshopScreenInitEvent(
          business: widget.checkoutScreenBloc.state.business,
          channelSet: widget.checkoutScreenBloc.state.channelSet,
          defaultCheckout: widget.checkoutScreenBloc.state.defaultCheckout,
        ));
    }
    if (widget.formKeyOrder != null) {
      _formKeyOrder = widget.formKeyOrder;
    } else {
      _formKeyOrder = GlobalKey<FormState>();
    }
    // initialize(widget.checkoutScreenBloc.state.channelSetFlow);
    super.initState();
  }

  @override
  void dispose() {
    if (!fromCheckout) {
      screenBloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, WorkshopScreenState state) async {
        if (state is WorkshopScreenPayflowStateSuccess) {
          setState(() {
            switch (_selectedSectionIndex) {
              case 0:
                isOrderApproved = true;
                if (editOrder)
                  editOrder = false;
                break;
              case 1:
                isAccountApproved = true;
                break;
              case 2:
                isBillingApproved = true;
                break;
              default:
                break;
            }
            _selectedSectionIndex++;
          });
        } else if (state.isPaid == true) {
          showPaySuccessDialog(state);
        } else if (state is WorkshopScreenStateFailure) {
          Fluttertoast.showToast(msg: state.error);
        } else if (state.qrImage != null) {
          Navigator.push(
            context,
            PageTransition(
              child: PrefilledQRCodeScreen(
                qrForm: state.qrForm,
                qrImage: state.qrImage,
                title: 'QR',
              ),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<WorkshopScreenBloc, WorkshopScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, state) {
          return state.defaultCheckout == null ? Container() : _body(state);
        },
      ),
    );
  }

  Widget _body(WorkshopScreenState state) {
    if (switchCheckout) {
      return CheckoutSwitchScreen(
        businessId: state.business,
        checkoutScreenBloc: widget.checkoutScreenBloc,
        onOpen: (Checkout checkout) {
          setState(() {
            switchCheckout = false;
          });
        },
      );
    }
    if (state.channelSetFlow == null) {
      return Container();
    }
    return _workshop(state);
  }

  Widget _workshop(WorkshopScreenState state) {
    Business business =
        widget.checkoutScreenBloc.dashboardScreenBloc.state.activeBusiness;
    String currencyString = business.currency;
    NumberFormat format = NumberFormat();
    currency = format.simpleCurrencySymbol(currencyString);

    return BackgroundBase(
      true,
      body: Container(
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              width: Measurements.width,
              height: 50,
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  editOrder
                      ? MaterialButton(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.keyboard_arrow_left,
                          size: 24,
                        ),
                        Text(
                          'Pay',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        editOrder = false;
                      });
                    },
                    height: 32,
                    minWidth: 0,
                    padding: EdgeInsets.only(left: 4, right: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
                      : SvgPicture.asset(
                    'assets/images/payeverlogoandname.svg',
                    color: iconColor(),
                    height: 16,
                  ),
                  Spacer(),
                  isOrderApproved
                      ? MaterialButton(
                    child: Row(
                      children: <Widget>[
                        Text(
                          state.channelSetFlow != null
                              ? '$currency${state.channelSetFlow.amount.toStringAsFixed(2)}'
                              : '',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                        ),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        editOrder = !editOrder;
                      });
                    },
                    height: 32,
                    minWidth: 0,
                    padding: EdgeInsets.only(left: 4, right: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
                      : Container(),
                  Spacer(),
                  MaterialButton(
                    color: overlayBackground(),
                    child: Text(
                      'Switch Checkout',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        switchCheckout = true;
                      });
                    },
                    //callback when button is clicked
                    height: 32,
                    minWidth: 0,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: BorderSide(
                        color: Colors.black38,
                        width: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _divider,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    editOrder
                        ? Container(
                        width: Measurements.width,
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                        ),
                        child: _orderView(state)/*_editOrderView(state)*/)
                        : Container(
                      width: Measurements.width,
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      child: Column(
                        children: <Widget>[
                          _orderView(state),
                          _divider,
                          _accountView(state),
                          _divider,
                          _billingView(state),
                          _divider,
                          _selectPaymentView(state),
                          _divider,
                          // _sendToDeviceView(state),
                          // _divider,
                          _paymentOptionView(state),
                          _divider,
                          _addressView(state),
                          _divider,
                          _orderDetailView(state),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cautionTestMode(WorkshopScreenState state) {
    String title =
        'Caution. Your checkout is in test mode. You just can test but there will be no regular transactions. In order to have real transactions please switch your checkout to live.';
    return Visibility(
        visible: state.defaultCheckout.settings.testingMode,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.deepOrange,
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  Widget _orderView(WorkshopScreenState state) {
    if (state.channelSetFlow == null) {
      return Container();
    }
    return Form(
      key: _formKeyOrder,
      child: Visibility(
        visible: isVisible(state, 'order'),
        child: Column(
          children: <Widget>[
            _cautionTestMode(state),
            WorkshopHeader(
              title:
              Language.getCheckoutStrings('checkout_order_summary.title'),
              isExpanded: editOrder ? true : _selectedSectionIndex == 0,
              isApproved: isOrderApproved,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 0 ? -1 : 0;
                });
              },
            ),
            Visibility(
              visible: editOrder ? true : _selectedSectionIndex == 0,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Column(
                      children: <Widget>[
                        BlurEffectView(
                          color: overlayRow(),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4)),
                          child: Container(
                            height: 55,
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: TextFormField(
                              style: textFieldStyle,
                              initialValue: amount > 0 ? '$amount' : '',
                              onChanged: (val) {
                                amount = double.parse(val);
                              },
                              validator: (text) {
                                if (text.isEmpty || double.parse(text) <= 0) {
                                  return 'Amount required';
                                }
                                if (double.parse(text) < 1) {
                                  return 'Correct Amount required';
                                }
                                return null;
                              },
                              decoration: textFieldDecoration(Language.getCartStrings(
                                  'checkout_cart_edit.form.label.amount'), prefixIcon: Container(
                                width: 44,
                                child: Center(
                                  child: Text(
                                    currency,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        BlurEffectView(
                          color: overlayRow(),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4)),
                          child: Container(
                            height: 55,
                            padding: EdgeInsets.symmetric(vertical: 4),
                            alignment: Alignment.center,
                            child: TextFormField(
                              style: textFieldStyle,
                              onChanged: (val) {
                                reference = val;
                              },
                              initialValue: reference,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return 'Reference required';
                                }
                                return null;
                              },
                              decoration: textFieldDecoration(Language.getCartStrings(
                                  'checkout_cart_edit.form.label.reference')),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 55,
                    child: SizedBox.expand(
                      child: MaterialButton(
                        onPressed: () {
                          if (_formKeyOrder.currentState.validate() &&
                              !state.isUpdating) {
                            _selectedSectionIndex = 0;
                            screenBloc.add(PatchCheckoutFlowOrderEvent(body: {
                              'amount': amount,
                              'reference': reference
                            }));
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        color: overlayBackground(),
                        child: state.isUpdating && state.updatePayflowIndex == 0
                            ? Center(child: Container(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 2,)))
                            : Text(
                          editOrder ? 'Save' : 'Next Step',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderDetailView(WorkshopScreenState state) {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              child: Text(
                Language.getCheckoutStrings('checkout_order_summary.title')
                    .toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Helvetica Neue',
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        Language.getCartStrings(
                            'checkout_cart_edit.form.label.subtotal')
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '${currency}${state.channelSetFlow.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        Language.getCartStrings(
                            'checkout_cart_view.payment_costs')
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '${currency}0.00',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        Language.getCartStrings('checkout_cart_view.shipping')
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '${currency}0.00',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        Language.getCartStrings('checkout_cart_view.total')
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        state.channelSetFlow != null
                            ? '$currency${state.channelSetFlow.amount.toStringAsFixed(2)}'
                            : '',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountView(WorkshopScreenState state) {
    return Form(
      key: _formKeyAccount,
      child: Visibility(
        visible: isVisible(state, 'user'),
        child: Column(
          children: <Widget>[
            WorkshopHeader(
              title: 'Account',
              subTitle: isAccountApproved ? email : 'Login or enter your email',
              isExpanded: _selectedSectionIndex == 1,
              isApproved: isAccountApproved,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 1 ? -1 : 1;
                });
              },
            ),
            Visibility(
              visible: _selectedSectionIndex == 1,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Column(
                      children: <Widget>[
                        BlurEffectView(
                            color: overlayRow(),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4)),
                            child: _emailField(state)),
                        SizedBox(
                          height: 2,
                        ),
                        BlurEffectView(
                          color: overlayRow(),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4)),
                          child: payflowLogin
                              ? _passwordField(state)
                              : GoogleMapAddressField(
                            googleAutocomplete: googleAutocomplete,
                            height: 55,
                            onChanged: (val) {
                              googleAutocomplete = val;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 55,
                    child: SizedBox.expand(
                      child: MaterialButton(
                        onPressed: () {
                          if (_formKeyAccount.currentState.validate()) {
                            if (payflowLogin) {
                              _selectedSectionIndex = 1;
                              screenBloc.add(PayflowLoginEvent(email: email, password: password));
                            } else {
                              _selectedSectionIndex = 2;
                              isAccountApproved = true;
                            }
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        color: overlayBackground(),
                        child: state.isUpdating && state.updatePayflowIndex == 1
                            ? Center(child: Container(width: 30, height: 30 ,child: CircularProgressIndicator(strokeWidth: 2,)))
                            : Text(
                          Language.getCheckoutStrings(
                              'checkout_send_flow.action.continue'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billingView(WorkshopScreenState state) {
    if (state.user != null) {
      firstName = state.user.firstName;
      lastName = state.user.lastName;
      salutation = state.user.salutation;
      phone = state.user.phone;
      if (state.user.shippingAddresses != null && state.user.shippingAddresses.isNotEmpty) {
        ShippingAddress address = state.user.shippingAddresses.first;
        city = address.city;
        countryCode = address.country;
        street = address.street;
        zipCode = address.zipCode;
      }
    }

    return Column(
      children: <Widget>[
        WorkshopHeader(
          title: 'BILLING & SHIPPING',
          subTitle: isBillingApproved ? googleAutocomplete : 'Add your billing and shipping address',
          isExpanded: _selectedSectionIndex == 2,
          isApproved: isBillingApproved,
          onTap: () {
            setState(() {
              _selectedSectionIndex = _selectedSectionIndex == 2 ? -1 : 2;
            });
          },
        ),
        Form(
          key: _formKeyBilling,
          child: Visibility(
            visible: _selectedSectionIndex == 2,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Column(
                    children: <Widget>[
                      BlurEffectView(
                          color: overlayRow(),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4)),
                          child: _emailField(state)),
                      SizedBox(
                        height: 2,
                      ),
                      PersonalNameField(
                        salutation: salutation,
                        firstName: firstName,
                        lastName: lastName,
                        height: 55,
                        salutationChanged: (val) {
                          setState(() {
                            salutation = val;
                          });
                        },
                        firstNameChanged: (val) {
                          setState(() {
                            firstName = val;
                          });
                        },
                        lastNameChanged: (val) {
                          setState(() {
                            lastName = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      AddressFieldGroup(
                        googleAutocomplete: googleAutocomplete,
                        city: city,
                        countryCode: countryCode,
                        street: street,
                        zipCode: zipCode,
                        height: 55,
                        hasBorder: false,
                        onChangedGoogleAutocomplete: (val) {
                          googleAutocomplete = val;
                        },
                        onChangedCode: (val) {
                          countryCode = val;
                        },
                        onChangedCity: (val) {
                          setState(() {
                            city = val;
                            setGoogleAutoComplete();
                          });
                        },
                        onChangedStreet: (val) {
                          setState(() {
                            street = val;
                            setGoogleAutoComplete();
                          });
                        },
                        onChangedZipCode: (val) {
                          setState(() {
                            zipCode = val;
                            setGoogleAutoComplete();
                          });
                        },
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      BlurEffectView(
                        color: overlayRow(),
                        radius: 0,
                        child: Container(
                          height: 55,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: TextFormField(
                            style: textFieldStyle,
                            onChanged: (val) {
                              company = val;
                            },
                            initialValue: company,
                            decoration: textFieldDecoration('Company (optional)'),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      BlurEffectView(
                        color: overlayRow(),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4)),
                        child: Container(
                          height: 55,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          alignment: Alignment.center,
                          child: TextFormField(
                            style: textFieldStyle,
                            onChanged: (val) {
                              phone = val;
                            },
                            initialValue: phone,
                            decoration: textFieldDecoration('Phone (optional)'),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 55,
                  child: SizedBox.expand(
                    child: MaterialButton(
                      onPressed: () {
                        bool testMode = false;
                        if (testMode) {
                          Map<String, dynamic> body = {
                            'city': 'Berlin',
                            'company': company,
                            'country': 'DE',
                            'email': 'abiantgmbh@payever.de',
                            'first_name': 'Artur',
                            'full_address':
                            'Germaniastraße, 12099, 12099 Berlin, Germany',
                            'id': state.channelSetFlow.billingAddress.id,
                            'last_name': 'S',
                            'phone': phone,
                            'salutation': 'SALUTATION_MR',
                            'select_address': '',
                            'social_security_number': '',
                            'street': 'Germaniastraße, 12099',
                            'street_name': 'Germaniastraße',
                            'street_number': '12',
                            'type': 'billing',
                            'zip_code': '12099',
                          };
                          screenBloc
                              .add(PatchCheckoutFlowAddressEvent(body: body));
                        } else {
                          if (countryCode == null || countryCode.isEmpty) {
                            Fluttertoast.showToast(msg: 'Country is needed');
                            return;
                          }
                          if (salutation == null || salutation.isEmpty) {
                            Fluttertoast.showToast(msg: 'Salutation is needed');
                            return;
                          }
                          if (_formKeyBilling.currentState.validate() && !state.isUpdating) {
                            Map<String, dynamic> body = {
                              'city': city,
                              'company': company,
                              'country': countryCode,
                              'email': email,
                              'first_name': firstName,
                              'full_address': googleAutocomplete,
                              'id': state.channelSetFlow.billingAddress.id,
                              'last_name': lastName,
                              'phone': phone,
                              'salutation': salutation,
                              'select_address': '',
                              'social_security_number': '',
                              'street': street,
                              'street_name': street,
                              'street_number': zipCode,
                              'type': 'billing',
                              'zip_code': zipCode,
                            };
                            print('body: $body');
                            screenBloc
                                .add(PatchCheckoutFlowAddressEvent(body: body));
                          }
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      color: overlayBackground(),
                      child: state.isUpdating && state.updatePayflowIndex == 2
                          ? Center(
                        child: Container(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            )),
                      )
                          : Text(
                        Language.getCheckoutStrings(
                            'checkout_send_flow.action.continue'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _selectPaymentView(WorkshopScreenState state) {
    return Form(
      key: _formKeyPayment,
      child: PaymentSelectView(
        enable: isVisible(state, 'choosePayment'),
        subtitle: isBillingApproved ? '' : 'Select a payment method',
        approved: isSelectPaymentApproved,
        isUpdating: state.isUpdating && state.updatePayflowIndex == 3,
        channelSetFlow: state.channelSetFlow,
        expanded: _selectedSectionIndex == 3,
        onTapApprove: () {
          setState(() {
            _selectedSectionIndex = _selectedSectionIndex == 3 ? -1 : 3;
          });
        },
        onTapPay: (Map body) {
          if (_formKeyPayment.currentState.validate() && !state.isUpdating) {
            List<CheckoutPaymentOption> payments = state
                .channelSetFlow.paymentOptions
                .where((element) =>
            element.id == state.channelSetFlow.paymentOptionId)
                .toList();
            if (payments == null || payments.isEmpty) {
              return;
            } else {
              String paymentMethod = payments.first.paymentMethod;
              if (paymentMethod == null) return;

              if (paymentMethod == GlobalUtils.PAYMENT_CASH) {
                screenBloc.add(PayWireTransferEvent());
              } else if (paymentMethod == GlobalUtils.PAYMENT_STRIPE) {
                screenBloc.add(PayCreditPaymentEvent(cardJson));
              } else {
                screenBloc.add(PayInstantPaymentEvent(paymentMethod: paymentMethod, body: body));
              }
            }
          }
        },
        onTapChangePayment: (num id) {
          print(id);
          screenBloc.add(
              PatchCheckoutFlowOrderEvent(body: {'payment_option_id': '$id'}));
        },
        onChangeCredit: (val) {
          print('Card Json : ' + val.toString());
          cardJson = val;
        },
      ),
    );
  }

  Widget _sendToDeviceView(WorkshopScreenState state) {
    return Visibility(
      visible: isVisible(state, 'send_to_device'),
      child: Column(
        children: <Widget>[
          WorkshopHeader(
            title: Language.getCheckoutStrings('SEND TO DEVICE'),
            isExpanded: _selectedSectionIndex == 3,
            isApproved: isOrderApproved,
            onTap: () {
              setState(() {
                _selectedSectionIndex = _selectedSectionIndex == 3 ? -1 : 3;
              });
            },
          ),
          Visibility(
            visible: _selectedSectionIndex == 3,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 55,
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: TextFormField(
                          style: textFieldStyle,
                          onChanged: (val) {},
                          initialValue: '',
                          decoration: textFieldDecoration(Language.getCheckoutStrings(
                              'checkout_send_flow.form.phoneTo.placeholder')),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black54,
                      ),
                      Container(
                        height: 55,
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: TextFormField(
                          style: textFieldStyle,
                          onChanged: (val) {},
                          initialValue: '',
                          decoration: textFieldDecoration(Language.getCheckoutStrings(
                              'checkout_send_flow.form.email.placeholder')),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 55,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: SizedBox.expand(
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                _selectedSectionIndex++;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: state.isUpdating
                                ? CircularProgressIndicator()
                                : Text(
                              Language.getCheckoutStrings(
                                  'checkout_send_flow.action.skip'),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox.expand(
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                _selectedSectionIndex++;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            color: Colors.black87,
                            child: state.isUpdating
                                ? CircularProgressIndicator()
                                : Text(
                              Language.getCheckoutStrings(
                                  'checkout_send_flow.action.continue'),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentOptionView(WorkshopScreenState state) {
    return Visibility(
      visible: false/*isVisible(state, 'payment')*/,
      child: Column(
        children: <Widget>[
          WorkshopHeader(
            title: 'PAYMENT OPTION',
            subTitle: 'Select payment options',
            isExpanded: _selectedSectionIndex == 5,
            isApproved: isBillingApproved,
            onTap: () {
              setState(() {
                _selectedSectionIndex = _selectedSectionIndex == 5 ? -1 : 5;
              });
            },
          ),
          Visibility(
            visible: _selectedSectionIndex == 5,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 55,
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: TextFormField(
                          style: textFieldStyle,
                          onChanged: (val) {},
                          initialValue: '',
                          decoration: textFieldDecoration('Mobile number'),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black54,
                      ),
                      Container(
                        height: 55,
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: TextFormField(
                          style: textFieldStyle,
                          onChanged: (val) {},
                          initialValue: '',
                          decoration: textFieldDecoration('E-Mail Address'),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 55,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: SizedBox.expand(
                          child: MaterialButton(
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: state.isUpdating
                                ? CircularProgressIndicator()
                                : Text(
                              Language.getCheckoutStrings(
                                  'checkout_send_flow.action.skip'),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox.expand(
                          child: MaterialButton(
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            color: Colors.black87,
                            child: state.isUpdating
                                ? CircularProgressIndicator()
                                : Text(
                              Language.getCheckoutStrings(
                                  'checkout_send_flow.action.continue'),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressView(WorkshopScreenState state) {
    return Visibility(
      visible: isVisible(state, 'address'),
      child: Container(),
    );
  }

  get _divider {
    return Divider(
      height: 0,
      thickness: 0.5,
      color: iconColor(),
    );
  }

  bool isVisible(WorkshopScreenState state, String code) {
    List<Section> sections = state.defaultCheckout.sections
        .where((element) => (element.code == code))
        .toList();
    if (sections.length > 0)
      return sections.first.enabled;
    else
      return false;
  }

  Widget _emailField(WorkshopScreenState state) {
    return Container(
      height: 55,
      padding: EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              style: textFieldStyle,
              onChanged: (val) {
                email = val;
                if (validEmail())
                  screenBloc.add(EmailValidationEvent(email: email));
              },
              initialValue: isAccountApproved ? email : '',
              decoration: textFieldDecoration('E-Mail Address'),
              validator: FieldValidator.email(),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          validEmail()
              ? InkWell(
            onTap: () {
              if (payflowLogin) {
                setState(() {
                  payflowLogin = false;
                });
              } else {
                if (state.isValid && state.isAvailable) {
                  setState(() {
                    email = '';
                  });
                } else {
                  setState(() {
                    payflowLogin = true;
                  });
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: state.isCheckingEmail ? Center(
                child: Container(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2,),
                ),
              ): Text(payflowLogin
                  ? 'Continue as guest'
                  : state.isValid && state.isAvailable
                  ? 'Clear'
                  : 'Login'),
            ),
          )
              : Container(),
        ],
      ),
    );
  }

  Widget _passwordField(WorkshopScreenState state) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        onChanged: (val) {
          password = val;
        },
        decoration: textFieldDecoration('Password'),
        validator: (value) {
          if (value.isEmpty) {
            return 'Password required';
          }
          return null;
        },
        obscureText: true,
        keyboardType: TextInputType.text,
      ),
    );
  }

  bool validEmail() {
    if (email == null || email.length < 3)
      return false;
    return email.contains('@') && email.contains('.');
  }

  void initialize(ChannelSetFlow channelSetFlow) {
    if (channelSetFlow == null) return;
    amount = channelSetFlow.amount == 0 ? 0 : channelSetFlow.amount.toDouble();
    reference =
    channelSetFlow.reference != null ? channelSetFlow.reference : '';
    BillingAddress billingAddress = channelSetFlow.billingAddress;
    if (billingAddress != null) {
      email = billingAddress.email;
      googleAutocomplete = billingAddress.fullAddress ?? '';
      countryCode = billingAddress.country ?? '';
      city = billingAddress.city ?? '';
      street = billingAddress.street ?? '';
      zipCode = billingAddress.zipCode ?? '';

      salutation = billingAddress.salutation ?? '';
      firstName = billingAddress.firstName ?? '';
      lastName = billingAddress.lastName ?? '';
      company = billingAddress.company ?? '';
      phone = billingAddress.phone ?? '';
    }
  }

  void setGoogleAutoComplete() {
    setState(() {
      if (street != null && street.isNotEmpty) {
        googleAutocomplete = street;
      }
      if (zipCode != null && zipCode.isNotEmpty) {
        googleAutocomplete = googleAutocomplete + ', ' + zipCode;
      }
      if (city != null && city.isNotEmpty) {
        googleAutocomplete = googleAutocomplete + ', ' + city;
      }
      print('googleAutocomplete ' + googleAutocomplete);
    });
  }

  void getPrefilledLink(WorkshopScreenState state, bool isCopyLink) {
    if (_formKeyOrder.currentState.validate()) {
      num _amount = state.channelSetFlow.amount;
      String _reference = state.channelSetFlow.reference;
      if (_amount >= 0 && _reference != null) {
        screenBloc.add(GetPrefilledLinkEvent(isCopyLink: isCopyLink));
      } else {
        Fluttertoast.showToast(msg: 'Please set amount and reference.');
      }
    }
  }

  showPaySuccessDialog(WorkshopScreenState state) {
    // if (state.channelSetFlow.payment == null ||
    //     state.channelSetFlow.payment.paymentDetails == null) return;
    // if (state.payResult == null) return;
    showCupertinoDialog(
      context: context,
      builder: (builder) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: PaySuccessView(
            screenBloc: screenBloc,
            channelSetFlow: state.channelSetFlow,
          ),
        );
      },
    );
  }
}
