import 'package:flutter/material.dart';
import 'package:payever/checkout_process/checkout_process.dart';
import '../../commons/views/custom_elements/custom_elements.dart';
import 'package:provider/provider.dart';
import '../view_models/checkout_process_state_model.dart';

class CheckOutScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider<CheckoutProcessStateModel>(
    //       builder: (BuildContext context) => CheckoutProcessStateModel(),
    //     ),
    //   ],
    //   child: CheckOutStepper(),
    // );
    return CheckOutStepper();
  }
}

class CheckOutStepper extends StatefulWidget {
  @override
  _CheckOutStepperState createState() => _CheckOutStepperState();
}

class _CheckOutStepperState extends State<CheckOutStepper> {
  @override
  Widget build(BuildContext context) {
    CheckoutProcessStateModel checkoutProcessStateModel =Provider.of<CheckoutProcessStateModel>(context);
    // checkoutProcessStateModel.getChannelSet(context);
    return CustomFutureBuilder(
      errorMessage: "",
      future: CheckoutProcessApi().getCheckoutFlow(checkoutProcessStateModel.getchannelSet,GlobalUtils.activeToken.accessToken),
      onDataLoaded: (results) {
        print(results);
      },
    );
  }
}