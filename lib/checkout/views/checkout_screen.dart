import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/channels/channels_screeen.dart';
import 'package:payever/checkout/views/channels/checkout_channel_shopsystem_screen.dart';
import 'package:payever/checkout/views/connect/checkout_device_payment_screen.dart';
import 'package:payever/checkout/views/channels/checkout_link_edit_screen.dart';
import 'package:payever/checkout/views/connect/checkout_twillo_settings.dart';
import 'package:payever/checkout/views/connect/connect_screen.dart';
import 'package:payever/checkout/views/payments/checkout_payment_settings_screen.dart';
import 'package:payever/checkout/views/payments/payment_options_screen.dart';
import 'package:payever/checkout/views/sections/sections_screen.dart';
import 'package:payever/checkout/views/settings/settings_screen.dart';
import 'package:payever/checkout/views/workshop/checkout_switch_screen.dart';
import 'package:payever/checkout/views/workshop/create_edit_checkout_screen.dart';
import 'package:payever/checkout/views/workshop/subview/work_shop_view.dart';
import 'package:payever/checkout/views/workshop/workshop_screen.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/shop/widgets/shop_top_button.dart';
import 'package:payever/theme.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'channels/channels_checkout_flow_screen.dart';
import 'channels/checkout_channelset_screen.dart';
import 'connect/checkout_connect_screen.dart';
import 'connect/checkout_qr_integration.dart';

class CheckoutInitScreen extends StatelessWidget {
  final DashboardScreenBloc dashboardScreenBloc;

  CheckoutInitScreen({
    this.dashboardScreenBloc,
  });

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return CheckoutScreen(
      globalStateModel: globalStateModel,
      dashboardScreenBloc: dashboardScreenBloc,
    );
  }
}

class CheckoutScreen extends StatefulWidget {

  final GlobalStateModel globalStateModel;
  final DashboardScreenBloc dashboardScreenBloc;

  CheckoutScreen({
    this.globalStateModel,
    this.dashboardScreenBloc,
  });

  @override
  State<StatefulWidget> createState() {
   return _CheckoutScreenState();
  }
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isPortrait;
  bool _isTablet;

  double iconSize;
  double margin;

  int selectedIndex = 0;
  CheckoutScreenBloc screenBloc;
  double mainWidth = 0;

  @override
  void initState() {
    screenBloc = CheckoutScreenBloc(
        dashboardScreenBloc: widget.dashboardScreenBloc,
        globalStateModel: widget.globalStateModel)
      ..add(CheckoutScreenInitEvent(
        business: widget.dashboardScreenBloc.state.activeBusiness,
        terminal: widget.dashboardScreenBloc.state.activeTerminal,
        checkouts: widget.dashboardScreenBloc.state.checkouts,
        defaultCheckout: widget.dashboardScreenBloc.state.defaultCheckout,
        channelSets: widget.dashboardScreenBloc.state.channelSets,
      ));
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

    if (mainWidth == 0) {
      mainWidth = GlobalUtils.isTablet(context) ? Measurements.width * 0.7 : Measurements.width;
    }

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, CheckoutScreenState state) async {
        if (state is CheckoutScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, CheckoutScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(CheckoutScreenState state) {
    iconSize = _isTablet ? 120: 80;
    margin = _isTablet ? 24: 16;
    return Scaffold(
      backgroundColor: overlayBackground(),
      appBar: MainAppbar(
        dashboardScreenBloc: widget.dashboardScreenBloc,
        dashboardScreenState: widget.dashboardScreenBloc.state,
        title: Language.getCommerceOSStrings('dashboard.apps.checkout'),
        icon: SvgPicture.asset(
          'assets/images/checkout.svg',
          height: 20,
          width: 20,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: Column(
            children: <Widget>[
              // _toolBar(state),
              // Expanded(child: _getBody(state)),
              Expanded(child: _body1(state),)
            ],
          ),
        ),
      ),
    );
  }

  Widget _toolBar(CheckoutScreenState state) {
    String defaultCheckoutTitle = '-';
    if (state.defaultCheckout != null) {
      defaultCheckoutTitle = state.defaultCheckout.name;
    }
    return Container(
      height: 50,
      width: double.infinity,
      color: Colors.black87,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            ShopTopButton(
              title: defaultCheckoutTitle,
              selectedIndex: selectedIndex,
              index: 0,
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
            ),
            ShopTopButton(
              title: Language.getSettingsStrings('info_boxes.panels.general.menu_list.personal_information.title'),
              selectedIndex: selectedIndex,
              index: 1,
              onTap: () {
                screenBloc.add(GetPaymentConfig());
                setState(() {
                  selectedIndex = 1;
                });
              },
            ),
            ShopTopButton(
              title: Language.getWidgetStrings('widgets.checkout.channels'),
              index: 2,
              selectedIndex: selectedIndex,
              onTap: () {
                screenBloc.add(GetChannelConfig());
                setState(() {
                  selectedIndex = 2;
                });
              },
            ),
            ShopTopButton(
              title: Language.getCommerceOSStrings('dashboard.apps.connect'),
              selectedIndex: selectedIndex,
              index: 3,
              onTap: () {
                screenBloc.add(GetConnectConfig());
                setState(() {
                  selectedIndex = 3;
                });
              },
            ),
            ShopTopButton(
              title: Language.getPosConnectStrings('Sections'),
              selectedIndex: selectedIndex,
              index: 4,
              onTap: () {
                screenBloc.add(GetSectionDetails());
                setState(() {
                  selectedIndex = 4;
                });
              },
            ),
            ShopTopButton(
              title: Language.getConnectStrings('categories.communications.main.titles.settings'),
              selectedIndex: selectedIndex,
              index: 5,
              onTap: () {
                setState(() {
                  selectedIndex = 5;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBody(CheckoutScreenState state) {
    switch (selectedIndex) {
      case 0:
        return state.isLoading || state.channelSet == null ?
        Center(
          child: CircularProgressIndicator(),
        ) : WorkshopScreen(checkoutScreenBloc: this.screenBloc);



      case 3:
        return ConnectScreen(
          checkoutScreenBloc: screenBloc,
          isLoading: state.loadingConnect,
          onChangeSwitch: (val) {
            screenBloc.add(InstallCheckoutIntegrationEvent(integrationId: val));
          },
          onTapAdd: () {
            Navigator.push(
              context,
              PageTransition(
                child: CheckoutConnectScreen(
                  checkoutScreenBloc: screenBloc,
                  business: state.activeBusiness.id,
                  category: 'communications',
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
              ),
            );
          },
          onTapOpen: (String title) {
            if (title.contains('QR')) {
              Navigator.push(
                context,
                PageTransition(
                  child: CheckoutQRIntegrationScreen(
                    screenBloc: screenBloc,
                    title: 'QR',
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            } else if (title.contains('Device')) {
              Navigator.push(
                context,
                PageTransition(
                  child: CheckoutDevicePaymentScreen(
                    screenBloc: screenBloc,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            } else if (title.contains('Twilio')) {
              Navigator.push(
                context,
                PageTransition(
                  child: CheckoutTwilioScreen(
                    screenBloc: screenBloc,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            }
          },
        );
      case 4:
        return SectionsScreen(
          checkoutScreenBloc: screenBloc,
        );
      case 5:
        return CheckoutSettingsScreen(
          checkoutScreenBloc: screenBloc,
          businessId: state.activeBusiness.id,
          checkout: screenBloc.state.defaultCheckout,
        );
    }
    return Container();
  }

  Widget _body1(CheckoutScreenState state) {
    if (state.isLoading || state.channelSet == null)
      return Center(
        child: CircularProgressIndicator(),
      );

    String defaultCheckoutTitle = '-';
    if (state.defaultCheckout != null) {
      defaultCheckoutTitle = state.defaultCheckout.name;
    }
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Container(
          width: mainWidth,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: overlayBackground(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    if (state.activeTerminal != null)
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: WorkshopView(
                                      business: state.activeBusiness,
                                      terminal: state.activeTerminal,
                                      // channelSetFlow: state.channelSetFlow,
                                      channelSetId: state.channelSet.id,
                                      defaultCheckout: state.defaultCheckout,
                                      fromCart: false,
                                      onTapClose: () {

                                      },
                                    ),
                                    type: PageTransitionType.fade
                                )
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/images/checkout.svg', width: 24, height: 24, color: iconColor(),),
                              SizedBox(width: 12,),
                              Expanded(child: Text(defaultCheckoutTitle, style: TextStyle(fontSize: 18),)),
                              Icon(Icons.arrow_forward_ios, size: 20,),
                            ],
                          ),
                        ),
                      ),
                    divider,
                    Container(
                      height: 61,
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: CheckoutSwitchScreen(
                                    businessId: state.activeBusiness.id,
                                    checkoutScreenBloc: screenBloc,
                                    onOpen: (Checkout checkout) {
                                      setState(() {

                                      });
                                    },
                                  ),
                                  type: PageTransitionType.fade
                              )
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/images/checkout-switch.svg', width: 24, height: 24,),
                            SizedBox(width: 12,),
                            Expanded(child: Text('Switch checkout', style: TextStyle(fontSize: 18),)),
                            Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),
                    ),
                    divider,
                    Container(
                      height: 61,
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: CreateEditCheckoutScreen(
                                    businessId: state.activeBusiness.id,
                                    fromDashBoard: false,
                                    screenBloc: CheckoutSwitchScreenBloc(),
                                  ),
                                  type: PageTransitionType.fade
                              )
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/images/checkout-add.svg', width: 24, height: 24,),
                            SizedBox(width: 12,),
                            Expanded(child: Text('Add new checkout', style: TextStyle(fontSize: 18),)),
                            Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16,),
              Container(
                  decoration: BoxDecoration(
                    color: overlayBackground(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Container(),
                                    type: PageTransitionType.fade
                                )
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/pay_link.svg',
                                width: 24,
                                height: 24,
                                color: iconColor(),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  child: Text(
                                    'Copy pay link',
                                    style: TextStyle(fontSize: 18),
                                  )),
                              Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                        ),
                      ),
                      divider,
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Container(),
                                    type: PageTransitionType.fade
                                )
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/prefilled_link.svg',
                                width: 24,
                                height: 24,
                                color: iconColor(),
                              ),
                              SizedBox(width: 12,),
                              Expanded(child: Text('Copy prefilled link', style: TextStyle(fontSize: 18),)),
                              Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                        ),
                      ),
                      divider,
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Container(),
                                    type: PageTransitionType.fade
                                )
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/email_link.svg',
                                width: 24,
                                height: 24,
                                color: iconColor(),
                              ),
                              SizedBox(width: 12,),
                              Expanded(child: Text('E-mail prefilled link', style: TextStyle(fontSize: 18),)),
                              Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                        ),
                      ),
                      divider,
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Container(),
                                    type: PageTransitionType.fade
                                )
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/prefilled_qr.svg',
                                width: 24,
                                height: 24,
                                color: iconColor(),
                              ),
                              SizedBox(width: 12,),
                              Expanded(child: Text('Prefilled QR code', style: TextStyle(fontSize: 18),)),
                              Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 16,),
              if (state.defaultCheckout != null)
                Container(
                  decoration: BoxDecoration(
                    color: overlayBackground(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: PaymentOptionsScreen(screenBloc),
                                    type: PageTransitionType.fade
                                )
                            );

                          },
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/images/checkout-payment.svg', width: 24, height: 24,),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  child: Text('Payment options', style: TextStyle(fontSize: 18),
                                  )),
                              Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                        ),
                      ),
                      divider,
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: ChannelsScreen(screenBloc),
                                    type: PageTransitionType.fade
                                )
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/images/checkout-channels.svg', width: 24, height: 24,),
                              SizedBox(width: 12,),
                              Expanded(child: Text(Language.getWidgetStrings('widgets.checkout.channels'), style: TextStyle(fontSize: 18),)),
                              Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                        ),
                      ),
                      divider,
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Container(),
                                    type: PageTransitionType.fade
                                )
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      '${Env.cdnIcon}icon-comerceos-connect-not-installed.png',
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12,),
                              Expanded(child: Text(Language.getCommerceOSStrings('dashboard.apps.connect'), style: TextStyle(fontSize: 18),)),
                              Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                        ),
                      ),
                      divider,
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Container(),
                                    type: PageTransitionType.fade
                                )
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      '${Env.cdnIcon}icon-comerceos-settings-not-installed.png',
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  child: Text(
                                    Language.getConnectStrings('categories.communications.main.titles.settings'),
                                    style: TextStyle(fontSize: 18),
                                  )),
                              Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                        ),
                      ),
                      divider,
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Container(),
                                    type: PageTransitionType.fade
                                )
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/images/checkout-section.svg', width: 24, height: 24,),
                              SizedBox(width: 12,),
                              Expanded(child: Text('Sections', style: TextStyle(fontSize: 18),)),
                              Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  get divider {
    return Divider(
      height: 0,
      indent: 50,
      thickness: 0.5,
      color: Colors.grey[500],
    );
  }
}