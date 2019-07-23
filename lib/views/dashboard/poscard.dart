import 'dart:math';
import 'dart:ui';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' ;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' ;
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/models/business.dart';
import 'package:payever/models/pos.dart';
import 'package:payever/models/transaction.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/dashboard/dashboard_screen.dart';
import 'package:payever/views/dashboard/dashboardcard.dart';
import 'package:payever/views/pos/edit_terminal.dart';
import 'package:payever/views/pos/native_pos_screen.dart';
import 'package:payever/views/pos/pos_screen.dart';




class POSCard extends StatefulWidget {

  String _appName;
  ImageProvider _imageProvider;
  String _wallpaper;
  Business _business;
  POSCardParts _parts;
  POSNavigation _posNavigation;
  String _help;
  

  POSCard(this._appName,this._imageProvider,this._business,this._wallpaper,this._help){

  }
  @override
  _POSCardState createState() => _POSCardState();
}

class _POSCardState extends State<POSCard> {

  _POSCardState(){
    
  }
  @override
  void initState() {
    widget._parts = POSCardParts(widget._help,widget._business);
    widget._parts._wallpaper = widget._wallpaper;
    widget._posNavigation = POSNavigation(widget._parts);
    super.initState();
    RestDatasource api = RestDatasource();
    api.getTerminal(widget._business.id, GlobalUtils.ActiveToken.accesstoken,context).then((terminals){
      terminals.forEach((terminal){
        widget._parts._terminals.add(Terminal.toMap(terminal));
      });
      if(terminals.isEmpty){
        widget._parts._noTerminals = true;
        widget._parts._mainCardLoading.value = false;
      }
    }).then((_){
      api.getChannelSet(widget._business.id,GlobalUtils.ActiveToken.accesstoken,context).then((channelsets){
          channelsets.forEach((chset){
            widget._parts._chSets.add(ChannelSet.toMap(chset));
          });
        }).then((_){
          widget._parts.terminals.forEach((terminal){
            print(terminal.name);
            widget._parts._chSets.forEach((chset){
              if(terminal.channelSet == chset.id){
                api.getcheckoutIntegration(widget._business.id ,chset.checkout, GlobalUtils.ActiveToken.accesstoken,context).then((paymentMethods){
                  paymentMethods.forEach((pm){
                    terminal.paymentMethods.add(pm);
                  });
                  api.getLastWeek(widget._business.id ,chset.id, GlobalUtils.ActiveToken.accesstoken,context).then((days){
                    int length = days.length - 1;
                    for(int i = length;i > length-7;i--){
                      terminal.lastweekAmount += Day.map(days[i]).amount;
                    }
                    days.forEach((day){
                      terminal.lastWeek.add(Day.map(day));
                      }
                    );
                    api.getPopularWeek(widget._business.id ,chset.id, GlobalUtils.ActiveToken.accesstoken,context).then((products){
                      products.forEach((product){
                        terminal.bestSales.add(Product.toMap(product));                        
                      });
                    }).then((_){
                      widget._parts._secondCardLoading.value = false;
                    });
                  });
                }).then((_){
                    for(int i = 0;i<widget._parts._terminals.length;i++){
                      widget._parts._terminalcards.add(TerminalCard(widget._parts,i));
                      widget._parts._salesCards.add(ProductCard(widget._parts,i));
                    }
                    widget._parts.index.value = widget._parts._terminals.indexWhere((term)=>term.active);
                    
                    if((terminal.id == widget._parts.terminals.last.id) && (widget._parts._chSets.last.id == chset.id)){
                      widget._parts._mainCardLoading.value = false;
                      print("finish");
                    }
                    CardParts.currentTerminal = widget._parts._terminals[widget._parts.index.value];
                });
              }
            });
          });
          setState(() {});
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        widget._parts._isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
        Measurements.height = (widget._parts._isPortrait ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width);
        Measurements.width  = (widget._parts._isPortrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height);
        widget._parts._isTablet = Measurements.width < 600 ? false : true; 
        return DashboardCard(widget._appName, widget._imageProvider, MainPOSCard(widget._parts),POSSecondCard(widget._parts), widget._posNavigation,!widget._parts._noTerminals);
      },
    );
  }
}

class POSCardParts{
  
  Business business;
  String _wallpaper;
  List<Terminal> _terminals        = List();
  List<TerminalCard> _terminalcards = List();
  List<Terminal> get terminals =>_terminals;
  List<ProductCard> _salesCards = List();
  List<ProductCard> get salesCards => _salesCards;

  num _lastWeek = 0;

  List<ChannelSet> _chSets = List();
  List<ChannelSet> get chSets =>_chSets;

  List<String> _paymentMethods = List();
  List<String> get paymentMethods => _paymentMethods;

  var _mainCardLoading   = ValueNotifier(true);
  var _secondCardLoading = ValueNotifier(true);
  var index = ValueNotifier(0);

  Widget _mainCard;
  Widget _secondCard;

  bool _isTablet = false;
  bool _isPortrait =true;
  bool _noTerminals = false;
  
  String IMAGE_BASE    = Env.Storage + '/images/';
  String help;

   
  String numberFilter(double n,bool chart){
  var million  = NumberFormat("##0.00", "en_US");
  var thousand = NumberFormat("##0.0", "en_US");
  var hundred  = NumberFormat("##0.0", "en_US");
    bool dec;
    if(!chart){
      if(n>=10000 && n<1000000){
        n = (n/1000);
        dec = n.truncate() - n == 0.0;
        return thousand.format(n) + "k";
      }else if(n>1000000){
        n= n/1000000;
        return million.format(n) + "M";
      }else{
        dec = n.truncate() - n == 0.0;
        return  hundred.format(n);
      }
    }else{
      if(n>1000 && n<1000000){
        n = (n/1000);
        return thousand.format(n) + "k";
      }else if(n>1000000){
          n= n/1000000;
        return million.format(n) + "M";
      }else{
        return hundred.format(n);
      }
    }
  }

  POSCardParts(this.help,this.business);

}

class POSNavigation implements CardContract{

  POSCardParts _parts;
  POSNavigation(this._parts);
  
  @override
  void loadScreen(BuildContext context,ValueNotifier state) {
    state.value =false;
    state.notifyListeners();
    
    Navigator.push(context, PageTransition(child:NativePosScreen(terminal:_parts._terminals[_parts.index.value],business:_parts.business),type:PageTransitionType.fade));
  }

  @override
  String learnMore() {
    return _parts.help;
  }

}


class MainPOSCard extends StatefulWidget {
  POSCardParts _parts;
  double _cardSize ;
  
  MainPOSCard(this._parts){
    _cardSize = Measurements.height *(_parts._isTablet? 0.03:0.07);
  }
  
  @override
  _MainPOSCardState createState() => _MainPOSCardState();
}

class _MainPOSCardState extends State<MainPOSCard> {
      @override
      void initState() {
        super.initState();
        widget._parts._mainCardLoading.addListener(listener);
        widget._parts.index.addListener(listener);
      }
      
      @override
      Widget build(BuildContext context) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
          widget._parts._isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
          return !widget._parts._noTerminals? Container(
          height: widget._cardSize * (widget._parts._isTablet? 2.5:2),
          child: (!widget._parts._mainCardLoading.value && widget._parts.index.value != -1 )?Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              widget._parts._terminalcards[widget._parts.index.value],
              InkWell(
                child: Container(
                  width: Measurements.width * 0.1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      widget._parts._terminals.length > 1 ?SvgPicture.asset("images/arrowposicon.svg",color: Colors.white.withOpacity(0.6),height:  (widget._cardSize * (widget._parts._isTablet? 2.5:2)* 0.5 ),):Container(),
                    ],),
                ),
                onTap: (){
                  setState((){
                   if(widget._parts._terminals.length > 1 ) {
                     widget._parts.index.value = widget._parts.index.value == (widget._parts._terminals.length - 1)?
                      widget._parts.index.value = 0:widget._parts.index.value +1;
                     }
                    
                  });
                },
              ),
            ],):Center(child:CircularProgressIndicator()),
          ):!widget._parts._mainCardLoading.value? NoTerminalWidget(widget._parts):Center(child:CircularProgressIndicator());
          },
        );
      }

  void listener() {
    setState(() {});
  }
}

class TerminalCard extends StatefulWidget {
  POSCardParts _parts;
  int index;
  double _cardSize;
  TerminalCard(this._parts,this.index){
    _cardSize = Measurements.height * (_parts._isTablet?0.07:0.13);
  }
  @override
  _TerminalCardState createState() => _TerminalCardState();
}

class _TerminalCardState extends State<TerminalCard> {
  String initials(String name){
    String displayName;
    if(name.contains(" ")){
      displayName = name.substring(0,1);
      displayName = displayName + name.split(" ")[1].substring(0,1);
    }else{
      displayName = name.substring(0,1) + name.substring(name.length-1);
    }
    return displayName = displayName.toUpperCase();
  }
  @override
  Widget build(BuildContext context){
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        widget._parts._isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
        var cardRadius =widget._cardSize/(widget._parts._isTablet? 2.5:2.8);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget._parts._terminals[widget.index].logo !=null ? CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.5),
                radius: cardRadius,
                backgroundImage: NetworkImage(widget._parts.IMAGE_BASE + widget._parts._terminals[widget.index].logo),
              ):CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.5),
                radius: cardRadius,
                child: Container( 
                  child: Container(
                    child:Text(initials(widget._parts._terminals[widget.index].name),style: widget._parts._isTablet? Styles.noAvatarTablet:Styles.noAvatarPhone,),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: Measurements.width * 0.02) ),
              Container(
                width: Measurements.width * (widget._parts._isTablet?(0.22):(widget._parts._isPortrait? 0.26:0.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AutoSizeText("${widget._parts.terminals[widget.index].name}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: widget._parts._isTablet?20:15 ),overflow: TextOverflow.ellipsis,maxLines: 1,),
                    Padding(padding: EdgeInsets.only(bottom: Measurements.width * (widget._parts._isTablet?0.02:0.025)),),
                    InkWell(
                      child: Container(child: Text(Language.getConnectStrings("actions.edit"),style: TextStyle(color: Colors.white.withOpacity(0.7)),),padding:EdgeInsets.symmetric(vertical: Measurements.width * 0.005,horizontal: Measurements.width * 0.03) ,decoration: BoxDecoration( borderRadius:BorderRadius.circular( 16),color: Colors.grey.withOpacity(0.6) ),),
                      onTap: (){
                        Navigator.push(context, PageTransition(child:EditTerminal(widget._parts._wallpaper,widget._parts._terminals[widget._parts.index.value].name,widget._parts._terminals[widget._parts.index.value].logo,widget._parts._terminals[widget._parts.index.value].id,widget._parts._terminals[widget._parts.index.value].business,widget._parts._terminals[widget._parts.index.value],widget._parts.business),type:PageTransitionType.fade));
                      },),
                  ],),
              ),
              Container(
                width: Measurements.width * (widget._parts._isTablet?(0.2):(widget._parts._isPortrait? 0.22:0.4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: Measurements.width * (widget._parts._isTablet?(0.2):(widget._parts._isPortrait? 0.22:0.4)),
                      child: AutoSizeText(Language.getWidgetStrings("widgets.pos.payment-methods"),minFontSize: 8,maxLines: 1,)
                    ),
                    Padding(padding: EdgeInsets.only(bottom: Measurements.width * (widget._parts._isTablet?0.02:0.025)),),
                    PaymentMethods(widget._parts.terminals[widget.index].paymentMethods,widget._parts._isTablet),
                  ],),
              ),
          ],
        );
      },);
  }
}


class PaymentMethods extends StatefulWidget {
  List<String> pm = List();
  List<String> pmcleand = List();
  bool _isTablet;
  PaymentMethods(this.pm,this._isTablet);
  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  @override
  Widget build(BuildContext context) {
    widget.pm.sort();
    List<Widget> pmIcons = List();
    widget.pmcleand = List();
    for(int i=0;i<widget.pm.length;i++){
      if(!widget.pmcleand.contains(Measurements.paymentType(widget.pm[i]))){
        pmIcons.add(Container(padding: EdgeInsets.only(left: Measurements.width * 0.01),child:SvgPicture.asset(Measurements.paymentType(widget.pm[i]),height: Measurements.width * (widget._isTablet? 0.025:0.04),)));
        widget.pmcleand.add(Measurements.paymentType(widget.pm[i]));
      }
    }
    
    return Container(
      child:Container(
        child: widget.pm.length == 0? AutoSizeText(Language.getWidgetStrings("widgets.pos.no-payments"),maxLines: 2,minFontSize: 10,style: TextStyle(fontSize: 13),):Row(children: pmIcons.sublist(0,pmIcons.length<5?pmIcons.length:4)))
    );
  }
}

class NoTerminalWidget extends StatelessWidget {
  double _cardSize;
  POSCardParts _parts;
  NoTerminalWidget(this._parts);
  @override
  Widget build(BuildContext context) {
    _cardSize = Measurements.height * (_parts._isTablet?0.07:0.13);
    return Container(
      child: Container(
        padding: EdgeInsets.only(bottom:Measurements.width * 0.05,left:Measurements.width * 0.03,right:Measurements.width * 0.03 ),
        height: _cardSize ,
        child: Center(
          child: InkWell(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: (_cardSize)/2,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                  child: Container(
                    color: Colors.white.withOpacity(0.1),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Start accepting payments locally 14 days for free",style: TextStyle(fontSize: 13,color: Colors.white.withOpacity(0.7)),)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class POSSecondCard extends StatefulWidget {
  POSCardParts _parts;
  POSSecondCard(this._parts);
  
  @override
  _POSSecondCardState createState() => _POSSecondCardState();
}

class _POSSecondCardState extends State<POSSecondCard> {
  @override
  void initState() {
    super.initState();
    widget._parts.index.addListener(listener);
    widget._parts._secondCardLoading.addListener(listener);
  }
  @override
  Widget build(BuildContext context) {
    return !widget._parts._secondCardLoading.value? Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(width:Measurements.width*0.3,child: Text(Language.getWidgetStrings("widgets.pos.sale-7-days"),style: TextStyle(fontSize: 13,color: Colors.white.withOpacity(0.5)),)),
              Text(Language.getWidgetStrings("widgets.pos.top-sale-products"),style: TextStyle(fontSize: 13,color: Colors.white.withOpacity(0.5)),),
            ],
          ),
          widget._parts.terminals[widget._parts.index.value].bestSales.length<=0?
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children:  <Widget>[
              Container(alignment:Alignment.bottomLeft,height:   Measurements.width * (widget._parts._isTablet? 0.04: 0.09),width:Measurements.width*0.3,child: Text("${ widget._parts.terminals[widget._parts.index.value].lastweekAmount>0 ? (widget._parts.numberFilter(widget._parts.terminals[widget._parts.index.value].lastweekAmount.toDouble(),false) + Measurements.currency(widget._parts.terminals[0].lastWeek[0].currency)) : "0.00 €"}",style: TextStyle(fontSize: 20),)),
              Container(alignment:Alignment.bottomCenter,height: Measurements.width * (widget._parts._isTablet? 0.04: 0.09),child: Text(Language.getWidgetStrings("widgets.store.no-products"),style: TextStyle(fontSize: 16,color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w300),)),
            ],
          ):widget._parts.salesCards[widget._parts.index.value],
        ],
      ),
    ):CircularProgressIndicator();
  }

  void listener() {
    setState(() {});
  }
}

class ProductCard extends StatefulWidget {
  POSCardParts _parts;
  num index;
  ProductCard(this._parts,this.index);
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  List<ProductItem> topSales= List();
  var size = Measurements.width * 0.05;
  @override
  Widget build(BuildContext context) {
    topSales= List();
    int long = widget._parts.terminals[widget._parts.index.value].bestSales.length>3? 3:1;
    for(int i = 0;i<long;i++){
      topSales.add(ProductItem(widget._parts.terminals[widget._parts.index.value].bestSales[i].thumbnail, widget._parts.terminals[widget._parts.index.value].bestSales[i],size,widget._parts._isTablet));
    }
    return Container(
      padding: EdgeInsets.only(top: Measurements.width * 0.01),
      child: Row(
        children: <Widget>[
          Container(width:Measurements.width*0.3,child: Text("${widget._parts.numberFilter(widget._parts.terminals[widget._parts.index.value].lastweekAmount.toDouble(),false)} ${Measurements.currency(widget._parts.terminals[widget.index].lastWeek[0].currency)}",style: TextStyle(fontSize: 20),)),
          Container(
            child: Expanded (
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children:topSales),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  String url;
  Product _product;
  num size ;
  bool _isTablet;
  ProductItem(this.url,this._product,this.size,this._isTablet);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: Measurements.width * 0.03),
          child: Container(
            height:size.toDouble()*(_isTablet? 0.9:1.8),
            width:size.toDouble()*(_isTablet?  0.9:1.8),
            decoration: BoxDecoration(
              color:Colors.white,
              borderRadius:BorderRadius.circular(8),
              image: url!=null? DecorationImage(image:NetworkImage(url)):DecorationImage(image: AssetImage("")),
            ),
            child:url==null?SvgPicture.asset("images/noimage.svg"):Container(),
            ),
        ),
      ],
    );
  }
}