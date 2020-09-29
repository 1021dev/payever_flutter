import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/pos/views/products_screen/pos_product_detail_screen.dart';
import 'package:payever/pos/views/products_screen/products_filter_screen.dart';
import 'package:payever/pos/views/products_screen/widget/pos_product_grid_item.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/theme.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:icon_badge/icon_badge.dart';
import '../pos_qr_app.dart';

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
  bool isGridMode = true;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
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
    return Stack(
      children: [
        Column(
          children: <Widget>[
            _toolBar(state),
            _secondToolBar(state),
            Expanded(
              child: isGridMode ? gridBody(state) : _listBody(state),
            ),
            // _bottomBar(state),
          ],
        ),
        state.searching
            ? Center(child: CircularProgressIndicator())
            : Container(),
      ],
    );
  }

  Widget _toolBar(PosScreenState state) {
    searchController.text = state.searchText;
    return Container(
      height: 50,
      color: overlaySecondAppBar().withOpacity(0.9),
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              _filterButton(),
              // Padding(
              //   padding: EdgeInsets.only(left: 8, right: 12),
              //   child: Container(
              //     width: 1,
              //     color: Color(0xFF888888),
              //     height: 24,
              //   ),
              // ),
              // InkWell(
              //   onTap: () {},
              //   child: Text(
              //     'Amount',
              //     style: TextStyle(
              //       fontSize: 14,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(left: 12, right: 12),
              //   child: Container(
              //     width: 1,
              //     color: Color(0xFF888888),
              //     height: 24,
              //   ),
              // ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       PageTransition(
              //         child: PosQRAppScreen(
              //           businessId: state.businessId,
              //           screenBloc: widget.posScreenBloc,
              //           fromProductsScreen: true,
              //         ),
              //         type: PageTransitionType.fade,
              //         duration: Duration(milliseconds: 500),
              //       ),
              //     );
              //   },
              //   child: Text(
              //     'QR',
              //     style: TextStyle(
              //       fontSize: 14,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
            ],
          ),
          Expanded(
            child: Container(
              height: 35,
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: overlayBackground(),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 20,),
                  SizedBox(width: 4,),
                  Expanded(
                    child: TextFormField(
                      style: textFieldStyle,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Search products',
                        border: InputBorder.none,
                      ),
                      controller: searchController,
                      onChanged: (String value) {
                        if (value.length > 2) {
                          widget.posScreenBloc.add(ProductsFilterEvent(searchText: value));
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                widget.posScreenBloc.add(ProductsFilterEvent(
                    orderDirection: !state.orderDirection));
              },
              child: Container(
                child: SvgPicture.asset(
                  'assets/images/sort-by-button.svg',
                  width: 20,
                ),
              ),
            ),
          ),
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
    );
  }

  Widget _secondToolBar(PosScreenState state) {
    searchController.text = state.searchText;
    return Container(
      height: 50,
      color: overlaySecondAppBar().withOpacity(0.8),
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 12),
              ),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   PageTransition(
                  //     child: WorkshopScreen(
                  //       checkoutScreenBloc: CheckoutScreenBloc(
                  //           dashboardScreenBloc:
                  //               widget.posScreenBloc.dashboardScreenBloc)
                  //         ..add(CheckoutScreenInitEvent(
                  //           business: state.businessId,
                  //           checkouts: widget.posScreenBloc.dashboardScreenBloc.state.checkouts,
                  //           defaultCheckout: widget.posScreenBloc.dashboardScreenBloc.state.defaultCheckout,
                  //         )),
                  //     ),
                  //     type: PageTransitionType.fade,
                  //   ),
                  // );
                },
                child: Text(
                  'Amount',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: Container(
                  width: 1,
                  color: Color(0xFF888888),
                  height: 24,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: PosQRAppScreen(
                        businessId: state.businessId,
                        screenBloc: widget.posScreenBloc,
                        fromProductsScreen: true,
                      ),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                },
                child: Text(
                  'QR',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          IconBadge(
            icon: Icon(Icons.shop, color: Colors.white, size: 20,),
            itemCount: (state.channelSetFlow == null || state.channelSetFlow.cart == null) ? 0 : state.channelSetFlow.cart.length,
            badgeColor: Colors.red,
            itemColor: Colors.white,
            hideZero: true,
            onTap: () {
              print('test');
            },
          ),
          SizedBox(width: 10,),
        ],
      ),
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
    if (state.products == null || state.products.isEmpty)
        return Container();

    List<Widget> productsItems = [];
    state.products.forEach((product) {
      productsItems.add(PosProductGridItem(
        product,
        onTap: (ProductsModel model) {
          navigateProductDetail(model);
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

  Widget _listBody(PosScreenState state) {
    if (state.products == null || state.products.isEmpty)
      return Container();
    return ListView.builder(
        itemCount: state.products.length,
        itemBuilder: (context, index) =>
            _productListBody(state, state.products[index]));
  }

  Widget _productListBody(PosScreenState state, ProductsModel model) {
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
                      margin: EdgeInsets.only(left: 19, right: 17),
                      height: 40,
                      width: 40,
                      child: model.images != null &&
                              model.images.isNotEmpty &&
                              model.images.first != null
                          ? CachedNetworkImage(
                              imageUrl:
                                  '${Env.storage}/products/${model.images.first}',
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
                    Flexible(child: Text(model.title)),
                  ],
                ),
              ),
              Text(
                  '${Measurements.currency(model.currency)}${model.price}'),
              IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: () {
                  navigateProductDetail(model);
                },
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.white.withOpacity(0.5)),
      ],
    );
  }

  void navigateProductDetail(ProductsModel model) {
    Navigator.push(
      context,
      PageTransition(
        child: PosProductDetailScreen(
          posScreenBloc: widget.posScreenBloc,
          productsModel: model,
        ),
        type: PageTransitionType.fade,
      ),
    );
  }
}
