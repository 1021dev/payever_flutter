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
    bool _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    bool _isTablet = Measurements.width < 600 ? false : true;
    List<ConnectModel> checkoutConnections = [];
    widget.checkoutIntegrations.forEach((checkoutIntegration) {
      bool isConnected = false;
      ConnectModel connectModel;
      widget.connects.forEach((connect) {
        if (connect.integration.name == checkoutIntegration.integration && connect.integration.category == 'payments') {
          isConnected = true;
          connectModel = connect;
        }
      });
      if (isConnected) {
        checkoutConnections.add(connectModel);
      }
    });

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
                children: List.generate(checkoutConnections.length + 1, (index) {
                  if (index == checkoutConnections.length) {
                    return Container(
                      height: 50,
                      width: Measurements.width,
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
                    ConnectModel connectModel = checkoutConnections[index];
                    List list = widget.integrations.where((element) => element.integration == connectModel.integration.name).toList();
                    bool installed = false;
                    if (list.length > 0) {
                      installed = true;
                    }
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 50,
                          width: Measurements.width,
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
                                      value: installed,
                                      onChanged: (val) {
                                        IntegrationModel integrationModel = widget.checkoutIntegrations.singleWhere((element) => element.integration == connectModel.integration.name);
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
                }),
              ),
            ),
          ),
        )
      ),
    );
  }
}