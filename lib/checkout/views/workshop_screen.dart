import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/checkout/checkout_bloc.dart';
import 'package:payever/blocs/checkout/checkout_state.dart';
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
  Widget build(BuildContext context) {

    return BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
      bloc: widget.checkoutScreenBloc,
      builder: (BuildContext context, state) {
        return Container(
          color: Colors.white,
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
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/images/payeverlogo.svg',
                      color: Colors.black,
                      height: 20,
                      width: 20,
                    ),
                    Text(
                      'Payever',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
                    OutlineButton(
                      child: Text(
                        'Switch Checkout',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      onPressed: () {}, //callback when button is clicked
                      borderSide: BorderSide(
                        color: Colors.black54, //Color of the border
                        style: BorderStyle.solid, //Style of the border
                        width: 0.8, //width of the border
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5,
                color: Colors.black54,
              ),
              Column(
                children: <Widget>[
                  _orderView(state),
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
                  _billingView(state),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderView(CheckoutScreenState state) {
    return Column(
      children: <Widget>[
        WorkshopHeader(
          title: Language.getCheckoutStrings(
              'checkout_order_summary.title'),
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
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('US\$',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Expanded(
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
                                labelText: 'Amount',
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
                          labelText: 'Reference',
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
              InkWell(
                onTap: () {
                  if (!state.isOrdering) {
                    widget.checkoutScreenBloc.add(
                        PatchCheckoutOrderEvent(amount: 100, reference: 'Test'));
                    _selectedSectionIndex = 1;
                    isAccountApproved = true;
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black87,
                  ),
                  child: Center(
                    child: state.isOrdering ?
                    CircularProgressIndicator() :
                    Text(
                      'Next Step',
                      style: TextStyle(
                        fontSize: 20,
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

  Widget _sendToDeviceView(CheckoutScreenState state) {
    return Container();
  }

  Widget _accountView(CheckoutScreenState state) {
    return Column(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        _selectedSectionIndex = 2;
                        isBillingApproved = true;
                      });
                    },
                    elevation: 0,
                    height: 24,
                    minWidth: Measurements.width/2 - 30,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedSectionIndex = 2;
                        isBillingApproved = true;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: Measurements.width/2 - 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black87,
                      ),
                      child: Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {},
                    elevation: 0,
                    height: 24,
                    minWidth: Measurements.width/2 - 30,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      width: Measurements.width/2 - 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black87,
                      ),
                      child: Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentView() {
    return Container();
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