import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/checkout/checkout_bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/workshop/subview/payment_select_view.dart';
import 'package:payever/checkout/widgets/checkout_top_button.dart';
import 'package:payever/checkout/widgets/workshop_header_item.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/widgets/address_field_group.dart';
import 'package:payever/widgets/googlemap_address_filed.dart';
import 'package:payever/widgets/peronal_name_field.dart';

import '../../../theme.dart';
import 'checkout_switch_screen.dart';

class WorkshopScreen1 extends StatefulWidget {
  final CheckoutScreenBloc checkoutScreenBloc;

  const WorkshopScreen1({this.checkoutScreenBloc});

  @override
  _WorkshopScreen1State createState() => _WorkshopScreen1State();
}

class _WorkshopScreen1State extends State<WorkshopScreen1> {
  int _selectedSectionIndex = 0;
  bool isOrderApproved = true;
  bool isAccountApproved = false;
  bool isBillingApproved = false;
  bool isSendDeviceApproved = false;
  bool isSelectPaymentApproved = false;

  String currency = '';
  bool editOrder = false;

  double amount = 0;
  String reference;

  String email;
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
  final _formKeyOrder = GlobalKey<FormState>();
  final _formKeyAccount = GlobalKey<FormState>();
  final _formKeyBilling = GlobalKey<FormState>();
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

  WorkshopScreenBloc screenBloc;

  @override
  void initState() {
    screenBloc = WorkshopScreenBloc(checkoutScreenBloc: widget.checkoutScreenBloc);
    screenBloc.add(WorkshopScreenInitEvent(
      business: widget.checkoutScreenBloc.state.business,
      checkoutFlow: widget.checkoutScreenBloc.state.checkoutFlow,
      channelSetFlow: widget.checkoutScreenBloc.state.channelSetFlow,
      defaultCheckout: widget.checkoutScreenBloc.state.defaultCheckout,
    ));
    initialize(widget.checkoutScreenBloc.state.channelSetFlow);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, WorkshopScreenState state) async {
        if (state is WorkshopScreenPayflowStateSuccess) {
          setState(() {
            switch(_selectedSectionIndex) {
              case 0:
                // isOrderApproved = true;
                break;
              case 2:
                isBillingApproved = true;
                break;
              default:
                break;
            }
            _selectedSectionIndex ++;
          });
        }
      },
      child: BlocBuilder<WorkshopScreenBloc, WorkshopScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, state) {
          return state.defaultCheckout == null ? Container() :
          Container(
            child: Column(
              children: <Widget>[
                _topBar(),
                Flexible(
                  child: _body(state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _topBar() {
    return Container(
      height: 50,
      color: Colors.black87,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Text(
            'Your checkout',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {},
            child: Container(
              height: 30,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  'Open',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10,),
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: PopupMenuButton<CheckOutPopupButton>(
              child: Icon(
                Icons.more_horiz,
                color: Colors.black,
              ),
              offset: Offset(0, 100),
              onSelected: (CheckOutPopupButton item) => item.onTap(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.black87,
              itemBuilder: (BuildContext context) {
                return _morePopup(context).map((CheckOutPopupButton item) {
                  return PopupMenuItem<CheckOutPopupButton>(
                    value: item,
                    child: Row(
                      children: <Widget>[
                        item.icon,
                        SizedBox(width: 8,),
                        Text(
                          item.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ),
          SizedBox(width: 10,),
        ],
      ),
    );
  }

  Widget _body(WorkshopScreenState state) {
    Business business = widget.checkoutScreenBloc.dashboardScreenBloc.state.activeBusiness;
    String currencyString = business.currency;
    NumberFormat format = NumberFormat();
    currency = format.simpleCurrencySymbol(currencyString);

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
    return Container(
      color: Colors.white,
      child: Container(
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
                  editOrder ? MaterialButton(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.black54,
                          size: 24,
                        ),
                        Text(
                          'Pay',
                          style: TextStyle(
                            color: Colors.black54,
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
                    color: Colors.black,
                    height: 16,
                  ),
                  Spacer(),
                  isOrderApproved ? MaterialButton(
                    child: Row(
                      children: <Widget>[
                        Text(
                          state.channelSetFlow != null ? '$currency${state.channelSetFlow.amount.toStringAsFixed(2)}': '',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black54,
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
                  ): Container(),
                  Spacer(),
                  MaterialButton(
                    child: Text(
                      'Switch Checkout',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        switchCheckout = true;
                      });
                    }, //callback when button is clicked
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
                    editOrder ? Container(
                        width: Measurements.width,
                        padding: EdgeInsets.only(left: 16, right: 16, top: 16,),
                        child: _editOrderView(state)
                    )
                        : Container(
                      width: Measurements.width,
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16,),
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
                          _sendToDeviceView(state),
                          _divider,
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
    String title = 'Caution. Your checkout is in test mode. You just can test but there will be no regular transactions. In order to have real transactions please switch your checkout to live.';
    return Visibility(
        visible: state.defaultCheckout.settings.testingMode,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.deepOrange,
          child: Text(title, style: TextStyle(color: Colors.white),),)
    );
  }

  Widget _editOrderView(WorkshopScreenState state) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            children: <Widget>[
              Container(
                child: TextFormField(
                  style: TextStyle(
                    fontSize: 16,
                    color:Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                  onChanged: (val) {
                  },
                  initialValue: '',
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      width: 44,
                      child: Center(
                        child: Text(
                          currency,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    labelText: Language.getCartStrings('checkout_cart_edit.form.label.amount'),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    ),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Divider(height: 1,color: Colors.black54,),
              Container(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: TextFormField(
                  style: TextStyle(
                    fontSize: 16,
                    color:Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                  onChanged: (val) {
                  },
                  initialValue: '',
                  decoration: InputDecoration(
                    labelText: Language.getCartStrings('checkout_cart_edit.form.label.reference'),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                  ),
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
          height: 50,
          child: SizedBox.expand(
            child: MaterialButton(
              onPressed: () {
                if (!state.isUpdating) {
//                  widget.checkoutScreenBloc.add(
//                      PatchCheckoutOrderEvent(amount: 100, reference: 'Test'));
                  _selectedSectionIndex = 2;
                  isAccountApproved = true;
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              color: Colors.black87,
              child: state.isUpdating ?
              CircularProgressIndicator() :
              Text(
                'Save',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20,),
      ],
    );
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
              title: Language.getCheckoutStrings('checkout_order_summary.title'),
              isExpanded: _selectedSectionIndex == 0,
              isApproved: isOrderApproved,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 0 ? -1 : 0;
                });
              },
            ),
            Visibility(
              visible: _selectedSectionIndex == 0,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 50,
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 16,
                              color:Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                            initialValue: amount > 0 ? '$amount' : '',
                            onChanged: (val) {
                              amount = double.parse(val);
                            },
                            validator: (text) {
                              if (text.isEmpty || double.parse(text) <= 0){
                                return 'Amount required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Container(
                                width: 44,
                                child: Center(
                                  child: Text(
                                    currency,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              labelText: Language.getCartStrings('checkout_cart_edit.form.label.amount'),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0.5,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 0.5,
                                ),
                              ),
                              isDense: true,
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Divider(height: 1,color: Colors.black54,),
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 4, right: 4),
                          alignment: Alignment.center,
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 16,
                              color:Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            onChanged: (val) {
                              reference = val;
                            },
                            initialValue: reference,
                            validator: (text) {
                              if (text.isEmpty){
                                return 'Reference required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: Language.getCartStrings('checkout_cart_edit.form.label.reference'),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0.5,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 0.5,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                            ),
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
                    height: 50,
                    child: SizedBox.expand(
                      child: MaterialButton(
                        onPressed: () {
                          if (_formKeyOrder.currentState.validate() && !state.isUpdating) {
                            screenBloc.add(
                                PatchCheckoutFlowOrderEvent(body: {'amount': amount, 'reference': reference}));
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        color: Colors.black87,
                        child: state.isUpdating && state.updatePayflowIndex == 0 ?
                        CircularProgressIndicator() :
                        Text(
                          'Next Step',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
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
      padding: EdgeInsets.only(top: 16, bottom: 16,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              child: Text(
                Language.getCheckoutStrings('checkout_order_summary.title').toUpperCase(),
                style: TextStyle(
                  color: Colors.black54,
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
                        Language.getCartStrings('checkout_cart_edit.form.label.subtotal').toUpperCase(),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '${currency}${state.channelSetFlow.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.black54,
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
                        Language.getCartStrings('checkout_cart_view.payment_costs').toUpperCase(),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '${currency}0.00',
                        style: TextStyle(
                          color: Colors.black54,
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
                        Language.getCartStrings('checkout_cart_view.shipping').toUpperCase(),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '${currency}0.00',
                        style: TextStyle(
                          color: Colors.black54,
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
                        Language.getCartStrings('checkout_cart_view.total').toUpperCase(),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        state.channelSetFlow != null ? '$currency${state.channelSetFlow.amount.toStringAsFixed(2)}': '',
                        style: TextStyle(
                          color: Colors.black87,
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
              subTitle: 'Login or enter your email',
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
                        _emailField(),
                        _divider,
                        GoogleMapAddressField(
                          googleAutocomplete: googleAutocomplete,
                          height: 50,
                          onChanged: (val) {
                            googleAutocomplete = val;
                          },
                        ),
                        _divider,
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    child: SizedBox.expand(
                      child: MaterialButton(
                        onPressed: () {
                          if (_formKeyAccount.currentState.validate()) {
                            setState(() {
                              _selectedSectionIndex++;
                              isAccountApproved = true;
                            });
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        color: Colors.black87,
                        child: Text(
                          Language.getCheckoutStrings('checkout_send_flow.action.continue'),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billingView(WorkshopScreenState state) {
    return Column(
      children: <Widget>[
        WorkshopHeader(
          title: 'BILLING & SHIPPING',
          subTitle: 'Add your billing and shipping address',
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
                          radius: 0,
                          child: _emailField(isInitValue: true)),
                      SizedBox(height: 2,),
                      PersonalNameField(
                        salutation: salutation,
                        firstName: firstName,
                        lastName: lastName,
                        height: 50,
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
                      SizedBox(height: 2,),
                      AddressFieldGroup(
                        googleAutocomplete: googleAutocomplete,
                        city: city,
                        countryCode: countryCode,
                        street: street,
                        zipCode: zipCode,
                        height: 50,
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
                      SizedBox(height: 2,),
                      BlurEffectView(
                        color: overlayRow(),
                        radius: 0,
                        child: Container(
                          height: 50,
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 16,
                              color:Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            onChanged: (val) {
                              company = val;
                            },
                            initialValue: company,
                            decoration: InputDecoration(
                              labelText: 'Company',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0.5,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 0.5,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12,  vertical: 4),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                      SizedBox(height: 2,),
                      BlurEffectView(
                        color: overlayRow(),
                        radius: 0,
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 16,
                              color:Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            onChanged: (val) {
                              phone = val;
                            },
                            initialValue: phone,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0.5,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 0.5,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                            ),
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
                  height: 50,
                  child: SizedBox.expand(
                    child: MaterialButton(
                      onPressed: () {
                        Map<String, dynamic> body = {
                          'city': 'Berlin',
                          'company': company,
                          'country': 'DE',
                          'email': 'abiantgmbh@payever.de',
                          'first_name': 'Artur',
                          'full_address': 'Germaniastraße, 12099, 12099 Berlin, Germany',
                          'id': state.channelSetFlow.billingAddress.id,
                          'last_name': 'S',
                          'phone': phone,
                          'salutation': 'SALUTATION_MR',
                          'select_address': '',
                          'social_security_number': '',
                          'street': 'Germaniastraße, 12099',
                          'street_name': 'Germaniastraße',
                          'street_number': '12099',
                          'type': 'billing',
                          'zip_code': 'billing',
                        };
                        screenBloc
                            .add(PatchCheckoutFlowAddressEvent(body: body));
                        // if (countryCode == null || countryCode.isEmpty) {
                        //   Fluttertoast.showToast(msg: 'Country is needed');
                        //   return;
                        // }
                        // if (salutation == null || salutation.isEmpty) {
                        //   Fluttertoast.showToast(msg: 'Salutation is needed');
                        //   return;
                        // }
                        // if (_formKeyBilling.currentState.validate() && !state.isUpdating) {
                        //   Map<String, dynamic> body = {
                        //     'city': city,
                        //     'company': company,
                        //     'country': countryCode,
                        //     'email': email,
                        //     'first_name': firstName,
                        //     'full_address': googleAutocomplete,
                        //     'id': state.channelSetFlow.billingAddress.id,
                        //     'last_name': lastName,
                        //     'phone': phone,
                        //     'salutation': salutation,
                        //     'select_address': '',
                        //     'social_security_number': '',
                        //     'street': street,
                        //     'street_name': street,
                        //     'street_number': "12099",
                        //     'type': 'billing',
                        //     'zip_code': zipCode,
                        //   };
                        //   print('body: $body');
                        //   screenBloc
                        //       .add(PatchCheckoutFlowAddressEvent(body: body));
                        // }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      color: Colors.black87,
                      child: state.isUpdating && state.updatePayflowIndex == 1 ?
                      CircularProgressIndicator() :
                      Text(
                        Language.getCheckoutStrings('checkout_send_flow.action.continue'),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _selectPaymentView(WorkshopScreenState state) {
    return PaymentSelectView(
      enable: isVisible(state, 'choosePayment'),
      approved: isSelectPaymentApproved,
      isUpdating: state.isUpdating,
      paymentOptions: state.channelSetFlow.paymentOptions,
      paymentOptionId: state.channelSetFlow.paymentOptionId,
      expanded: _selectedSectionIndex == 3,
      onTapApprove: () {
        setState(() {
          _selectedSectionIndex = _selectedSectionIndex == 3 ? -1 : 3;
        });
      },
      onTapPay: () {
        setState(() {
          _selectedSectionIndex++;
        });
      },
    );
  }

  Widget _sendToDeviceView(WorkshopScreenState state) {
    return Visibility(
      visible: isVisible(state, 'send_to_device'),
      child: Column(
        children: <Widget>[
          WorkshopHeader(
            title: Language.getCheckoutStrings(
                'SEND TO DEVICE'),
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
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 16,
                            color:Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                          onChanged: (val) {
                          },
                          initialValue: '',
                          decoration: InputDecoration(
                            labelText: Language.getCheckoutStrings('checkout_send_flow.form.phoneTo.placeholder'),
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0.5,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 0.5,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Divider(height: 1,color: Colors.black54,),
                      Container(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 16,
                            color:Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                          onChanged: (val) {
                          },
                          initialValue: '',
                          decoration: InputDecoration(
                            labelText: Language.getCheckoutStrings('checkout_send_flow.form.email.placeholder'),
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0.5,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 0.5,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                          ),
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
                  height: 50,
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
                            child: state.isUpdating ?
                            CircularProgressIndicator() :
                            Text(
                              Language.getCheckoutStrings('checkout_send_flow.action.skip'),
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
                            child: state.isUpdating ?
                            CircularProgressIndicator() :
                            Text(
                              Language.getCheckoutStrings('checkout_send_flow.action.continue'),
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
                SizedBox(height: 20,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentOptionView(WorkshopScreenState state) {
    return Visibility(
      visible: isVisible(state, 'payment'),
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
                        height: 50,
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 16,
                            color:Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                          onChanged: (val) {
                          },
                          initialValue: '',
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 16, right: 16),
                            labelText: 'Mobile number',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            enabledBorder: InputBorder.none,
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Divider(height: 1,color: Colors.black54,),
                      Container(
                        height: 50,
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 16,
                            color:Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                          onChanged: (val) {
                          },
                          initialValue: '',
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 16, right: 16),
                            labelText: 'E-Mail Address',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            enabledBorder: InputBorder.none,
                          ),
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
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: SizedBox.expand(
                          child: MaterialButton(
                            onPressed: () {
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: state.isUpdating ?
                            CircularProgressIndicator() :
                            Text(
                              Language.getCheckoutStrings('checkout_send_flow.action.skip'),
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
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            color: Colors.black87,
                            child: state.isUpdating ?
                            CircularProgressIndicator() :
                            Text(
                              Language.getCheckoutStrings('checkout_send_flow.action.continue'),
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
                SizedBox(height: 20,),
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
      color: Colors.black54,
    );
  }

  bool isVisible(WorkshopScreenState state, String code) {
    List<Section> sections = state.defaultCheckout.sections.where((element) => (element.code == code)).toList();
    if (sections.length > 0)
      return sections.first.enabled;
    else
      return false;
  }

  Widget _emailField({bool isInitValue = false}) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: TextFormField(
        style: TextStyle(
          fontSize: 16,
          color:Colors.black,
          fontWeight: FontWeight.w400,
        ),
        onChanged: (val) {
          email = val;
        },
        initialValue: (isInitValue || isAccountApproved) ? email : '',
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12,  vertical: 4),
          labelText: 'E-Mail Address',
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
          enabledBorder: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Username or email is required!';
          }
          if (!value.contains('@')) {
            return 'Enter valid email address';
          }
          return null;
        },
        keyboardType: TextInputType.text,
      ),
    );
  }

  void initialize(ChannelSetFlow channelSetFlow) {
    if (channelSetFlow == null)
      return;
    amount = channelSetFlow.amount == 0 ? 0 : channelSetFlow.amount.toDouble();
    reference = channelSetFlow.reference != null ? channelSetFlow.reference : '';
    BillingAddress billingAddress = channelSetFlow.billingAddress;
    if (billingAddress != null) {
      email = billingAddress.email;
      googleAutocomplete = billingAddress.fullAddress  ??'';
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

  List<CheckOutPopupButton> _morePopup(BuildContext context) {
    return [
      CheckOutPopupButton(
        title: 'Copy pay link',
        icon: SvgPicture.asset(
          'assets/images/pay_link.svg',
          width: 16,
          height: 16,
        ),
        onTap: () async {
          setState(() {});
        },
      ),
      CheckOutPopupButton(
        title: 'Copy prefilled link',
        icon: SvgPicture.asset(
          'assets/images/prefilled_link.svg',
          width: 16,
          height: 16,
        ),
        onTap: () async {
          setState(() {});
        },
      ),
      CheckOutPopupButton(
        title: 'E-mail prefilled link',
        icon: SvgPicture.asset(
          'assets/images/email_link.svg',
          width: 16,
          height: 16,
        ),
        onTap: () async {
          setState(() {});
        },
      ),
      CheckOutPopupButton(
        title: 'Prefilled QR code',
        icon: SvgPicture.asset(
          'assets/images/prefilled_qr.svg',
          width: 16,
          height: 16,
        ),
        onTap: () async {
          setState(() {});
        },
      ),
    ];
  }
}