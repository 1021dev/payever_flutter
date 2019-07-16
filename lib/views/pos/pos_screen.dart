import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payever/models/business.dart';
import 'package:payever/models/pos.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/dashboard/transactioncard.dart';
import 'package:payever/views/products/product_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

//Not used
//Not used
//Not used
//Not used

class POSParts{


}

class POSScreen extends StatefulWidget {
  Terminal _terminal;
  String _wallpaper;
  WebView _view;
  Business business;
  var _terminalLoading = ValueNotifier(true);
  POSScreen(this._terminal,this._wallpaper,this.business){
    _view = WebView(
    onPageFinished: (s){
      _terminalLoading.value = false;
    },
    key: UniqueKey(),
    javascriptMode: JavascriptMode.unrestricted,
    initialUrl: Env.Builder + "/pos/"+_terminal.id+"/products?enableMerchantMode=true",
    );
  }
  @override
  _POSScreenState createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  Widget _currentBody ;
  
  bool _isLoading= false;
  TextStyle _style = TextStyle(
    fontSize: 15,
  );
  ValueNotifier index = ValueNotifier(0);
   
  @override
  void initState() {
    super.initState();
    loadTerminal();
    widget._terminalLoading.addListener(listener);
  } 
      @override
      Widget build(BuildContext context) {
        index.addListener(selection);
        
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
              Positioned(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              top: 0.0,
              child: CachedNetworkImage(
              imageUrl: widget._wallpaper,
              placeholder: (context, url) => new Container(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
              fit: BoxFit.cover,
            ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: 
                  InkWell(radius: 20,
                  child: Icon(IconData(58829, fontFamily: 'MaterialIcons')),
                  onTap: (){
                    Navigator.pop(context);
                    },
                ),
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: index.value == 0? Colors.white:Colors.transparent,
                title: Text(widget._terminal.name,style: TextStyle(color: Colors.black),) ,
              ),
                body:  BackdropFilter( filter: ImageFilter.blur(sigmaX: 25,sigmaY: 40),child:_isLoading?Center(child: CircularProgressIndicator() ,):
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                    _currentBody,
                    Center(child: widget._terminalLoading.value? Container(height:Measurements.width * 0.1,width:Measurements.width * 0.1,
                    child:CircularProgressIndicator(backgroundColor: Colors.black)):Container()),
                    ],
                  ))),
                
                ],);
              }
        
              void changeFragment(Widget newFrag){
                setState(() {
                  _isLoading= false;
                  _currentBody = newFrag;
                });
              }
            
              void selection() {
                setState(() {
                  
                });
              }
        
            Future<void> loadTransactions(BuildContext context){
              RestDatasource api = RestDatasource();
              api.getTransactionList(widget._terminal.business,GlobalUtils.ActiveToken.accessToken,"?orderBy=created_at&direction=desc&limit=20&query=&page=1&currency=DKK&filters%5Bchannel_set_uuid%5D%5Bcondition%5D=is&filters%5Bchannel_set_uuid%5D%5Bvalue%5D%5B0%5D=${widget._terminal.channelSet}",context).
                then((obj){
                  print(obj);
                  TransactionScreenData tsc = TransactionScreenData(obj,widget._wallpaper);
                  // changeFragment(TrasactionScreen(widget._wallpaper,false));
                    
              });                                        
            }

          loadProducts(BuildContext context) {
            changeFragment(ProductScreen(business: widget.business,wallpaper: widget._wallpaper, posCall: true, ));
          }
        
          void loadTerminal(){
            
            changeFragment(widget._view);
          }
        
          void listener() {
            setState((){
    
            });
          }
    }
                        

