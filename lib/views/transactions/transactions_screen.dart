import 'dart:ui' as prefix0;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/models/business.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'dart:ui';


import 'package:payever/views/dashboard/transactioncard.dart';
import 'package:payever/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:payever/views/login/login_page.dart';
import 'package:payever/views/transactions/transactions_details_screen.dart';

bool _isPortrait;
bool _isTablet;


class TrasactionScreen extends StatefulWidget {
  ValueNotifier<bool> isLoading       = ValueNotifier(true);
  ValueNotifier<bool> isLoadingSearch = ValueNotifier(true);
  TransactionScreenData data;
  String wallpaper;
  Business _currentBusiness; 
  bool _pos;
  bool initQueryNotEmpty = false;
  ValueNotifier<String> searching = ValueNotifier("");
  String search ="";
  TrasactionScreen(this.wallpaper,this._pos,this._currentBusiness);
  @override
  _TrasactionScreenState createState() => _TrasactionScreenState();

}


class _TrasactionScreenState extends State<TrasactionScreen> {
  @override
  void initState() {
    super.initState();
    widget.isLoading.addListener(listener);
    widget.isLoadingSearch.addListener(listener);
    fetchTransactions(init: true,search: "");
    widget.searching.addListener(listener);
  }
  listener(){
    setState(() {
    });
  }
  fetchTransactions({String search,bool init}){
    RestDatasource api = RestDatasource();
    api.getTransactionList(widget._currentBusiness.id,GlobalUtils.ActiveToken.accessToken,"?orderBy=created_at&direction=desc&limit=50&query=${search}&page=1&currency=${widget._currentBusiness.currency}",context).
      then((obj){
        widget.data = TransactionScreenData(obj,widget.wallpaper);
        print("OUT____");
        if(init) widget.isLoading.value = false;
        widget.isLoadingSearch.value = false;
      }).catchError((onError){
        if(onError.toString().contains("401")){
          GlobalUtils.clearCredentials();
          Navigator.pushReplacement(context,PageTransition(child:LoginScreen() ,type: PageTransitionType.fade));
        }
      });  
  }
  num _quantity ;
  String _currency;
  num _totalAmount;
  var f = new NumberFormat("###,###,##0.00", "en_US");
  bool noTransactions= false;
  String _search ="";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width);
    Measurements.width  = (_isPortrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true; 
      if(widget.data != null){
        _quantity       = widget.data.transaction.paginationData.total??0;
        _currency       = widget.data.currency(widget.data.business.currency);
        _totalAmount    = widget.data.transaction.paginationData.amount??0;
      }
    return Stack(
      children: <Widget>[
        Positioned(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          top: 0.0,
          child: CachedNetworkImage(
                  imageUrl: widget.wallpaper,
                  placeholder: (context, url) =>  Container(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  fit: BoxFit.cover,
                ) 
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25,sigmaY: 25),
          child: Container(
            child: Scaffold(
              backgroundColor: Colors.black.withOpacity(0.2),
              appBar: !widget._pos?AppBar(
                elevation: 0,
                title: !noTransactions && !widget._pos ?AutoSizeText(Language.getTransactionStrings("total_orders.heading").toString().replaceFirst("{{total_count}}", "${_quantity??0}").replaceFirst("{{total_sum}}", "${_currency??"€"}${f.format(_totalAmount??0)}"),overflow: TextOverflow.fade,maxLines: 1,):Container(),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                leading: 
                !widget._pos?InkWell(radius: 20,child: Icon(IconData(58829, fontFamily: 'MaterialIcons')),
                onTap: (){
                  Navigator.pop(context);
                  },
                ):Text(""),
              ):null,
              body:
                Column(
                  children: <Widget>[
                    widget.isLoading.value?Container(): Container(
                          padding: EdgeInsets.only(bottom: Measurements.height * 0.02,left: Measurements.width* (_isTablet?0.01:0.05),right: Measurements.width* (_isTablet?0.01:0.05)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              ),
                            padding:EdgeInsets.only(left: Measurements.width* (_isTablet?0.01:0.025)),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Search",
                                border: InputBorder.none,
                                icon: Container(child:SvgPicture.asset("images/searchicon.svg",height: Measurements.height * 0.0175,color:Colors.white,))
                              ),
                              onFieldSubmitted: (search){
                                widget.search = search;
                                widget.isLoadingSearch.value = true;
                                widget.data.transaction.collection.clear();
                                fetchTransactions(init: false,search: search);
                              },
                            ),
                          ),
                        ),
                    widget.isLoadingSearch.value||widget.isLoading.value? Expanded(child:Center(child:CircularProgressIndicator(),)) : Expanded(child:CustomList(widget._currentBusiness,widget.search,widget.data.transaction.collection,widget.data)),
                  ],
                )
            ),
          )
        )  
      ],
    );
  }
}

class CustomList extends StatefulWidget {
  List<Collection> collection = List();
  Business currentBusiness;
  TransactionScreenData data;
  CustomList(this.currentBusiness,this.search,this.collection,this.data);
  ValueNotifier isLoading = ValueNotifier(false);
  
  String search;
  int page = 1;
  int pageCount;
  @override
  _CustomListState createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  ScrollController controller;
  @override
  void initState() {
    super.initState();
    widget.pageCount = (widget.data.transaction.paginationData.total/50).ceil();
    controller = new ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 500) {
      if(widget.page<widget.pageCount && !widget.isLoading.value){
        setState(() {
          widget.isLoading.value = true;
        });
        widget.page ++;
        RestDatasource().getTransactionList(widget.currentBusiness.id,GlobalUtils.ActiveToken.accessToken,"?orderBy=created_at&direction=desc&limit=50&query=${widget.search}&page=${widget.page}&currency=${widget.currentBusiness.currency}",context).then((transaction){
          List<Collection> temp = Transaction.toMap(transaction).collection;
          if(temp.isNotEmpty){
            setState((){
              widget.isLoading.value = false;
              widget.collection.addAll(temp);
            });
          }
        });
      }
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      controller: controller,
      itemCount: widget.collection.length+1,
      itemBuilder: (BuildContext context, int index) {
        if(index == 0) return _isTablet? TabletTableRow(null,true,null): PhoneTableRow(null,true,null);
        index = index - 1;
        return _isTablet? TabletTableRow(widget.collection[index],false,widget.data): PhoneTableRow(widget.collection[index],false,widget.data);
      },
    );
  }
}


class PhoneTableRow extends StatelessWidget {
  Collection _currentTransaction;
  TransactionScreenData data;
  bool _isHeader;
  PhoneTableRow(this._currentTransaction,this._isHeader,this.data);
  var f = new NumberFormat("###,###.00", "en_US");
  @override
  Widget build(BuildContext context) {
    DateTime time;
    if(_currentTransaction!= null)time = DateTime.parse(_currentTransaction.createdAt);
    return InkWell(
      child: Container(
        alignment: Alignment.topCenter,
        width: Measurements.width,
        padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.05),
        height: Measurements.height * (!_isHeader? 0.07:0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  width: Measurements.width * (_isPortrait? 0.13:0.25),
                  child: !_isHeader? TransactionScreenParts.channelIcon(_currentTransaction.channel) : Container(child:Text(Language.getTransactionStrings("form.filter.labels.channel"),style: TextStyle(fontSize:12),)),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: Measurements.width * (_isPortrait? 0.11:0.2),
                  child: !_isHeader? TransactionScreenParts.paymentType(_currentTransaction.type): Container(child: Text(Language.getTransactionStrings("form.filter.labels.type"),style: TextStyle(fontSize:12)),) ,
                ),
                Container(
                  width: Measurements.width * (_isPortrait? 0.39:0.45),
                  child: !_isHeader? Text(_currentTransaction.customerName):Text(Language.getTransactionStrings("form.filter.labels.customer_name"),style: TextStyle(fontSize:12)),
                ),
                Container(
                  width: Measurements.width * (_isPortrait? 0.22:0.3),
                  child: !_isHeader? Text("${Measurements.currency(_currentTransaction.currency)}${f.format(_currentTransaction.total)}",style:TextStyle(fontSize:13) ,):Text(Language.getTransactionStrings("form.filter.labels.total"),style: TextStyle(fontSize:12)),
                ),
                !_isPortrait? Container(
                  width: Measurements.width * 0.4,
                  child: !_isHeader? Text("${DateFormat.d("en_US").add_MMMM().add_y().format(time)} ${DateFormat.Hm("en_US").format(time.add(Duration(hours: 2)))}"):Text(Language.getTransactionStrings("form.filter.labels.created_at"),style: TextStyle(fontSize:12)),
                ):Container(),
                !_isPortrait? Container(
                  width: Measurements.width * 0.35,
                  child: !_isHeader? Measurements.statusWidget(_currentTransaction.status):Text(Language.getTransactionStrings("form.filter.labels.status"),style: TextStyle(fontSize:12)),
                ):Container(),
                Container(
                  width: Measurements.width * 0.02,
                  child: !_isHeader? Icon(IconData(58849, fontFamily: 'MaterialIcons'),size: Measurements.width *0.04,):Container(),
                ),
              ],
            ),
            Divider()
          ],
        ),
      ),
      onTap: (){
        if(!_isHeader){
          RestDatasource api  = RestDatasource();
          showDialog(context: context,
          barrierDismissible: false,
          builder:(BuildContext context) {
            api.getTransactionDetail(data.business.id, GlobalUtils.ActiveToken.accesstoken,_currentTransaction.uuid,context).then((obj){ 
              var td = TransactionDetails.toMap(obj);
              Navigator.pop(context);
              Navigator.push(context, PageTransition(child:TransactionDetailsScreen(td,data.wallpaper),type:PageTransitionType.fade));
            }).catchError((onError){
              if(onError.toString().contains("401")){
                GlobalUtils.clearCredentials();
                Navigator.pushReplacement(context,PageTransition(child:LoginScreen() ,type: PageTransitionType.fade));
              }else{
                Navigator.pop(context);
                print(onError);
              }
            });
            return Container(
              child: Dialog(
                backgroundColor: Colors.transparent,
                child: Center(
                  child: Container(
                  child: CircularProgressIndicator()),),
              ),
            );
          });
        }
      },
    );
  }
  
  //channels
} 

class TabletTableRow extends StatelessWidget {
  Collection _currentTransaction;
  TransactionScreenData data;
  bool _isHeader;
  TabletTableRow(this._currentTransaction,this._isHeader,this.data);
  var f = new NumberFormat("###,##0.00", "en_US");
  @override
  Widget build(BuildContext context) {
    DateTime time;
    if(_currentTransaction!= null)time = DateTime.parse(_currentTransaction.createdAt);
    return InkWell(
      child: Container(
        width: Measurements.width,
        height: Measurements.height * (!_isHeader? 0.05:0.04),
        padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  width:  Measurements.width * (_isPortrait ?0.07:0.08),
                  child: !_isHeader? TransactionScreenParts.channelIcon(_currentTransaction.channel) : Container(child:AutoSizeText(Language.getTransactionStrings("form.filter.labels.channel"),style: TextStyle(fontSize:12),)),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: Measurements.width * (_isPortrait ?0.06:0.08),
                  child: !_isHeader? TransactionScreenParts.paymentType(_currentTransaction.type): Container(child:AutoSizeText(Language.getTransactionStrings("form.filter.labels.type"),style: TextStyle(fontSize:12))) ,
                ),
                Container(
                  width: Measurements.width * (_isPortrait ?0.27:0.28),
                  child: !_isHeader? AutoSizeText("#${_currentTransaction.id}"): AutoSizeText(Language.getTransactionStrings("form.filter.labels.original_id"),maxLines: 1,textAlign: TextAlign.left,style: TextStyle(fontSize:12)),
                ),
                Container(
                  width: Measurements.width * (_isPortrait ?0.18:0.20),
                  child: !_isHeader? AutoSizeText(_currentTransaction.customerName):AutoSizeText(Language.getTransactionStrings("form.filter.labels.customer_name"),maxLines: 1,style: TextStyle(fontSize:12)),
                ),
                Container(
                  width: Measurements.width * (_isPortrait ?0.11:0.13),
                  child: !_isHeader? AutoSizeText("${Measurements.currency(_currentTransaction.currency)}${f.format(_currentTransaction.total)}"):AutoSizeText(Language.getTransactionStrings("form.filter.labels.total"),maxLines: 1,style: TextStyle(fontSize:12)),
                ),
                Container(
                  width: Measurements.width * (_isPortrait ?0.17:0.25),
                  child: !_isHeader? AutoSizeText("${DateFormat.d("en_US").add_MMMM().add_y().format(time)} ${DateFormat.Hm("en_US").format(time.add(Duration(hours: 2)))}"):Text(Language.getTransactionStrings("form.filter.labels.created_at"),style: TextStyle(fontSize:12)),
                ),
                Container(
                  width: Measurements.width * 0.10,
                  child: !_isHeader? Measurements.statusWidget(_currentTransaction.status):Text(Language.getTransactionStrings("form.filter.labels.status"),style: TextStyle(fontSize:12)),
                ),
              ],
            ),
            Divider()
          ],
        ),
      ),
      onTap: (){
        if(!_isHeader){
          RestDatasource api  = RestDatasource();
          showDialog(
          context: context,
          barrierDismissible: false,
          builder:(BuildContext context) {
            api.getTransactionDetail(data.business.id, GlobalUtils.ActiveToken.accesstoken,_currentTransaction.uuid,context).then((obj){ 
              var td = TransactionDetails.toMap(obj);
              Navigator.pop(context);
              Navigator.push(context, PageTransition(child:TransactionDetailsScreen(td,data.wallpaper),type:PageTransitionType.fade));
            }).catchError((onError){
              Navigator.pop(context);
              print(onError);
            });
            return BackdropFilter(
              filter:ImageFilter.blur(sigmaX: 5,sigmaY: 5),
              child: Container(
                child: Dialog(
                  backgroundColor: Colors.transparent,
                  child: Center(
                    child: Container(
                    child: CircularProgressIndicator()),),
                ),
              ),
            );
          });
        }
      },

    );
  }

} 

class TransactionScreenParts{

  static channelIcon(String channel){
    double size = Measurements.width * (_isTablet? 0.03:0.06); 
    return SvgPicture.asset(Measurements.channelIcon(channel),height:  size);
  }
  static paymentType(String type){
    double size = Measurements.width * (_isTablet? 0.03:0.06); 
    Color _color = Colors.white.withOpacity(0.7);
    return SvgPicture.asset(Measurements.paymentType(type),height: size,color:  _color,);
  }

}
