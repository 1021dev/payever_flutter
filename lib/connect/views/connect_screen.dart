import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/screens/dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/connect/views/connect_detail_screen.dart';
import 'package:payever/connect/views/connect_setting_screen.dart';
import 'package:payever/connect/widgets/connect_grid_item.dart';
import 'package:payever/connect/widgets/connect_list_item.dart';
import 'package:payever/connect/widgets/connect_top_button.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'connect_categories_screen.dart';


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

  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  double iconSize;
  double margin;

  List<ConnectPopupButton> appBarPopUpActions(BuildContext context, ConnectScreenState state) {
    return [
      ConnectPopupButton(
        title: Language.getProductListStrings('list_view'),
        icon: SvgPicture.asset('assets/images/list.svg'),
        onTap: () async {
          setState(() {
            selectedStyle = 0;
          });
        },
      ),
      ConnectPopupButton(
        title: Language.getProductListStrings('grid_view'),
        icon: SvgPicture.asset('assets/images/grid.svg'),
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
        if (state.installedConnect != '') {
          List<ConnectModel> models = state.connectInstallations;
          List list = models.where((element) =>
          element.integration.name == state.installedConnect).toList();
          if (list.length > 0) {
            showInstalledDialog(true, list.first);
          }
        } else if (state.uninstalledConnect != '') {
          List<ConnectModel> models = state.connectInstallations;
          List list = models.where((element) =>
          element.integration.name == state.uninstalledConnect).toList();
          if (list.length > 0) {
            showInstalledDialog(false, list.first);
          }
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
                child: SvgPicture.asset(
                  'assets/images/connect.svg',
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
    iconSize = _isTablet ? 120: 80;
    margin = _isTablet ? 24: 16;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(state),
      body: SafeArea(
        child: BackgroundBase(
          true,
          backgroudColor: Color.fromRGBO(0, 0, 0, 0.75),
          body: state.isLoading ?
          Center(
            child: CircularProgressIndicator(),
          ): Center(
            child: Column(
              children: <Widget>[
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

  Widget _topBar(ConnectScreenState state) {
    String itemsString = '';
    if (state.selectedCategory == 'all') {
      itemsString = '${state.connectInstallations.length} ${Language.getWidgetStrings('widgets.store.product.items')} in ${state.categories.length}'
          ' ${Language.getProductStrings('category.headings.categories').toLowerCase()}';
    } else {
      itemsString = '${state.connectInstallations.length} ${Language.getWidgetStrings('widgets.store.product.items')} in'
          ' ${Language.getConnectStrings('categories.${state.selectedCategory}.title')}';
    }
    return Container(
      height: 64,
      color: Color(0xFF212122),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                onTap: () async {
                  await showGeneralDialog(
                      barrierColor: null,
                      transitionBuilder: (context, a1, a2, wg) {
                    final curvedValue = 1.0 - Curves.ease.transform(a1.value);
                    return Transform(
                      transform: Matrix4.translationValues(-curvedValue * 200, 0.0, 0),
                      child: ConnectCategoriesScreen(
                        screenBloc: screenBloc,
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
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    'assets/images/filter.svg',
                    color: Color(0xFF78787d),
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: Container(
                  width: 1,
                  color: Color(0xFF888888),
                  height: 24,
                ),
              ),
              InkWell(
                onTap: () {

                },
                child: Text(
                  'Reset'
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12),
              ),
              Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: Measurements.width / 2, maxHeight: 36, minHeight: 36),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFF111111),
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: SvgPicture.asset(
                        'assets/images/search_place_holder.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: searchFocus,
                        controller: searchTextController,
                        autofocus: false,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search in Connect',
                          isDense: true,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                        onSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      !_isTablet && _isPortrait ? '' : itemsString,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton<ConnectPopupButton>(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: selectedStyle == 0 ? SvgPicture.asset('assets/images/list.svg'): SvgPicture.asset('assets/images/grid.svg'),
                    ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                item.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: item.icon,
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
          ),
        ],
      ),
    );
  }

  Widget _getBody(ConnectScreenState state) {
    return selectedStyle == 0
        ? _getListBody(state)
        : _getGridBody(state);
  }

  Widget _getListBody(ConnectScreenState state) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 44,
            padding: EdgeInsets.only(left: 24, right: 24),
            color: Color(0xff3f3f3f),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'App Name',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                      fontFamily: 'HelveticaNeue',
                      fontSize: 14,
                    ),
                  ),
                ),
                _isTablet || !_isPortrait ? Container(
                  width: Measurements.width * (_isPortrait ? 0.1 : 0.2),
                  child: Text(
                    'Category',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                      fontFamily: 'HelveticaNeue',
                      fontSize: 14,
                    ),
                  ),
                ): Container(),
                _isTablet || !_isPortrait ? Container(
                  width: Measurements.width * (_isPortrait ? 0.1 : 0.2),
                  child: Text(
                    'Developer',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                      fontFamily: 'HelveticaNeue',
                      fontSize: 14,
                    ),
                  ),
                ): Container(),
                _isTablet || !_isPortrait ? Container(
                  width: Measurements.width * (_isPortrait ? 0.1 : 0.2),
                  child: Text(
                    'Languages',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                      fontFamily: 'HelveticaNeue',
                      fontSize: 14,
                    ),
                  ),
                ): Container(),
                Container(
                  width: !_isTablet && _isPortrait ? null : Measurements.width * (_isTablet ? (_isPortrait ? 0.15 : 0.2) : (_isPortrait ? null: 0.35)),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Price',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                      fontFamily: 'HelveticaNeue',
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ConnectListItem(
                  connectModel: state.connectInstallations[index],
                  isPortrait: _isPortrait,
                  isTablet: _isTablet,
                  installingConnect: state.connectInstallations[index].integration.name == state.installingConnect,
                  onOpen: (model) {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: ConnectSettingScreen(
                          screenBloc: screenBloc,
                          connectIntegration: model.integration,
                        ),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  onInstall: (model) {
                    screenBloc.add(InstallConnectAppEvent(model: model));
                  },
                  onUninstall: (model) {
                    screenBloc.add(UninstallConnectAppEvent(model: model));
                  },
                  onTap: (model) {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: ConnectDetailScreen(
                          screenBloc: screenBloc,
                          connectModel: state.connectInstallations[index],
                        ),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Color.fromRGBO(255, 255, 255, 0.2),
                );
              },
              itemCount: state.connectInstallations.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getGridBody(ConnectScreenState state) {
    int crossAxisCount = _isTablet ? (_isPortrait ? 2 : 3): (_isPortrait ? 1 : 2);
    double imageRatio= 323.0 / 182.0;
    double contentHeight = 116;
    double cellWidth = _isPortrait ? (Measurements.width - 44) / crossAxisCount : (Measurements.height - 56) / crossAxisCount;
    double imageHeight = cellWidth / imageRatio;
    double cellHeight = imageHeight + contentHeight;
    print('$cellWidth,  $cellHeight, $imageHeight  => ${cellHeight / cellWidth}');
    if (state.connectInstallations.length == 0) {
      return Container();
    }
    return Container(
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        padding: EdgeInsets.all(16),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        shrinkWrap: true,
        childAspectRatio: cellWidth / cellHeight,
        children: state.connectInstallations.map((installation) {
          return ConnectGridItem(
            connectModel: installation,
            installingConnect: installation.integration.name == state.installingConnect,
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: ConnectDetailScreen(
                    screenBloc: screenBloc,
                    connectModel: installation,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            },
            onInstall: (model) {
              screenBloc.add(InstallConnectAppEvent(model: model));
            },
            onUninstall: (model) {
              screenBloc.add(UninstallConnectAppEvent(model: model));
            },
          );
        }).toList(),
      ),
    );
  }


    void showInstalledDialog(bool install, ConnectModel model) {
/*    "installation.installed.title": "Installed",
    "installation.installed.description": "You have successfully installed {{ title }}!<br>\nPlease connect you payment account to payever.",
    "installation.uninstalled.title": "Uninstalled",
    "installation.uninstalled.description": "You are successfully disconnected from \"{{ title }}\" now!",*/
      screenBloc.add(ClearInstallEvent());
      String detail = install ? Language.getConnectStrings('installation.installed.description')
          : Language.getConnectStrings('installation.uninstalled.description');
      if (install) {
        detail = detail.replaceAll('{{ title }}!<br>', Language.getPosConnectStrings(model.integration.displayOptions.title));
      } else {
        detail = detail.replaceAll('\"{{ title }}\"', Language.getPosConnectStrings(model.integration.displayOptions.title));
      }
      showCupertinoDialog(
        context: context,
        builder: (builder) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 250,
              width: Measurements.width * 0.8,
              child: BlurEffectView(
                color: Color.fromRGBO(50, 50, 50, 0.4),
                padding: EdgeInsets.all(margin / 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(margin / 2),
                    ),
                    Icon(Icons.check),
                    Padding(
                      padding: EdgeInsets.all(margin / 2),
                    ),
                    Text(
                      Language.getConnectStrings(install ? 'installation.installed.title': 'installation.uninstalled.title'),
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'HelveticaNeueMed',
                          color: Colors.white
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(margin / 2),
                    ),
                    Text(
                      detail,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Helvetica Neue',
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(margin / 2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (install) {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: ConnectSettingScreen(
                                    screenBloc: screenBloc,
                                    connectIntegration: model.integration,
                                  ),
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 500),
                                ),
                              );
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 24,
                          elevation: 0,
                          minWidth: 0,
                          color: Colors.white10,
                          child: Text(
                            install ? Language.getPosConnectStrings('integrations.actions.open') : Language.getConnectStrings('actions.close'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

}