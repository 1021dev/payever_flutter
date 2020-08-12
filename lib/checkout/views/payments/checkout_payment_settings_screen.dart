import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/views/connect/checkout_qr_integration.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/login/login_screen.dart';

class CheckoutPaymentSettingsScreen extends StatefulWidget {

  final CheckoutScreenBloc checkoutScreenBloc;
  final String business;
  final ConnectModel connectModel;

  CheckoutPaymentSettingsScreen({
    this.checkoutScreenBloc,
    this.business,
    this.connectModel,
  });

  @override
  _CheckoutPaymentSettingsScreenState createState() => _CheckoutPaymentSettingsScreenState();
}

class _CheckoutPaymentSettingsScreenState extends State<CheckoutPaymentSettingsScreen> {
  bool _isPortrait;
  bool _isTablet;
  double iconSize;
  double margin;

  CheckoutPaymentSettingScreenBloc screenBloc;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    screenBloc = CheckoutPaymentSettingScreenBloc(checkoutScreenBloc: widget.checkoutScreenBloc);
    screenBloc.add(CheckoutPaymentSettingScreenInitEvent(business: widget.business, connectModel: widget.connectModel,));
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, CheckoutPaymentSettingScreenState state) async {
        if (state is CheckoutPaymentSettingScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<CheckoutPaymentSettingScreenBloc, CheckoutPaymentSettingScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, CheckoutPaymentSettingScreenState state) {
          iconSize = _isTablet ? 120: 80;
          margin = _isTablet ? 24: 16;
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomPadding: false,
            appBar: _appBar(state),
            body: SafeArea(
              child: BackgroundBase(
                true,
                backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
                body: state.isLoading ?
                Center(
                  child: CircularProgressIndicator(),
                ): Center(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: _getBody(state),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(CheckoutPaymentSettingScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Text(
        Language.getPosConnectStrings(widget.connectModel.integration.displayOptions.title ?? ''),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody(CheckoutPaymentSettingScreenState state) {
    print(state.connectInstallations);
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    ConnectModel connectModel = state.connectInstallations[index];
                    String iconType = connectModel.integration.displayOptions.icon ?? '';
                    iconType = iconType.replaceAll('#icon-', '');
                    iconType = iconType.replaceAll('#', '');
                    return Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                  Measurements.channelIcon(iconType),
                                  width: 24,
                                  color: Colors.white70,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: margin / 2),
                                ),
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
                              ],
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              if (connectModel.installed) {
                                if (connectModel.integration.displayOptions.title.contains('qr')) {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: CheckoutQRIntegrationScreen(
                                        screenBloc: widget.checkoutScreenBloc,
                                        title: 'QR',
                                      ),
                                      type: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 500),
                                    ),
                                  );
                                }
                              }
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
                              connectModel.installed
                                  ? Language.getConnectStrings('actions.open')
                                  : Language.getPosConnectStrings('integrations.actions.install'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Helvetica Neue',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 0,
                      thickness: 0.5,
                      color: Colors.white70,
                    );
                  },
                  itemCount: state.connectInstallations.length,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}