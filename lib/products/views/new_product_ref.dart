import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:payever/products/network/products_api.dart';
import '../../products/utils/utils.dart';
import '../../commons/views/custom_elements/custom_elements.dart';
import 'package:payever/pos/view_models/view_models.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import 'views.dart';

ValueNotifier<GraphQLClient> clientForNewProduct({
  @required String uri,
  String subscriptionUri,
}) {
  Link link = HttpLink(uri: uri);
  if (subscriptionUri != null) {
    WebSocketLink webSocketLink = WebSocketLink(
        config: SocketClientConfig(
          autoReconnect: true,
          inactivityTimeout: Duration(seconds: 30),
        ),
        url: uri);
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

class ProductEditor extends StatefulWidget {
  final ProductsModel productsModel;
  ProductStateModel productProvider;
  GlobalStateModel global;
  final bool isFromDashboardCard;
  ProductEditor({
    this.productsModel,
    @required this.productProvider,
    @required this.global,
    this.isFromDashboardCard,
  });

  @override
  _ProductEditorState createState() => _ProductEditorState();
}

class _ProductEditorState extends State<ProductEditor> {
  @override
  void initState() {
    super.initState();
    widget.productProvider.resetKey();
    if (widget.productsModel == null) {
      widget.productProvider.setEditProduct(
        ProductsModel(
          businessUuid: widget.global.currentBusiness.id,
          onSales: false,
          imagesUrl: List(),
          images: List(),
          shipping: ProductShippingInterface(free: false, general: false),
          active: true,
          type: ProductTypeEnum.physical,
          variants: List<ProductVariantModel>(),
          categories: List<ProductCategoryInterface>(),
          channelSets: List<ProductChannelSet>(),
          vatRate: widget.global.vatRates.first.rate,
        ),
      );
    } else {
      widget.productProvider.setEditProduct(
        ProductsModel(
          businessUuid: widget.global.currentBusiness.id,
          onSales: widget.productsModel.onSales,
          images: widget.productsModel.images.toList(),
          shipping: widget.productsModel.shipping,
          active: widget.productsModel.active,
          type: widget.productsModel.type,
          variants: widget.productsModel.variants.toList(),
          categories: widget.productsModel.categories,
          channelSets: widget.productsModel.channelSets,
          description: widget.productsModel.description,
          price: widget.productsModel.price,
          salePrice: widget.productsModel.salePrice,
          title: widget.productsModel.title,
          barcode: widget.productsModel.barcode,
          sku: widget.productsModel.sku,
          id: widget.productsModel.id,
          vatRate: widget.productsModel.vatRate,
        ),
      );
      ProductsApi()
          .getInventory(
        widget.global.currentBusiness.id,
        GlobalUtils.activeToken.accessToken,
        widget.productsModel.sku,
        null,
      )
          .then(
        (inv) {
          setState(
            () {
              InventoryModel currentInventory = InventoryModel.toMap(inv);
              widget.productProvider.inventories.addAll({
                widget.productsModel.sku: Inventory(
                  barcode: currentInventory.barcode,
                  hiddenIndex: 0,
                  sku: currentInventory.sku,
                  tracking: currentInventory.isTrackable,
                  amount: currentInventory.stock,
                  newAmount: null,
                ),
              });
            },
          );
        },
      ).catchError(
        (onError) {
          print(onError);
        },
      );
      int index = 1;
      widget.productsModel.variants.forEach(
        (variant) {
          ProductsApi()
              .getInventory(
            widget.global.currentBusiness.id,
            GlobalUtils.activeToken.accessToken,
            variant.sku,
            null,
          )
              .then(
            (inv) {
              InventoryModel currentInventory = InventoryModel.toMap(inv);
              widget.productProvider.inventories.addAll({
                variant.sku: Inventory(
                  barcode: currentInventory.barcode,
                  hiddenIndex: index,
                  sku: currentInventory.sku,
                  tracking: currentInventory.isTrackable,
                  amount: currentInventory.stock,
                  newAmount: null,
                ),
              });
              index++;
              if (widget.productsModel.variants.last.sku == variant.sku) {
                setState(() {});
              }
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ProductStateModel productProvider = Provider.of<ProductStateModel>(context);
    ProductSections productSections = ProductSections();
    productSections.setProductSections(productProvider.editProduct);
    return BackgroundBase(
      true,
      appBar: CustomAppBar(
        title: Text("Editor"),
        actions: <Widget>[
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              child: Text(
                Language.getCommerceOSStrings("actions.save"),
              ),
            ),
            onTap: () {
              productProvider.formKey.currentState.save();
              try {
                productProvider.formKey.currentState.validate();
                save(
                  widget.productsModel == null
                      ? productProvider.createQuery()
                      : productProvider.updateQuery(),
                  widget.productsModel == null
                      ? productProvider.editProduct.toJson()
                      : productProvider.editProduct.toJsonWithID(),
                );
              } catch (e) {
                print("error \n -> $e ");
                Provider.of<GlobalStateModel>(context).launchCustomSnack(
                  productProvider.formKey.currentContext,
                  "error message",
                );
              }
            },
          ),
        ],
        onTap: () {
          productProvider.cleanproduct();
          Navigator.pop(context);
        },
      ),
      body: Form(
        key: productProvider.formKey,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                TypeBody(),
                CustomExpansionTile(
                  scrollable: false,
                  headerColor: Colors.transparent,
                  bodyColor: Colors.black.withOpacity(0.1),
                  isWithCustomIcon: true,
                  widgetsBodyList: productSections?.bodies,
                  widgetsTitleList: productSections?.headers,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  save(String query, Map variables) {
    final ValueNotifier<GraphQLClient> client = clientForNewProduct(
      uri: Env.products + "/products",
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 2,
              sigmaY: 2,
            ),
            child: Container(
              color: Colors.transparent,
              height: 200,
              width: 200,
              child: GraphQLProvider(
                client: client,
                child: Query(
                  options: QueryOptions(
                    variables: <String, dynamic>{
                      "product": variables,
                    },
                    document: query,
                  ),
                  builder: (
                    QueryResult result, {
                    VoidCallback refetch,
                    fetchMore: null,
                  }) {
                    if (result.errors != null) {
                      print("Error = ${result.errors}");
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Error while creating/updating a product"),
                          IconButton(
                            highlightColor: Colors.transparent,
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context); //pop on error
                            },
                          )
                        ],
                      );
                    }
                    if (result.loading) {
                      return Center(
                        child: const CircularProgressIndicator(),
                      );
                    }
                    return OrientationBuilder(
                      builder: (BuildContext context, Orientation orientation) {
                        Provider.of<ProductStateModel>(context).saveInventories(
                          context,
                          Provider.of<GlobalStateModel>(context),
                          widget.isFromDashboardCard,
                        );
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
