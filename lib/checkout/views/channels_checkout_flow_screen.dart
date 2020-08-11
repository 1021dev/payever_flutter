import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/checkout/checkout_bloc.dart';
import 'package:payever/checkout/widgets/checkout_flow.dart';
import 'package:payever/checkout/widgets/workshop_top_bar.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';

class ChannelCheckoutFlowScreen extends StatefulWidget {
  final CheckoutScreenBloc checkoutScreenBloc;
  final String url;
  ChannelCheckoutFlowScreen({
    this.checkoutScreenBloc, this.url,
  });

  @override
  _ChannelCheckoutFlowScreenState createState() =>
      _ChannelCheckoutFlowScreenState();
}

class _ChannelCheckoutFlowScreenState extends State<ChannelCheckoutFlowScreen> {
  InAppWebViewController webView;

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
    return DefaultTabController(
      length: 6,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomPadding: false,
        appBar: CustomAppBar(
          widget.checkoutScreenBloc,
        ),
        body: SafeArea(
          child: BackgroundBase(
            true,
            backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
            body: CheckoutFlowWebView(
              checkoutScreenBloc: widget.checkoutScreenBloc,
              checkoutUrl: widget.url,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final CheckoutScreenBloc checkoutScreenBloc;

  CustomAppBar(this.checkoutScreenBloc);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      alignment: Alignment.bottomCenter,
      child: WorkshopTopBar(
        checkoutScreenBloc: checkoutScreenBloc,
        title: 'Pay by Link Editing',
        onCloseTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(50);
}
