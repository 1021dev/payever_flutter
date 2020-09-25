import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/pos/views/products_screen/products_filter_screen.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/widgets/product_grid_item.dart';
import 'package:payever/theme.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';

final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

class ProductsScreen extends StatefulWidget {
  final PosScreenBloc posScreenBloc;

  ProductsScreen({
    this.posScreenBloc,
  });

  @override
  createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _isPortrait;
  bool _isTablet;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  InAppWebViewController webView;
  double progress = 0;
  String url = '';

  String wallpaper;
  int selectedIndex = 0;
  List<FilterItem> filterTypes = [];
  int selectedTypes = 0;
  bool isGridMode = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
      bloc: widget.posScreenBloc,
      listener: (BuildContext context, PosScreenState state) async {
        // if (state is PosScreenStateFailure) {
        //   Navigator.pushReplacement(
        //     context,
        //     PageTransition(
        //       child: LoginInitScreen(),
        //       type: PageTransitionType.fade,
        //     ),
        //   );
        // }
      },
      child: BlocBuilder<PosScreenBloc, PosScreenState>(
        bloc: widget.posScreenBloc,
        builder: (BuildContext context, PosScreenState state) {
          return Scaffold(
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: _body(state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(PosScreenState state) {
    return state.productLists == null || state.productLists.isEmpty
        ? Container()
        : Column(
            children: <Widget>[
              _toolBar(state),
              Expanded(
                child: isGridMode ? gridBody(state) : _listBody(state),
              ),
              // _bottomBar(state),
            ],
          );
  }

  Widget _toolBar(PosScreenState state) {
    int selectedCount = 0;
    if (state.productLists.length > 0) {
      selectedCount = state.productLists
          .where((element) => element.isChecked)
          .toList()
          .length;
    }
    return Stack(
      children: <Widget>[
        Container(
          height: 50,
          color: overlaySecondAppBar(),
          child: Row(
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                      ),
                      _filterButton(),
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 12),
                        child: Container(
                          width: 1,
                          color: Color(0xFF888888),
                          height: 24,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Amount',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 12),
                        child: Container(
                          width: 1,
                          color: Color(0xFF888888),
                          height: 24,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'QR',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )),
              Flexible(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () {
                        // showCupertinoModalPopup(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return ProductSortContentView(
                        //       selectedIndex: state.sortType,
                        //       onSelected: (val) {
                        //         Navigator.pop(context);
                        //         screenBloc.add(
                        //             UpdateProductSortType(sortType: val));
                        //       },
                        //     );
                        //   },
                        // );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          'assets/images/sort-by-button.svg',
                          width: 20,
                        ),
                      ),
                    ),
                  )),
              Container(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<MenuItem>(
                  icon: SvgPicture.asset(
                    isGridMode
                        ? 'assets/images/grid.svg'
                        : 'assets/images/list.svg',
                  ),
                  offset: Offset(0, 100),
                  onSelected: (MenuItem item) => item.onTap(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: overlayFilterViewBackground(),
                  itemBuilder: (BuildContext context) {
                    return gridListPopUpActions(
                      (grid) => {
                        setState(() {
                          isGridMode = grid;
                        })
                      },
                    ).map((MenuItem item) {
                      return PopupMenuItem<MenuItem>(
                        value: item,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            item.icon,
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
        selectedCount > 0
            ? Container(
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
                            child: SvgPicture.asset(
                                'assets/images/xsinacircle.svg'),
                            onTap: () {
                              // screenBloc.add(state.isProductMode
                              //     ? UnSelectProductsEvent()
                              //     : UnSelectCollectionsEvent());
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                          ),
                          Text(
                            '$selectedCount ITEM${selectedCount > 1 ? 'S' : ''} SELECTED',
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
                          return productsPopUpActions(context, state)
                              .map((OverflowMenuItem item) {
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
              )
            : Container(
                width: 0,
                height: 0,
              ),
      ],
    );
  }

  Widget _filterButton() {
    return InkWell(
      onTap: () async {
        await showGeneralDialog(
          barrierColor: null,
          transitionBuilder: (context, a1, a2, wg) {
            final curvedValue = 1.0 - Curves.ease.transform(a1.value);
            return Transform(
              transform: Matrix4.translationValues(-curvedValue * 200, 0.0, 0),
              child: ProductsFilterScreen(
                screenBloc: widget.posScreenBloc,
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
          width: 20,
        ),
      ),
    );
  }

  Widget gridBody(PosScreenState state) {
    List<Widget> productsItems = [];
    state.productLists.forEach((product) {
      productsItems.add(ProductGridItem(
        product,
        fromPos: true,
        onTap: (ProductListModel model) {},
        onCheck: (ProductListModel model) {
          // screenBloc.add(CheckProductItem(model: model));
        },
        onTapMenu: (ProductListModel model) {
          showCupertinoModalPopup(
            context: context,
            builder: (builder) {
              return Container(
                height: 64.0 * 2.0 + MediaQuery.of(context).padding.bottom,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: overlayFilterViewBackground(),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  children: popupButtons(
                    context,
                    model,
                  ),
                ),
              );
            },
          );
        },
      ));
    });
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverGrid.count(
            crossAxisCount: _isTablet ? 3 : (_isPortrait ? 2 : 3),
            crossAxisSpacing: _isTablet ? 12 : (_isPortrait ? 0 : 6),
            mainAxisSpacing: _isTablet ? 12 : (_isPortrait ? 6 : 6),
            children: List.generate(
              productsItems.length,
              (index) {
                return productsItems[index];
              },
            ),
          ),
        ],
      ),
    );
  }

  // List<ProductListModel> _productListModels(PosScreenState state) {
  //   String selectedCategory = state.selectedCategory;
  //   List<String>subCategories = state.subCategories;
  //   if (selectedCategory.isEmpty || selectedCategory == 'All')
  //     return state.productLists;
  //   else {
  //     if (subCategories.isEmpty)
  //       return state.productLists;
  //     else {
  //       List<ProductListModel> productModelLists = [];
  //       WallpaperCategory wallpaperCategory = state.productLists.where((element) => element.productsModel.n == selectedCategory).toList().first;
  //       subCategories.forEach((subCategory) {
  //         wallpaperCategory.industries.where((industry) => industry.code == subCategory).toList().first.wallpapers.forEach((wallpaper) {
  //           productModelLists.add(wallpaper);
  //         });
  //       });
  //       return productModelLists;
  //     }
  //   }
  // }

  Widget _listBody(PosScreenState state) {
    return ListView.builder(
        itemCount: state.productLists.length,
        itemBuilder: (context, index) =>
            _productListBody(state, state.productLists[index]));
  }

  Widget _productListBody(PosScreenState state, ProductListModel model) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: Measurements.width * 0.5,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: InkWell(
                          onTap: () {
                            // screenBloc.add(CheckProductItem(model: model));
                          },
                          child: model.isChecked
                              ? Icon(
                                  Icons.check_circle,
                                  size: 20,
                                )
                              : Icon(
                                  Icons.radio_button_unchecked,
                                  size: 20,
                                )),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 19, right: 17),
                      height: 40,
                      width: 40,
                      child: model.productsModel.images != null &&
                              model.productsModel.images.isNotEmpty &&
                              model.productsModel.images.first != null
                          ? CachedNetworkImage(
                              imageUrl:
                                  '${Env.storage}/products/${model.productsModel.images.first}',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  color: overlayBackground(),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6.0),
                                  ),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                  child: Center(
                                      child: CircularProgressIndicator())),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          : SvgPicture.asset('assets/images/no_image.svg'),
                    ),
                    Flexible(child: Text(model.productsModel.title)),
                  ],
                ),
              ),
              Text(
                  '${Measurements.currency(model.productsModel.currency)}${model.productsModel.price}'),
              IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.white.withOpacity(0.5)),
      ],
    );
  }

  List<Widget> popupButtons(BuildContext context, ProductListModel model) {
    return [
      Container(
        height: 44,
        child: SizedBox.expand(
          child: MaterialButton(
            onPressed: () {},
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
                              Language.getPosStrings(
                                  'Do you really want to delete your product?'),
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
                                    // screenBloc.add(DeleteProductsEvent(
                                    //     models: [model.productsModel]));
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

  List<OverflowMenuItem> productsPopUpActions(
      BuildContext context, PosScreenState state) {
    return [
      OverflowMenuItem(
        title: 'Select All',
        onTap: () {
          // screenBloc.add(SelectAllProductsEvent());
        },
      ),
      OverflowMenuItem(
        title: 'UnSelect',
        onTap: () {
          // screenBloc.add(UnSelectProductsEvent());
        },
      ),
      OverflowMenuItem(
        title: 'Add to Collection',
        onTap: () {
          // screenBloc.add(AddToCollectionEvent());
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
                          Language.getPosStrings(
                              'Do you really want to delete your products?'),
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
                                // screenBloc
                                //     .add(DeleteProductsEvent(models: deletes));
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
}
