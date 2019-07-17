
import 'dart:io';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/models/business.dart';
import 'package:payever/models/pos.dart';
import 'package:payever/models/products.dart';
import 'package:payever/models/shop.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/login/login_page.dart';
import 'new_product.dart';
import 'package:flutter/cupertino.dart';



ValueNotifier<GraphQLClient> clientFor({
  @required String uri,
  String subscriptionUri,
}) {
  Link link = HttpLink(uri: uri) as Link;
  if (subscriptionUri != null) {
    WebSocketLink websocketLink = WebSocketLink(
      headers: { HttpHeaders.AUTHORIZATION: "Bearer ${GlobalUtils.ActiveToken.accessToken}" ,
      HttpHeaders.CONTENT_TYPE: "application/json"},
      url: uri,
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: Duration(seconds: 30),
      ),
    );
    final AuthLink authLink = AuthLink(
    getToken: () => 'Bearer ${GlobalUtils.ActiveToken.accessToken}',
  );
    link = authLink.concat(link);
  }
  return ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: InMemoryCache(customStorageDirectory: null),
      link: link,
    ),
  );
}

class ProductScreenParts{
  bool isTablet;
  bool isPortrait;
  bool posCall;
  bool havePOS  = false;
  bool haveShop = false;
  bool isSearching = false;
  int  page = 1;
  int  pageCount = 1;
  var qkey = GlobalKey();
  ValueNotifier loadMore = ValueNotifier(false);
  String  wallpaper;
  String searchDocument = "";
  Business business;
  List<ProductsModel>  products    = List();
  List<InventoryModel> inventories = List();
  List<Terminal> terminals   = List();
  List<Shop> shops       = List();
  ValueNotifier<bool> isLoading    = ValueNotifier(true);
  final ValueNotifier<GraphQLClient> client = clientFor(
    uri: Env.Products + "/products",
  );
}

class ProductScreen extends StatefulWidget {
  TextEditingController searchController= TextEditingController(text: "");
  String wallpaper;
  Business business;
  ProductScreenParts _parts;
  bool posCall;
  int stateCounter =0;
  ProductScreen({@required this.wallpaper,@required this.business,@required this.posCall});
  List<ProductsModel> products = List();
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  AppBar _appBar;
  listener() {
    setState((){
      widget.stateCounter++;
      
    });
  }

  @override
  void initState() {
    super.initState();
    widget._parts = ProductScreenParts() ;
    widget._parts.wallpaper = widget.wallpaper;
    widget._parts.business = widget.business;
    widget._parts.posCall = widget.posCall;
    widget._parts.isLoading.addListener(listener);
    widget._parts.loadMore.addListener(listener);
    RestDatasource api = RestDatasource();
    widget._parts.inventories.clear();
    api.getInventory(widget._parts.business.id, GlobalUtils.ActiveToken.accessToken).then((inventories){
      inventories.forEach((inv){
        widget._parts.inventories.add(InventoryModel.toMap(inv));
      });
    });
    api.getTerminal(widget._parts.business.id, GlobalUtils.ActiveToken.accessToken,context).then((terminals){
      terminals.forEach((term){
        widget._parts.terminals.add(Terminal.toMap(term));
      });
    }).catchError((onError){
      if(onError.toString().contains("401")){
        GlobalUtils.clearCredentials();
        Navigator.pushReplacement(context,PageTransition(child:LoginScreen() ,type: PageTransitionType.fade));
      }
    });
    api.getShop(widget._parts.business.id, GlobalUtils.ActiveToken.accessToken,context).then((shops){
      shops.forEach((shop){
        widget._parts.shops.add(Shop.toMap(shop));
      });
    }).catchError((onError){
      if(onError.toString().contains("401")){
        GlobalUtils.clearCredentials();
        Navigator.pushReplacement(context,PageTransition(child:LoginScreen() ,type: PageTransitionType.fade));
      }
    });
    }
    @override
    Widget build(BuildContext context) {
      _appBar = AppBar(elevation: 0,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: () {
            Navigator.push(context, PageTransition(child:NewProductScreen(wallpaper: widget.wallpaper,business: widget.business.id,view: this,currency: widget.business.currency,editMode: false,productEdit: null,isLoading: widget._parts.isLoading),type:PageTransitionType.fade));
          },),
        ],
        title: Text("Products"),
        backgroundColor: Colors.transparent,
        leading: 
        InkWell(radius: 20,child: Icon(IconData(58829, fontFamily: 'MaterialIcons')),
        onTap: (){
          Navigator.pop(context);
          },
        ),
      );
      return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
        widget._parts.isPortrait = orientation == Orientation.portrait;
        widget._parts.isTablet = widget._parts.isPortrait? MediaQuery.of(context).size.width > 600:MediaQuery.of(context).size.height > 600;
          return Stack(
            children: <Widget>[
              Positioned(
                height: widget._parts.isPortrait ? Measurements.height:Measurements.width,
                width:  widget._parts.isPortrait ? Measurements.width:Measurements.height,
                child: CachedNetworkImage(
                    imageUrl: widget.wallpaper,
                    placeholder: (context, url) =>  Container(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
              ),
              Container(
                color: Colors.black.withOpacity(0.2),
                height: widget._parts.isPortrait?Measurements.height:Measurements.width,
                width: widget._parts.isPortrait?Measurements.width:Measurements.height,
                child:BackdropFilter(
                  filter: ImageFilter.blur(sigmaX:25,sigmaY: 40,),
                  child: Container(
                    height: widget._parts.isPortrait?Measurements.height:Measurements.width,
                    width: widget._parts.isPortrait?Measurements.width:Measurements.height,
                    child: Scaffold(
                      bottomNavigationBar: Container(
                        height: widget._parts.loadMore.value ? Measurements.height * 0.0001:0,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            widget._parts.loadMore.value?ProductLoader(isSearching: widget._parts.isSearching ,business: widget._parts.business,page: widget._parts.page ,parts: widget._parts,):Container(),
                          ],
                        ),
                       ),
                      backgroundColor: Colors.black.withOpacity(0.2),
                      appBar: widget.posCall? null : _appBar, 
                      body: 
                      Column(children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: Measurements.height * 0.02,left: Measurements.width* (widget._parts.isTablet?0.01:0.05),right: Measurements.width* (widget._parts.isTablet?0.01:0.05)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              ),
                            padding:EdgeInsets.only(left: Measurements.width* (widget._parts.isTablet?0.01:0.025)),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Search",
                                border: InputBorder.none,
                                icon: Container(child:SvgPicture.asset("images/searchicon.svg",height: Measurements.height * 0.0175,color:Colors.white,))
                              ),
                              onFieldSubmitted: (doc){
                                widget._parts.products.clear();
                                widget._parts.searchDocument = doc; 
                                widget._parts.page = 1;
                                widget._parts.isLoading.value = true;
                              },
                            ),
                          ),
                        ),
                        widget._parts.isLoading.value?
                        ProductLoader(business: widget.business,parts: widget._parts,isSearching: false,):
                        ProductsBody(widget._parts),
                      ],)
                    )
                  )
                )
              ),
            ],
          );
        },
      );
    }
}

class ProductsBody extends StatefulWidget {
  ProductScreenParts _parts;
  ProductsBody(this._parts);
  @override
  _ProductsBodyState createState() => _ProductsBodyState();
}
class _ProductsBodyState extends State<ProductsBody> {

  ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener(){
    if (controller.position.extentAfter < 800) {
      if(widget._parts.page < widget._parts.pageCount && !widget._parts.loadMore.value){
        setState(() {
          widget._parts.loadMore.value = true;
          widget._parts.page ++;
        });
      }
    }
  }
  
  Future _refresh(){
    widget._parts.page = 1;
    widget._parts.loadMore.value = true;
    return Future.microtask((){
      return widget._parts.loadMore.value;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: !widget._parts.isTablet? 
          ListView.builder(
          physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          controller: controller,
          shrinkWrap: true,
          itemCount: widget._parts.products.length,
          itemBuilder: (BuildContext context, int index) {
            return ProductItem(currentProduct: widget._parts.products[index], parts: widget._parts);
          },)
          :GridView.builder(
            controller: controller,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: Measurements.height * 0.02,
              crossAxisCount: widget._parts.isPortrait?3:4,childAspectRatio:0.7
            ),
            shrinkWrap: true,
            itemCount:widget._parts.products.length,
            itemBuilder: (BuildContext context, int index) {
              return ProductItem(currentProduct: widget._parts.products[index], parts: widget._parts);
            },
        ),
      ),
    );
  }
}

class ProductLoader extends StatefulWidget {
  ProductScreenParts parts;
  Business business;
  String initialDocument;
  int page;
  int limit = 3;
  ProductLoader({this.parts,this.business,@required this.isSearching,this.page}){
    initialDocument = ''' 
              query Product {
                  getProducts(
                    businessUuid: "${business.id}",
                    paginationLimit: $limit,
                    pageNumber: $page,
                    orderBy: "createdAt",
                    orderDirection: "desc",
                    search: "${parts.searchDocument}",
                  ){
                    products {
                      images
                      uuid
                      title
                      description
                      hidden
                      price
                      salePrice
                      sku
                      barcode
                      currency
                      type
                      enabled
                      categories {
                        title
                      }
                      channelSets {
                        id
                        type
                        name
                      }
                      variants {
                        id
                        images
                        title
                        description
                        hidden
                        price
                        salePrice
                        sku
                        barcode
                      }
                      shipping {
                        free
                        general
                        weight
                        width
                        length
                        height
                      }
                    }
                    info {
                      pagination {
                        page
                        page_count
                        per_page
                        item_count
                      }
                    }
                  }
                }
              ''';
  }
  bool isSearching;
  @override
  _ProductLoaderState createState() => _ProductLoaderState();
}

class _ProductLoaderState extends State<ProductLoader> {
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GraphQLProvider(
        client: widget.parts.client,
        child: Query(
          options: QueryOptions(
            variables: <String,dynamic>{},
            document:widget.initialDocument),
            builder: (QueryResult result,{VoidCallback refetch}){
            if (result.errors != null) {
              print(result.errors);
              return Center(child: Text("Error while fetching data"));
            }
            if (result.loading){
              return Center(
                child: const CircularProgressIndicator(),
              );
            }
            if(widget.parts.page==1)widget.parts.products.clear();
            widget.parts.pageCount = result.data["getProducts"]["info"]["pagination"]["page_count"];
            result.data["getProducts"]["products"].forEach((prod){
              var tempProduct = ProductsModel.toMap(prod);
              if((widget.parts.products.indexWhere((test) => test.uuid == tempProduct.uuid)<0))
                widget.parts.products.add(tempProduct);
            });
            Future.delayed(Duration(seconds: 1)).then((_){
              result = null;
              widget.parts.isLoading.value = false;
              widget.parts.loadMore.value  = false;
            });
            return Center(
              child: const CircularProgressIndicator()
            );
          },
        ),
      ),
    );
  }
}

class ProductItem extends StatefulWidget {
  ProductsModel currentProduct;
  ProductScreenParts parts;
  dynamic refresh;
  num invStock = 0;
  ProductItem({@required this.currentProduct,@required this.parts,this.refresh});
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool test = true;
  @override
  Widget build(BuildContext context) {
    widget.invStock=0;
    if(widget.currentProduct.variants.isNotEmpty){
      widget.currentProduct.variants.forEach((variant){
        widget.parts.inventories.forEach((inv){
          if(variant.sku == inv.sku){
            widget.invStock += inv.stock??0;
          }
        });
      });
    }else{
      widget.parts.inventories.forEach((inv){
        if(widget.currentProduct.sku == inv.sku){
          widget.invStock = inv.stock??0;
        }
      });
    }
    widget.parts.haveShop  = false;
    widget.parts.havePOS   = false;
    widget.currentProduct.channels.forEach((channel){
      widget.parts.shops.forEach((shop){
        if(shop.channelSet == channel.id){
          widget.parts.haveShop  = true;
        }
      });
      widget.parts.terminals.forEach((terminal){
        if(terminal.channelSet == channel.id){
          widget.parts.havePOS= true;
        }
      });
      
    });
    String category;
    if(widget.currentProduct.categories.isNotEmpty)
      category = widget.currentProduct.categories[0].title??"";
    else
      category = "";
    return Container(
      padding: EdgeInsets.symmetric(horizontal:Measurements.width * (widget.parts.isTablet?0.01:0.05),vertical:Measurements.height *(widget.parts.isTablet?0.00:0.02)),        
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              InkWell(
                child: Container(
                  width: Measurements.width *(widget.parts.isTablet? (widget.parts.isPortrait? 0.3:0.3): 0.9),
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),color: Colors.black.withOpacity(0.3)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topRight,
                        padding: EdgeInsets.only(top: Measurements.width *(widget.parts.isTablet? (widget.parts.isPortrait? 0.02:0.02): 0.075),),
                        width:  Measurements.width *(widget.parts.isTablet? (widget.parts.isPortrait? 0.25:0.25): 0.75),
                        child: AutoSizeText("$category",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontSize: 16),minFontSize: 15,)
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: Measurements.height * (widget.parts.isTablet?0.01:0.025)),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(vertical: Measurements.height * 0.01),
                              height: Measurements.width *(widget.parts.isTablet? (widget.parts.isPortrait? 0.25:0.25): 0.75),
                              width:  Measurements.width *(widget.parts.isTablet? (widget.parts.isPortrait? 0.25:0.25): 0.75),
                              decoration: BoxDecoration(
                                color:Colors.black.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(widget.currentProduct.images.isEmpty ?12:12),
                              ),),
                              widget.currentProduct.images.isEmpty ?
                              Center(
                                child: SvgPicture.asset("images/noimage.svg",color: Colors.white.withOpacity(0.7),height: Measurements.width *(widget.parts.isTablet?0.1:0.2),),
                              ):
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(widget.currentProduct.images.isEmpty ?12:12),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(Env.Storage +"/products/"+ widget.currentProduct.images[0],
                                    ),
                                  ),
                                ),
                                height: Measurements.width *(widget.parts.isTablet? (widget.parts.isPortrait? 0.25:0.25): 0.75),
                                width:  Measurements.width *(widget.parts.isTablet? (widget.parts.isPortrait? 0.25:0.25): 0.75),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        width:  Measurements.width *(widget.parts.isTablet? (widget.parts.isPortrait? 0.25:0.25): 0.75),
                        child: Text(widget.currentProduct.title,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                      Container(
                        width:  Measurements.width *(widget.parts.isTablet? (widget.parts.isPortrait? 0.25:0.25): 0.75),                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            !widget.currentProduct.hidden?Container(
                              padding: EdgeInsets.only(right: Measurements.width * (widget.parts.isTablet?0.01 : 0.03)),
                              child: Text("${widget.currentProduct.salePrice} ${Measurements.currency(widget.currentProduct.currency)}",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16),),
                            ):Container(),
                            Container(
                              child: Text("${widget.currentProduct.price} ${Measurements.currency(widget.currentProduct.currency)}",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16,decoration: !widget.currentProduct.hidden?TextDecoration.lineThrough:TextDecoration.none,color:  widget.currentProduct.hidden? Colors.white:Colors.white.withOpacity(0.7)),),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: Measurements.width *(widget.parts.isTablet? (widget.parts.isPortrait? 0.02:0.02): 0.075),),
                        width:  Measurements.width *(widget.parts.isTablet? (widget.parts.isPortrait? 0.25:0.25): 0.75), 
                        child: widget.invStock <= 0?Text(Language.getProductListStrings("filters.quantity.outStock"),overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16,color:Colors.white.withOpacity(0.7),fontWeight: FontWeight.w300),):widget.invStock<=5?Text(Language.getProductListStrings("filters.quantity.lowStock"),overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16,color:Colors.white.withOpacity(0.7),fontWeight: FontWeight.w300),):Text("Stock ${widget.invStock}",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16,color:Colors.white.withOpacity(0.7),fontWeight: FontWeight.w300),),
                      )
                    ],
                  ),
                ),
                onTap: (){
                  widget.parts.isLoading.value = false;
                  if(!widget.parts.posCall)Navigator.push(context, PageTransition(child:NewProductScreen(wallpaper: widget.parts.wallpaper,business: widget.parts.business.id,view: this,currency: widget.parts.business.currency,editMode: true,productEdit: widget.currentProduct,isLoading: widget.parts.isLoading,),type:PageTransitionType.fade));
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 1),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Measurements.width * (widget.parts.isTablet?(widget.parts.isPortrait? 0.02:0.02):0.05),vertical: Measurements.height * (widget.parts.isTablet?(widget.parts.isPortrait? 0.0075:0.0075):0.02)),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                bottomLeft:  Radius.circular(12),
                bottomRight: Radius.circular(12),
              )
            ),
            height: Measurements.height * (widget.parts.isTablet? (widget.parts.isPortrait? 0.035:0.035):0.07),
            width: Measurements.width *   (widget.parts.isTablet? (widget.parts.isPortrait? 0.3:0.3):0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    widget.parts.havePOS  ? SvgPicture.asset("images/posicon.svg" ,color:Colors.white) :Container(),
                    widget.parts.haveShop ? SvgPicture.asset("images/shopicon.svg",color:Colors.white) :Container(),
                  ],
                ),
                widget.parts.posCall? Container():Container(
                  height: Measurements.height * 0.05,
                  alignment: Alignment.topCenter,
                  child: PopupMenuButton(
                    onSelected: (action){
                      if(action == "delete"){
                            String doc = '''
                            mutation deleteProduct {
                                deleteProduct(product: {uuids: ["${widget.currentProduct.uuid}"]}) 
                                }
                            ''';
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    color: Colors.transparent,
                                    height: Measurements.width * 0.3,
                                    width: Measurements.width * 0.3,
                                    child: GraphQLProvider(
                                      client: widget.parts.client,
                                      child: Query(
                                        options: QueryOptions(
                                        variables: <String, dynamic>{}, document: doc),
                                        builder: (QueryResult result, {VoidCallback refetch}) {
                                          if (result.errors != null) {
                                            print(result.errors);
                                            return Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  Text("Error while Deleting"),
                                                  IconButton(
                                                    icon: Icon(Icons.close),
                                                    onPressed: (){
                                                      if(result.errors.toString().contains("401")){
                                                        GlobalUtils.clearCredentials();
                                                        Navigator.pushReplacement(context,PageTransition(child:LoginScreen() ,type: PageTransitionType.fade));
                                                      }else{
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          if (result.loading) {
                                            return Center(
                                              child: const CircularProgressIndicator(),
                                            );
                                          }
                                          return OrientationBuilder(
                                            builder:(BuildContext context, Orientation orientation) {
                                              Future.delayed(Duration(microseconds: 1)).then((_){
                                                widget.parts.isLoading.notifyListeners();
                                                widget.parts.products.remove(widget.currentProduct);
                                                Navigator.pop(context);
                                              });
                                              return Text("");
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              });
                      }
                    },
                    child: Container(child: Icon(Icons.more_vert)),
                    itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                      PopupMenuItem<String>(
                        value: "delete",
                        child: Text(Language.getProductStrings("delete")),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


