import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/commons/models/products_ref.dart';
import 'package:payever/commons/network/rest_ds.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:provider/provider.dart';

import '../../commons/view_models/view_models.dart';
import '../../commons/views/screens/dashboard/dashboard_card_ref.dart';
import 'new_product_ref.dart';

import 'product_screen.dart';

class ProductsSoldCard extends StatelessWidget {
  final String _appName;
  final ImageProvider _imageProvider;
  final String _help;

  ProductsSoldCard(this._appName, this._imageProvider, this._help);

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return DashboardCardRef(
      _appName,
      _imageProvider,
      Padding(
        padding: EdgeInsets.symmetric(vertical: 1),
        child: InkWell(
          highlightColor: Colors.transparent,
          child: ProductsSoldCardItem(),
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                child: ProductScreen(
                  business: globalStateModel.currentBusiness,
                  wallpaper: globalStateModel.currentWallpaper,
                  posCall: false,
                ),
                type: PageTransitionType.fade,
              ),
            );
          },
        ),
      ),
    );
  }
}

ValueNotifier<GraphQLClient> clientFor({
  @required String uri,
  String subscriptionUri,
}) {
  Link link = HttpLink(uri: uri);
  if (subscriptionUri != null) {
    final AuthLink authLink = AuthLink(
      getToken: () => 'Bearer ${GlobalUtils.activeToken.accessToken}',
    );
    link = authLink.concat(link);
  }
  return ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    ),
  );
}

class ProductsSoldCardItem extends StatefulWidget {
  @override
  createState() => _ProductsSoldCardItemState();
}

class _ProductsSoldCardItemState extends State<ProductsSoldCardItem> {
  Future<List<Products>> fetchProductsSold(
      GlobalStateModel globalStateModel, BuildContext context) async {
    RestDataSource api = RestDataSource();

    List<Products> lastSalesList = List<Products>();

    await api
        .getProductsPopularMonth(globalStateModel.currentBusiness.id,
            GlobalUtils.activeToken.accessToken, context)
        .then(
      (lastSales) {
        if (lastSales.isNotEmpty) {
          List<dynamic> lastSaleData = List<dynamic>();
          lastSaleData = lastSales;
          if (lastSaleData.length < 4) {
            for (var salesData in lastSaleData) {
              lastSalesList.add(Products.toMap(salesData));
            }
          } else {
            for (var salesData in lastSaleData.sublist(0, 4)) {
              lastSalesList.add(Products.toMap(salesData));
            }
          }
        }
      },
    );

    return lastSalesList;
  }

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    bool _isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
//    bool _isTablet = Measurements.width < 600 ? false : true;

    final ValueNotifier<GraphQLClient> graphClient = clientFor(
      uri: Env.products + "/products",
    );

    String getInitialDocument(String uuid) {
      return ''' 
              query getProducts {
                product(uuid: "$uuid") {
                    images      id      title      description      onSales      price      salePrice      sku      barcode      currency      type      active      categories {        title      }      variants {        id        images        options {          name          value        }        description        onSales        price        salePrice        sku        barcode      }      channelSets {        id        type        name      }      shipping {        free        general        weight        width        length        height      }         
                  }
                }''';
    }

    return CustomFutureBuilder<List<Products>>(
      color: Colors.transparent,
      future: fetchProductsSold(globalStateModel, context),
      errorMessage: "Error loading sales",
      onDataLoaded: (List<Products> results) {
        List<Widget> productsList = List<Widget>();

        if (results.length > 0) {
          for (var resultData in results) {
            productsList.add(
              Container(
                width: 68,
                height: 68,
                child: GraphQLProvider(
                  client: graphClient,
                  child: Query(
                    options: QueryOptions(
                      variables: <String, dynamic>{},
                      document: getInitialDocument(resultData.uuid),
                    ),
                    builder: (QueryResult result,
                        {VoidCallback refetch, fetchMore: null}) {
                      if (result.errors != null) {
                        // print(result.errors);
                        // return Center(
                        //   child: Text("Error"),
                        // );
                      }

                      if (result.loading) {
                        // return Center(child: CircularProgressIndicator());
                        return Container();
                      }

                      if (result.data == null)
                        return productSoldItemElementCard(
                            globalStateModel, null, resultData, context);
                      if (result.data != null ||
                          result.data['product'] != null) {
                        if (result.data['product'] != null) {
                          var productData =
                              ProductsModel.fromMap(result.data['product']);
                          return productSoldItemElementCard(globalStateModel,
                              productData, resultData, context);
                        } else {
                          return productSoldItemElementCard(
                              globalStateModel, null, resultData, context);
                        }
                      } else {
                        return Center(
                          child: Container(),
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          }

          return ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: productsList,
              ),
            ],
          );
        } else {
          return NoItemsCard(
            Text(Language.getWidgetStrings("widgets.products.actions.add-new")),
            () {
              _goToProducts(globalStateModel, context);
            },
          );
        }
      },
    );
  }

  Widget productSoldItemElementCard(GlobalStateModel globalStateModel,
      ProductsModel productData, Products resultData, BuildContext context) {
    return InkWell(
      child: Container(
        width: 69,
        height: 69,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 69,
              height: 69,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                image: resultData.thumbnail != null
                    ? DecorationImage(
                        image: NetworkImage(
                          !resultData.thumbnail.toString().contains("https://")
                              ? Env.storage +
                                  "/products/" +
                                  resultData.thumbnail
                              : resultData.thumbnail,
                        ),
                      )
                    : DecorationImage(
                        image: AssetImage(
                          "assets/images/wallpapericon.png",
                        ),
                      ),
              ),
              child: resultData.thumbnail == null
                  ? Center(
                      child: SvgPicture.asset(
                        "assets/images/noimage.svg",
                        color: Colors.black.withOpacity(0.3),
                      ),
                    )
                  : Container(),
            ),
            Container(
              width: 69,
              height: 69,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(top: 10, right: 2, bottom: 10, left: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AutoSizeText(
                      productData != null ? productData.title : resultData.name,
//                        resultData.name,
                      maxLines: 1,
                      minFontSize: 10,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoSizeText(
//                            productData != null ? productData.title : resultData.name,
                      "Sold: ${resultData.quantity}",
                      maxLines: 1,
                      minFontSize: 10,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (productData != null) {
          Navigator.push(
              context,
              PageTransition(
                  // child: NewProductScreen(
                  //   wallpaper: globalStateModel.currentWallpaper,
                  //   business: globalStateModel.currentBusiness.id,
                  //   view: this,
                  //   currency: globalStateModel.currentBusiness.currency,
                  //   editMode: true,
                  //   productEdit: productData,
                  //   isFromDashboardCard: true,
                  //   isLoading: ValueNotifier(0),
                  // ),
                  child: ProductEditor(
                    global: Provider.of<GlobalStateModel>(context),
                    productProvider: Provider.of<ProductStateModel>(context),
                    isFromDashboardCard: true,
                    productsModel: productData,
                  ),
                  type: PageTransitionType.fade));
        } else {
          Navigator.push(
            context,
            PageTransition(
                child: ProductScreen(
                  wallpaper: globalStateModel.currentWallpaper,
                  business: globalStateModel.currentBusiness,
                  posCall: false,
                  isProductNotAvailable: true,
                  isFromDashboardCard: true,
                ),
                type: PageTransitionType.fade),
          );
        }
      },
    );
  }

  _goToProducts(GlobalStateModel globalStateModel, BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        child: ProductScreen(
          business: globalStateModel.currentBusiness,
          wallpaper: globalStateModel.currentWallpaper,
          posCall: false,
        ),
        type: PageTransitionType.fade,
      ),
    );
  }
}
