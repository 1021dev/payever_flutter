import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/models/pos.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/pos/native_pos_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class WebViewSections extends StatefulWidget {
  PosScreenParts parts;
  bool empty;
  String url = "";
  WebViewSections({this.parts,this.url});
  ValueNotifier<bool> isLoading = ValueNotifier(true); 
  @override
  _WebViewSectionsState createState() => _WebViewSectionsState();
}

class _WebViewSectionsState extends State<WebViewSections> {
  @override
  void initState() {
    super.initState();
    widget.isLoading.addListener(listener);
    print(widget.parts.shoppingCart.items);
    // RestDatasource().postStorageSimple(GlobalUtils.ActiveToken.accessToken, Cart.items2MapSimple(widget.empty?[]:widget.parts.shoppingCart.items),null,true,true,"widget.phone.replaceAll(" ","")", "sms", DateTime.now().subtract(Duration(hours: 2)).add(Duration(minutes: 1)).toIso8601String(),widget.parts.currentTerminal.channelSet,widget.parts.smsenabled).then((obj){
    //   widget.checkUrl = widget.parts.url = Env.Wrapper + "/pay/restore-flow-from-code/" + obj["id"]+"?noHeaderOnLoading=true";
    //   print(widget.checkUrl);
    //   widget.parts.shoppingCartID = obj["id"];
    //   widget.isLoading.value = false;                    
    // });
  }
  listener(){
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.isLoading.value?
      Center(child:CircularProgressIndicator(backgroundColor: Colors.black,)):
      WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
class WebViewPayments extends StatefulWidget {
  PosScreenParts parts;
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  String url = "";
  bool empty;
  WebViewPayments({this.parts,this.url});
  @override
  _WebViewPaymentsState createState() => _WebViewPaymentsState();
}

class _WebViewPaymentsState extends State<WebViewPayments> {
  
  @override
  void initState() {
    super.initState();
    widget.isLoading.addListener(listener);
    print(widget.parts.shoppingCart.items);
    if(widget.url==null){
      print("url null");
      RestDatasource().postStorageSimple(GlobalUtils.ActiveToken.accessToken, Cart.items2MapSimple([]),null,false,true,"widget.phone.replaceAll(" ","")",DateTime.now().subtract(Duration(hours: 2)).add(Duration(minutes: 1)).toIso8601String(),widget.parts.currentTerminal.channelSet,widget.parts.smsenabled).then((obj){
        widget.url = Env.Wrapper + "/pay/restore-flow-from-code/" + obj["id"]+"?noHeaderOnLoading=true";
        widget.isLoading.notifyListeners();
      });
    }
      
  }
  listener(){
    setState(() {
      print(widget.url);
    });
  }

  //widget.parts.url = Env.Wrapper + "/pay/restore-flow-from-code/" + obj["id"]+"?noHeaderOnLoading=true"
  @override
  Widget build(BuildContext context) {
    print(widget.url);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.close,color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: SvgPicture.asset("images/payeverlogoandname.svg",color: Colors.black,),
        backgroundColor: Colors.white,
      ),
      body:widget.url==null?Container(color:Colors.white):WebviewScaffold(initialChild: Container(color: Colors.white,),
        url: widget.url,
        withJavascript: true,
      //body: WebviewSections(parts: widget.parts,empty: false,), url: null,
    ));
  }
}