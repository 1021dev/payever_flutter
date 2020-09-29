import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
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
import 'package:payever/checkout/views/workshop/workshop_screen.dart';
import 'package:payever/checkout/views/workshop/workshop_screen1.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/dashboard/sub_view/dashboard_menu_view.dart';
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
  final List<Checkout> checkouts;
  final Checkout defaultCheckout;

  CheckoutInitScreen({
    this.dashboardScreenBloc,
    this.checkouts = const [],
    this.defaultCheckout,
  });

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return CheckoutScreen(
      globalStateModel: globalStateModel,
      dashboardScreenBloc: dashboardScreenBloc,
      checkouts: checkouts,
      defaultCheckout: defaultCheckout,
    );
  }
}

class CheckoutScreen extends StatefulWidget {

  final GlobalStateModel globalStateModel;
  final DashboardScreenBloc dashboardScreenBloc;
  final List<Checkout> checkouts;
  final Checkout defaultCheckout;

  CheckoutScreen({
    this.globalStateModel,
    this.dashboardScreenBloc,
    this.checkouts = const [],
    this.defaultCheckout,
  });

  @override
  State<StatefulWidget> createState() {
   return _CheckoutScreenState();
  }
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isPortrait;
  bool _isTablet;

  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  double iconSize;
  double margin;

  int selectedIndex = 0;
  CheckoutScreenBloc screenBloc;

  @override
  void initState() {
    screenBloc = CheckoutScreenBloc(
        dashboardScreenBloc: widget.dashboardScreenBloc,
        globalStateModel: widget.globalStateModel)
      ..add(CheckoutScreenInitEvent(
        business: widget.globalStateModel.currentBusiness,
        checkouts: widget.checkouts,
        defaultCheckout: widget.defaultCheckout,
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
          return DashboardMenuView(
            innerDrawerKey: _innerDrawerKey,
            dashboardScreenBloc: widget.dashboardScreenBloc,
            activeBusiness: widget.dashboardScreenBloc.state.activeBusiness,
            onClose: () {
              _innerDrawerKey.currentState.toggle();
            },
            scaffold: _body(state),
          );
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
        innerDrawerKey: _innerDrawerKey,
      ),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: Column(
            children: <Widget>[
              _toolBar(state),
              Expanded(child: _getBody(state)),
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
              title: Language.getPosConnectStrings('integrations.payments.instant_payment.category'),
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
        ) : WorkshopScreen1(checkoutScreenBloc: this.screenBloc,);
      case 1:
        return PaymentOptionsScreen(
          connects: state.connects,
          integrations: state.checkoutConnections,
          isLoading: state.loadingPaymentOption,
          paymentOptions: state.paymentOptions,
          checkoutIntegrations: state.connections,
          onTapAdd: () {
            Navigator.push(
              context,
              PageTransition(
                child: CheckoutConnectScreen(
                  checkoutScreenBloc: screenBloc,
                  business: state.activeBusiness.id,
                  category: 'payments',
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
              ),
            );
          },
          onTapOpen: (connectModel) {
            Navigator.push(
              context,
              PageTransition(
                child: CheckoutPaymentSettingsScreen(
                  checkoutScreenBloc: screenBloc,
                  business: state.activeBusiness.id,
                  connectModel: connectModel,
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
              ),
            );
          },
          onTapInstall: (integrationModel) {
            screenBloc.add(InstallCheckoutPaymentEvent(integrationModel: integrationModel));
          },
          onTapUninstall: (integrationModel) {
            screenBloc.add(UninstallCheckoutPaymentEvent(integrationModel: integrationModel));
          },
        );
      case 2:
        return ChannelsScreen(
          checkoutScreenBloc: screenBloc,
          isLoading: state.loadingChannel,
          onChangeSwitch: (val) {

          },
          onTapAdd: () {
            Navigator.push(
              context,
              PageTransition(
                child: CheckoutConnectScreen(
                  checkoutScreenBloc: screenBloc,
                  business: state.activeBusiness.id,
                  category: 'shopsystems',
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
              ),
            );
          },
          onTapOpen: (ChannelItem model) {
            if (model.title == 'Pay by Link') {
              Navigator.push(
                context,
                PageTransition(
                  child: ChannelCheckoutFlowScreen(
                    checkoutScreenBloc:screenBloc,
                    openUrl:
                    'https://checkout.payever.org/pay/create-flow/channel-set-id/${state.channelSet.id}',
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            }
            else if (model.title == 'Point of Sale') {
              Navigator.push(
                context,
                PageTransition(
                  child: CheckoutChannelSetScreen(
                    checkoutScreenBloc: screenBloc,
                    business: state.activeBusiness.id,
                    category: 'pos',
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            }
            else if (model.title == 'Shop') {
              Navigator.push(
                context,
                PageTransition(
                  child: CheckoutChannelSetScreen(
                    checkoutScreenBloc: screenBloc,
                    business: state.activeBusiness.id,
                    category: 'shop',
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            }
            else if (model.title == 'Mail') {
              Navigator.push(
                context,
                PageTransition(
                  child: CheckoutChannelSetScreen(
                    checkoutScreenBloc: screenBloc,
                    business: state.activeBusiness.id,
                    category: 'marketing',
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            }
            else if (model.button == 'Edit') {
              Navigator.push(
                context,
                PageTransition(
                  child: CheckoutLinkEditScreen(
                    screenBloc: screenBloc,
                    title: model.title,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            }
            else {
              Navigator.push(
                context,
                PageTransition(
                  child: CheckoutChannelShopSystemScreen(
                    checkoutScreenBloc: screenBloc,
                    business: state.activeBusiness.id,
                    connectModel: model.model,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            }
          },
        );
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

}