import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/checkout_process/utils/checkout_process_utils.dart';
import 'package:payever/commons/views/custom_elements/appbar_avatar.dart';
import 'package:payever/pos/network/pos_api.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
  const CheckoutProcessScreen({
    @required this.manual,
  });

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
        brightness: Brightness.light,
        centerTitle: true,
        title: AppBarAvatar(),
        backgroundColor: Color(
            Provider.of<GlobalStateModel>(context).currentBusiness.primary ??
                0xffffffff),
        actions: <Widget>[
          QrButton(manual: widget.manual),
          widget.manual
              ? Container()
              : DeleteButton(
                  checkoutProcessStateModel: checkoutProcessStateModel,
                  action: () => setState(() {}),
                ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: CustomFutureBuilder(
        errorMessage: "",
        // future: CheckoutProcessApi().getCheckoutFlow(
        //   checkoutProcessStateModel.getchannelSet,
        // ),

        /// ***
        ///
        /// The use of a Temporal Flow Obj is to get from the server
        /// the specific payments for PoS that the checkout uses
        ///   (the stepper is for the checkout construction same as the web version does it but with  ==  "order"
        ///     to restrict it just to use the orden + the custombuttons).
        ///
        /// ***

        future: checkoutProcessStateModel
            .startCheckout(Provider.of<GlobalStateModel>(context)),
        onDataLoaded: (results) {
          CheckoutStructure checkoutStructure =
              CheckoutStructure.fromMap(results);
          List<Widget> bodies = List();
          List<String> headers = List();
          checkoutProcessStateModel.setcheckoutStructure(checkoutStructure);
          for (var i in checkoutStructure.sections) {
            /// ***
            /// to test just need to chage the commented
            /// if - checkout_screen.dart line 113
            /// and
            /// the sectionMap - checkout_process_state_model.dart line 182
            /// old implementation.

            // if (i.enabled ) {
            if (i.enabled && i.code == "order") {
              checkoutProcessStateModel.sectionIndexMap
                  .addAll({i.code: i.order});
              headers.add(i.code);
              if (i.code == "order" && widget.manual) {
                bodies.add(
                  checkoutProcessStateModel.sectionMap[i.code + "_manual"],
                );
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

  /// ***
  ///
  /// The temporal flow is need because its the way to know
  /// which paymentes are enabled in the terminal.
  ///
  /// ***

  temporalFlow(channelSet, checkoutProcessStateModel) async {
    var obj = await CheckoutProcessApi().createFlow(
      null,
      [],
      channelSet,
      Provider.of<GlobalStateModel>(context).currentBusiness.createdAt,
      false,
    );
    checkoutProcessStateModel.paymentOption.clear();
    obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_PAYMENT_OPTIONS].forEach(
      (pm) {
        checkoutProcessStateModel.paymentOption.add(
          CheckoutPaymentOption.toMap(pm),
        );
      },
    );
  }
}

class DeleteButton extends StatefulWidget {
  final VoidCallback action;
  final CheckoutProcessStateModel checkoutProcessStateModel;
  const DeleteButton({Key key, this.action, this.checkoutProcessStateModel})
      : super(key: key);

  @override
  _DeleteButtonState createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  @override
  void initState() {
    super.initState();
    widget.checkoutProcessStateModel.notifier
        .addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(15),
      icon: SvgPicture.asset(
        "assets/images/trashicon.svg",
        color: widget.checkoutProcessStateModel.posStateModel.haveProducts
            ? Colors.black
            : Colors.black45,
        height: Measurements.height * 0.035,
      ),
      onPressed: () {
        setState(() {
          // widget.action();
          widget.checkoutProcessStateModel.posStateModel.trashCart();
          widget.checkoutProcessStateModel.posCartStateModel.cartHasItems =
              false;
          widget.checkoutProcessStateModel.notifyListeners();
        });
      },
    );
  }
}

class QrButton extends StatefulWidget {
  final bool manual;

  const QrButton({Key key, this.manual}) : super(key: key);

  @override
  _QrButtonState createState() => _QrButtonState();
}

class _QrButtonState extends State<QrButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        "assets/images/qr.svg",
        color: Colors.black,
      ),
      padding: EdgeInsets.all(15),
      onPressed: () async {
        String _url = await generateQr(widget.manual);
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              child: Container(
                padding: EdgeInsets.all(10),
                child: QrImage(
                  backgroundColor: Colors.transparent,
                  data: _url,
                  version: 9,
                  gapless: false,
                  size: 300,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<String> generateQr(bool manual) async {
    String paymentUrl;
    var obj = await PosApi().postStorageSimple(
        GlobalUtils.activeToken.accessToken,
        manual
            ? []
            : Cart.items2MapSimple(
                Provider.of<CheckoutProcessStateModel>(context)
                    .posStateModel
                    .shoppingCart
                    .items),
        null,
        false,
        true,
        "widget.phone.replaceAll(" "," ")",
        DateTime.now()
            .subtract(Duration(hours: 1))
            .add(Duration(minutes: 1))
            .toIso8601String(),
        Provider.of<CheckoutProcessStateModel>(context).getchannelSet,
        true);
    paymentUrl = Env.wrapper +
        "/pay/restore-flow-from-code/" +
        obj["id"] +
        "?noHeaderOnLoading=true";
    return paymentUrl;
  }
}
