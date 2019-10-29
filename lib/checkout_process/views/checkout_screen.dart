import 'package:flutter/material.dart';
import 'package:payever/commons/views/custom_elements/appbar_avatar.dart';
import 'package:provider/provider.dart';
import '../views/custom_elements/custom_elements.dart';
import '../../commons/views/custom_elements/custom_elements.dart';
import '../view_models/view_models.dart';
import '../checkout_process.dart';
import '../../pos/view_models/view_models.dart';

class CheckOutScreen extends StatelessWidget {
  final String channelSet;
  final PosCartStateModel posCartStateModel;
  final bool manual;
  final PosStateModel posStateModel;

  CheckOutScreen({
    Key key,
    @required this.channelSet,
    @required this.posCartStateModel,
    @required this.posStateModel,
    this.manual = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckoutProcessStateModel>(
      builder: (context) {
        CheckoutProcessStateModel checkoutProcessStateModel =
            CheckoutProcessStateModel();
        checkoutProcessStateModel.setChannelSet(this.channelSet);
        checkoutProcessStateModel.posCartStateModel = posCartStateModel;
        checkoutProcessStateModel.posStateModel = posStateModel;
        return checkoutProcessStateModel;
      },
      child: CheckoutProcessScreen(
        manual: manual,
      ),
    );
  }
}

class CheckoutProcessScreen extends StatefulWidget {
  final bool manual;
  const CheckoutProcessScreen({@required this.manual,});

  @override
  _CheckoutProcessScreenState createState() => _CheckoutProcessScreenState();
}

class _CheckoutProcessScreenState extends State<CheckoutProcessScreen> {
  @override
  Widget build(BuildContext context) {
    CheckoutProcessStateModel checkoutProcessStateModel =
        Provider.of<CheckoutProcessStateModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppBarAvatar(),
        backgroundColor: Color(Provider.of<GlobalStateModel>(context).currentBusiness.primaryColor??0xffffffff),
        actions: <Widget>[],
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: ()=>Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: CustomFutureBuilder(
        errorMessage: "",
        future: CheckoutProcessApi().getCheckoutFlow(
          checkoutProcessStateModel.getchannelSet,
        ),
        onDataLoaded: (results) {
          CheckoutStructure checkoutStructure =
              CheckoutStructure.fromMap(results);
          List<Widget> bodies = List();
          List<String> headers = List();
          checkoutProcessStateModel.setcheckoutStructure(checkoutStructure);
          for (var i in checkoutStructure.sections) {
            // if (i.enabled ) {
            if (i.enabled && i.code == "order") {
              checkoutProcessStateModel.sectionIndexMap
                  .addAll({i.code: i.order});
              headers.add(i.code);
              if (i.code == "order" && widget.manual) {
                bodies.add(checkoutProcessStateModel.sectionMap[i.code+"_manual"]);
              } else {
                bodies.add(checkoutProcessStateModel.sectionMap[i.code]);
              }
            }
          }
          CheckoutStepper stepper = CheckoutStepper(
            bodies: bodies,
            headers: headers,
            checkoutProcessStateModel: checkoutProcessStateModel,
          );
          return stepper;
        },
      ),
    );
  }
}
