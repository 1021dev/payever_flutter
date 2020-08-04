import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/checkout/views/channels_screeen.dart';
import 'package:payever/checkout/views/connect_screen.dart';
import 'package:payever/checkout/views/payment_options_screen.dart';
import 'package:payever/checkout/views/sections_screen.dart';
import 'package:payever/checkout/views/settings_screen.dart';
import 'package:payever/checkout/views/workshop_screen.dart';
import 'package:payever/checkout/widgets/checkout_top_button.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:payever/switcher/switcher_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'checkout_connect_screen.dart';

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
    screenBloc.add(CheckoutScreenInitEvent(business: widget.globalStateModel.currentBusiness.id));
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
            onLogout: () async* {
              FlutterSecureStorage storage = FlutterSecureStorage();
              await storage.deleteAll();
              SharedPreferences.getInstance().then((p) {
                p.setString(GlobalUtils.BUSINESS, '');
                p.setString(GlobalUtils.EMAIL, '');
                p.setString(GlobalUtils.PASSWORD, '');
                p.setString(GlobalUtils.DEVICE_ID, '');
                p.setString(GlobalUtils.DB_TOKEN_ACC, '');
                p.setString(GlobalUtils.DB_TOKEN_RFS, '');
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
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
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
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(state),
      body: SafeArea(
        child: BackgroundBase(
          true,
          backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _topBar(state),
              Expanded(
                child: Center(
                  child: _getBody(state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar(CheckoutScreenState state) {
    String defaultCheckoutTitle = '';
    if (state.defaultCheckout != null) {
      defaultCheckoutTitle = state.defaultCheckout.name;
    }
    return Container(
      color: Color(0xFF212122),
      child: Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CheckoutTopButton(
                    title: defaultCheckoutTitle,
                    selectedIndex: selectedIndex,
                    index: 0,
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                  ),
                  CheckoutTopButton(
                    title: Language.getPosConnectStrings('integrations.payments.instant_payment.category'),
                    selectedIndex: selectedIndex,
                    index: 1,
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                      screenBloc.add(GetPaymentConfig());
                    },
                  ),
                  CheckoutTopButton(
                    title: Language.getWidgetStrings('widgets.checkout.channels'),
                    selectedIndex: selectedIndex,
                    index: 2,
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                  ),
                  CheckoutTopButton(
                    title: Language.getCommerceOSStrings('dashboard.apps.connect'),
                    selectedIndex: selectedIndex,
                    index: 3,
                    onTap: () {
                      setState(() {
                        selectedIndex = 3;
                      });
                    },
                  ),
                  CheckoutTopButton(
                    title: Language.getPosConnectStrings('Sections'),
                    selectedIndex: selectedIndex,
                    index: 4,
                    onTap: () {
                      setState(() {
                        selectedIndex = 4;
                      });
                    },
                  ),
                  CheckoutTopButton(
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody(CheckoutScreenState state) {
    switch (selectedIndex) {
      case 0:
        return state.isLoading ?
        Center(
          child: CircularProgressIndicator(),
        ) : WorkShopInitScreen();
      case 1:
        return PaymentOptionsScreen(
          connects: state.connects,
          integrations: state.checkoutConnections,
          isLoading: state.isLoading,
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
        return ChannelsInitScreen();
      case 3:
        return ConnectInitScreen();
      case 4:
        return SectionsInitScreen();
      case 5:
        return CheckoutSettingsScreen(
          checkoutScreenBloc: screenBloc,
        );
    }
    return Container();
  }

}