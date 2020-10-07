import 'dart:io';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/pos/views/pos_connect_screen.dart';
import 'package:payever/pos/views/pos_create_terminal_screen.dart';
import 'package:payever/pos/views/pos_qr_app.dart';
import 'package:payever/pos/views/pos_switch_terminals_screen.dart';
import 'package:payever/pos/views/pos_twillo_settings.dart';
import 'package:payever/pos/views/products_screen/pos_products_screen.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/theme.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'pos_device_payment_settings.dart';

class PosInitScreen extends StatelessWidget {

  final List<Terminal> terminals;
  final Terminal activeTerminal;
  final DashboardScreenBloc dashboardScreenBloc;
  final Checkout defaultCheckout;
  final Business currentBusiness;
  final List<ChannelSet> channelSets;
  final List<ProductsModel> products;

  PosInitScreen({
    this.terminals,
    this.activeTerminal,
    this.dashboardScreenBloc,
    this.defaultCheckout,
    this.currentBusiness,
    this.channelSets,
    this.products,
  });

  @override
  Widget build(BuildContext context) {

    return PosScreen(
      dashboardScreenBloc: dashboardScreenBloc,
      currentBusiness: currentBusiness,
      terminals: terminals,
      activeTerminal: activeTerminal,
      defaultCheckout: defaultCheckout,
      channelSets: channelSets,
      products: products,
    );
  }
}

class PosScreen extends StatefulWidget {

  final List<Terminal> terminals;
  final Terminal activeTerminal;
  final DashboardScreenBloc dashboardScreenBloc;
  final Checkout defaultCheckout;
  final Business currentBusiness;
  final List<ChannelSet> channelSets;
  final List<ProductsModel> products;

  PosScreen({
    this.currentBusiness,
    this.terminals,
    this.activeTerminal,
    this.dashboardScreenBloc,
    this.defaultCheckout,
    this.channelSets,
    this.products,
  });

  @override
  createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {

  static const platform = const MethodChannel('payever.flutter.dev/tapthephone');
  PosScreenBloc screenBloc;
  int selectedIndex = 0;
  PosProductsScreen posProductScreen;
  @override
  void initState() {
    super.initState();

    screenBloc = PosScreenBloc(
      dashboardScreenBloc: widget.dashboardScreenBloc,
    )..add(PosScreenInitEvent(
        currentBusiness: widget.currentBusiness,
        terminals: widget.terminals,
        activeTerminal: widget.activeTerminal,
        defaultCheckout: widget.defaultCheckout,
        channelSets: widget.channelSets,
        products: widget.products
      ));
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, PosScreenState state) async {
        if (state is PosScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<PosScreenBloc, PosScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, PosScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(PosScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: MainAppbar(
        dashboardScreenBloc: widget.dashboardScreenBloc,
        dashboardScreenState: widget.dashboardScreenBloc.state,
        title:
        Language.getWidgetStrings('widgets.pos.title'),
        icon: SvgPicture.asset(
          'assets/images/pos.svg',
          color: Colors.white,
          height: 20,
          width: 20,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: state.isLoading ?
          Center(
            child: CircularProgressIndicator(),
          ): Column(
            children: <Widget>[
              _toolBar(state),
              Expanded(
                child: _getBody(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toolBar(PosScreenState state) {
    return Container(
      height: 50,
      color: overlaySecondAppBar(),
      child: Row(
        children: <Widget>[
          if (state.activeTerminal != null)
            PosTopButton(
              title: state.activeTerminal.name,
              selectedIndex: selectedIndex,
              index: 0,
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
            ),
          if (state.activeTerminal != null)
            PosTopButton(
              title: 'Connect',
              selectedIndex: selectedIndex,
              index: 1,
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
            ),
          if (state.activeTerminal != null)
            PosTopButton(
              title: 'Settings',
              index: 2,
              selectedIndex: selectedIndex,
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
              },
            ),
          PosTopButton(
            title: 'Open',
            selectedIndex: selectedIndex,
            index: 3,
            onTap: () {
              if (Platform.isAndroid) {
                _showNativeView();
              }
            },
          ),
          PopupMenuButton<OverflowMenuItem>(
            icon: Icon(Icons.more_horiz, color: Colors.white,),
            offset: Offset(0, 100),
            onSelected: (OverflowMenuItem item) => item.onTap(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: overlayFilterViewBackground(),
            itemBuilder: (BuildContext context) {
              return appBarPopUpActions(context, state)
                  .map((OverflowMenuItem item) {
                return PopupMenuItem<OverflowMenuItem>(
                  value: item,
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }

  Widget _getBody(PosScreenState state) {
    switch(selectedIndex) {
      case 0:
        if (posProductScreen == null) {
          List<ProductsModel>products = [];
          products.addAll(widget.products);
          posProductScreen = PosProductsScreen(
              state.businessId,
              screenBloc,
              products,
              widget.dashboardScreenBloc.state.posProductsInfo,);
        }
        return posProductScreen;
      case 1:
        return _connectWidget(state);
      case 2:
        return _settingsWidget(state);
      default:
        return Container();
    }
  }

  Widget _connectWidget(PosScreenState state) {
    List<Communication> integrations = state.integrations;
    List<String> terminalIntegrations = state.terminalIntegrations;
    return Center(
      child: Container(
        width: Measurements.width,
        padding: EdgeInsets.only(left: 16, right: 16),
        height: (state.integrations.length * 50).toDouble() + 50,
        child: BlurEffectView(
          radius: 12,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                        height: 50,
                        child: Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                Language.getPosConnectStrings(integrations[index].integration.displayOptions.title),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                      value: terminalIntegrations.contains(integrations[index].integration.name),
                                      onChanged: (value) {
                                        screenBloc.add(value ? InstallTerminalDevicePaymentEvent(
                                          payment: integrations[index].integration.name,
                                          businessId: widget.currentBusiness.id,
                                          terminalId: state.activeTerminal.id,
                                        ): UninstallTerminalDevicePaymentEvent(
                                          payment: integrations[index].integration.name,
                                          businessId: widget.currentBusiness.id,
                                          terminalId: state.activeTerminal.id,
                                        ));
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (state.integrations[index].integration.name == 'device-payments') {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: PosDevicePaymentSettings(
                                              businessId: widget.currentBusiness.id,
                                              screenBloc: screenBloc,
                                            ),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 500),
                                          ),
                                        );
                                      }
                                      else if (state.integrations[index].integration.name == 'qr') {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: PosQRAppScreen(
                                              businessId: widget.currentBusiness.id,
                                              screenBloc: screenBloc,
                                              businessName: widget.currentBusiness.name,
                                            ),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 500),
                                          ),
                                        );
                                      } else if (state.integrations[index].integration.name == 'twilio') {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: PosTwilioScreen(
                                              businessId: widget.currentBusiness.id,
                                              screenBloc: screenBloc,
                                              businessName: widget.currentBusiness.name,
                                            ),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 500),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 20,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: overlayBackground()
                                      ),
                                      child: Center(
                                        child: Text(
                                          Language.getCommerceOSStrings('actions.open'),
                                          style: TextStyle(
                                              fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 0,
                      thickness: 0.5,
                      color: Colors.white30,
                      endIndent: 0,
                      indent: 0,
                    );
                  },
                  itemCount: state.integrations.length,
                ),
              ),
              integrations.length > 0 ? Divider(
                height: 0,
                thickness: 0.5,
                color: Colors.white30,
                endIndent: 0,
                indent: 0,
              ): Container(height: 0,),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                height: 50,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: PosConnectScreen(
                          activeBusiness: widget.currentBusiness,
                          screenBloc: screenBloc,
                        ),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          size: 12,
                        ),
                        Padding(padding: EdgeInsets.only(left: 4),),
                        Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsWidget(PosScreenState state) {
    return Container(
      padding: EdgeInsets.all(16),
      width: Measurements.width,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Business UUID',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              Expanded(
                child: AutoSizeText(
                  widget.currentBusiness.id,
                  minFontSize: 12,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              MaterialButton(
                height: 32,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: overlayBackground(),
                child: Text(
                  state.businessCopied ? 'Copied': 'Copy',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
                onPressed: () {
                  screenBloc.add(CopyBusinessEvent(businessId: widget.currentBusiness.id));
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'Terminal UUID',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              Expanded(
                child: AutoSizeText(
                  state.activeTerminal.id,
                  minFontSize: 12,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              MaterialButton(
                height: 32,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: overlayBackground(),
                child: Text(
                  state.terminalCopied ? 'Copied': 'Copy',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
                onPressed: () {
                  screenBloc.add(CopyTerminalEvent(
                      businessId: widget.currentBusiness.id,
                      terminal: state.activeTerminal));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<OverflowMenuItem> appBarPopUpActions(BuildContext context, PosScreenState state) {
    return [
      if (state.activeTerminal != null)
        OverflowMenuItem(
          title: 'Switch terminal',
          onTap: () async {
            Navigator.push(
              context,
              PageTransition(
                child: PosSwitchTerminalsScreen(
                  screenBloc: screenBloc,
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
              ),
            );
          },
        ),
      OverflowMenuItem(
        title: 'Add new terminal',
        onTap: () async {
          Navigator.push(
            context,
            PageTransition(
              child: PosCreateTerminalScreen(
                screenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        },
      ),
      OverflowMenuItem(
        title: 'Edit',
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              child: PosCreateTerminalScreen(
                screenBloc: screenBloc,
                editTerminal: state.activeTerminal,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        },
      ),
    ];
  }

  Future<Null> _showNativeView() async {
    await platform.invokeMethod('showNativeView');
  }
}

