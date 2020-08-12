import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/connect/models/connect.dart';

class PaymentOptionsScreen extends StatefulWidget {

  final List<ConnectModel> connects;
  final List<IntegrationModel> integrations;
  final List<IntegrationModel> checkoutIntegrations;
  final List<Payment> paymentOptions;
  final Function onTapAdd;
  final Function onTapOpen;
  final Function onTapInstall;
  final Function onTapUninstall;
  final bool isLoading;

  PaymentOptionsScreen({
    this.connects = const [],
    this.integrations = const [],
    this.paymentOptions = const [],
    this.checkoutIntegrations = const [],
    this.onTapAdd,
    this.onTapOpen,
    this.onTapInstall,
    this.onTapUninstall,
    this.isLoading = false,
  });

  @override
  _PaymentOptionsScreenState createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {

  @override
  Widget build(BuildContext context) {
    List<IntegrationModel> checkoutConnections = [];
    widget.checkoutIntegrations.forEach((checkoutIntegration) {
      bool isConnected = false;
      widget.paymentOptions.forEach((payment) {
        if (payment.name == checkoutIntegration.integration) {
          isConnected = true;
        }
      });
      if (isConnected) {
        checkoutConnections.add(checkoutIntegration);
      }
    });

    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
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
              children: List.generate(checkoutConnections.length + 1, (index) {
                if (index == widget.integrations.length) {
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
                                    fontSize: 14,
                                    fontFamily: 'Helvetica Neue',
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                      value: connectModel.installed,
                                      onChanged: (val) {
                                        val ? widget.onTapInstall(integrationModel) : widget.onTapUninstall(integrationModel);
                                      },
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      widget.onTapOpen(connectModel);
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
                                      style: TextStyle(
                                        color: Colors.white,
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
                }
              }),
            ),
          ),
        ),
      ),
    );
  }

}