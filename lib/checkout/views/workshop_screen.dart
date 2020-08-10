import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
  final Function onOpen;

  WorkshopScreen({this.checkoutScreenBloc, this.onOpen,});

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
  double progress = 0;
  String url = '';
  InAppWebViewController webView;

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
            onTap: () {
              widget.onOpen(url);
            },
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
    if (state.channelSet == null) {
      return Container();
    }
    String checkoutUrl = 'https://checkout.payever.org/pay/create-flow/channel-set-id/${state.channelSet.id}';
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(0.0),
              child: progress < 1.0
                  ? LinearProgressIndicator(value: progress)
                  : Container()
          ),
          Expanded(
            child: InAppWebView(
              initialUrl: checkoutUrl,
              initialHeaders: {},
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: true,
                  )
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart: (InAppWebViewController controller, String url) {
                setState(() {
                  this.url = url;
                });
              },
              onLoadStop: (InAppWebViewController controller, String url) async {
                setState(() {
                  this.url = url;
                });
              },
              onProgressChanged: (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
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