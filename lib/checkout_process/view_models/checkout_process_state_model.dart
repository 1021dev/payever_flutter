import 'package:flutter/material.dart';
import 'package:payever/checkout_process/checkout_process.dart';
import 'package:provider/provider.dart';
import '../models/flow_object.dart';
import '../views/views.dart';
class CheckoutProcessStateModel extends ChangeNotifier {

  CheckoutProcessStateModel();

  DashboardStateModel dashboardStateModel;

  FlowObject _currentFlow;
  FlowObject get currentFlow => _currentFlow;
  setCurrentFlow(FlowObject flow) => _currentFlow = flow;

  String _channelSet;
  String get getchannelSet => _channelSet;
  setChannelSet(String channelSet) => _channelSet = channelSet;

  void getChannelSet(BuildContext context){
    setChannelSet(Provider.of<DashboardStateModel>(context).activeTerminal.channelSet);
  }

  final Map<String,Widget> sectionMap = {
    "order": CheckoutOrderSection(),
    "send_to_device": CheckoutS2DeviceSection(),
    "user": CheckoutAccountSection(),
    "address": CheckoutShippingSection(),
    "choosePayment": CheckoutPayementSection(),
    "payment": CheckoutTotalSection(),
  };
}