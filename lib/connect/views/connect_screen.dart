
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/screens/dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/connect/widgets/connect_top_button.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ConnectInitScreen extends StatelessWidget {

  final List<Connect> connectModels;
  final Connect activeConnect;
  final DashboardScreenBloc dashboardScreenBloc;

  ConnectInitScreen({
    this.connectModels,
    this.activeConnect,
    this.dashboardScreenBloc,
  });

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return ConnectScreen(
      globalStateModel: globalStateModel,
      connectModels: connectModels,
      activeConnect: activeConnect,
      dashboardScreenBloc: dashboardScreenBloc,
    );
  }
}

class ConnectScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final List<Connect> connectModels;
  final Connect activeConnect;
  final DashboardScreenBloc dashboardScreenBloc;

  ConnectScreen({
    this.dashboardScreenBloc,
    this.activeConnect,
    this.connectModels,
    this.globalStateModel,
  });

  @override
  createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {

  bool _isPortrait;
  bool _isTablet;

  ConnectScreenBloc screenBloc;
  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  static int selectedIndex = 0;
  static int selectedStyle = 1;

  List<String> toolBarWidgetStrings = <String>[
    Language.getConnectStrings('categories.all.title'),
    Language.getConnectStrings('categories.payments.title'),
    Language.getConnectStrings('categories.shipping.title'),
    Language.getConnectStrings('categories.products.title'),
    Language.getConnectStrings('categories.shopsystem.title'),
    Language.getConnectStrings('categories.communication.title'),
  ];

  List<ConnectPopupButton> appBarPopUpActions(BuildContext context, ConnectScreenState state) {
    return [
      ConnectPopupButton(
        title: Language.getProductListStrings('list_view'),
        icon: Icon(Icons.view_list, size: 24,),
        onTap: () async {
          setState(() {
            selectedStyle = 0;
          });
        },
      ),
      ConnectPopupButton(
        title: Language.getProductListStrings('grid_view'),
        icon: Icon(Icons.grid_on, size: 24,),
        onTap: () async {
          setState(() {
            selectedStyle = 1;
          });
        },
      ),
    ];
  }

  @override
  void initState() {
    screenBloc = ConnectScreenBloc(
      dashboardScreenBloc: widget.dashboardScreenBloc,
    );
    screenBloc.add(
        ConnectScreenInitEvent(
          business: widget.globalStateModel.currentBusiness.id,
        )
    );
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
      listener: (BuildContext context, ConnectScreenState state) async {
        if (state is ConnectScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<ConnectScreenBloc, ConnectScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, ConnectScreenState state) {
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

  Widget _appBar(ConnectScreenState state) {
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
                  child: Icon(Icons.add, size: 24,),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Text(
            Language.getConnectStrings('layout.title'),
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
            Provider.of<GlobalStateModel>(context,listen: false)
                .setCurrentBusiness(widget.dashboardScreenBloc.state.activeBusiness);
            Provider.of<GlobalStateModel>(context,listen: false)
                .setCurrentWallpaper(widget.dashboardScreenBloc.state.curWall);

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
                    type: 'connect',
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

  Widget _body(ConnectScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(state),
      body: SafeArea(
        child: BackgroundBase(
          true,
          body: state.isLoading ?
          Center(
            child: CircularProgressIndicator(),
          ): Center(
            child: Column(
              children: <Widget>[
                _toolBar(state),
                _topBar(state),
                Expanded(
                  child: _getBody(state),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _toolBar(ConnectScreenState state) {
    return Container(
      height: 44,
      color: Colors.black87,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return ConnectTopButton(
            title: toolBarWidgetStrings[index],
            selectedIndex: selectedIndex,
            index: index,
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
          );
        },
        itemCount: toolBarWidgetStrings.length,
        separatorBuilder: (context, index) {
          return Container();
        },
      ),
    );
  }

  Widget _topBar(ConnectScreenState state) {
    return Container(
      height: 44,
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text(
              ' ${Language.getWidgetStrings('widgets.store.product.items')}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: PopupMenuButton<ConnectPopupButton>(
              icon: Icon(selectedStyle == 0 ? Icons.view_list: Icons.grid_on),
              offset: Offset(0, 100),
              onSelected: (ConnectPopupButton item) => item.onTap(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.black87,
              itemBuilder: (BuildContext context) {
                return appBarPopUpActions(context, state)
                    .map((ConnectPopupButton item) {
                  return PopupMenuItem<ConnectPopupButton>(
                    value: item,
                    child: Row(
                      children: <Widget>[
                        item.icon,
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        Text(
                          item.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBody(ConnectScreenState state) {
    return Container();
  }


}