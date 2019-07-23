import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payever/models/transaction.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:payever/views/switcher/switcher_page.dart';




class ScreenParts{
  bool isTablet;
  bool isPortrait;
  var f = new NumberFormat("###,###,##0.00", "en_US");
  EdgeInsets padding ;
  EdgeInsets animatedpadding ;
  TransactionDetails currentTransaction;
  ValueNotifier<int> rowClosed = ValueNotifier(1);
}

class TransactionDetailsScreen extends StatefulWidget {
  TransactionDetails currentTransaction;
  ScreenParts parts;
  String _wallpaper;
  TransactionDetailsScreen(this.currentTransaction,this._wallpaper);

  HeaderRow   headerRow;
  OrderNRow   orderNRow;
  BillingRow  billingRow;
  PaymentRow  paymentRow;
  TimelineRow timelineRow;
  TotalRow    totalRow;
  ShippingRow shippingRow;

  @override
  _TransactionDetailsState createState() => _TransactionDetailsState();
}


class _TransactionDetailsState extends State<TransactionDetailsScreen> {
  
  @override
  void initState() {
    super.initState();
    print("start init");
    widget.parts = ScreenParts();
    widget.parts.currentTransaction = widget.currentTransaction;
    widget.headerRow = HeaderRow(openedRow: widget.parts.rowClosed, parts: widget.parts,);
    widget.orderNRow = OrderNRow(openedRow: widget.parts.rowClosed, parts: widget.parts);
    widget.billingRow = BillingRow(openedRow: widget.parts.rowClosed, parts: widget.parts);
    widget.paymentRow = PaymentRow(openedRow: widget.parts.rowClosed, parts: widget.parts);
    widget.timelineRow = TimelineRow(openedRow: widget.parts.rowClosed, parts: widget.parts);
    widget.shippingRow = ShippingRow(openedRow: widget.parts.rowClosed, parts: widget.parts);
    widget.totalRow   = TotalRow(parts: widget.parts);
  }

  @override
  Widget build(BuildContext context) {
   return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
      widget.parts.isPortrait = Orientation.portrait == orientation;
        Measurements.height = (widget.parts.isPortrait ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width);
        Measurements.width  = (widget.parts.isPortrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height);
        widget.parts.isTablet        = Measurements.width < 600 ? false : true;
        widget.parts.padding         = EdgeInsets.symmetric(horizontal: Measurements.width *0.05,vertical: Measurements.height * 0.01);
        widget.parts.animatedpadding = EdgeInsets.symmetric(horizontal: Measurements.width *(widget.parts.isTablet? 0.03:0.05));
        return Stack(
        children: <Widget>[
          Positioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            top: 0.0,
            child: CachedNetworkImage(
              imageUrl: widget._wallpaper,
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.black.withOpacity(0.2),
            appBar:  AppBar(
            title: Text(Language.getTransactionStrings("actions.details")),
            centerTitle: true,  
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: InkWell(radius: 20,child: Icon(IconData(58829, fontFamily: 'MaterialIcons')),
            onTap: (){
              Navigator.pop(context);
              },
            
            ),
            ),
            body: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
              child: OrientationBuilder(
                builder: (BuildContext context, Orientation orientation) {
                  Measurements.height = (widget.parts.isPortrait ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width);
                  Measurements.width  = (widget.parts.isPortrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height);
                  widget.parts.isTablet = Measurements.width < 600 ? false : true;  
                  return DetailBody(billingRow: widget.billingRow, headerRow: widget.headerRow, orderNRow: widget.orderNRow, paymentRow: widget.paymentRow, timelineRow: widget.timelineRow, totalRow: widget.totalRow,shippingRow:widget.shippingRow);
                },),
            )
          )
        ]
      ); 
      },
       
    );
  }

}

class DetailBody extends StatefulWidget {
  HeaderRow   headerRow;
  OrderNRow   orderNRow;
  BillingRow  billingRow;
  PaymentRow  paymentRow;
  TimelineRow timelineRow;
  TotalRow    totalRow;
  ShippingRow shippingRow;
  DetailBody({@required this.headerRow,@required this.orderNRow,@required this.billingRow,@required this.paymentRow,@required this.timelineRow,@required this.totalRow ,@required this.shippingRow ,});
  @override
  _DetailBodyState createState() => _DetailBodyState();
}

class _DetailBodyState extends State<DetailBody> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            widget.headerRow,
            widget.orderNRow,
            widget.shippingRow,
            widget.billingRow,
            widget.paymentRow,
            widget.timelineRow,
            widget.totalRow
          ],
        );
      },);
  }
}

class HeaderRow extends StatefulWidget {
  ScreenParts parts;
  ValueNotifier<int> openedRow;
  bool isOpen = false;
  HeaderRow({@required this.parts,@required this.openedRow});
  @override
  _HeaderRowState createState() => _HeaderRowState();
}

class _HeaderRowState extends State<HeaderRow> {
    listener() {
    setState(() {
      if (widget.openedRow.value == 0) {
        widget.isOpen = !widget.isOpen;
      } else {
        widget.isOpen = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.openedRow.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    bool _noItem = widget.parts.currentTransaction.cart.items.isEmpty;
    bool havePicture;
    bool showItems= false;
    if(_noItem){
      havePicture= false;
    }else{
      havePicture = widget.parts.currentTransaction.cart.items[0].thumbnail != null;
    }
    Widget title(){
      if(_noItem){
        return Text("#${widget.parts.currentTransaction.transaction.originalID??widget.parts.currentTransaction.transaction.uuid}",overflow: TextOverflow.ellipsis,);
      }else if(widget.parts.currentTransaction.cart.items.length == 1){
        return Text("${widget.parts.currentTransaction.cart.items[0].name}");
      }else{
        showItems = true;
        return Text(Language.getTransactionStrings("details.overview.products_number").replaceAll("{{ count }}", "${widget.parts.currentTransaction.cart.items.length}"));
      }
    }
    return Container(
      child:Container(
      padding: widget.parts.padding,
      child: Column(
        children: <Widget>[
          InkWell(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width:  Measurements.width * (widget.parts.isTablet?0.15: 0.25),
                          height: Measurements.width * (widget.parts.isTablet?0.15: 0.25),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                            color: havePicture?Colors.white:Colors.grey.withOpacity(0.7),
                          ),
                          child: havePicture? Image.network(widget.parts.currentTransaction.cart.items[0].thumbnail):Center(child:SvgPicture.asset("images/noimage.svg",height: Measurements.height *0.05,color: Colors.white.withOpacity(0.6),),),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: Measurements.width * 0.06),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: <Widget>[
                              title(),
                              Text("${Measurements.currency(widget.parts.currentTransaction.transaction.currency)}${widget.parts.currentTransaction.transaction.amountRefunded!=0?widget.parts.f.format(widget.parts.currentTransaction.transaction.amountRest):widget.parts.f.format(widget.parts.currentTransaction.transaction.total)}"),
                              Measurements.statusWidget(widget.parts.currentTransaction.status.general),
                            ],
                          ),
                        ),
                      ]
                    ),
                    showItems?AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      child:  widget.isOpen?Icon(Icons.remove,color: Colors.white.withOpacity(0.6),) : Icon(Icons.add,color: Colors.white.withOpacity(0.6),),
                    ):Container(),
                  ],
                ),
                showItems?Padding(padding: EdgeInsets.only(top: Measurements.height *0.02),):Container(),
                showItems?AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  //padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.05),
                  //padding: widget.parts.animatedpadding,
                  height: !widget.isOpen ? 0: Measurements.width *(widget.parts.isTablet ? 0.14:0.24)*widget.parts.currentTransaction.cart.items.length,
                  child:  widget.isOpen ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.parts.currentTransaction.cart.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(Measurements.width *0.02),
                              child: Row(
                                children: <Widget>[
                                    Container(
                                      width: Measurements.width * (widget.parts.isTablet?0.10: 0.20),
                                      height: Measurements.width * (widget.parts.isTablet?0.10: 0.20),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(12),
                                        color: widget.parts.currentTransaction.cart.items[index].thumbnail != null?Colors.white:Colors.grey.withOpacity(0.7),
                                      ),
                                      child: widget.parts.currentTransaction.cart.items[index].thumbnail != null? Image.network(widget.parts.currentTransaction.cart.items[index].thumbnail,fit: BoxFit.contain,):Center(child:SvgPicture.asset("images/noimage.svg",height: Measurements.height *0.05,color: Colors.white.withOpacity(0.6),),),
                                    ),
                                    Padding(padding: EdgeInsets.only(left: Measurements.width * 0.02),),//
                                    Text("${widget.parts.currentTransaction.cart.items[index].name}"),
                                    Padding(padding: EdgeInsets.only(left: Measurements.width * 0.02),),//
                                    widget.parts.currentTransaction.cart.items[index].quantity > 1 ?Text("${widget.parts.currentTransaction.cart.items[index].quantity}"):Text(""),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(Measurements.width * 0.01),
                              child: Text((widget.parts.currentTransaction.cart.items[index].price < 0 ?"-":"")+"${Measurements.currency(widget.parts.currentTransaction.transaction.currency)}${widget.parts.currentTransaction.cart.items[index].quantity * widget.parts.currentTransaction.cart.items[index].price.abs()}"),
                            ),
                          ],
                        );
                      },
                    ),
                  ):Container(),

                ):Container(),
              ],
            ),
            onTap: (){
              widget.openedRow.notifyListeners();
              widget.openedRow.value = 0;
            },
          ),
          !widget.isOpen? Divider(color: Colors.white.withOpacity(0.25),):Container(),
        ],
      ),
      ),
    );
  }
}

class OrderNRow extends StatefulWidget {
  ScreenParts parts;
  ValueNotifier<int> openedRow;
  bool isOpen = false;
  int length;
  OrderNRow({@required this.parts,@required this.openedRow});
  @override
  _OrderNRowState createState() => _OrderNRowState();
}

class _OrderNRowState extends State<OrderNRow> {
    listener() {
    setState(() {
      if (widget.openedRow.value == 1) {
        widget.isOpen = !widget.isOpen;
      } else {
        widget.isOpen = false;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.openedRow.addListener(listener);
    int ref     = widget.parts.currentTransaction.details.reference == null? 0:1;
    int usage   = widget.parts.currentTransaction.details.usage_text == null? 0:1;
    int no      = widget.parts.currentTransaction.details.application_no == null? 0:1;
    int number  = widget.parts.currentTransaction.details.application_number == null? 0:1;
    int finance = widget.parts.currentTransaction.details.finance_id == null? 0:1;
    int pan     = widget.parts.currentTransaction.details.pan_id == null? 0:1;
    int orig     = widget.parts.currentTransaction.transaction.originalID== null? 0:1;
    widget.length = ref + usage + no + number + finance + pan + orig;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: InkWell(
              child: Container(
                padding: widget.parts.padding,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      height: Measurements.height * 0.05,
                      width: Measurements.width * (widget.parts.isTablet?0.17: 0.25),
                      child: Text(Language.getTransactionStrings("details.order.header"),style: TextStyle(fontSize: 17),)
                    ),
                    Expanded(
                      child: 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              SvgPicture.asset(Measurements.channelIcon(widget.parts.currentTransaction.channel.name),height: Measurements.height* (widget.parts.isTablet? 0.02:0.025),),
                              Padding(padding: EdgeInsets.only(left: Measurements.width * 0.01),),
                              Text(Measurements.channel(widget.parts.currentTransaction.channel.name),style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 17),)
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top:Measurements.height *0.015),),
                          Container(child: Text("${Language.getTransactionStrings("details.order.payeverId")} ${widget.parts.currentTransaction.transaction.originalID??widget.parts.currentTransaction.transaction.uuid}",maxLines: 2,style: TextStyle(color: Colors.white.withOpacity(0.6),),overflow: TextOverflow.ellipsis,)),  
                          //payever id
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      child:  !widget.isOpen? Icon(Icons.add,color: Colors.white.withOpacity(0.6),) : Icon(Icons.remove,color: Colors.white.withOpacity(0.6),),
                    )
                  ],
                ),
              ),
              onTap: (){
                setState(() {
                  widget.openedRow.notifyListeners();
                  widget.openedRow.value = 1;
                });
              },
              splashColor: Colors.transparent,
            )
          ),
          AnimatedContainer(
            height: !widget.isOpen?0:((Measurements.height * (widget.parts.isTablet?0.015:0.05) * (widget.length))+ Measurements.height * 0.03 ),
            duration: Duration(milliseconds: 200),
            padding: widget.parts.animatedpadding,
            child: Container(
              padding: EdgeInsets.all(Measurements.width * 0.02),  
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.3),
              ),
              child: Container(
                height: ((Measurements.height * (widget.parts.isTablet?0.015:0.04) * (widget.length))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    widget.parts.currentTransaction.transaction.originalID!=null      ? Container(alignment:Alignment.centerLeft,height: Measurements.height * (widget.parts.isTablet?0.015:0.05),child: Text("${Language.getTransactionStrings("details.order.payeverId")}: ${widget.parts.currentTransaction.transaction.originalID??widget.parts.currentTransaction.transaction.uuid}",maxLines: 2,                 style: TextStyle(color: Colors.white.withOpacity(0.6))),):Container(),
                    widget.parts.currentTransaction.details.reference!=null           ? Container(alignment:Alignment.centerLeft,height: Measurements.height * (widget.parts.isTablet?0.015:0.05),child: Text("${Language.getTransactionStrings("details.order.reference")}: ${widget.parts.currentTransaction.details.reference}",                 style: TextStyle(color: Colors.white.withOpacity(0.6))),):Container(),
                    widget.parts.currentTransaction.details.pan_id!=null              ? Container(alignment:Alignment.centerLeft,height: Measurements.height * (widget.parts.isTablet?0.015:0.05),child: Text("${Language.getTransactionStrings("details.order.panId")}: ${widget.parts.currentTransaction.details.pan_id}",                       style: TextStyle(color: Colors.white.withOpacity(0.6))),):Container(),
                    widget.parts.currentTransaction.details.application_no!=null      ? Container(alignment:Alignment.centerLeft,height: Measurements.height * (widget.parts.isTablet?0.015:0.05),child: Text("${Language.getTransactionStrings("details.order.santanderApplicationId")}: ${widget.parts.currentTransaction.details.application_no}",       style: TextStyle(color: Colors.white.withOpacity(0.6))),):Container(),
                    widget.parts.currentTransaction.details.application_number!=null  ? Container(alignment:Alignment.centerLeft,height: Measurements.height * (widget.parts.isTablet?0.015:0.05),child: Text("${Language.getTransactionStrings("details.order.santanderApplicationId")}: ${widget.parts.currentTransaction.details.application_number}",style: TextStyle(color: Colors.white.withOpacity(0.6))),):Container(),
                    widget.parts.currentTransaction.details.finance_id!=null          ? Container(alignment:Alignment.centerLeft,height: Measurements.height * (widget.parts.isTablet?0.015:0.05),child: Text("${Language.getTransactionStrings("details.order.paymentId")}: ${widget.parts.currentTransaction.details.finance_id}",               style: TextStyle(color: Colors.white.withOpacity(0.6))),):Container(),
                    widget.parts.currentTransaction.details.usage_text!=null          ? Container(alignment:Alignment.centerLeft,height: Measurements.height * (widget.parts.isTablet?0.015:0.05),child: Text("Usage Text: ${widget.parts.currentTransaction.details.usage_text}",             style: TextStyle(color: Colors.white.withOpacity(0.6))),):Container(),
                  ],
                ),
              ),
            ) ,
          ),
          !widget.isOpen? Divider(color: Colors.white.withOpacity(0.25),):Container(),
        ]
      ),
    );
  }
}

class TotalRow extends StatefulWidget {
  ScreenParts parts;
  TotalRow({@required this.parts});
  @override
  _TotalRowState createState() => _TotalRowState();
}

class _TotalRowState extends State<TotalRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: widget.parts.padding,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: Measurements.height * 0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(Language.getTransactionStrings("form.refund.products_table.subtotal"),style: TextStyle(fontSize: 17),),
                  Text("${Measurements.currency(widget.parts.currentTransaction.transaction.currency)}${widget.parts.f.format(widget.parts.currentTransaction.transaction.amount)}",style: TextStyle(fontSize: 17),)
                ],
              ),
            ),
            widget.parts.currentTransaction.transaction.amountRefunded != 0 ?
            Container(
              padding: EdgeInsets.only(bottom: Measurements.height * 0.015),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(Language.getTransactionStrings("details.totals.refunded"),style: TextStyle(fontSize: 17),),
                  Text("-${Measurements.currency(widget.parts.currentTransaction.transaction.currency)}${widget.parts.f.format(widget.parts.currentTransaction.transaction.amountRefunded)}",style: TextStyle(fontSize: 17),)
                ],
              )
            ):Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(Language.getTransactionStrings("details.totals.total_incl_tax"),style: TextStyle(fontSize: 17),),
                Text("${Measurements.currency(widget.parts.currentTransaction.transaction.currency)}${widget.parts.f.format(widget.parts.currentTransaction.transaction.total)}",style: TextStyle(fontSize: 17),)
              ],
            ),

          ],
        )
      ),
    );
  }
}

class TimelineRow extends StatefulWidget {
  ScreenParts parts;
  ValueNotifier<int> openedRow;
  TimelineRow({@required this.parts,@required this.openedRow});
  bool isOpen= false;
  @override
  _TimelineRowState createState() => _TimelineRowState();
}

class _TimelineRowState extends State<TimelineRow> {
    listener() {
    setState(() {
      if (widget.openedRow.value == 4) {
        widget.isOpen = !widget.isOpen;
      } else {
        widget.isOpen = false;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.openedRow.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
                child: InkWell(
                  child: Container(
                    padding: widget.parts.padding,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          height: Measurements.height * 0.05,
                          width: Measurements.width * (widget.parts.isTablet?0.4: 0.25),
                          child: Text(Language.getTransactionStrings("details.history.header"),style: TextStyle(fontSize: 17),)
                        ),
                        Container(
                          width: widget.parts.isTablet?Measurements.width * 0.45: Measurements.width * 0.55),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          child:  widget.parts.currentTransaction.history.length!=0?(!widget.isOpen? Icon(Icons.add,color: Colors.white.withOpacity(0.6),) : Icon(Icons.remove,color: Colors.white.withOpacity(0.6),)):Container(),
                        )
                      ],
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      widget.openedRow.notifyListeners();
                      widget.openedRow.value = 4;
                    });
                  },
                  splashColor: Colors.transparent,
                )
              ),
              AnimatedContainer(
                height: !widget.isOpen?0:( Measurements.height *(widget.parts.isTablet?0.015:0.032) * widget.parts.currentTransaction.history.length)+Measurements.height * 0.03,
                duration: Duration(milliseconds: 200),
                padding: widget.parts.animatedpadding,
                child: Container( 
                  padding: EdgeInsets.all(Measurements.width * 0.02),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.parts.currentTransaction.history.length,
                    itemBuilder: (BuildContext context, int index) {
                      DateTime time = DateTime.parse(widget.parts.currentTransaction.history[index].createdAt);
                      return Container(
                        child: Container(
                          height: Measurements.height * (widget.parts.isTablet?0.015:0.04),
                          child: Row(
                            children: <Widget>[
                              Text("${DateFormat.d("en_US").add_MMM().add_y().format(time)} ${DateFormat.Hm("en_US").format(time.add(Duration(hours: 2)))}",style: TextStyle(color: Colors.white.withOpacity(0.6)),),
                              Padding(padding: EdgeInsets.only(left: Measurements.width * 0.02),),
                              AutoSizeText("${Measurements.actions(widget.parts.currentTransaction.history[index].action,widget.parts.currentTransaction.history[index],widget.parts.currentTransaction)}",style: TextStyle(color: Colors.white),),
                            ],
                          ),
                        ),
                      );
                    },),
                ) ,
              ),
              !widget.isOpen? Divider(color: Colors.white.withOpacity(0.25),):Container(),
        ],
      ),
    );
  }
}


class BillingRow extends StatefulWidget {
  ScreenParts parts;
  ValueNotifier<int> openedRow;
  bool isOpen= false;
  BillingRow({@required this.parts,@required this.openedRow});
  @override
  _BillingRowState createState() => _BillingRowState();
}

class _BillingRowState extends State<BillingRow> {
  listener() {
    setState(() {
      if (widget.openedRow.value == 2) {
        widget.isOpen = !widget.isOpen;
      } else {
        widget.isOpen = false;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.openedRow.addListener(listener);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
                child: InkWell(
                  child: Container(
                    height: Measurements.height * 0.07,
                    padding: widget.parts.padding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          height: Measurements.height * 0.05,
                          width: Measurements.width * (widget.parts.isTablet?0.17: 0.25),
                          child: Text(Language.getTransactionStrings("details.billing.header"),style: TextStyle(fontSize: 17),)
                        ),
                        Expanded(
                          child: Text("${Measurements.salutation(widget.parts.currentTransaction.billingAddress.salutation)} ${widget.parts.currentTransaction.billingAddress.firstName} ${widget.parts.currentTransaction.billingAddress.lastName}",style: TextStyle(color: Colors.white.withOpacity(0.6))),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          child:  !widget.isOpen? Icon(Icons.add,color: Colors.white.withOpacity(0.6),) : Icon(Icons.remove,color: Colors.white.withOpacity(0.6),),
                        )
                      ],
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      widget.openedRow.notifyListeners();
                      widget.openedRow.value = 2;
                    });
                  },
                  splashColor: Colors.transparent,
                )
              ),
              AnimatedContainer(
                height: !widget.isOpen?0: Measurements.height * (widget.parts.isTablet?0.1:0.13) ,
                duration: Duration(milliseconds: 200),
                padding: widget.parts.animatedpadding,
                child: Container( 
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  padding: EdgeInsets.all(Measurements.width * 0.02), 
                  child: Row(
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(height:Measurements.height * (widget.parts.isTablet?0.015:0.03),child: Text("${Language.getTransactionStrings("details.billing.name")}: ${Measurements.salutation(widget.parts.currentTransaction.billingAddress.salutation)} ${widget.parts.currentTransaction.billingAddress.firstName} ${widget.parts.currentTransaction.billingAddress.lastName}",style: TextStyle(fontSize: 13,color: Colors.white.withOpacity(0.7)),)),
                          Container(height:Measurements.height * (widget.parts.isTablet?0.015:0.03),child: Text("${Language.getTransactionStrings("details.billing.email")}: ${widget.parts.currentTransaction.billingAddress.email}",style: TextStyle(fontSize: 13,color: Colors.white.withOpacity(0.7)),)),
                          Container(height:Measurements.height * (widget.parts.isTablet?0.015:0.03),child: Text("${Language.getTransactionStrings("details.billing.address")}: ${widget.parts.currentTransaction.billingAddress.street}, ${widget.parts.currentTransaction.billingAddress.zipCode} ${widget.parts.currentTransaction.billingAddress.city}, ${widget.parts.currentTransaction.billingAddress.countryName}",maxLines: 2,style: TextStyle(fontSize: 13,color: Colors.white.withOpacity(0.7)),)),
                        ],
                      ),
                    ],
                  ),
                ) ,
              ),
              !widget.isOpen? Divider(color: Colors.white.withOpacity(0.25),):Container(),
        ],
      ),
    );
  }
}

class PaymentRow extends StatefulWidget {
  
  ValueNotifier<int> openedRow;
  ScreenParts parts;
  bool isOpen= false;
  PaymentRow({@required this.openedRow,@required this.parts});
  @override
  _PaymentRowState createState() => _PaymentRowState();
}

class _PaymentRowState extends State<PaymentRow> {
    listener() {
    setState(() {
      if (widget.openedRow.value == 3) {
        widget.isOpen = !widget.isOpen;
      } else {
        widget.isOpen = false;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.openedRow.addListener(listener);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
                child: InkWell(
                  child: Container(
                    padding: widget.parts.padding,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          height: Measurements.height * 0.05,
                          width: Measurements.width * (widget.parts.isTablet?0.17: 0.25),
                          child: Text(Language.getTransactionStrings("details.payment.header"),style: TextStyle(fontSize: 17),)
                        ),
                        Measurements.paymentTypeIcon(widget.parts.currentTransaction.paymentOption.type,widget.parts.isTablet),
                        Expanded(child: Text("  ${Measurements.paymentTypeName(widget.parts.currentTransaction.paymentOption.type)}",overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white.withOpacity(0.6))),),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          child:  !widget.isOpen? Icon(Icons.add,color: Colors.white.withOpacity(0.6),) : Icon(Icons.remove,color: Colors.white.withOpacity(0.6),),
                        )
                      ],
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      widget.openedRow.notifyListeners();
                      widget.openedRow.value = 3;
                    });
                  },
                  splashColor: Colors.transparent,
                )
              ),
              AnimatedContainer(
                height: !widget.isOpen? 0: ((Measurements.height * (widget.parts.isTablet?0.03:0.05)) + (Measurements.height * 0.02) + (widget.parts.currentTransaction.details.iban==null? 0 : (Measurements.height *0.03))),
                duration: Duration(milliseconds: 200),
                padding: widget.parts.animatedpadding,
                child: Container( 
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  padding: EdgeInsets.all(Measurements.width * 0.02), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(height:Measurements.height * (widget.parts.isTablet?0.015:0.04),
                      alignment: Alignment.centerLeft,
                      child: Text("${Language.getTransactionStrings("details.payment.type")}: ${Measurements.paymentTypeName(widget.parts.currentTransaction.paymentOption.type)}",style: TextStyle(fontSize: 13,color: Colors.white.withOpacity(0.7)),)),
                      widget.parts.currentTransaction.details.iban != null?Container(height:Measurements.height * 0.03,alignment: Alignment.centerLeft,
                        child: Text("${Language.getTransactionStrings("details.payment.iban")}: **** ${widget.parts.currentTransaction.details.iban.replaceAll(" ", "").substring(widget.parts.currentTransaction.details.iban.replaceAll(" ", "").length-4)}",style: TextStyle(color: Colors.white.withOpacity(0.7)),),
                       ):Container(),
                    ],
                  ),
                ) ,
              ),
              !widget.isOpen? Divider(color: Colors.white.withOpacity(0.25),):Container(),
        ],
      ),
    );
  }
}




class ShippingRow extends StatefulWidget {
  ValueNotifier<int> openedRow;
  ScreenParts parts;
  bool isOpen= false;
  ShippingRow({@required this.openedRow,@required this.parts});
  @override
  _ShippingRow createState() => _ShippingRow();
}

class _ShippingRow extends State<ShippingRow> {
    listener() {
    setState(() {
      if (widget.openedRow.value == 6) {
        widget.isOpen = !widget.isOpen;
      } else {
        widget.isOpen = false;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.openedRow.addListener(listener);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
                child: InkWell(
                  child: Container(
                    padding: widget.parts.padding,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          height: Measurements.height * 0.05,
                          width: Measurements.width * (widget.parts.isTablet?0.17: 0.25),
                          child: Text(Language.getTransactionStrings("details.shipping.header"),style: TextStyle(fontSize: 17),)
                        ),
                        //Measurements.paymentTypeIcon(widget.parts.currentTransaction.paymentOption.type,widget.parts.isTablet),
                        //Expanded(child: Text("  ${Measurements.paymentTypeName(widget.parts.currentTransaction.paymentOption.type)}",overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white.withOpacity(0.6))),),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          child:  !widget.isOpen? Icon(Icons.add,color: Colors.white.withOpacity(0.6),) : Icon(Icons.remove,color: Colors.white.withOpacity(0.6),),
                        )
                      ],
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      widget.openedRow.notifyListeners();
                      widget.openedRow.value = 6;
                    });
                  },
                  splashColor: Colors.transparent,
                )
              ),
              AnimatedContainer(
                height: !widget.isOpen? 0: ((Measurements.height * (widget.parts.isTablet?0.03:0.05)) + (Measurements.height * 0.02) ),
                duration: Duration(milliseconds: 200),
                padding: widget.parts.animatedpadding,
                child: Container( 
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  padding: EdgeInsets.all(Measurements.width * 0.02), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(height:Measurements.height * (widget.parts.isTablet?0.015:0.04),
                      alignment: Alignment.centerLeft,
                      child: Text("Shipping method: ${Measurements.paymentTypeName(widget.parts.currentTransaction.shipping.methodName.toUpperCase())}",style: TextStyle(fontSize: 13,color: Colors.white.withOpacity(0.7)),)),
                      // widget.parts.currentTransaction.details.iban != null?Container(height:Measurements.height * 0.03,alignment: Alignment.centerLeft,
                      //   child: Text("IBAN: **** ${widget.parts.currentTransaction.details.iban.replaceAll(" ", "").substring(widget.parts.currentTransaction.details.iban.replaceAll(" ", "").length-4)}",style: TextStyle(color: Colors.white.withOpacity(0.7)),),
                      //  ):Container(),
                    ],
                  ),
                ) ,
              ),
              !widget.isOpen? Divider(color: Colors.white.withOpacity(0.25),):Container(),
        ],
      ),
    );
  }
}