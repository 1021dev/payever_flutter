import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/channels_screeen.dart';
import 'package:payever/checkout/views/checkout_link_edit_screen.dart';
import 'package:payever/checkout/views/connect_screen.dart';
import 'package:payever/checkout/views/payment_options_screen.dart';
import 'package:payever/checkout/views/sections_screen.dart';
import 'package:payever/checkout/views/settings_screen.dart';
import 'package:payever/checkout/views/workshop_screen.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:payever/switcher/switcher_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'channels_checkout_flow_screen.dart';
import 'checkout_channelset_screen.dart';
import 'checkout_connect_screen.dart';
import 'checkout_qr_integration.dart';

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
    screenBloc = CheckoutScreenBloc(dashboardScreenBloc: widget.dashboardScreenBloc);
    screenBloc.add(CheckoutScreenInitEvent(
      business: widget.globalStateModel.currentBusiness.id,
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
              child: LoginScreen(),
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
            onLogout: () async {
              FlutterSecureStorage storage = FlutterSecureStorage();
              await storage.delete(key: GlobalUtils.TOKEN);
              await storage.delete(key: GlobalUtils.BUSINESS);
              await storage.delete(key: GlobalUtils.REFRESH_TOKEN);
              SharedPreferences.getInstance().then((p) {
                p.setString(GlobalUtils.BUSINESS, '');
                p.setString(GlobalUtils.DEVICE_ID, '');
              });
              Navigator.pushReplacement(
                context,
                PageTransition(
                  child: LoginScreen(), type: PageTransitionType.fade,
                ),
              );
            },
            onSwitchBusiness: () async {
              final result = await Navigator.pushReplacement(
                context,
                PageTransition(
                  child: SwitcherScreen(),
                  type: PageTransitionType.fade,
                ),
              );
              if (result == 'refresh') {
              }
            },
            onPersonalInfo: () {

            },
            onAddBusiness: () {

            },
            onClose: () {
              _innerDrawerKey.currentState.toggle();
            },
            scaffold: _body(state),
          );
        },
      ),
    );
  }

  Widget _appBar(CheckoutScreenState state) {
    String defaultCheckoutTitle = '';
    if (state.defaultCheckout != null) {
      defaultCheckoutTitle = state.defaultCheckout.name;
    }
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      bottom: TabBar(
        isScrollable: true,
        indicatorColor: Colors.white70,
        onTap: (index) {
          if (index == 1) {
            screenBloc.add(GetPaymentConfig());
          } else if (index == 2) {
            screenBloc.add(GetChannelConfig());
          } else if (index == 3) {
            screenBloc.add(GetConnectConfig());
          } else if (index == 4) {
            screenBloc.add(GetSectionDetails());
          }
        },
        tabs: <Widget>[
          Tab(
            text: defaultCheckoutTitle,
          ),
          Tab(
            text: Language.getPosConnectStrings('integrations.payments.instant_payment.category'),
          ),
          Tab(
            text: Language.getWidgetStrings('widgets.checkout.channels'),
          ),
          Tab(
            text: Language.getCommerceOSStrings('dashboard.apps.connect'),
          ),
          Tab(
            text: Language.getPosConnectStrings('Sections'),
          ),
          Tab(
            text: Language.getConnectStrings('categories.communications.main.titles.settings'),
          ),
        ],
      ),
      title: Row(
        children: <Widget>[
          Container(
            child: Center(
              child: Container(
                child: SvgPicture.asset(
                  'assets/images/checkout.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Text(
            Language.getCommerceOSStrings('dashboard.apps.checkout'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
            Icons.person_pin,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
          },
        ),
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.search,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {

          },
        ),
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () async{
            await showGeneralDialog(
              barrierColor: null,
              transitionBuilder: (context, a1, a2, wg) {
                final curvedValue = Curves.ease.transform(a1.value) -   1.0;
                return Transform(
                  transform: Matrix4.translationValues(-curvedValue * 200, 0.0, 0),
                  child: NotificationsScreen(
                    business: widget.dashboardScreenBloc.state.activeBusiness,
                    businessApps: widget.dashboardScreenBloc.state.businessWidgets,
                    dashboardScreenBloc: widget.dashboardScreenBloc,
                    type: 'checkout',
                  ),
                );
              },
              transitionDuration: Duration(milliseconds: 200),
              barrierDismissible: true,
              barrierLabel: '',
              context: context,
              pageBuilder: (context, animation1, animation2) {
                return null;
              },
            );
          },
        ),
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.menu,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            _innerDrawerKey.currentState.toggle();
          },
        ),
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

  Widget _body(CheckoutScreenState state) {
    iconSize = _isTablet ? 120: 80;
    margin = _isTablet ? 24: 16;
    return DefaultTabController(
      length: 6,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomPadding: false,
        appBar: _appBar(state),
        body: SafeArea(
          child: BackgroundBase(
            true,
            backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                _getBody(state, 0),
                _getBody(state, 1),
                _getBody(state, 2),
                _getBody(state, 3),
                _getBody(state, 4),
                _getBody(state, 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBody(CheckoutScreenState state, int index) {

    switch (index) {
      case 0:
        return state.isLoading ?
        Center(
          child: CircularProgressIndicator(),
        ) : WorkshopScreen(checkoutScreenBloc: this.screenBloc,);
      case 1:
        return PaymentOptionsScreen(
          connects: state.connects,
          integrations: state.checkoutConnections,
          isLoading: state.loadingPaymentOption,
          onTapAdd: () {
            Navigator.push(
              context,
              PageTransition(
                child: CheckoutConnectScreen(
                  checkoutScreenBloc: screenBloc,
                  business: state.business,
                  category: 'payments',
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
              ),
            );
          },
          onTapOpen: (connectModel) {

          },
          onTapInstall: () {

          },
          onTapUninstall: () {

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
                  business: state.business,
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
                    url:
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
                    business: state.business,
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
                    business: state.business,
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
                    business: state.business,
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
          },
        );
      case 3:
        return ConnectScreen(
          checkoutScreenBloc: screenBloc,
          isLoading: state.loadingConnect,
          onChangeSwitch: (val) {
          },
          onTapAdd: () {
            Navigator.push(
              context,
              PageTransition(
                child: CheckoutConnectScreen(
                  checkoutScreenBloc: screenBloc,
                  business: state.business,
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
          businessId: state.business,
          checkout: screenBloc.state.defaultCheckout,
        );
    }
    return Container();
  }

}