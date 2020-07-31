import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/switcher/switcher_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            onLogout: () {
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

  Widget _body(CheckoutScreenState state) {
    return Scaffold(

    );
  }

}