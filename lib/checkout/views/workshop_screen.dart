import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/checkout/checkout_bloc.dart';
import 'package:payever/blocs/checkout/checkout_state.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/checkout_switch_screen.dart';
import 'package:payever/checkout/widgets/checkout_top_button.dart';
import 'package:payever/checkout/widgets/workshop_header_item.dart';
import 'package:payever/commons/commons.dart';

class WorkshopScreen extends StatefulWidget {
  final CheckoutScreenBloc checkoutScreenBloc;

  const WorkshopScreen({this.checkoutScreenBloc});

  @override
  _WorkshopScreenState createState() => _WorkshopScreenState();
}

class _WorkshopScreenState extends State<WorkshopScreen> {

  int _selectedSectionIndex = 0;
  bool isOrderApproved = true;
  bool isAccountApproved = false;
  bool isSendDeviceApproved = false;
  bool isSelectPaymentApproved = false;
  bool isBillingApproved = false;
  String currency = '';
  bool editOrder = false;

  var controllerAmount = TextEditingController();
  var controllerReference = TextEditingController();

  bool switchCheckout = false;

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controllerAmount.dispose();
    controllerReference.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
      bloc: widget.checkoutScreenBloc,
      builder: (BuildContext context, state) {
        return Container(
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

  Widget _body(CheckoutScreenState state) {

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
                          '${currency}${state.channelSetFlow.amount.toStringAsFixed(2)}',
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
                    padding: EdgeInsets.only(left: 4, right: 4),
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
            Divider(
              height: 0,
              thickness: 0.5,
              color: Colors.black54,
            ),
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
                          Divider(
                            height: 0,
                            thickness: 0.5,
                            color: Colors.black54,
                          ),
                          _sendToDeviceView(state),
                          Divider(
                            height: 0,
                            thickness: 0.5,
                            color: Colors.black54,
                          ),
                          _selectPaymentView(state),
                          Divider(
                            height: 0,
                            thickness: 0.5,
                            color: Colors.black54,
                          ),
                          _billingView(state),
                          Divider(
                            height: 0,
                            thickness: 0.5,
                            color: Colors.black54,
                          ),
                          _accountView(state),
                          Divider(
                            height: 0,
                            thickness: 0.5,
                            color: Colors.black54,
                          ),
                          _paymentOptionView(state),
                          Divider(
                            height: 0,
                            thickness: 0.5,
                            color: Colors.black54,
                          ),
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

  Widget _orderView(CheckoutScreenState state) {
    controllerAmount = TextEditingController(text: (state.channelSetFlow == null || state.channelSetFlow.amount == 0) ? '' : '${state.channelSetFlow.amount}');
    controllerReference = TextEditingController(text: state.channelSetFlow.reference != null ? state.channelSetFlow.reference : '');
    return Column(
      children: <Widget>[
        _cautionTestMode(),
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
                        controller: controllerAmount,
                        validator: (text) {
                          if (text.isEmpty){
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
                      padding: EdgeInsets.only(left: 4, right: 4),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 16,
                          color:Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (val) {
                        },
                        controller: controllerReference,
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
                      if (!state.isUpdating) {
                        widget.checkoutScreenBloc.add(
                            PatchCheckoutFlowEvent(body: {'amount': double.parse(controllerAmount.text), 'reference': controllerReference.text}));
                        _selectedSectionIndex = 1;
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
    );
  }

  Widget _cautionTestMode() {
    return Container();
}
  Widget _editOrderView(CheckoutScreenState state) {
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
                  _selectedSectionIndex = 1;
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

  Widget _sendToDeviceView(CheckoutScreenState state) {
    return Column(
      children: <Widget>[
        WorkshopHeader(
          title: Language.getCheckoutStrings(
              'SEND TO DEVICE'),
          isExpanded: _selectedSectionIndex == 1,
          isApproved: isOrderApproved,
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
    );
  }

  Widget _accountView(CheckoutScreenState state) {
    return Column(
      children: <Widget>[
        WorkshopHeader(
          title: 'Account',
          subTitle: 'Login or enter your email',
          isExpanded: _selectedSectionIndex == 4,
          isApproved: isAccountApproved,
          onTap: () {
            setState(() {
              _selectedSectionIndex = _selectedSectionIndex == 4 ? -1 : 4;
            });
          },
        ),
        Visibility(
          visible: _selectedSectionIndex == 4,
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
                            if (!state.isUpdating) {
                              setState(() {
                                _selectedSectionIndex++;
                              });
                            }
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
    );
  }

  Widget _billingView(CheckoutScreenState state) {
    return Column(
      children: <Widget>[
        WorkshopHeader(
          title: 'BILLING & SHIPPING',
          subTitle: 'Add your billing and shipping address',
          isExpanded: _selectedSectionIndex == 3,
          isApproved: isBillingApproved,
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
    );
  }

  Widget _selectPaymentView(CheckoutScreenState state) {
    return Column(
      children: <Widget>[
        WorkshopHeader(
          title: 'SELECT PAYMENT',
          subTitle: 'Select a payment method',
          isExpanded: _selectedSectionIndex == 2,
          isApproved: isBillingApproved,
          onTap: () {
            setState(() {
              _selectedSectionIndex = _selectedSectionIndex == 2 ? -1 : 2;
            });
          },
        ),
        Visibility(
          visible: _selectedSectionIndex == 2,
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
    );
  }

  Widget _paymentOptionView(CheckoutScreenState state) {
    return Column(
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
    );
  }

  Widget _orderDetailView(CheckoutScreenState state) {
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
                        '${currency}0.00',
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