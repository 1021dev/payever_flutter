import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/widgets/checkout_top_button.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/pos/views/pos_twillo_add_phonenumber.dart';

class PaymentOptionsScreen extends StatefulWidget {

  final List<ConnectModel> connects;
  final List<IntegrationModel> integrations;

  PaymentOptionsScreen({
    this.connects = const [],
    this.integrations = const [],
  });

  @override
  _PaymentOptionsScreenState createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(widget.integrations.length + 1, (index) {
                if (index == widget.integrations.length) {
                  return Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 16),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '+ Add',
                        ),
                      ],
                    ),
                  );
                } else {
                  IntegrationModel integrationModel = widget.integrations[index];
                  ConnectModel connectModel = widget.connects.firstWhere((element) {
                    return element.integration.name == integrationModel.integration;
                  });
                  if (integrationModel == null) {
                    return Container();
                  } else {
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  Language.getPosConnectStrings(connectModel.integration.displayOptions.title ?? ''),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Helvetica Neue',
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  CupertinoSwitch(
                                    value: true,
                                    onChanged: (val) {

                                    },
                                  ),
                                  MaterialButton(
                                    onPressed: () {

                                    },
                                    color: Colors.black38,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    height: 24,
                                    minWidth: 0,
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Text(
                                      Language.getConnectStrings('actions.open'),
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
                }
              }),
            ),
          ),
        ),
      ),
    );
  }

}