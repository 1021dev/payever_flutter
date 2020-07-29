import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/screens/dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/connect/widgets/connect_top_button.dart';
import 'package:payever/contacts/views/add_contact_screen.dart';
import 'package:payever/contacts/views/contacts_filter_screen.dart';
import 'package:payever/contacts/widgets/contact_grid_add_item.dart';
import 'package:payever/contacts/widgets/contact_grid_item.dart';
import 'package:payever/contacts/widgets/contact_list_item.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ContactsInitScreen extends StatelessWidget {

  final DashboardScreenBloc dashboardScreenBloc;

  ContactsInitScreen({
    this.dashboardScreenBloc,
  });

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return ContactScreen(
      globalStateModel: globalStateModel,
      dashboardScreenBloc: dashboardScreenBloc,
    );
  }
}

class ContactScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final DashboardScreenBloc dashboardScreenBloc;

  ContactScreen({
    this.dashboardScreenBloc,
    this.globalStateModel,
  });

  @override
  createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  bool _isPortrait;
  bool _isTablet;

  ContactScreenBloc screenBloc;
  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  static int selectedIndex = 0;
  static int selectedStyle = 1;

  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  double iconSize;
  double margin;

  List<ConnectPopupButton> appBarPopUpActions(BuildContext context, ContactScreenState state) {
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
    screenBloc = ContactScreenBloc(
      dashboardScreenBloc: widget.dashboardScreenBloc,
    );
    screenBloc.add(
        ContactScreenInitEvent(
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
      listener: (BuildContext context, ContactScreenState state) async {
        if (state is ContactScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<ContactScreenBloc, ContactScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, ContactScreenState state) {
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

  Widget _appBar(ContactScreenState state) {
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
                  'assets/images/contacts.svg',
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
            Language.getCommerceOSStrings('dashboard.apps.contacts'),
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

  Widget _body(ContactScreenState state) {
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

  Widget _topBar(ContactScreenState state) {
    String itemsString = '';
    int selectedCount = 0;
    if (state.contactLists.length > 0) {
      selectedCount = state.contactLists.where((element) => element.isChecked).toList().length;
    }
    itemsString = '${state.contactLists.length} items';
    return selectedCount == 0 ? Container(
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
                            child: ContactsFilterScreen(
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
                      padding: EdgeInsets.all(margin),
                      child: SvgPicture.asset(
                        'assets/images/filter.svg',
                        width: 12,
                        height: 12,
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
                              hintText: 'Search in Contact',
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
                    GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/images/sort-by-button.svg',
                          width: 12,
                          height: 12,
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
    ): Container(
      height: 64,
      color: Color(0xFF212122),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            onPressed: () {
              screenBloc.add(SelectAllContactsEvent());
            },
            child: Text(
              'Select all',
            ),
          ),
          Container(
            height: 36,
            width: 0.5,
            color: Colors.white38,
          ),
          MaterialButton(
            onPressed: () {
              screenBloc.add(DeselectAllContactsEvent());
            },
            child: Text(
              'Deselect all',
            ),
          ),
          Container(
            height: 36,
            width: 0.5,
            color: Colors.white38,
          ),
          MaterialButton(
            onPressed: () {
              screenBloc.add(DeleteSelectedContactsEvent());
            },
            child: Text(
              'Delete',
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBody(ContactScreenState state) {
    return selectedStyle == 0
        ? _getListBody(state)
        : _getGridBody(state);
  }

  Widget _getListBody(ContactScreenState state) {
    int selectedCount = 0;
    if (state.contactLists.length > 0) {
      selectedCount = state.contactLists.where((element) => element.isChecked).toList().length;
    }
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 44,
            padding: EdgeInsets.only(left: 24, right: 24),
            color: Color(0xff3f3f3f),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    screenBloc.add(SelectAllContactsEvent());
                  },
                  child: Icon(
                    selectedCount == state.contactLists.length ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Text(
                  'Contacts',
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ContactListItem(
                  isTablet: _isTablet,
                  isPortrait: _isPortrait,
                  onOpen: (contactModel) {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: AddContactScreen(
                          screenBloc: screenBloc,
                          editContact: contactModel.contact,
                        ),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  onTap: (contactModel){
                    screenBloc.add(SelectContactEvent(contact: contactModel));
                  },
                  contact: state.contactLists[index],
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Color.fromRGBO(255, 255, 255, 0.2),
                );
              },
              itemCount: state.contactLists.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getGridBody(ContactScreenState state) {
    int crossAxisCount = _isTablet ? (_isPortrait ? 2 : 3): (_isPortrait ? 1 : 2);
    double imageRatio= 323.0 / 182.0;
    double contentHeight = 116;
    double cellWidth = _isPortrait ? (Measurements.width - 44) / crossAxisCount : (Measurements.height - 56) / crossAxisCount;
    double imageHeight = cellWidth / imageRatio;
    double cellHeight = imageHeight + contentHeight;
    print('$cellWidth,  $cellHeight, $imageHeight  => ${cellHeight / cellWidth}');

    List<Widget> widgets = [];
    widgets.add(
      ContactGridAddItem(
        onAdd: () {
          Navigator.push(
            context,
            PageTransition(
              child: AddContactScreen(
                screenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        },
      ),
    );
    if (state.contacts != null) {
      widgets.addAll(state.contactLists.map((contact) {
        return ContactGridItem(
          contact: contact,
          onTap: (contactModel) {
            screenBloc.add(SelectContactEvent(contact: contactModel));
          },
          onOpen: (contactModel) {
            Navigator.push(
              context,
              PageTransition(
                child: AddContactScreen(
                  screenBloc: screenBloc,
                  editContact: contactModel.contact,
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
              ),
            );
          },
        );
      }).toList());
    }

    return Container(
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        padding: EdgeInsets.all(16),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        shrinkWrap: true,
        childAspectRatio: cellWidth / cellHeight,
        children: widgets,
      ),
    );
  }

}