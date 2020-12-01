import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/widgets/product_item_image_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import '../../../theme.dart';

class AddProductsScreen extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;

  AddProductsScreen(this.screenBloc);

  @override
  createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  bool _isPortrait;
  bool _isTablet;

  InAppWebViewController webView;
  double progress = 0;
  String url = '';

  String wallpaper;
  int selectedIndex = 0;
  List<FilterItem> filterTypes = [];
  int selectedTypes = 0;

  @override
  void initState() {
    widget.screenBloc.add(FetchProductsInitEvent());
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

    return BlocBuilder<ShopEditScreenBloc, ShopEditScreenState>(
      bloc: widget.screenBloc,
      builder: (BuildContext context, ShopEditScreenState state) {
        return _body(state);
      },
    );
  }

  Widget _body(ShopEditScreenState state) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: state.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: _getBody(state),
                      ),
                      // _bottomBar(state),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _getBody(ShopEditScreenState state) {
    if (state.isLoading) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return gridBody(state);
  }

  Widget gridBody(ShopEditScreenState state) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, top: 16),
      child: GridView.count(
        crossAxisCount: _isTablet ? 3 : (_isPortrait ? 2 : 3),
        crossAxisSpacing: _isTablet ? 12 : (_isPortrait ? 6 : 12),
        mainAxisSpacing: 12,
        children: List.generate(
          state.products.length,
          (index) {
            ProductsModel productsModel = state.products[index];
            return Container(
              margin: EdgeInsets.only(left: 3, right: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                color: overlayBackground(),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        ProductItemImage(
                          productsModel.images.isEmpty
                              ? null
                              : productsModel.images.first,
                        ),
                      ],
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 6 / 1.7,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, bottom: 3, top: 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            AutoSizeText(
                              productsModel.title,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                              maxLines: 1,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 3, bottom: 1),
                              child: Text(
                                '${formatter.format(productsModel.price)} ${Measurements.currency(productsModel.currency)}',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            // Text(
                            //   productsModel.onSales
                            //       ? Language.getProductListStrings('filters.quantity.options.outStock')
                            //       : Language.getProductListStrings('filters.quantity.options.inStock'),
                            //   style: TextStyle(
                            //     fontSize: 8,
                            //     fontWeight: FontWeight.w300,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 0.5,
                    color: Colors.white54,
                  ),
                  AspectRatio(
                    aspectRatio: 6 / 1,
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          // onTap(product);
                        },
                        child: Center(
                            child: Text(
                          'Select',
                          style: TextStyle(fontSize: 12),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
