import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/models/business.dart';
import 'package:payever/models/checkout.dart';
import 'package:payever/models/pos.dart';
import 'package:payever/models/products.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/utils.dart';

ValueNotifier<GraphQLClient> clientFor({
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
    print("webSocketLink: $webSocketLink");

    final AuthLink authLink = AuthLink(
      getToken: () => 'Bearer ${GlobalUtils.ActiveToken.accessToken}',
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

class PosStateModel extends ChangeNotifier {
  final GlobalStateModel globalStateModel;
  final RestDatasource api;

  PosStateModel(this.globalStateModel, this.api);

  String get accessToken => GlobalUtils.ActiveToken.accessToken;

  String get businessId => globalStateModel.currentBusiness.id;

  Terminal currentTerminal;

  Terminal get getCurrentTerminal => currentTerminal;

  Business business;

  Business get getBusiness => globalStateModel.currentBusiness;

  Cart shoppingCart = Cart();
  List<ProductsModel> productList = List<ProductsModel>();

  List<ProductsModel> get getProductList => productList;

  Map<String, String> productStock = Map();

  Map<String, String> get getProductStock => productStock;

  bool smsEnabled = false;
  String shoppingCartID = "";
  String url;

  bool isTablet;
  bool isPortrait;

  int pageCount;

  int get getPageCount => pageCount;

  int page = 1;

  int get getPage => page;

  String search = "";

  String get getSearch => search;

  bool loadMore = false;

  bool get getLoadMore => loadMore;

  bool isLoading = true;

  bool get getIsLoading => isLoading;

  bool haveProducts = false;

  bool get getHaveProducts => haveProducts;

  bool dataFetched = true;

  bool get getDataFetched => dataFetched;

  int openSection = 0;

  int get getOpenSection => openSection;

  updateOpenSection(int value) {
    openSection = value;
    notifyListeners();
  }

  final ValueNotifier<GraphQLClient> client = clientFor(
    uri: Env.Products + "/products",
  );

  Checkout currentCheckout;
  Color titleColor = Colors.black;
  Color saleColor = Color(0xFFFF3D34);

  var f = NumberFormat("###,##0.00", "de_DE");

  addProductList(productsList) {
    productList.add(productsList);
//    notifyListeners();
  }

  updatePage() {
    page++;
    notifyListeners();
  }

  updatePageCount(int value) {
    pageCount = value;
//    notifyListeners();
  }

  updateIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  updateLoadMore(bool value) {
    loadMore = value;
//    notifyListeners();
  }

  updateFetchValues(bool dataFetchedValue, bool loadMoreValue) {
    dataFetched = dataFetchedValue;
    loadMore = loadMoreValue;
    notifyListeners();
  }

  add2cart({
    String id,
    String image,
    String name,
    num price,
    num qty,
    String sku,
    String uuid,
  }) {

    print("shoppingCart: $shoppingCart");

    int index = shoppingCart.items.indexWhere((test) => test.id == id);
    if (index < 0) {
      shoppingCart.items.add(CartItem(
          id: id,
          sku: sku,
          price: price,
          name: name,
          quantity: qty,
          uuid: uuid,
          image: image));
    } else {
      shoppingCart.items[index].quantity += qty;
    }
    shoppingCart.total += price;
    haveProducts = shoppingCart.items.isNotEmpty;

    notifyListeners();
  }

  deleteProduct(int index) {
    num less =
        shoppingCart.items[index].price * shoppingCart.items[index].quantity;
    shoppingCart.total -= less;
    shoppingCart.items.removeAt(index);
    haveProducts = shoppingCart.items.isNotEmpty;
    notifyListeners();
  }

  updateQty({int index, num quantity}) {
    var add = quantity - shoppingCart.items[index].quantity;
    shoppingCart.items[index].quantity = quantity;
    shoppingCart.total =
        shoppingCart.total + (shoppingCart.items[index].price * add);
    notifyListeners();
  }

  addProductStock(InventoryModel _currentInv) {
    productStock
        .addAll({"${_currentInv.sku}": "${_currentInv.stock.toString()}"});
    notifyListeners();
  }

  addProductListStock(List<InventoryModel> inventoryModelList) {
    for (var inv in inventoryModelList) {
      productStock.addAll({"${inv.sku}": "${inv.stock.toString()}"});
    }
  }

  Future<void> loadPosProductsList(Terminal terminal) async {
    print("loadPosProductsList()");

    try {
      var inventories = await getInventoryList();
      List<InventoryModel> inventoryModelList = List<InventoryModel>();

      inventories.forEach((inv) {
        InventoryModel _currentInv = InventoryModel.toMap(inv);
//          addProductStock(_currentInv);
        inventoryModelList.add(_currentInv);
      });

      addProductListStock(inventoryModelList);

      if (terminal == null) {
        List<Terminal> _terminals = List();
        List<ChannelSet> _chSets = List();
        var terminals = await getTerminalsList();
        terminals.forEach((terminal) {
          _terminals.add(Terminal.toMap(terminal));
        });
        var channelSets = await getChannel();
        channelSets.forEach((channelSet) {
          _chSets.add(ChannelSet.toMap(channelSet));
        });

        currentTerminal = _terminals.firstWhere((term) => term.active);

        var checkout = await getCheckout(currentTerminal.channelSet);
        currentCheckout = Checkout.toMap(checkout);
//        smsEnabled = !currentCheckout.sections.firstWhere((test)=> test.code=="send_to_device").enabled;

//        haveProducts = true;
//        dataFetched = false;
//        loadMore = false;

//        updateFetchValues(true, false);

        return true;
      } else {
        var checkout = await getCheckout(terminal.channelSet);
        currentCheckout = Checkout.toMap(checkout);

        currentTerminal = terminal;

//        haveProducts = true;
//        dataFetched = false;
//        loadMore = false;

//        updateFetchValues(true, false);

        return true;
      }
    } catch (e) {
      print("Error: $e");

      return false;
    }
  }

  Future<dynamic> getInventoryList() async {
    return api.getInventory(businessId, accessToken);
  }

  Future<dynamic> getTerminalsList() async {
    return api.getTerminal(businessId, accessToken, null);
  }

  Future<dynamic> getChannel() async {
    return api.getChannelSet(businessId, accessToken, null);
  }

  Future<dynamic> getCheckout(String terminalChannelSet) async {
    return api.getCheckout(terminalChannelSet, accessToken);
  }
}
