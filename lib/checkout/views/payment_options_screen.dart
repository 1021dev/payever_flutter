import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/widgets/checkout_top_button.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/connect/models/connect.dart';

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
      child: Column(
        children: List.generate(widget.integrations.length + 1, (index) {
          if (index == widget.integrations.length) {
            return Container();
          } else {
            IntegrationModel integrationModel = widget.integrations[index];
            ConnectModel connectModel = widget.connects.firstWhere((element) {
              return element.integration.name == integrationModel.integration;
            });
            if (integrationModel == null) {
              return Container();
            } else {
              return Container(
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
                          color: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 24,
                          minWidth: 0,
                          padding: EdgeInsets.all(4),
                          child: Text(
                            Language.getConnectStrings('actions.open'),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            }
          }
        })
      ),
    );
  }

}