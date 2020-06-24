import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/transaction_detail/transaction_detail.dart';
import 'package:payever/commons/views/screens/login/login_page.dart';

import '../utils/utils.dart';
import '../../commons/models/models.dart';
import '../../commons/views/custom_elements/custom_elements.dart';

class ScreenParts {
  bool isTablet;
  bool isPortrait;
  var f = NumberFormat('###,###,##0.00', 'en_US');
  EdgeInsets padding;

  EdgeInsets animatedPadding;

  TransactionDetails currentTransaction;
  ValueNotifier<int> rowClosed = ValueNotifier(1);
}

class TransactionDetailsScreen extends StatefulWidget {
  final String businessId;
  final String transactionId;

  TransactionDetailsScreen({
    this.businessId,
    this.transactionId,
  });
  @override
  _TransactionDetailsState createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetailsScreen> {
  ScreenParts parts = ScreenParts();

  bool _isTablet = false;
  bool _isPortrait = true;
  TransactionDetailScreenBloc screenBloc = TransactionDetailScreenBloc();

  @override
  void initState() {
    screenBloc.add(TransactionDetailScreenInitEvent(
      businessId: widget.businessId,
      transactionId: widget.transactionId,
    ));
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, TransactionDetailScreenState state) async {
        if (state is TransactionDetailScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<TransactionDetailScreenBloc, TransactionDetailScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text(
                Language.getTransactionStrings('actions.details'),
                style: TextStyle(fontSize: AppStyle.fontSizeAppBar()),
              ),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            body: BackgroundBase(
              true,
              body: OrientationBuilder(
                builder: (BuildContext context, Orientation orientation) {
                  if (state.data != null ) {
                    parts.currentTransaction = state.data;
                    _isPortrait = Orientation.portrait == orientation;
                    print('_isPortrait: $_isPortrait');
                    parts.isPortrait = Orientation.portrait == orientation;
                    Measurements.height = (parts.isPortrait
                        ? MediaQuery.of(context).size.height
                        : MediaQuery.of(context).size.width);
                    Measurements.width = (parts.isPortrait
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.height);
                    _isTablet = Measurements.width < 600 ? false : true;
                    parts.padding = EdgeInsets.symmetric(
                        horizontal: Measurements.width * 0.05,
                        vertical: Measurements.height * 0.01);
                    CustomExpansionTile productRowsList = CustomExpansionTile(
                      scrollable: false,
                      isWithCustomIcon: true,
                      addBorderRadius: true,
                      headerColor: Colors.transparent,
                      widgetsTitleList: <Widget>[
                        orderRowHeader(),
                        shippingRowHeader(),
                        billingRowHeader(),
                        paymentRoWHeader(),
                        timeLineRowHeader(),
                      ],
                      widgetsBodyList: <Widget>[
                        orderRowBody(),
                        shippingRowBody(),
                        billingRowBody(),
                        paymentRowBody(),
                        timeLineRowBody(),
                      ],
                    );
                    return ListView(
                      children: <Widget>[
                        highlightHeaderRow(),
                        Divider(
                          height: 0,
                          thickness: 0.5,
                          color: Colors.black38,
                        ),
                        productRowsList,
                        totalPriceRow(),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  num getCustomNumber(num option1, num option2) {
    return _isTablet ? option1 : option2;
  }

  bool getDeviceOrientation() {
    return _isPortrait;
  }

  Widget highlightHeaderRow() {
    bool _noItem = parts.currentTransaction.cart.items.isEmpty;
    bool havePicture;
    if (_noItem) {
      havePicture = false;
    } else {
      havePicture = parts.currentTransaction.cart.items[0].thumbnail != null;
    }
    Widget title() {
      if (_noItem) {
        return AutoSizeText(
          '#${parts.currentTransaction.transaction.originalID ?? parts.currentTransaction.transaction.uuid}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        );
      } else if (parts.currentTransaction.cart.items.length == 1) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AutoSizeText(
              '${parts.currentTransaction.cart.items[0].name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              softWrap: true,
            ),
            parts.currentTransaction.cart.items[0].options.length > 0 ?
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: AutoSizeText(
                '${parts.currentTransaction.cart.items[0].options[0].name}: ${parts.currentTransaction.cart.items[0].options[0].value}',
                style: TextStyle(
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ):
            Container(),
          ],
        );
      } else {
        return AutoSizeText(
            Language.getTransactionStrings('details.overview.products_number')
                .replaceAll('{{ count }}',
                '${parts.currentTransaction.cart.items.length}'));
      }
    }

    return Padding(
      padding: EdgeInsets.all(0),
      child: Container(
        //color: Colors.white.withOpacity(0.1),
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(children: <Widget>[
              Container(
                width: Measurements.width * getCustomNumber(0.15, 0.25),
                height: Measurements.width * getCustomNumber(0.15, 0.25),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  color:
                  havePicture ? Colors.white : Colors.grey.withOpacity(0.7),
                  image: !havePicture
                      ? null
                      : DecorationImage(
                      image: NetworkImage(parts
                          .currentTransaction.cart.items[0].thumbnail
                          .contains('https:')
                          ? parts.currentTransaction.cart.items[0].thumbnail
                          : Env.storage +
                          '/products/' +
                          parts.currentTransaction.cart.items[0]
                              .thumbnail)),
                ),
                child: havePicture
                    ? Container()
                    : Center(
                  child: SvgPicture.asset(
                    'assets/images/noimage.svg',
                    height: Measurements.height * 0.05,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: Measurements.width * 0.06),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      title(),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                      ),
                      Text(
                        '${Measurements.currency(parts.currentTransaction.transaction.currency)}${parts.currentTransaction.transaction.amountRefunded != 0 ?
                        parts.f.format(parts.currentTransaction.transaction.amountRest) : parts.f.format(parts.currentTransaction.transaction.total)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                      ),
                      Measurements.statusWidget(
                          parts.currentTransaction.status.general),
                      parts.currentTransaction.cart.availableRefundItems.length > 0 ?
                      MaterialButton(
                        height: 32,
                        minWidth: 0,
                        onPressed: () {

                        },
                        child: Text(
                          'Refund',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.black38,
                      ):
                      Container(),
                    ],
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget orderRowHeader() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: Measurements.width * getCustomNumber(0.17, 0.25),
            height: Measurements.height * 0.05,
            child: Text(
              Language.getTransactionStrings('details.order.header'),
              style: TextStyle(
                fontSize: AppStyle.fontSizeTabTitle(),
                color: Colors.white,
              ),
            ),
          ),
          SvgPicture.asset(
            Measurements.channelIcon(parts.currentTransaction.channel.name),
            height: AppStyle.iconTabSize(_isTablet),
          ),
          Padding(
            padding: EdgeInsets.only(left: Measurements.width * 0.01),
          ),
          Text(Measurements.channel(parts.currentTransaction.channel.name),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: AppStyle.fontSizeTabTitle())),
        ],
      ),
    );
  }

  Widget orderRowBody() {
    int ref = parts.currentTransaction.details.reference == null ? 0 : 1;
    int no = parts.currentTransaction.details.applicationNo == null ? 0 : 1;
    int number =
    parts.currentTransaction.details.applicationNumber == null ? 0 : 1;
    int finance = parts.currentTransaction.details.financeId == null ? 0 : 1;
    int pan = parts.currentTransaction.details.panId == null ? 0 : 1;
    int orig = parts.currentTransaction.transaction.originalID == null ? 0 : 1;
    int length = ref + no + number + finance + pan + orig;

    print('Length: $length');

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(Measurements.width * 0.02),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
          // color: Colors.black.withOpacity(0.3),
        ),
        child: Container(
          //height: Measurements.height * getCustomNumber(0.015, 0.06) * length,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: parts.currentTransaction.transaction.originalID !=
                        null
                        ? Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.centerLeft,
                      // height: Measurements.height *
                      //     getCustomNumber(0.015, 0.05),
                      child: RichText(
                          maxLines: 2,
                          text: TextSpan(
                              style: TextStyle(
                                fontSize: AppStyle.fontSizeTabContent(),
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                    text:
                                    '${Language.getTransactionStrings('details.order.payeverId')}: ',
                                    style: TextStyle(
                                        fontSize:
                                        AppStyle.fontSizeTabContent(),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200,
                                    ),
                                ),
                                TextSpan(
                                  text:
                                  '${parts.currentTransaction.transaction.originalID ?? parts.currentTransaction.transaction.uuid}',
                                ),
                              ])),
                    )
                        : Container(),
                  ),
                ],
              ),
              parts.currentTransaction.details.reference != null
                  ? Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(5),
                //height: Measurements.height * getCustomNumber(0.05, 0.05),
                child: RichText(
                    maxLines: 2,
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: AppStyle.fontSizeTabContent(),
                            color: Colors.white),
                        children: [
                          TextSpan(
                              text:
                              '${Language.getTransactionStrings('details.order.reference')}: ',
                              style: TextStyle(
                                fontSize: AppStyle.fontSizeTabContent(),
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                              ),
                          ),
                          TextSpan(
                            text:
                            '${parts.currentTransaction.details.reference}',
                          ),
                        ])),
              )
                  : Container(),
              parts.currentTransaction.details.panId != null
                  ? Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(5),
                // height: Measurements.height * getCustomNumber(0.05, 0.05),
                child: RichText(
                    maxLines: 2,
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: AppStyle.fontSizeTabContent(),
                            color: Colors.white),
                        children: [
                          TextSpan(
                              text:
                              '${Language.getTransactionStrings('details.order.panId')}: ',
                              style: TextStyle(
                                fontSize: AppStyle.fontSizeTabContent(),
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                              ),
                          ),
                          TextSpan(
                            text:
                            '${parts.currentTransaction.details.panId}',
                          ),
                        ])),
              )
                  : Container(),
              parts.currentTransaction.details.applicationNo != null
                  ? Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(5),
                // height: Measurements.height * getCustomNumber(0.05, 0.05),
                child: RichText(
                    maxLines: 2,
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: AppStyle.fontSizeTabContent(),
                            color: Colors.white),
                        children: [
                          TextSpan(
                              text:
                              '${Language.getTransactionStrings('details.order.santanderApplicationId')}: ',
                              style: TextStyle(
                                  fontSize: AppStyle.fontSizeTabContent(),
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                              ),
                          ),
                          TextSpan(
                            text:
                            '${parts.currentTransaction.details.applicationNo}',
                          ),
                        ])),
              )
                  : Container(),
              parts.currentTransaction.details.applicationNumber != null
                  ? Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(5),
                // height: Measurements.height * getCustomNumber(0.05, 0.05),
                child: RichText(
                    maxLines: 2,
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: AppStyle.fontSizeTabContent(),
                            color: Colors.white),
                        children: [
                          TextSpan(
                              text:
                              '${Language.getTransactionStrings('details.order.santanderApplicationId')}: ',
                              style: TextStyle(
                                  fontSize: AppStyle.fontSizeTabContent(),
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                              ),
                          ),
                          TextSpan(
                            text:
                            '${parts.currentTransaction.details.applicationNumber}',
                          ),
                        ])),
              )
                  : Container(),
              parts.currentTransaction.details.financeId != null
                  ? Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(5),
                // height: Measurements.height * getCustomNumber(0.05, 0.05),
                child: RichText(
                    maxLines: 2,
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: AppStyle.fontSizeTabContent(),
                            color: Colors.white),
                        children: [
                          TextSpan(
                              text:
                              '${Language.getTransactionStrings('details.order.paymentId')}: ',
                              style: TextStyle(
                                  fontSize: AppStyle.fontSizeTabContent(),
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                              ),
                          ),
                          TextSpan(
                            text:
                            '${parts.currentTransaction.details.financeId}',
                          ),
                        ])),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget shippingRowHeader() {
    return Container(
        alignment: Alignment.centerLeft,
        height: Measurements.height * 0.05,
        width: Measurements.width * getCustomNumber(0.17, 0.25),
        child: Text(
          Language.getTransactionStrings('details.shipping.header'),
          style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),
        ));
  }

  Widget shippingRowBody() {
    return Expanded(
      child: Container(
        // height: Measurements.height * getCustomNumber(0.07, 0.08),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
          // color: Colors.black.withOpacity(0.3),
        ),
        padding: EdgeInsets.all(Measurements.width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        'Shipping method: ${Measurements.paymentTypeName(parts.currentTransaction.shipping?.methodName?.toUpperCase()??'')}',
                        style: TextStyle(
                            fontSize: AppStyle.fontSizeTabContent(),
                          color: Colors.white,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget billingRowHeader() {
    return Container(
      //height: Measurements.height * 0.07,
//      width:
//      getDeviceOrientation() ? Measurements.width - 73 : Measurements.width - 13,
      width: Measurements.width * 0.75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              constraints: BoxConstraints(
                minWidth: Measurements.width * getCustomNumber(0.17, 0.25),
              ),
              alignment: Alignment.centerLeft,
              height: Measurements.height * getCustomNumber(0.05, 0.06),
              child: Text(
                Language.getTransactionStrings('details.billing.header'),
                style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),
              )),
          SizedBox(
            width: 5,
          ),
//          Container(
//            alignment: Alignment.centerLeft,
//            child: Text(
//                '${Measurements.salutation(parts.currentTransaction.billingAddress.salutation)} ${parts.currentTransaction.billingAddress.firstName} ${parts.currentTransaction.billingAddress.lastName} ',
//                maxLines: 1,
//                overflow: TextOverflow.ellipsis,
//                style: TextStyle(
//                    fontSize: AppStyle.fontSizeTabMid(),
//                    color: Colors.white.withOpacity(0.6))),
//          ),
          Expanded(
            child: Text(
                '${Measurements.salutation(parts.currentTransaction.billingAddress.salutation)} ${parts.currentTransaction.billingAddress.firstName} ${parts.currentTransaction.billingAddress.lastName} ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppStyle.fontSizeTabContent(),
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
            ),
          ),
        ],
      ),
    );
  }

  Widget billingRowBody() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(Measurements.width * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    child: RichText(
                        maxLines: 2,
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: AppStyle.fontSizeTabContent(),
                                color: Colors.white),
                            children: [
                              TextSpan(
                                  text:
                                  '${Language.getTransactionStrings('details.billing.name')}: ',
                                  style: TextStyle(
                                      fontSize: AppStyle.fontSizeTabContent(),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200,
                                  ),
                              ),
                              TextSpan(
                                text:
                                '${Measurements.salutation(parts.currentTransaction.billingAddress.salutation)} ${parts.currentTransaction.billingAddress.firstName} ${parts.currentTransaction.billingAddress.lastName}',
                              ),
                            ])),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    child: RichText(
                        maxLines: 2,
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: AppStyle.fontSizeTabContent(),
                                color: Colors.white),
                            children: [
                              TextSpan(
                                  text:
                                  '${Language.getTransactionStrings('details.billing.email')}: ',
                                  style: TextStyle(
                                      fontSize: AppStyle.fontSizeTabContent(),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200,
                                  ),
                              ),
                              TextSpan(
                                text:
                                '${parts.currentTransaction.billingAddress.email}',
                              ),
                            ])),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    child: RichText(
                        maxLines: 2,
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: AppStyle.fontSizeTabContent(),
                                color: Colors.white),
                            children: [
                              TextSpan(
                                  text:
                                  '${Language.getTransactionStrings('details.billing.address')}: ',
                                  style: TextStyle(
                                      fontSize: AppStyle.fontSizeTabContent(),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200,
                                  ),
                              ),
                              TextSpan(
                                text:
                                '${parts.currentTransaction.billingAddress.street}, ${parts.currentTransaction.billingAddress.zipCode} ${parts.currentTransaction.billingAddress.city}, ${parts.currentTransaction.billingAddress.countryName}',
                              ),
                            ])),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentRoWHeader() {
    return Container(
      width: Measurements.width - 73,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Container(
                alignment: Alignment.centerLeft,
                width: Measurements.width * getCustomNumber(0.17, 0.25),
                child: Text(
                  Language.getTransactionStrings('details.payment.header'),
                  style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),
                )),
          ),
          Measurements.paymentTypeIcon(
              parts.currentTransaction.paymentOption.type, _isTablet),
          Expanded(
            child: Text(
                '  ${Measurements.paymentTypeName(parts.currentTransaction.paymentOption.type)}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
//                softWrap: false,
                style: TextStyle(
                    fontSize: AppStyle.fontSizeTabContent(),
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentRowBody() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
          // color: Colors.black.withOpacity(0.3),
        ),
        padding: EdgeInsets.all(Measurements.width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    child: RichText(
                        maxLines: 2,
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: AppStyle.fontSizeTabContent(),
                                color: Colors.white),
                            children: [
                              TextSpan(
                                  text:
                                  '${Language.getTransactionStrings('details.payment.type')}: ',
                                  style: TextStyle(
                                      fontSize: AppStyle.fontSizeTabContent(),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200,
                                  ),
                              ),
                              TextSpan(
                                text:
                                '${Measurements.paymentTypeName(parts.currentTransaction.paymentOption.type)}',
                              ),
                            ])),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: parts.currentTransaction.details.iban != null
                      ? Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.centerLeft,
                      child: RichText(
                          maxLines: 2,
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: AppStyle.fontSizeTabContent(),
                                  color: Colors.white),
                              children: [
                                TextSpan(
                                    text:
                                    '${Language.getTransactionStrings('details.payment.iban')}: ',
                                    style: TextStyle(
                                        fontSize:
                                        AppStyle.fontSizeTabContent(),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200,
                                    ),
                                ),
                                TextSpan(
                                  text:
                                  '**** ${parts.currentTransaction.details.iban.replaceAll(' ', '').substring(parts.currentTransaction.details.iban.replaceAll(' ', '').length - 4)}',
                                ),
                              ])))
                      : Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget timeLineRowHeader() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              height: Measurements.height * 0.05,
              width: Measurements.width * getCustomNumber(0.4, 0.35),
              child: Text(
                Language.getTransactionStrings('details.history.header'),
                style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),
              )),
        ],
      ),
    );
  }

  Widget timeLineRowBody() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(Measurements.width * 0.02),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
          // color: Colors.black.withOpacity(0.3),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: parts.currentTransaction.history.length,
          itemBuilder: (BuildContext context, int index) {
            DateTime time = DateTime.parse(
                parts.currentTransaction.history[index].createdAt);
            return Container(
              child: Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                    maxLines: 2,
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: AppStyle.fontSizeTabContent(),
                            color: Colors.white),
                        children: [
                          TextSpan(
                              text:
                              '${DateFormat.d('en_US').add_MMM().add_y().format(time)} ${DateFormat.Hm('en_US').format(time.add(Duration(hours: 2)))}  ',
                              style: TextStyle(
                                  fontSize: AppStyle.fontSizeTabContent(),
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                              ),
                          ),
                          TextSpan(
                            text:
                            '${Measurements.actions(parts.currentTransaction.history[index].action, parts.currentTransaction.history[index], parts.currentTransaction)}',
                          ),
                        ])),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget totalPriceRow() {
    return Container(
      child: Container(
        //color: Colors.white.withOpacity(0.1),
          padding: parts.padding,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: Measurements.height * 0.015),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      Language.getTransactionStrings(
                          'form.refund.products_table.subtotal'),
                      style: TextStyle(
                        fontSize: AppStyle.fontSizeTabTitle(),
                      ),
                    ),
                    Text(
                      '${Measurements.currency(parts.currentTransaction.transaction.currency)}${parts.f.format(parts.currentTransaction.transaction.amount)}',
                      style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),
                    )
                  ],
                ),
              ),
              parts.currentTransaction.transaction.amountRefunded != 0
                  ? Container(
                  padding:
                  EdgeInsets.only(bottom: Measurements.height * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        Language.getTransactionStrings(
                            'details.totals.refunded'),
                        style: TextStyle(
                            fontSize: AppStyle.fontSizeTabTitle()),
                      ),
                      Text(
                        '-${Measurements.currency(parts.currentTransaction.transaction.currency)}${parts.f.format(parts.currentTransaction.transaction.amountRefunded)}',
                        style: TextStyle(
                            fontSize: AppStyle.fontSizeTabTitle()),
                      )
                    ],
                  ))
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Language.getTransactionStrings(
                        'details.totals.total_incl_tax'),
                    style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),
                  ),
                  Text(
                    '${Measurements.currency(parts.currentTransaction.transaction.currency)}${parts.f.format(parts.currentTransaction.transaction.total)}',
                    style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
