import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/models/business.dart';
import 'package:payever/models/transaction.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:payever/views/dashboard/dashboard_screen.dart';
import 'dart:ui';
import 'package:payever/views/dashboard/dashboardcard.dart';
import 'package:payever/views/login/login_page.dart';
import 'package:payever/views/transactions/transactions_screen.dart';



bool _isTablet = false;
bool _isPortrait =true;
String _currentWallpaper;
Business _currentBusiness;
DashboardWidgets _dashboardWidgets;

class TransactionScreenData{
  Business _business;
  String _wallpaper;
  Transaction _transaction;
  TransactionScreenData(dynamic obj,this._wallpaper){
    _business = _currentBusiness;
    _transaction = Transaction.toMap(obj);
  }

  Business get business => _business;
  String get wallpaper => _wallpaper;
  Transaction get transaction => _transaction;

  String currency(String currency){
    
    switch(currency.toUpperCase()){
      case "EUR":
        return "€";
      case "USD":
        return 'US\$';
      case "NOK":
        return "NOK";
      case "SEK":
        return "SEK";
      case "GBP":
        return"£";
      case "DKK":
        return "DKK";
      case "CHF":
        return "CHF";
      
    }
  }

}

class TransactionCard extends StatefulWidget {
  
  String _appName;
  ImageProvider _imageProvider;
  String _wallpaper;
  Business _business;
  bool _isBusiness ;
  TransactionCard(this._appName,this._imageProvider,this._business,this._isBusiness,this._wallpaper){
    _currentWallpaper = _wallpaper;
    _currentBusiness = _business;
    _dashboardWidgets = DashboardWidgets();
  }
  @override
  _TransactionCardState createState() => _TransactionCardState(_appName,_imageProvider,_isBusiness);
}

class _TransactionCardState extends State<TransactionCard> {

  String _appName;
  ImageProvider _imageProvider;
  
  bool _isBusiness ;
  _TransactionCardState(this._appName,this._imageProvider,this._isBusiness){
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(_appName, _imageProvider, MainTransactionCard(_isBusiness), TrasactionSecCard(),TransactionNavigation(),true, false);
  }

}

class MainTransactionCard  extends StatefulWidget  {
  bool _isBusiness ;
  MainTransactionCard(this._isBusiness);
  @override
  _MainTransactionCardState createState() => _MainTransactionCardState(_isBusiness);
}

class _MainTransactionCardState extends State<MainTransactionCard> {

  bool _isBusiness ;
  List<num> _months = new  List();
  List<double> _days   = new List();
  bool _chartLoad = false;
  double _cardSize;

  num _hi= 0 ,_low = 1,_mid=0 ;
  
  _MainTransactionCardState(this._isBusiness){
    _chartLoad= false;
    RestDatasource api = RestDatasource();
    if(_isBusiness){
       api.getMonths(_currentBusiness.id,GlobalUtils.ActiveToken.accesstoken,context).then((months){
        months.forEach((month){
          
          _dashboardWidgets._transactionsData.lastYear.add(Month.map(month));
          _months.add( Month.map(month).amount.toDouble());
        });
      }).then((_){
        api.getDays(_currentBusiness.id, GlobalUtils.ActiveToken.accessToken,context).then((days){
          num _currentD;
          days.forEach((day){
            _currentD = Day.map(day).amount.toDouble();
            _dashboardWidgets._transactionsData.lastMonth.add(Day.map(day));
            _days.add(_currentD);
            if(_currentD>_hi){
              _hi = _currentD;
            }else if(_currentD<_low){
              _low = _currentD; 
            }
          });
          _mid = ((_hi + _low)/2);
          setState(() {
            _chartLoad = true;
          });
            setState(() {
              _dashboardWidgets._isDataLoaded.value = true;
              //_dashboardWidgets._isDataLoaded.notifyListeners();
          });
      }).catchError((onError){
        print("Error in Transaction Card$onError");
        print("Error end");
      });
      }).catchError((onError){
        if(onError.toString().contains("401")){
          GlobalUtils.clearCredentials();
          Navigator.pushReplacement(context,PageTransition(child:LoginScreen() ,type: PageTransitionType.fade));
        }
      });
    }else {
       api.getMonthsPersonal(GlobalUtils.ActiveToken.accesstoken,context).then((months){
        months.forEach((month){
          _dashboardWidgets._transactionsData.lastYear.add(Month.map(month));
          _months.add( Month.map(month).amount.toDouble());
        });
      }).then((_){
        api.getDaysPersonal( GlobalUtils.ActiveToken.accessToken,context).then((days){
          double _currentD;
          days.forEach((day){
            _currentD = Day.map(day).amount.toDouble();
            _dashboardWidgets._transactionsData.lastMonth.add(Day.map(day));
            _days.add(_currentD);
            if(_currentD>_hi){
              _hi = _currentD;
            }else if(_currentD<_low){
              _low = _currentD; 
            }
          }).catchError((onError){print("error personal days $onError");});
          _mid = ((_hi + _low)/2);

          setState(() {
            _chartLoad = true;
          });
         
      }).catchError((onError){
        print("Error in Transaction Card $onError");
        print("Error end");
      });
      });
     
    }
  }

  
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
        Measurements.height = (_isPortrait ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width);
        Measurements.width  = (_isPortrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height);
        _isTablet = Measurements.width < 600 ? false : true; 
        _cardSize = Measurements.height * (_isTablet?0.03:0.05);
        return AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: _cardSize * (_isTablet? 2.5:2),
          padding: EdgeInsets.only(bottom:Measurements.width * (_isTablet?0.01:0.015)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: (Measurements.width - (Measurements.width * 0.1))/ ((!_isTablet && !_isPortrait)?(1.1):(2.1)) ,
                child: _chartLoad ? Sparkline(
                  lineWidth: 2.5,
                  data: _days,
                  lineGradient: new LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF00FFD6), Color(0xFF007AAE), Color(0xFF007AAE)],
                  ),):Center(child: CircularProgressIndicator()),
              ),
              Padding(padding: EdgeInsets.only(left:Measurements.width * (_isTablet?0.015:0.025)),),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(alignment: Alignment.centerLeft,child:_chartLoad && _hi!=0? AutoSizeText(DashboardWidgets.numberFilter(_hi , true ),maxLines: 1,style: TextStyle(fontSize: 1.0),):Text("")),
                    Container(alignment: Alignment.centerLeft,child: _chartLoad && _hi!=0? AutoSizeText(DashboardWidgets.numberFilter(_mid, true),maxLines: 1,style: TextStyle(fontSize: 1.0),):Text("")),
                    Container(alignment: Alignment.centerLeft,child: _chartLoad && _hi!=0? AutoSizeText(DashboardWidgets.numberFilter(_low, true),maxLines: 1,style: TextStyle(fontSize: 1.0),textAlign: TextAlign.left,):Text("")),
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,      
                  children: <Widget>[
                    Container(child: Text(Language.getWidgetStrings("widgets.transactions.today-revenue"),style: TextStyle(fontSize: 14),)),
                    Expanded(child: Container(alignment:Alignment.centerLeft,child: AutoSizeText("${ _chartLoad ? DashboardWidgets.numberFilter(_days.last, false): "0"} ${_dashboardWidgets.currency(_dashboardWidgets._transactionsData.lastMonth.isEmpty ? "EUR":_dashboardWidgets._transactionsData.lastMonth[0].currency)}",style: TextStyle(fontSize: _isTablet?26: 20),))),
                    _isTablet?Container(child: AutoSizeText("${Language.getWidgetStrings("widgets.transactions.this-month")} ${_chartLoad ? DashboardWidgets.numberFilter(_months.last ,false) : "0"} ${_dashboardWidgets.currency(_dashboardWidgets._transactionsData.lastMonth.isEmpty ? "EUR":_dashboardWidgets._transactionsData.lastMonth[0].currency)}",maxLines: 1))
                    :Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(child: AutoSizeText("${Language.getWidgetStrings("widgets.transactions.this-month")}",maxLines: 1,maxFontSize: 13,),),
                          Container(child: AutoSizeText("${_chartLoad ? DashboardWidgets.numberFilter(_months.last ,false) : "0"} ${_dashboardWidgets.currency(_dashboardWidgets._transactionsData.lastMonth.isEmpty ? "EUR":_dashboardWidgets._transactionsData.lastMonth[0].currency)}",style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(left:Measurements.width * (_isTablet?0.015:0.025)),),
            ],
          ),
        );
      },
    );
  }
}

class TrasactionSecCard extends StatefulWidget {
  @override
  _TrasactionSecCardState createState() => _TrasactionSecCardState();
}

class _TrasactionSecCardState extends State<TrasactionSecCard> {
  
  List<double> monthlysum= new List();
  double sum=0;

  @override
  void initState() {
    super.initState();
    _dashboardWidgets._isDataLoaded.addListener(listener);
  }
  
  
  var f = new NumberFormat("###,###.00", "en_US");
  @override
  Widget build(BuildContext context) {
    
    if(_dashboardWidgets._transactionsData.lastYear!=null){
      if(_dashboardWidgets._transactionsData.lastYear.length > 0){
        for(int i =(_dashboardWidgets._transactionsData.lastYear.length-2);i>=0;i--){
          
          sum += _dashboardWidgets._transactionsData.lastYear[i].amount;
          monthlysum.add(sum);
        }
      }
    }
    
    return _dashboardWidgets._isDataLoaded.value ? Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Row(
              children: <Widget>[
                Text(Language.getWidgetStrings("widgets.transactions.1-month").toString().substring(0,1),style: TextStyle(fontSize: _isTablet?20:16)),
                Text(Language.getWidgetStrings("widgets.transactions.1-month").toString().substring(1),style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: _isTablet?20:16)),
              ],
            ),
            AutoSizeText("${DashboardWidgets.numberFilter(monthlysum[0],false)} ${_dashboardWidgets.currency(_dashboardWidgets._transactionsData.lastMonth.isEmpty ? "EUR":_dashboardWidgets._transactionsData.lastMonth[0].currency)}",style: TextStyle(fontSize: _isTablet?25: 18,fontWeight: FontWeight.w600))
          ],),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Row(
              children: <Widget>[
                Text(Language.getWidgetStrings("widgets.transactions.3-months").toString().substring(0,1),style: TextStyle(fontSize: _isTablet?20:16)),
                Text(Language.getWidgetStrings("widgets.transactions.3-months").toString().substring(1),style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: _isTablet?20:16)),
              ],
            ),
            AutoSizeText("${DashboardWidgets.numberFilter(monthlysum[2],false)} ${_dashboardWidgets.currency(_dashboardWidgets._transactionsData.lastMonth.isEmpty ? "EUR":_dashboardWidgets._transactionsData.lastMonth[0].currency)}",style: TextStyle(fontSize: _isTablet?25: 18,fontWeight: FontWeight.w600))
          ],),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
            Row(
              children: <Widget>[
                Text(Language.getWidgetStrings("widgets.transactions.6-months").toString().substring(0,1),style: TextStyle(fontSize: _isTablet?20:16)),
                Text(Language.getWidgetStrings("widgets.transactions.6-months").toString().substring(1),style: TextStyle(color:Colors.white.withOpacity(0.6),fontSize: _isTablet?20:16)),
              ],
            ),
            AutoSizeText("${DashboardWidgets.numberFilter(monthlysum[5],false)} ${_dashboardWidgets.currency(_dashboardWidgets._transactionsData.lastMonth.isEmpty ? "EUR":_dashboardWidgets._transactionsData.lastMonth[0].currency)}",style: TextStyle(fontSize: _isTablet?25: 18,fontWeight: FontWeight.w600))
          ],),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Row(
              children: <Widget>[
                Text(Language.getWidgetStrings("widgets.transactions.1-year").toString().substring(0,1),style: TextStyle(fontSize: _isTablet?20:16)),
                Text(Language.getWidgetStrings("widgets.transactions.1-year").toString().substring(1),style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: _isTablet?20:16)),
              ],
            ),
            AutoSizeText("${DashboardWidgets.numberFilter(monthlysum[10],false)} ${_dashboardWidgets.currency(_dashboardWidgets._transactionsData.lastMonth[0].currency)}",style: TextStyle(fontSize: _isTablet?25: 18,fontWeight: FontWeight.w600))
          ],),
        ],
      ),
    ):CircularProgressIndicator();
  }

  void listener() {
    setState(() {

    });
  }
}

class DashboardWidgets{
  var _isDataLoaded = ValueNotifier(false) ;
  TransactionCardData _transactionsData = TransactionCardData();
  static String numberFilter(double n,bool chart){
  var million = new NumberFormat("###.##", "en_US");
  var thousand = new NumberFormat("###.#", "en_US");
  var hundred = new NumberFormat("###.#", "en_US");
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
  String currency(String currency){
        switch(currency.toUpperCase()){
          case "EUR":
            return "€";
          case "USD":
            return 'US\$';
          case "NOK":
            return "NOK";
          case "SEK":
            return "SEK";
          case "GBP":
            return"£";
          case "DKK":
            return "DKK";
          case "CHF":
            return "CHF";
          
        }
      }
}

class TransactionNavigation implements CardContract{
  @override
  void loadScreen(BuildContext context,ValueNotifier state) {
    
    state.notifyListeners();
    Navigator.push(context, PageTransition(child: TrasactionScreen(_currentWallpaper,false,_currentBusiness), type: PageTransitionType.fade,));
    state.value = false;


  }

  @override
  String learnMore() {
    return null;
  }

}