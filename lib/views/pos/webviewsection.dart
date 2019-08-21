import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:payever/view_models/pos_state_model.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/models/pos.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/utils.dart';

class WebViewPayments extends StatefulWidget {
  final PosStateModel posStateModel;
  final String url;

  WebViewPayments({this.posStateModel, this.url});

  @override
  createState() => _WebViewPaymentsState();
}

class _WebViewPaymentsState extends State<WebViewPayments> {
  String paymentUrl;

  @override
  void initState() {
    super.initState();
    print(widget.url);

    if (widget.url == null)
      RestDatasource()
          .postStorageSimple(
              GlobalUtils.ActiveToken.accessToken,
              Cart.items2MapSimple([]),
              null,
              false,
              true,
              "widget.phone.replaceAll(" "," ")",
              DateTime.now()
                  .subtract(Duration(hours: 2))
                  .add(Duration(minutes: 1))
                  .toIso8601String(),
              widget.posStateModel.currentTerminal.channelSet,
              widget.posStateModel.smsEnabled)
          .then((obj) {
        setState(() {
          paymentUrl = Env.Wrapper +
              "/pay/restore-flow-from-code/" +
              obj["id"] +
              "?noHeaderOnLoading=true";
        });

        print("paymentUrl: $paymentUrl");
      });
      else paymentUrl = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: SvgPicture.asset(
            "images/payeverlogoandname.svg",
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
        body: paymentUrl == null
            ? Container(color: Colors.white)
            : WebviewScaffold(
                initialChild: Container(
                  color: Colors.white,
                ),
                url: paymentUrl,
                withJavascript: true,
              ));
  }
}
