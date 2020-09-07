import 'dart:async';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/dashboard/sub_view/business_logo.dart';
import 'package:payever/dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/views/collection_detail_screen.dart';
import 'package:payever/products/views/product_detail_screen.dart';
import 'package:payever/products/widgets/collection_grid_item.dart';
import 'package:payever/products/widgets/product_filter_content_view.dart';
import 'package:payever/products/widgets/product_grid_item.dart';
import 'package:payever/products/widgets/product_sort_content_view.dart';
import 'package:payever/products/widgets/products_top_button.dart';
import 'package:payever/search/views/search_screen.dart';
import 'package:payever/theme.dart';
import 'package:payever/transactions/models/enums.dart';
import 'package:payever/transactions/views/sub_view/search_text_content_view.dart';
import 'package:payever/transactions/views/transactions_screen.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';


bool _isPortrait;
bool _isTablet;

final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

class ProductsInitScreen extends StatelessWidget {
  final ProductsModel productModel;
  final DashboardScreenBloc dashboardScreenBloc;

  ProductsInitScreen({this.productModel, this.dashboardScreenBloc});

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return ProductsScreen(
      globalStateModel: globalStateModel,
      productModel: productModel,
      dashboardScreenBloc: dashboardScreenBloc,
    );
  }
}

class ProductsScreen extends StatefulWidget {

  final ProductsModel productModel;
  final DashboardScreenBloc dashboardScreenBloc;
  final GlobalStateModel globalStateModel;

  ProductsScreen({
    this.globalStateModel,
    this.productModel,
    this.dashboardScreenBloc,
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
  List<TagItemModel> _filterItems;
  int _searchTagIndex = -1;

  ProductsScreenBloc screenBloc;
  String wallpaper;
  int selectedIndex = 0;
  List<FilterItem> filterTypes = [];
  int selectedTypes = 0;
  int _selectedIndexValue = 0;
  RefreshController _productsRefreshController = RefreshController(
    initialRefresh: false,
  );
  RefreshController _collectionsRefreshController = RefreshController(
    initialRefresh: false,
  );

  List<OverflowMenuItem> productsPopUpActions(BuildContext context, ProductsScreenState state) {
    return [
      OverflowMenuItem(
        title: 'Select All',
        onTap: () {
          screenBloc.add(SelectAllProductsEvent());
        },
      ),
      OverflowMenuItem(
        title: 'UnSelect',
        onTap: () {
          screenBloc.add(UnSelectProductsEvent());
        },
      ),
      OverflowMenuItem(
        title: 'Add to Collection',
        onTap: () {
          screenBloc.add(AddToCollectionEvent());
        },
      ),
      OverflowMenuItem(
        title: 'Delete Products',
        onTap: () {
          showCupertinoDialog(
            context: context,
            builder: (builder) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  height: 216,
                  child: BlurEffectView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        Icon(Icons.info),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        Text(
                          Language.getPosStrings('Deleting Products'),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        Text(
                          Language.getPosStrings('Do you really want to delete your products?'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 24,
                              elevation: 0,
                              minWidth: 0,
                              color: overlayBackground(),
                              child: Text(
                                Language.getPosStrings('actions.no'),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                                List<ProductsModel> deletes = [];
                                state.productLists.forEach((element) {
                                  if (element.isChecked) {
                                    deletes.add(element.productsModel);
                                  }
                                });
                                screenBloc.add(DeleteProductsEvent(models: deletes));
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 24,
                              elevation: 0,
                              minWidth: 0,
                              color: overlayBackground(),
                              child: Text(
                                Language.getPosStrings('actions.yes'),
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
          },
      ),
    ];
  }

  List<OverflowMenuItem> collectionsPopUpActions(BuildContext context, ProductsScreenState state) {
    return [
      OverflowMenuItem(
        title: 'Select All',
        onTap: () {
          screenBloc.add(SelectAllCollectionsEvent());
        },
      ),
      OverflowMenuItem(
        title: 'UnSelect',
        onTap: () {
          screenBloc.add(UnSelectCollectionsEvent());
        },
      ),
      OverflowMenuItem(
        title: 'Delete Collections',
        onTap: () {
          showCupertinoDialog(
            context: context,
            builder: (builder) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  height: 216,
                  child: BlurEffectView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        Icon(Icons.info),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        Text(
                          Language.getPosStrings('Deleting Collections'),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        Text(
                          Language.getPosStrings('Do you really want to delete your collections?'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 24,
                              elevation: 0,
                              minWidth: 0,
                              color: overlayBackground(),
                              child: Text(
                                Language.getPosStrings('actions.no'),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                                screenBloc.add(DeleteCollectionProductsEvent());
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 24,
                              elevation: 0,
                              minWidth: 0,
                              color: overlayBackground(),
                              child: Text(
                                Language.getPosStrings('actions.yes'),
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
          },
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    screenBloc = ProductsScreenBloc(dashboardScreenBloc: widget.dashboardScreenBloc);
    screenBloc.add(
        ProductsScreenInitEvent(
          currentBusinessId: widget.globalStateModel.currentBusiness.id,
        )
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.productModel != null) {
      Navigator.push(
        context,
        PageTransition(
          child: ProductDetailScreen(
            businessId: widget.globalStateModel.currentBusiness.id,
            screenBloc: screenBloc,
            productsModel: widget.productModel,
          ),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 500),
        ),
      );
    }
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

  Widget _appBar(ProductsScreenState state) {
    String businessLogo = '';
    if (widget.dashboardScreenBloc.state.activeBusiness != null && widget.dashboardScreenBloc.state.activeBusiness.logo != null) {
      businessLogo = 'https://payeverproduction.blob.core.windows.net/images/${widget.dashboardScreenBloc.state.activeBusiness.logo}';
    }
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
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
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: Row(
              children: <Widget>[
                BusinessLogo(url: businessLogo,),
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
                      type: 'products',
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

  Widget _body(ProductsScreenState state) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(state),
      body: SafeArea(
        bottom: false,
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
                _tagsBar(state),
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
    return BlurEffectView(
      radius: 0,
      child: Container(
        height: 44,
        color: overlayBackground(),
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
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ProductDetailScreen(
                        businessId: widget.globalStateModel.currentBusiness.id,
                        screenBloc: screenBloc,
                      ),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolBar(ProductsScreenState state) {
    int selectedCount = 0;
    if (_selectedIndexValue == 0 && state.productLists.length > 0) {
      selectedCount = state.productLists.where((element) => element.isChecked).toList().length;
    } else if (_selectedIndexValue == 1 && state.collectionLists.length > 0){
      selectedCount = state.collectionLists.where((element) => element.isChecked).toList().length;
    }
    return Stack(
      children: <Widget>[
        Container(
          height: 50,
          color: overlayBackground().withOpacity(0.5),
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
                        showSearchTextDialog(state);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: SvgPicture.asset('assets/images/searchicon.svg', width: 20, color: iconColor(),),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return ProductFilterContentView(
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
                                    UpdateProductFilterTypes(filterTypes: filterTypes)
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: SvgPicture.asset('assets/images/filter.svg', width: 20, color: iconColor(),),
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
                          Expanded(
                            child: MaterialButton(
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
                              color: _selectedIndexValue == 0 ? overlayBackground(): overlayBackground().withOpacity(0.1),
                              height: 24,
                              elevation: 0,
                              minWidth: 0,
                              padding: EdgeInsets.zero,
                              child: AutoSizeText(
                                Language.getProductStrings('Products'),
                                minFontSize: 8,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 2),
                          ),
                          Expanded(
                            child: MaterialButton(
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
                              color: _selectedIndexValue == 1 ? overlayBackground(): overlayBackground().withOpacity(0.1),
                              elevation: 0,
                              minWidth: 0,
                              height: 24,
                              padding: EdgeInsets.zero,
                              child: AutoSizeText(
                                Language.getProductStrings('Collections'),
                                maxLines: 1,
                                minFontSize: 8,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
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
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return ProductSortContentView(
                            selectedIndex: state.sortType ,
                            onSelected: (val) {
                              Navigator.pop(context);
                              screenBloc.add(
                                  UpdateProductSortType(sortType: val)
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: SvgPicture.asset('assets/images/sort-by-button.svg', width: 20, color: iconColor(),),
                    ),
                  ),
                ) : Container(),
              ),
            ],
          ),
        ),
        selectedCount > 0 ? Container(
          height: 50,
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 4,
            bottom: 4,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF888888),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                    ),
                    InkWell(
                      child: SvgPicture.asset('assets/images/xsinacircle.svg'),
                      onTap: () {
                        if (_selectedIndexValue == 0) {
                          screenBloc.add(UnSelectProductsEvent());
                        } else {
                          screenBloc.add(UnSelectCollectionsEvent());
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text(
                      '$selectedCount ITEM${selectedCount > 1 ? 'S': ''} SELECTED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<OverflowMenuItem>(
                  icon: Icon(Icons.more_horiz),
                  offset: Offset(0, 100),
                  onSelected: (OverflowMenuItem item) => item.onTap(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.black87,
                  itemBuilder: (BuildContext context) {
                    return _selectedIndexValue == 0 ? productsPopUpActions(context, state).map((OverflowMenuItem item) {
                      return PopupMenuItem<OverflowMenuItem>(
                        value: item,
                        child: Text(
                          item.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      );
                    }).toList() : collectionsPopUpActions(context, state).map((OverflowMenuItem item) {
                      return PopupMenuItem<OverflowMenuItem>(
                        value: item,
                        child: Text(
                          item.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
        ): Container(width: 0, height: 0,),
      ],
    );
  }

  Widget _tagsBar(ProductsScreenState state) {
    _filterItems = [];
    if (state.filterTypes.length > 0) {
      for (int i = 0; i < state.filterTypes.length; i++) {
        String filterString = '${filterProducts[state.filterTypes[i].type]} ${filterConditions[state.filterTypes[i].condition]}: ${state.filterTypes[i].disPlayName}';
        TagItemModel item = TagItemModel(title: filterString, type: state.filterTypes[i].type);
        _filterItems.add(item);
      }
    }
    if (state.searchText.length > 0) {
      _filterItems.add(TagItemModel(title: 'Search is: ${state.searchText}', type: null));
      _searchTagIndex = _filterItems.length - 1;
    }
    return _filterItems.length > 0 ?
    Container(
        width: Device.width,
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8,),
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
                color: overlayColor(),
                activeColor: overlayColor(),
                textActiveColor: iconColor(),
                textColor: iconColor(),
                elevation: 0,
                padding: EdgeInsets.only(
                  left: 16, top: 8, bottom: 8, right: 16,
                ),
                removeButton: ItemTagsRemoveButton(
                    backgroundColor: Colors.transparent,
                    color: iconColor(),
                    onRemoved: () {
                      if (index == _searchTagIndex) {
                        _searchTagIndex = -1;
                        screenBloc.add(
                            UpdateProductSearchText(searchText: '')
                        );
                      } else {
                        List<FilterItem> filterTypes = [];
                        filterTypes.addAll(state.filterTypes);
                        filterTypes.removeAt(index);
                        screenBloc.add(
                            UpdateProductFilterTypes(filterTypes: filterTypes)
                        );
                      }
                      return true;
                    }
                ),
              );
            },
          ),
        ): Container();
  }

  Widget _bottomBar(ProductsScreenState state) {
    return state.productsInfo == null
        ? Container()
        : Container(
            height: 50,
            color: overlayBackground().withOpacity(0.5),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16),
                ),
                Text(
                  'Total: ${_selectedIndexValue == 0 ? state.productsInfo.itemCount : state.collectionInfo.itemCount}',
                  style: TextStyle(               
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
  }

  Widget _getBody(ProductsScreenState state) {
    if (state.isSearching) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (state.productsInfo == null) {
      return Container();
    }
    if (state.addToCollection) {
      List<Widget> collectionItems  = [];
      collectionItems.add(getAddCollectionItem(state));
      print(state.collections);
      state.collectionLists.forEach ((collection) {
        collectionItems.add(
            CollectionGridItem(
              collection,
              addCollection: state.addToCollection,
              onTap: (CollectionListModel model) {
                Navigator.push(
                  context,
                  PageTransition(
                    child: CollectionDetailScreen(
                      businessId: widget.globalStateModel.currentBusiness.id,
                      screenBloc: screenBloc,
                      addProducts: state.addToCollection,
                      collection: model.collectionModel,
                    ),
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 500),
                  ),
                );
              },
              onCheck: (CollectionListModel model) {
                screenBloc.add(CheckCollectionItem(model: model));
              },
            ));
      });
      return Container(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: MaterialClassicHeader(semanticsLabel: '',),
          footer: CustomFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
            height: 1,
            builder: (context, status) {
              return Container();
            },
          ),
          controller: _collectionsRefreshController,
          onRefresh: () {
            _refreshCollections();
          },
          onLoading: () {
            _loadMoreCollections(state);
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverGrid.count(
                crossAxisCount: _isTablet ? 3: (_isPortrait ? 2: 2),
                crossAxisSpacing: _isTablet ? 12: (_isPortrait ? 6: 6),
                mainAxisSpacing: _isTablet ? 12: (_isPortrait ? 6: 6),
                childAspectRatio: 1,
                children: List.generate(
                  collectionItems.length,
                      (index) {
                    return collectionItems[index];
                  },
                ),
              ),
              new SliverToBoxAdapter(
                child: state.collectionLists.length < state.collectionInfo.itemCount ? Container(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ) : Container(),
              )
            ],
          ),
        ),
      );
    }
    switch(_selectedIndexValue) {
      case 0:
        List<Widget> productsItems  = [];
        productsItems.add(getAddProductItem(state));
        state.productLists.forEach ((product) {
          productsItems.add(
              ProductGridItem(
                product,
                onTap: (ProductListModel model) {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ProductDetailScreen(
                        businessId: widget.globalStateModel.currentBusiness.id,
                        screenBloc: screenBloc,
                        productsModel: model.productsModel,
                      ),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                },
                onCheck: (ProductListModel model) {
                  screenBloc.add(CheckProductItem(model: model));
                },
                onTapMenu: (ProductListModel model) {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (builder) {
                      return Container(
                        height: 64.0 * 2.0 + MediaQuery.of(context).padding.bottom,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: overlayBackground().withOpacity(1),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        padding: EdgeInsets.only(top: 16),
                        child: Column(
                          children: popupButtons(context, model,),
                        ),
                      );
                    },
                  );
                },
              ));
        });
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: MaterialClassicHeader(semanticsLabel: '',),
            footer: CustomFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              height: 1,
              builder: (context, status) {
                return Container();
              },
            ),
            controller: _productsRefreshController,
            onRefresh: () {
              _refreshProducts();
            },
            onLoading: () {
              _loadMoreProducts(state);
            },
            child: CustomScrollView(
              slivers: <Widget>[
                SliverGrid.count(
                  crossAxisCount: _isTablet ? 3: (_isPortrait ? 2: 2),
                  crossAxisSpacing: _isTablet ? 12: (_isPortrait ? 0: 6),
                  mainAxisSpacing: _isTablet ? 12: (_isPortrait ? 6: 6),
                  children: List.generate(
                    productsItems.length,
                        (index) {
                      return productsItems[index];
                    },
                  ),
                ),
                new SliverToBoxAdapter(
                  child: state.productLists.length < state.productsInfo.itemCount ? Container(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ) : Container(),
                )
              ],
            ),
          ),
        );
      case 1:
        List<Widget> collectionItems  = [];
        collectionItems.add(getAddCollectionItem(state));
        print(state.collections);
        state.collectionLists.forEach ((collection) {
          collectionItems.add(
              CollectionGridItem(
                collection,
                onTap: (CollectionListModel model) {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: CollectionDetailScreen(
                        businessId: widget.globalStateModel.currentBusiness.id,
                        screenBloc: screenBloc,
                        collection: model.collectionModel,
                      ),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                },
                onCheck: (CollectionListModel model) {
                  screenBloc.add(CheckCollectionItem(model: model));
                },
              ));
        });
        return Container(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: MaterialClassicHeader(semanticsLabel: '',),
            footer: CustomFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              height: 1,
              builder: (context, status) {
                return Container();
              },
            ),
            controller: _collectionsRefreshController,
            onRefresh: () {
              _refreshCollections();
            },
            onLoading: () {
              _loadMoreCollections(state);
            },
            child: CustomScrollView(
              slivers: <Widget>[
                SliverGrid.count(
                  crossAxisCount: _isTablet ? 3: (_isPortrait ? 2: 2),
                  crossAxisSpacing: _isTablet ? 12: (_isPortrait ? 6: 6),
                  mainAxisSpacing: _isTablet ? 12: (_isPortrait ? 6: 6),
                  childAspectRatio: 1,
                  children: List.generate(
                    collectionItems.length,
                        (index) {
                      return collectionItems[index];
                    },
                  ),
                ),
                new SliverToBoxAdapter(
                  child: state.collectionLists.length < state.collectionInfo.itemCount ? Container(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ) : Container(),
                )
              ],
            ),
          ),
        );
      default:
        return Container();
    }
  }

  List<Widget> popupButtons(BuildContext context, ProductListModel model) {
    return [
      Container(
        height: 44,
        child: SizedBox.expand(
          child: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageTransition(
                  child: ProductDetailScreen(
                    businessId: widget.globalStateModel.currentBusiness.id,
                    screenBloc: screenBloc,
                    productsModel: model.productsModel,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            },
            child: Text(
              Language.getProductStrings('edit'),
            ),
          ),
        ),
      ),
      Container(
        height: 44,
        child: SizedBox.expand(
          child: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              showCupertinoDialog(
                context: context,
                builder: (builder) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Container(
                      height: 216,
                      child: BlurEffectView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Icon(Icons.info),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Text(
                              Language.getPosStrings('Deleting Products'),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Text(
                              Language.getPosStrings('Do you really want to delete your product?'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  height: 24,
                                  elevation: 0,
                                  minWidth: 0,
                                  color: overlayBackground(),
                                  child: Text(
                                    Language.getPosStrings('actions.no'),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    screenBloc.add(DeleteProductsEvent(models: [model.productsModel]));
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  height: 24,
                                  elevation: 0,
                                  minWidth: 0,
                                  color: overlayBackground(),
                                  child: Text(
                                    Language.getPosStrings('actions.yes'),
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
            },
            child: Text(
              Language.getProductStrings('delete'),
            ),
          ),
        ),
      ),
    ];
  }

  Widget getAddProductItem(ProductsScreenState state) {
    return Container(
      margin: EdgeInsets.only(left: 3, right: 3,),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: overlayBackground(),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/productsicon.svg',
              width: 80,
              height: 80,
              color: iconColor().withOpacity(0.5),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: ProductDetailScreen(
                      businessId: widget.globalStateModel.currentBusiness.id,
                      screenBloc: screenBloc,
                    ),
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 500),
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              height: 30,
              minWidth: 0,
              elevation: 0,
              color: overlayBackground(),
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                    ),
                    Text(
                      Language.getProductStrings('add_product'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getAddCollectionItem(ProductsScreenState state) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: overlayBackground(),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/collection.svg',
              width: 80,
              height: 80,
              color: iconColor().withOpacity(0.5),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: CollectionDetailScreen(
                      businessId: widget.globalStateModel.currentBusiness.id,
                      screenBloc: screenBloc,
                      addProducts: state.addToCollection,
                    ),
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 500),
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              height: 30,
              minWidth: 0,
              elevation: 0,
              color: overlayBackground(),
              child: Container(
                width: 104,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                    ),
                    Text(
                      Language.getProductStrings('Add Collection'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _loadMoreProducts(ProductsScreenState state) async {
    print('Load more products');
    if (state.productsInfo.page == state.productsInfo.pageCount)
      return;
    screenBloc.add(
        ProductsLoadMoreEvent()
    );
    await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
    _productsRefreshController.loadComplete();
  }

  void _refreshProducts() async {
    screenBloc.add(
      ProductsReloadEvent()
    );
    await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
    _productsRefreshController.refreshCompleted(resetFooterState: true);
  }

  void _loadMoreCollections(ProductsScreenState state) async {
    print('Load more collection');
    if (state.collectionInfo.page == state.collectionInfo.pageCount)
      return;
    screenBloc.add(
        CollectionsLoadMoreEvent()
    );
    await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
    _collectionsRefreshController.loadComplete();
  }

  void _refreshCollections() async {
    screenBloc.add(
      CollectionsReloadEvent()
    );
    await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
    _collectionsRefreshController.refreshCompleted(resetFooterState: true);
  }

  void showSearchTextDialog(ProductsScreenState state) {
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
                  UpdateProductSearchText(searchText: value)
                );
              }
          ),
        );
      },
    );
  }


}

