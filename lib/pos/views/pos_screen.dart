import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

import '../view_models/view_models.dart';
import '../network/network.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class POSScreen extends StatefulWidget {
  final Terminal _terminal;

  POSScreen(this._terminal);

  @override
  createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  Widget _currentBody;
  bool _isLoading = false;
  ValueNotifier index = ValueNotifier(0);
  WebView _view;
  var _terminalLoading = ValueNotifier(true);

  createWebViewForTerminal(Terminal _terminal) {
    _view = WebView(
      onPageFinished: (s) {
        _terminalLoading.value = false;
      },
      key: UniqueKey(),
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: Env.builder +
          "/pos/" +
          _terminal.id +
          "/products?enableMerchantMode=true",
    );
  }

  @override
  void initState() async {
    super.initState();
    await createWebViewForTerminal(widget._terminal);
    loadTerminal();
    _terminalLoading.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    index.addListener(selection);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          top: 0.0,
          child: CachedNetworkImage(
            imageUrl: globalStateModel.currentWallpaper,
            placeholder: (context, url) => Container(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: InkWell(
                radius: 20,
                child: Icon(IconData(58829, fontFamily: 'MaterialIcons')),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor:
                  index.value == 0 ? Colors.white : Colors.transparent,
              title: Text(
                widget._terminal.name,
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 40),
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          _currentBody,
                          Center(
                              child: _terminalLoading.value
                                  ? Container(
                                      height: Measurements.width * 0.1,
                                      width: Measurements.width * 0.1,
                                      child: CircularProgressIndicator(
                                          backgroundColor: Colors.black))
                                  : Container()),
                        ],
                      ))),
      ],
    );
  }

  void changeFragment(Widget newFrag) {
    setState(() {
      _isLoading = false;
      _currentBody = newFrag;
    });
  }

  void selection() {
    setState(() {});
  }

  Future<void> loadTransactions(BuildContext context) async {
    PosApi api = PosApi();
    api
        .getTransactionList(
            widget._terminal.business,
            GlobalUtils.activeToken.accessToken,
            "?orderBy=created_at&direction=desc&limit=20&query=&page=1&currency=DKK&filters%5Bchannel_set_uuid%5D%5Bcondition%5D=is&filters%5Bchannel_set_uuid%5D%5Bvalue%5D%5B0%5D=${widget._terminal.channelSet}",
            context)
        .then((obj) {
      print(obj);
      //TransactionScreenData tsc = TransactionScreenData(obj,widget._wallpaper);
      // changeFragment(TransactionScreen(widget._wallpaper,false));
    });
  }

//  loadProducts(BuildContext context) {
//    changeFragment(ProductScreen(
//      business: widget.business,
//      wallpaper: widget._wallpaper,
//      posCall: true,
//    ));
//  }

  void loadTerminal() {
    changeFragment(_view);
  }

  void listener() {
    setState(() {});
  }
}
