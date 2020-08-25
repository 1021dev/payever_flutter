import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:payever/search/views/search_screen.dart';
import 'package:payever/switcher/switcher_page.dart';
import 'package:payever/transactions/models/enums.dart';
import 'package:payever/transactions/views/filter_content_view.dart';
import 'package:payever/transactions/views/sort_content_view.dart';
import 'package:payever/transactions/views/export_content_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/utils.dart';
import '../view_models/view_models.dart';
import '../network/network.dart';
import '../../commons/view_models/view_models.dart';
import '../../commons/models/models.dart';
import 'sub_view/search_text_content_view.dart';
import 'transactions_details_screen.dart';

bool _isPortrait;
bool _isTablet;
final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

class TagItemModel {
  String title;
  String type;
  TagItemModel({this.title = '', this.type});
}

class TransactionScreenInit extends StatelessWidget {
  final DashboardScreenBloc dashboardScreenBloc;

  TransactionScreenInit({this.dashboardScreenBloc});
  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return TransactionScreen(
      globalStateModel: globalStateModel,
      dashboardScreenBloc: dashboardScreenBloc,
    );
  }
}

class TransactionScreen extends StatefulWidget {

  final GlobalStateModel globalStateModel;
  final DashboardScreenBloc dashboardScreenBloc;

  TransactionScreen({
    this.globalStateModel,
    this.dashboardScreenBloc,
  });

  @override
  createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TransactionsScreenBloc screenBloc;
  String wallpaper;
  num _quantity;
  String _currency;
  num _totalAmount;
  var f = NumberFormat('###,###,##0.00', 'en_US');
  bool noTransactions = false;
  List<TagItemModel> _filterItems;
  int _searchTagIndex = -1;
  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();

  @override
  void initState() {
    super.initState();
    screenBloc = TransactionsScreenBloc(
      dashboardScreenBloc: widget.dashboardScreenBloc,
    );
    screenBloc.add(TransactionsScreenInitEvent(widget.globalStateModel.currentBusiness));
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
      listener: (BuildContext context, TransactionsScreenState state) async {
        if (state is TransactionsScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<TransactionsScreenBloc, TransactionsScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, state) {
          NumberFormat format = NumberFormat();
          if (state.transaction != null) {
            _quantity = state.transaction.paginationData.total ?? 0;
            _currency = format.simpleCurrencySymbol(widget.globalStateModel.currentBusiness.currency);
            _totalAmount = state.transaction.paginationData.amount ?? 0;
          } else {
            _quantity = 0;
            _currency = '';
            _totalAmount = 0;
          }

          _filterItems = [];
          if (state.filterTypes.length > 0) {
            for (int i = 0; i < state.filterTypes.length; i++) {
              String filterString = '${filterLabels[state.filterTypes[i].type]} ${filterConditions[state.filterTypes[i].condition]}: ${state.filterTypes[i].disPlayName}';
              TagItemModel item = TagItemModel(title: filterString, type: state.filterTypes[i].type);
              _filterItems.add(item);
            }
          }
          if (state.searchText.length > 0) {
            _filterItems.add(TagItemModel(title: 'Search is: ${state.searchText}', type: null));
            _searchTagIndex = _filterItems.length - 1;
          }
          return DashboardMenuView(
            innerDrawerKey: _innerDrawerKey,
            activeBusiness: screenBloc.dashboardScreenBloc.state.activeBusiness,
            onLogout: () async {
              FlutterSecureStorage storage = FlutterSecureStorage();
              await storage.delete(key: GlobalUtils.TOKEN);
              await storage.delete(key: GlobalUtils.BUSINESS);
              await storage.delete(key: GlobalUtils.REFRESH_TOKEN);
              SharedPreferences.getInstance().then((p) {
                p.setString(GlobalUtils.BUSINESS, '');
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

  Widget _body(TransactionsScreenState state) {
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
          ): Column(
            children: [
              Container(
                height: 50,
                color: Colors.black38,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 12,
                        ),
                        InkWell(
                          onTap: () {
                            if (state.isSearchLoading) return;
                            showSearchTextDialog(state);
                          },
                          child: SvgPicture.asset('assets/images/searchicon.svg', width: 20,),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: () {
                            if (state.isSearchLoading) return;
                            showCupertinoModalPopup(
                                context: context,
                                builder: (builder) {
                                  return FilterContentView(
                                    onSelected: (FilterItem val) {
                                      Navigator.pop(context);
                                      List<FilterItem> filterTypes = [];
                                      filterTypes.addAll(state.filterTypes);
                                      if (val != null) {
                                        if (filterTypes.length > 0) {
                                          int isExist = filterTypes.indexWhere((element) => element.type == val.type);
                                          if (isExist > -1) {
                                            filterTypes[isExist] = val;
                                          } else {
                                            filterTypes.add(val);
                                          }
                                        } else {
                                          filterTypes.add(val);
                                        }
                                      } else {
                                        if (filterTypes.length > 0) {
                                          int isExist = filterTypes.indexWhere((element) => element.type == val.type);
                                          if (isExist != null) {
                                            filterTypes.removeAt(isExist);
                                          }
                                        }
                                      }
                                      screenBloc.add(
                                          UpdateFilterTypes(filterTypes: filterTypes)
                                      );
                                    },
                                  );
                                });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            child: SvgPicture.asset('assets/images/filter.svg', width: 20,),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            if (state.isSearchLoading) return;
                            showGeneralDialog(
                                barrierLabel: 'Export',
                                barrierDismissible: true,
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionDuration: Duration(milliseconds: 350),
                                context: context,
                                pageBuilder: (context, anim1, anim2) {
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ExportContentView(
                                      onSelectType: (index) {},
                                    ),
                                  );
                                }
                            );
                          },
                          child: Text(
                            'Export',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (state.isSearchLoading) return;
                            showCupertinoModalPopup(
                                context: context,
                                builder: (builder) {
                                  return SortContentView(
                                    selectedIndex: state.curSortType ,
                                    onSelected: (val) {
                                      Navigator.pop(context);
                                      screenBloc.add(
                                          UpdateSortType(sortType: val)
                                      );
                                    },
                                  );
                                });
                          },
                          child: SvgPicture.asset('assets/images/sort-by-button.svg', width: 20,),
                        ),
                        SizedBox(
                          width: 24,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _filterItems.length > 0 ?
              Container(
                width: Device.width,
                padding: EdgeInsets.only(
                  left: 16, right: 16, top: 8, bottom: 8,
                ),
                child: Tags(
                  key: _tagStateKey,
                  itemCount: _filterItems.length,
                  alignment: WrapAlignment.start,
                  spacing: 4,
                  runSpacing: 8,
                  itemBuilder: (int index) {
                    return ItemTags(
                      key: Key('filterItem$index'),
                      index: index,
                      title: _filterItems[index].title,
                      color: Colors.white12,
                      activeColor: Colors.white12,
                      textActiveColor: Colors.white,
                      textColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.only(
                        left: 16, top: 8, bottom: 8, right: 16,
                      ),
                      removeButton: ItemTagsRemoveButton(
                          backgroundColor: Colors.transparent,
                          onRemoved: () {
                            if (index == _searchTagIndex) {
                              _searchTagIndex = -1;
                              screenBloc.add(
                                  UpdateSearchText(searchText: '')
                              );
                            } else {
                              List<FilterItem> filterTypes = [];
                              filterTypes.addAll(state.filterTypes);
                              filterTypes.removeAt(index);
                              screenBloc.add(
                                  UpdateFilterTypes(filterTypes: filterTypes)
                              );
                            }
                            return true;
                          }
                      ),
                    );
                  },
                ),
              ): Container(height: 0,),
              Container(
                height: 35,
                color: Colors.black45,
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Channel',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Type',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Customer name',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Total',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state.isSearchLoading ? Center(
                  child: CircularProgressIndicator(),
                ) : (state.transaction.collection.length > 0 ? CustomList(widget.globalStateModel,
                    state.transaction != null ? state.transaction.collection : [],
                    state):
                Center(
                  child: Text(
                    'The list is empty',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 24,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                )),
              ),
              Container(
                height: 50,
                color: Colors.black87,
                alignment: Alignment.center,
                child: !noTransactions ? AutoSizeText(
                  Language.getTransactionStrings('total_orders.heading')
                      .toString()
                      .replaceFirst('{{total_count}}', '${_quantity ?? 0}')
                      .replaceFirst('{{total_sum}}',
                      '${_currency ?? '€'}${f.format(_totalAmount ?? 0)}'),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                )
                    : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar(TransactionsScreenState state) {
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
                    'assets/images/transactions.svg',
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
            'Transactions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/images/business_person.svg',
                  width: 20,
                ),
                _isTablet || !_isPortrait ? Padding(
                  padding: EdgeInsets.only(left: 4, right: 4),
                  child: Text(
                    widget.dashboardScreenBloc.state.activeBusiness.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ): Container(),
              ],
            ),
            onTap: () {
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: SvgPicture.asset('assets/images/searchicon.svg', width: 20,),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: SearchScreen(
                    dashboardScreenBloc: widget.dashboardScreenBloc,
                    businessId: widget.dashboardScreenBloc.state.activeBusiness.id,
                    searchQuery: '',
                    appWidgets: widget.dashboardScreenBloc.state.currentWidgets,
                    activeBusiness: widget.dashboardScreenBloc.state.activeBusiness,
                    currentWall: widget.dashboardScreenBloc.state.curWall,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: SvgPicture.asset(
              'assets/images/notificationicon.svg',
              width: 20,
            ),
            onTap: () async {
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
                      type: 'transactions',
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
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: SvgPicture.asset(
              'assets/images/list.svg',
              width: 20,
            ),
            onTap: () {
              _innerDrawerKey.currentState.toggle();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: SvgPicture.asset(
              'assets/images/closeicon.svg',
              width: 16,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 8),
        ),
      ],
    );
  }

  void showSearchTextDialog(TransactionsScreenState state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          content: SearchTextContentView(
              searchText: state.searchText,
              onSelected: (value) {
                Navigator.pop(context);
                screenBloc.add(
                    UpdateSearchText(searchText: value)
                );
              }
          ),
        );
      },
    );
  }
}

class CustomList extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final List<Collection> collection;
  final TransactionsScreenState screenState;
  CustomList(this.globalStateModel, this.collection, this.screenState);

  @override
  _CustomListState createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  ScrollController controller;
  ValueNotifier isLoading = ValueNotifier(false);

  int page = 1;
  int pageCount;

  @override
  void initState() {
    super.initState();

    controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    pageCount = (widget.screenState.transaction.paginationData.total / 50).ceil();
    if (controller.position.extentAfter < 500) {
      if (page < pageCount && !isLoading.value) {
        setState(() {
          isLoading.value = true;
        });
        page++;

        TransactionsApi api = TransactionsApi();
        String queryString = '';
        String sortQuery = '';
        if (widget.screenState.curSortType == 'date') {
          sortQuery = 'orderBy=created_at&direction=desc&';
        } else if (widget.screenState.curSortType == 'total_high') {
          sortQuery = 'orderBy=total&direction=desc&';
        } else if (widget.screenState.curSortType == 'total_low') {
          sortQuery = 'orderBy=total&direction=asc&';
        } else if (widget.screenState.curSortType == 'customer_name') {
          sortQuery = 'orderBy=customer_name&direction=asc&';
        }
        queryString = '?${sortQuery}limit=50&query=${widget.screenState.searchText}&page=$page&currency=${widget.globalStateModel.currentBusiness.currency}';
        if (widget.screenState.filterTypes.length > 0) {
          for (int i = 0; i < widget.screenState.filterTypes.length; i++) {
            FilterItem item = widget.screenState.filterTypes[i];
            String filterType = item.type;
            String filterCondition = item.condition;
            String filterValue = item.value;
            String filterConditionString = 'filters[$filterType][$i][condition]';
            String filterValueString = 'filters[$filterType][$i][value]';
            String queryTemp = '&$filterConditionString=$filterCondition&$filterValueString=$filterValue';
            queryString = '$queryString$queryTemp';
          }
        }

        api.getTransactionList(
          widget.globalStateModel.currentBusiness.id,
          GlobalUtils.activeToken.accessToken,
          queryString,
        ).then((transaction) {
          List<Collection> temp = Transaction.toMap(transaction).collection;
          if (temp.isNotEmpty) {
            setState(() {
              isLoading.value = false;
              widget.collection.addAll(temp);
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: GlobalKeys.transactionList,
//      shrinkWrap: true,
      controller: controller,
      itemCount: widget.collection.length,
      itemBuilder: (BuildContext context, int index) {
//        if (index == 0)
//          return _isTablet
//              ? TabletTableRow(null, true, null)
//              : PhoneTableRow(null, true, null);
//        index = index - 1;
        Key itemKey = Key('transaction.list.transaction_$index');

        return Container(
          key: itemKey,
          child: _isTablet
              ? TabletTableRow(
            globalStateModel: widget.globalStateModel,
            currentTransaction: widget.collection[index],
            state: widget.screenState,
            isHeader: false,
          )
              : PhoneTableRow(
            globalStateModel: widget.globalStateModel,
            currentTransaction: widget.collection[index],
            state: widget.screenState,
            isHeader: false,
          ),
        );
      },
    );
  }
}

class PhoneTableRow extends StatelessWidget {
  final Collection currentTransaction;
  final TransactionsScreenState state;
  final GlobalStateModel globalStateModel;
  final bool isHeader;

  PhoneTableRow({
    this.globalStateModel,
    this.currentTransaction,
    this.isHeader,
    this.state,
  });

  final f = NumberFormat('###,###.00', 'en_US');

  @override
  Widget build(BuildContext context) {
    DateTime time;
    if (currentTransaction != null)
      time = DateTime.parse(currentTransaction.createdAt);

    return InkWell(
      highlightColor: Colors.transparent,
      child: Container(
        //alignment: Alignment.topCenter,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              padding: AppStyle.listRowPadding(false),
              height: AppStyle.listRowSize(false),
              child: Row(
                children: <Widget>[
                  Expanded(
//                    flex: _isPortrait ? 2 : 1.2,
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: !isHeader
                          ? TransactionScreenParts.channelIcon(
                          currentTransaction.channel)
                          : Container(
                          child: Text(
                            Language.getTransactionStrings(
                                'form.filter.labels.channel'),
                            style: TextStyle(
                                fontSize: AppStyle.fontSizeListRow()),
                          )),
                    ),
                  ),
                  Expanded(
//                    flex: _isPortrait ? 2 : 1,
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: !isHeader
                          ? TransactionScreenParts.paymentType(
                          currentTransaction.type)
                          : Container(
                        child: Text(
                            Language.getTransactionStrings(
                                'form.filter.labels.type'),
                            style: TextStyle(
                                fontSize: AppStyle.fontSizeListRow())),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: _isPortrait ? 6 : 5,
                    child: Container(
                      child: !isHeader
                          ? Text(
                        currentTransaction.customerName,
                        style: TextStyle(
                            fontSize: AppStyle.fontSizeListRow()),
                      )
                          : Text(
                          Language.getTransactionStrings(
                              'form.filter.labels.customer_name'),
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow())),
                    ),
                  ),
                  Expanded(
                    flex: _isPortrait ? 3 : 3,
                    child: Container(
                      child: !isHeader
                          ? Text(
                        '${Measurements.currency(currentTransaction.currency)}${f.format(currentTransaction.total)}',
                        style: TextStyle(
                            fontSize: AppStyle.fontSizeListRow()),
                      )
                          : Text(
                          Language.getTransactionStrings(
                              'form.filter.labels.total'),
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow())),
                    ),
                  ),
                  Expanded(
                    flex: _isPortrait ? 0 : 4,
                    child: !_isPortrait
                        ? Container(
                      child: !isHeader
                          ? Text(
                          '${DateFormat.d('en_US').add_MMMM().add_y().format(time)} ${DateFormat.Hm('en_US').format(time.add(Duration(hours: 2)))}',
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow()))
                          : Text(
                          Language.getTransactionStrings(
                              'form.filter.labels.created_at'),
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow())),
                    )
                        : Container(),
                  ),
                  Expanded(
                    flex: _isPortrait ? 0 : 3,
                    child: !_isPortrait
                        ? Container(
                      width: Measurements.width *
                          (_isPortrait ? 0.20 : 0.24),
                      child: !isHeader
                          ? Measurements.statusWidget(
                          currentTransaction.status)
                          : AutoSizeText(
                          Language.getTransactionStrings(
                              'form.filter.labels.status'),
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow())),
                    )
                        : Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: !_isPortrait
                        ? Container()
                        : Container(
                      width: Measurements.width * 0.02,
                      child: !isHeader
                          ? Icon(
                        IconData(58849,
                            fontFamily: 'MaterialIcons',
                        ),
                        size: Measurements.width * 0.04,
                      )
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.white.withOpacity(0.5)),
          ],
        ),
      ),
      onTap: () {
        if (!isHeader) {
          Navigator.push(
            context,
            PageTransition(
              child: TransactionDetailsScreen(
                businessId: globalStateModel.currentBusiness.id,
                transactionId: currentTransaction.uuid,
              ),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
    );
  }
}

class TabletTableRow extends StatelessWidget {
  final Collection currentTransaction;
  final TransactionsScreenState state;
  final GlobalStateModel globalStateModel;
  final bool isHeader;

  TabletTableRow({
    this.globalStateModel,
    this.currentTransaction,
    this.isHeader,
    this.state,
  });

  final f = NumberFormat('###,##0.00', 'en_US');

  @override
  Widget build(BuildContext context) {

    DateTime time;
    if (currentTransaction != null)
      time = DateTime.parse(currentTransaction.createdAt);
    return InkWell(
      highlightColor: Colors.transparent,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: AppStyle.listRowSize(true),
              padding: AppStyle.listRowPadding(true),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: !isHeader
                          ? Container(
//                          alignment: _isPortrait ? Alignment.centerLeft : Alignment.center,
                          alignment: Alignment.center,
                          child: TransactionScreenParts.channelIcon(
                              currentTransaction.channel))
                          : Container(
                          child: AutoSizeText(
                            Language.getTransactionStrings(
                                'form.filter.labels.channel'),
                            style: TextStyle(
                                fontSize: AppStyle.fontSizeListRow()),
                          )),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: !isHeader
                          ? Container(
                          alignment: Alignment.center,
                          child: TransactionScreenParts.paymentType(
                              currentTransaction.type))
                          : Container(
                          child: AutoSizeText(
                              Language.getTransactionStrings(
                                  'form.filter.labels.type'),
                              style: TextStyle(
                                  fontSize: AppStyle.fontSizeListRow()))),
                    ),
                  ),
                  Expanded(
                    flex: 12,
                    child: Container(
                      child: !isHeader
                          ? AutoSizeText('#${currentTransaction.originalId}',
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow(),
                          ),
                      )
                          : AutoSizeText(
                          Language.getTransactionStrings(
                              'form.filter.labels.original_id'),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow(),
                          ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      child: !isHeader
                          ? AutoSizeText(currentTransaction.customerName,
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow()))
                          : AutoSizeText(
                          Language.getTransactionStrings(
                              'form.filter.labels.customer_name'),
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow())),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: !isHeader
                          ? AutoSizeText(
                          '${Measurements.currency(currentTransaction.currency)}${f.format(currentTransaction.total)}',
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow()))
                          : AutoSizeText(
                          Language.getTransactionStrings(
                              'form.filter.labels.total'),
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow())),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      child: !isHeader
                          ? AutoSizeText(
                          '${DateFormat.d('en_US').add_MMMM().add_y().format(time)} ${DateFormat.Hm('en_US').format(time.add(Duration(hours: 2)))}',
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow()))
                          : Text(
                          Language.getTransactionStrings(
                              'form.filter.labels.created_at'),
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow())),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: Measurements.width * (_isPortrait ? 0.13 : 0.15),
                      child: !isHeader
                          ? Measurements.statusWidget(currentTransaction.status)
                          : Text(
                          Language.getTransactionStrings('form.filter.labels.status'),
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow(),
                          ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              color: Colors.white.withOpacity(0.5),
            ),
          ],
        ),
      ),
      onTap: () {
        if (!isHeader) {
          Navigator.push(
            context,
            PageTransition(
              child: TransactionDetailsScreen(
                businessId: globalStateModel.currentBusiness.id,
                transactionId: currentTransaction.uuid,
              ),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
    );
  }
}

class TransactionScreenParts {
  static channelIcon(String channel) {
    double size = AppStyle.iconRowSize(_isTablet);
    return SvgPicture.asset(Measurements.channelIcon(channel), height: size);
  }

  static paymentType(String type) {
    double size = AppStyle.iconRowSize(_isTablet);
    Color _color = Colors.white.withOpacity(0.7);
    return SvgPicture.asset(
      Measurements.paymentType(type),
      height: size,
      color: _color,
    );
  }
}
