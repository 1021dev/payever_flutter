import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/screens/dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/products_new/widgets/products_top_button.dart';
import 'package:payever/transactions/views/filter_content_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool _isPortrait;
bool _isTablet;


class ProductsInitScreen extends StatelessWidget {


  ProductsInitScreen();

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return ProductsScreen(
      globalStateModel: globalStateModel,
    );
  }
}

class ProductsScreen extends StatefulWidget {

  GlobalStateModel globalStateModel;

  ProductsScreen({
    this.globalStateModel,
  });

  @override
  createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  InAppWebViewController webView;
  double progress = 0;
  String url = '';

  ProductsScreenBloc screenBloc = ProductsScreenBloc();
  String wallpaper;
  int selectedIndex = 0;
  bool isShowCommunications = false;
  List<FilterItem> filterTypes = [];
  int selectedTypes = 0;
  int _selectedIndexValue = 0;

  @override
  void initState() {
    super.initState();
    screenBloc.add(
        ProductsScreenInitEvent(
          currentBusinessId: widget.globalStateModel.currentBusiness.id,
        )
    );
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
      listener: (BuildContext context, ProductsScreenState state) async {
        if (state is ProductsScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<ProductsScreenBloc, ProductsScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, ProductsScreenState state) {
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
                      child: LoginScreen(), type: PageTransitionType.fade));
            },
            onSwitchBusiness: () async {
              final result = await Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: SwitcherScreen(), type: PageTransitionType.fade));
              if (result == 'refresh') {
                screenBloc.add(
                    ProductsScreenInitEvent(
                      currentBusinessId: widget.globalStateModel.currentBusiness.id,
                    )
                );
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

  Widget _appBar(ProductsScreenState state) {
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
                    'assets/images/productsicon.svg',
                    color: Colors.white,
                    height: 16,
                    width: 24,
                  )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Text(
            Language.getWidgetStrings('widgets.products.title'),
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

  Widget _body(ProductsScreenState state) {
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
                _topBar(state),
                _toolBar(state),
                Expanded(
                  child: _getBody(state),
                ),
                _bottomBar(state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar(ProductsScreenState state) {
    return Container(
      height: 44,
      color: Colors.black87,
      child: Row(
        children: <Widget>[
          ProductsTopButton(
            title: Language.getProductStrings('product_list.all'),
            selectedIndex: selectedIndex,
            index: 0,
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
            },
          ),
          ProductsTopButton(
            title: Language.getProductStrings('add_product'),
            selectedIndex: selectedIndex,
            index: 1,
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _toolBar(ProductsScreenState state) {
    return Container(
      height: 50,
      color: Color(0xFF555555),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: _selectedIndexValue == 0 ? Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                InkWell(
                  onTap: () {

                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.search),
                  ),
                ),
                InkWell(
                  onTap: () {

                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.filter_list),
                  ),
                ),
              ],
            ): Container(),
          ),
          Flexible(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedIndexValue = 0;
                        });
                      },
                      color: _selectedIndexValue == 0 ? Color(0xFF2a2a2a): Color(0xFF1F1F1F),
                      height: 24,
                      minWidth: 100,
                      elevation: 0,
                      child: Text(
                        Language.getProductStrings('Products'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndexValue = 1;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      color: _selectedIndexValue == 1 ? Color(0xFF2a2a2a): Color(0xFF1F1F1F),
                      elevation: 0,
                      height: 24,
                      minWidth: 100,
                      child: Text(
                        Language.getProductStrings('Collections'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
          Flexible(
            flex: 1,
            child: _selectedIndexValue == 0 ? Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () {

                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.sort),
                ),
              ),
            ) : Container(),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar(ProductsScreenState state) {
    return Container(
      height: 50,
      color: Colors.black87,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16),
          ),
          Text(
            'Total: 0',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBody(ProductsScreenState state) {
    switch(selectedIndex) {
      default:
        return Container();
    }
  }

}

