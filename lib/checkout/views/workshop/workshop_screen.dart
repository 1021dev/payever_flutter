import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/checkout/checkout_bloc.dart';
import 'package:payever/blocs/checkout/checkout_state.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/widgets/checkout_flow.dart';
import 'package:payever/checkout/widgets/workshop_top_bar.dart';

import '../channels/channels_checkout_flow_screen.dart';
import 'checkout_switch_screen.dart';

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

  bool switchCheckout = false;

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
//                  widget.onOpen(state.openUrl);
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ChannelCheckoutFlowScreen(
                        checkoutScreenBloc: widget.checkoutScreenBloc,
                        url: 'https://checkout.payever.org/pay/create-flow/channel-set-id/${widget.checkoutScreenBloc.state.channelSet.id}',
                      ),
                      type: PageTransitionType.fade,
                    ),
                  );
                },
                onSwitchTap: () {
                  setState(() {
                    switchCheckout = true;
                  });
                },
                onPrefilledQrcode: () {
                  
                },
              ),
              Flexible(
                child: state.channelSet == null
                    ? Container()
                    : _body(state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _body(CheckoutScreenState state) {
    if (switchCheckout) {
      return CheckoutSwitchScreen(
        businessId: state.business,
        checkoutScreenBloc: widget.checkoutScreenBloc,
        onOpen: (Checkout checkout) {
          setState(() {
            switchCheckout = false;
          });
        },
      );
    } else {
      return CheckoutFlowWebView(
        checkoutScreenBloc: widget.checkoutScreenBloc,
        checkoutUrl:
          // 'https://checkout-backend.test.devpayever.com/api/flow/channel-set/${state.channelSetFlow.id}'
        'https://checkout.payever.org/pay/create-flow/channel-set-id/${state.channelSet.id}',
      );
    }
  }
}
