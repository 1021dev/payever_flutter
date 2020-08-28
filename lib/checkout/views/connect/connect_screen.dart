import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/blocs/checkout/checkout_bloc.dart';
import 'package:payever/blocs/checkout/checkout_state.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/theme.dart';

class ConnectScreen extends StatefulWidget {
  final CheckoutScreenBloc checkoutScreenBloc;
  final Function onTapOpen;
  final Function onTapAdd;
  final Function onChangeSwitch;
  final bool isLoading;

  ConnectScreen({
    this.checkoutScreenBloc,
    this.onTapOpen,
    this.onTapAdd,
    this.onChangeSwitch,
    this.isLoading = true,
  });
  @override
  ConnectScreenState createState() => ConnectScreenState();
}

class ConnectScreenState extends State<ConnectScreen> {
  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Container(
          width: Measurements.width,
          child: BlurEffectView(
            child: widget.isLoading ?
            Wrap(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ],
            ) : SingleChildScrollView(
              child: Column(
                children: List.generate(widget.checkoutScreenBloc.state.connectItems.length + 1, (index) {
                  if (index == widget.checkoutScreenBloc.state.connectItems.length) {
                    return Container(
                      height: 50,
                      child: SizedBox.expand(
                        child: MaterialButton(
                          onPressed: widget.onTapAdd,
                          child: Row(
                            children: <Widget>[
                              Text(
                                '+ Add',
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    ChannelItem model = widget.checkoutScreenBloc.state.connectItems[index];
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Row(
                                  children: <Widget>[
                                    model.image,
                                    Padding(
                                      padding: EdgeInsets.only(left: 8),
                                    ),
                                    Flexible(
                                      child: Text(
                                        model.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Helvetica Neue',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  model.checkValue != null ? Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                      value: isInstalled(model, widget.checkoutScreenBloc.state),
                                      onChanged: (val) {
                                        widget.onChangeSwitch(model.name);
                                      },
                                    ),
                                  ) : Container(),
                                  MaterialButton(
                                    onPressed:(){
                                      widget.onTapOpen(model.title);
                                    },
                                    color: overlayBackground(),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    height: 24,
                                    minWidth: 0,
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Text(
                                      model.button,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'HelveticaNeueMed',
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 0,
                          thickness: 0.5,
                          color: Colors.white70,
                        ),
                      ],
                    );
                  }
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isInstalled(ChannelItem item, CheckoutScreenState state) {
    return state.integrations.contains(item.name);
  }
}
