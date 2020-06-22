import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/BlurEffectView.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/TopBarView.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/transactions/FilterContentView.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/transactions/SortContentView.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/transactions/export_content_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/transactions/model/Enums.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/transactions/sub_view/search_text_content_view.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';
import '../view_models/view_models.dart';
import '../network/network.dart';
import '../../commons/view_models/view_models.dart';
import '../../commons/models/models.dart';
import '../../commons/views/screens/login/login.dart';
import '../../commons/views/screens/dashboard/transaction_card.dart';
import 'transactions_details_screen.dart';

bool _isPortrait;
bool _isTablet;
final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
// Allows you to get a list of all the ItemTags
_getAllItem(){
  List<Item> lst = _tagStateKey.currentState?.getAllItem;
  if(lst!=null)
    lst.where((a) => a.active==true).forEach( ( a) => print(a.title));
}

class TagItemModel {
  String title;
  FilterType type;
}

class TransactionScreenInit extends StatelessWidget {
  final TransactionStateModel dashboardStateModel = TransactionStateModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TransactionStateModel>(
      create: (BuildContext context) {
        return dashboardStateModel;
      },
      child: TransactionScreen(),
    );
  }
}

class TransactionScreen extends StatefulWidget {

  @override
  createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  ValueNotifier<bool> isLoadingSearch = ValueNotifier(true);
  TransactionScreenData data;

  Business _currentBusiness;

  bool _pos;
  bool initQueryNotEmpty = false;
  ValueNotifier<String> searching = ValueNotifier('');
  String search = '';
  bool init = true;
  String wallpaper;

  SortType curSortType = SortType.date;

  List<FilterType> filterTypes = [];

  @override
  void initState() {
    super.initState();
    _filterItems = [];
    isLoading.addListener(listener);
    isLoadingSearch.addListener(listener);
    searching.addListener(listener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  listener() {
    setState(() {});
  }

  num _quantity;

  String _currency;
  num _totalAmount;
  var f = NumberFormat("###,###,##0.00", "en_US");
  bool noTransactions = false;

  TransactionStateModel transactionsStateModel;

  List _filterItems;
  int _searchTagIndex = -1;

  fetchTransactions({String search, bool init}) {
    TransactionsApi api = TransactionsApi();
    api
        .getTransactionList(
      _currentBusiness.id,
      GlobalUtils.activeToken.accessToken,
      "?orderBy=created_at&direction=desc&limit=50&query=$search&page=1&currency=${_currentBusiness.currency}",
    )
        .then((obj) {
      data = TransactionScreenData(obj);
      if (init) isLoading.value = false;
      isLoadingSearch.value = false;
    }).catchError((onError) {
      if (onError.toString().contains("401")) {
        GlobalUtils.clearCredentials();
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: LoginScreen(), type: PageTransitionType.fade));
      }
      print(onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);
    transactionsStateModel = Provider.of<TransactionStateModel>(context);
    _currentBusiness = globalStateModel.currentBusiness;
    wallpaper = globalStateModel.currentWallpaper;

    fetchTransactions(init: init, search: transactionsStateModel.searchField);
    init = false;
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    if (data != null) {
      _quantity = isLoadingSearch.value
          ? 0
          : data.transaction.paginationData.total ?? 0;
      _currency = data.currency(globalStateModel.currentBusiness.currency);
      _totalAmount = isLoadingSearch.value
          ? 0
          : data.transaction.paginationData.amount ?? 0;
    }

    if (filterTypes.length > 0) {
      for (int i = 0; i < filterTypes.length; i++) {
        String filterString = ' start with: ${filterTypes[i]}';
      }
    }


    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        top: true,
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://payever.azureedge.net/images/commerceos-background.jpg"),
                      fit: BoxFit.cover)),
              child: BlurEffectView(
                radius: 0,
              ),
            ),
            Column(
              children: [
                TopBarView(
                  iconUrl: 'assets/images/transactions.svg',
                  title: 'Transactions',
                  onTapClose: () {
                    Navigator.of(context).pop();
                  },
                ),
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
                              showSearchTextDialog();
                            },
                            child: Icon(
                              Icons.search,
                              size: 24,
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
                            onTap: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (builder) {
                                    return FilterContentView(
                                      onSelected: (val) {
                                        Navigator.pop(context);
                                      },
                                    );
                                  });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.filter_list,
                                size: 24,
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
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
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (builder) {
                                    return SortContentView(
                                      selectedIndex: curSortType ,
                                      onSelected: (val) {
                                        Navigator.pop(context);
                                        setState(() {
                                          curSortType = val;
                                        });
                                      },
                                    );
                                  });
                            },
                            child: Icon(
                              Icons.sort,
                              size: 24,
                            ),
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
                      left: 16, right: 16,
                    ),
                    child: Tags(
                      key: _tagStateKey,
                      itemCount: _filterItems.length,
                      alignment: WrapAlignment.start,
                      itemBuilder: (int index) {
                        return ItemTags(
                          key: Key('filterItem$index'),
                          index: index,
                          title: _filterItems[index],
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
                              setState(() {
                                if (index == _searchTagIndex) {
                                  _searchTagIndex = -1;
                                  searching.value = '';
                                  search = '';
                                }
                                _filterItems.removeAt(index);
                              });
                              return true;
                            }
                          ),
                          onPressed: (item) {
                            showSearchTextDialog();
                          },
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
                          "Channel",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Type",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Customer name",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Total",
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
                  child: isLoading.value || isLoadingSearch.value ?
                  Center(
                    child: CircularProgressIndicator(),
                  ): CustomList(_currentBusiness, search,
                      data != null ? data.transaction.collection : [], data),
                ),
                Container(
                  height: 50,
                  color: Colors.black87,
                  alignment: Alignment.center,
                  child: !noTransactions ? AutoSizeText(
                    Language.getTransactionStrings("total_orders.heading")
                        .toString()
                        .replaceFirst("{{total_count}}", "${_quantity ?? 0}")
                        .replaceFirst("{{total_sum}}",
                        "${_currency ?? "€"}${f.format(_totalAmount ?? 0)}"),
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
            )
          ],
        ),
      ),
    );
  }

  void showSearchTextDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            content: SearchTextContentView(
                searchText: search,
                onSelected: (value) {
                  Navigator.pop(context);
                  setState(() {
                    searching.value = value;
                    search = value;
                    if (searching.value.length > 0) {
                      if (_searchTagIndex > -1) {
                        _filterItems[_searchTagIndex] = 'Search is: ${searching.value}';
                      } else {
                        _filterItems.add('Search is: ${searching.value}');
                        _searchTagIndex = _filterItems.length;
                      }
                    } else {
                      if (_searchTagIndex > -1) {
                        _filterItems.removeAt(_searchTagIndex);
                        _searchTagIndex = -1;
                      }
                    }
                  });
                }
            ),
          );
        });

  }
}

class CustomList extends StatefulWidget {
  final Business currentBusiness;
  final String search;
  final List<Collection> collection;
  final TransactionScreenData data;

  CustomList(this.currentBusiness, this.search, this.collection, this.data);

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
    pageCount = (widget.data.transaction.paginationData.total / 50).ceil();
    if (controller.position.extentAfter < 500) {
      if (page < pageCount && !isLoading.value) {
        setState(() {
          isLoading.value = true;
        });
        page++;
        TransactionsApi()
            .getTransactionList(
                widget.currentBusiness.id,
                GlobalUtils.activeToken.accessToken,
                "?orderBy=created_at&direction=desc&limit=50&query=${widget.search}&page=$page&currency=${widget.currentBusiness.currency}",)
            .then((transaction) {
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
                ? TabletTableRow(widget.collection[index], false, widget.data)
                : PhoneTableRow(widget.collection[index], false, widget.data));
      },
    );
  }
}

class PhoneTableRow extends StatelessWidget {
  final Collection currentTransaction;
  final TransactionScreenData data;
  final bool isHeader;

  PhoneTableRow(this.currentTransaction, this.isHeader, this.data);

  final f = NumberFormat("###,###.00", "en_US");

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
                                  "form.filter.labels.channel"),
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
                                      "form.filter.labels.type"),
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
                                  "form.filter.labels.customer_name"),
                              style: TextStyle(
                                  fontSize: AppStyle.fontSizeListRow())),
                    ),
                  ),
                  Expanded(
                    flex: _isPortrait ? 3 : 3,
                    child: Container(
                      child: !isHeader
                          ? Text(
                              "${Measurements.currency(currentTransaction.currency)}${f.format(currentTransaction.total)}",
                              style: TextStyle(
                                  fontSize: AppStyle.fontSizeListRow()),
                            )
                          : Text(
                              Language.getTransactionStrings(
                                  "form.filter.labels.total"),
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
                                    "${DateFormat.d("en_US").add_MMMM().add_y().format(time)} ${DateFormat.Hm("en_US").format(time.add(Duration(hours: 2)))}",
                                    style: TextStyle(
                                        fontSize: AppStyle.fontSizeListRow()))
                                : Text(
                                    Language.getTransactionStrings(
                                        "form.filter.labels.created_at"),
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
                                        "form.filter.labels.status"),
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
                                        fontFamily: 'MaterialIcons'),
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
          TransactionsApi api = TransactionsApi();
          GlobalStateModel globalStateModel =
              Provider.of<GlobalStateModel>(context);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                api
                    .getTransactionDetail(
                        globalStateModel.currentBusiness.id,
                        GlobalUtils.activeToken.accessToken,
                        currentTransaction.uuid)
                    .then((obj) {
                  var td = TransactionDetails.toMap(obj);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      PageTransition(
                          child: TransactionDetailsScreen(td),
                          type: PageTransitionType.fade));
                }).catchError((onError) {
                  if (onError.toString().contains("401")) {
                    GlobalUtils.clearCredentials();
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: LoginScreen(),
                            type: PageTransitionType.fade));
                  } else {
                    Navigator.pop(context);
                    print(onError);
                  }
                });
                return Container(
                  child: Dialog(
                    backgroundColor: Colors.transparent,
                    child: Center(
                      child: Container(child: CircularProgressIndicator()),
                    ),
                  ),
                );
              });
        }
      },
    );
  }
}

class TabletTableRow extends StatelessWidget {
  final Collection currentTransaction;
  final TransactionScreenData data;
  final bool isHeader;

  TabletTableRow(this.currentTransaction, this.isHeader, this.data);

  final f = NumberFormat("###,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

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
                                  "form.filter.labels.channel"),
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
                                      "form.filter.labels.type"),
                                  style: TextStyle(
                                      fontSize: AppStyle.fontSizeListRow()))),
                    ),
                  ),
                  Expanded(
                    flex: 12,
                    child: Container(
                      child: !isHeader
                          ? AutoSizeText("#${currentTransaction.originalId}",
                              style: TextStyle(
                                  fontSize: AppStyle.fontSizeListRow()))
                          : AutoSizeText(
                              Language.getTransactionStrings(
                                  "form.filter.labels.original_id"),
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: AppStyle.fontSizeListRow())),
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
                                  "form.filter.labels.customer_name"),
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
                              "${Measurements.currency(currentTransaction.currency)}${f.format(currentTransaction.total)}",
                              style: TextStyle(
                                  fontSize: AppStyle.fontSizeListRow()))
                          : AutoSizeText(
                              Language.getTransactionStrings(
                                  "form.filter.labels.total"),
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
                              "${DateFormat.d("en_US").add_MMMM().add_y().format(time)} ${DateFormat.Hm("en_US").format(time.add(Duration(hours: 2)))}",
                              style: TextStyle(
                                  fontSize: AppStyle.fontSizeListRow()))
                          : Text(
                              Language.getTransactionStrings(
                                  "form.filter.labels.created_at"),
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
                              Language.getTransactionStrings(
                                  "form.filter.labels.status"),
                              style: TextStyle(
                                  fontSize: AppStyle.fontSizeListRow())),
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
          TransactionsApi api = TransactionsApi();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                api
                    .getTransactionDetail(
                        globalStateModel.currentBusiness.id,
                        GlobalUtils.activeToken.accessToken,
                        currentTransaction.uuid,
                        )
                    .then((obj) {
                  var td = TransactionDetails.toMap(obj);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      PageTransition(
                          child: TransactionDetailsScreen(td),
                          type: PageTransitionType.fade));
                }).catchError((onError) {
                  Navigator.pop(context);
                  print(onError);
                });
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    child: Dialog(
                      backgroundColor: Colors.transparent,
                      child: Center(
                        child: Container(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                );
              });
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
