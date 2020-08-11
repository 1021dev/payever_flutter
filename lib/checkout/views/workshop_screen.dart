import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/checkout/checkout_bloc.dart';
import 'package:payever/blocs/checkout/checkout_state.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/checkout_switch_screen.dart';
import 'package:payever/checkout/widgets/checkout_flow.dart';
import 'package:payever/checkout/widgets/checkout_top_button.dart';
import 'package:payever/checkout/widgets/workshop_header_item.dart';
import 'package:payever/checkout/widgets/workshop_top_bar.dart';
import 'package:payever/commons/commons.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkshopScreen extends StatefulWidget {
  final CheckoutScreenBloc checkoutScreenBloc;
  final Function onOpen;

  WorkshopScreen({
    this.checkoutScreenBloc,
    this.onOpen,
  });

  @override
  _WorkshopScreenState createState() => _WorkshopScreenState();
}

class _WorkshopScreenState extends State<WorkshopScreen> {
  String currency = '';
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
    return BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
      bloc: widget.checkoutScreenBloc,
      builder: (BuildContext context, state) {
        return Container(
          child: Column(
            children: <Widget>[
              WorkshopTopBar(
                checkoutScreenBloc: widget.checkoutScreenBloc,
                title: 'Your checkout',
                onOpenTap: () {
                  widget.onOpen(state.openUrl);
                },
              ),
              Flexible(
                child: state.channelSet == null
                    ? Container()
                    : CheckoutFlowWebView(
                        checkoutScreenBloc: widget.checkoutScreenBloc,
                        checkoutUrl:
                            'https://checkout.payever.org/pay/create-flow/channel-set-id/${state.channelSet.id}',
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
