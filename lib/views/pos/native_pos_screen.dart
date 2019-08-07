import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/models/business.dart';
import 'package:payever/models/checkout.dart';
import 'package:payever/models/pos.dart';
import 'package:payever/models/products.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/customshapes.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/pos/detailedProduct.dart';
import 'package:payever/views/pos/pos_cart.dart';
import 'package:payever/views/pos/pos_order_section.dart';
import 'package:payever/views/pos/send2dev.dart';
import 'package:payever/views/pos/webviewsection.dart';

ValueNotifier<GraphQLClient> clientFor({
  @required String uri,
  String subscriptionUri,     
}) {
  Link link = HttpLink(uri: uri) as Link;
  if (subscriptionUri != null) {
    WebSocketLink websocketLink = WebSocketLink(
        config: SocketClientConfig(
          autoReconnect: true,
          inactivityTimeout: Duration(seconds: 30),
        ),
        url: uri
    );
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

class PosScreenParts{
  Terminal currentTerminal;
  Business business;
  Cart shoppingCart;
  List<ProductsModel> productList = List();
  
  Map<String,String> productStock = Map();

  bool smsenabled = false;
  String shoppingCartID = "";
  String url;
  
  bool isTablet;
  bool isPortrait;

  int pageCount;
  int page = 1;
  String search = "";
  ValueNotifier<bool> loadMore = ValueNotifier(false);
  //ValueNotifier<bool> searching = ValueNotifier(false);

  ValueNotifier haveProducts     = ValueNotifier(false);
  ValueNotifier dataFetched      = ValueNotifier(false);
  ValueNotifier<int> openSection = ValueNotifier(0);
  final ValueNotifier<GraphQLClient> client = clientFor(
    uri: Env.Products + "/products",
  );
  Checkout currentCheckout;
  Color titleColor = Colors.black;
  Color saleColor  = Color(0xFFFF3D34);

  var f = new NumberFormat("###,##0.00","de_DE");

  
  add2cart({String id,String image,String name,num price,num qty,String sku,String uuid}){
    int index = shoppingCart.items.indexWhere((test)=>test.id == id);
    if(index < 0){
      shoppingCart.items.add(CartItem(id:id,sku: sku,price: price,name:name,quantity: qty,uuid: uuid,image: image));
    }else{
      shoppingCart.items[index].quantity += qty;
    }
    shoppingCart.total += price;
    haveProducts.value = shoppingCart.items.isNotEmpty;
  }

  deleteProduct(int index){
    num less = shoppingCart.items[index].price * shoppingCart.items[index].quantity;
    shoppingCart.total -= less;
    shoppingCart.items.removeAt(index);
    haveProducts.value = shoppingCart.items.isNotEmpty;
  }

  updateQty({int index,num quantity}){
    var add = quantity - shoppingCart.items[index].quantity;
    shoppingCart.items[index].quantity = quantity;
    shoppingCart.total = shoppingCart.total + (shoppingCart.items[index].price * add);
  }

}

class NativePosScreen extends StatefulWidget {
  Terminal terminal;
  Business business;
  NativePosScreen({@required this.terminal,@required this.business});
  PosScreenParts parts;

  @override
  _NativePosScreenState createState() => _NativePosScreenState();
}

class _NativePosScreenState extends State<NativePosScreen> {
  @override
  void initState() {
    super.initState();
    widget.parts= PosScreenParts();
    RestDatasource api = RestDatasource();
    widget.parts.business = widget.business;
    RestDatasource().getInventory(widget.parts.business.id, GlobalUtils.ActiveToken.accessToken).then((inventories){
      inventories.forEach((inv){
        InventoryModel _currentInv =InventoryModel.toMap(inv);
        widget.parts.productStock.addAll({"${_currentInv.sku}" : "${_currentInv.stock.toString()}"});
      });
      setState(() {});
    });
    if(widget.terminal == null){
    List<Terminal> _terminals = List();
    List<ChannelSet> _chSets = List();
    
    api.getTerminal(widget.business.id, GlobalUtils.ActiveToken.accesstoken,context).then((terminals){
      terminals.forEach((terminal){
        _terminals.add(Terminal.toMap(terminal));
      });
    }).then((_){
      api.getChannelSet(widget.business.id,GlobalUtils.ActiveToken.accesstoken,context).then((channelsets){
          channelsets.forEach((chset){
            _chSets.add(ChannelSet.toMap(chset));
          });
        })
        .then((_){
          widget.parts.currentTerminal = _terminals.firstWhere((term)=>term.active);
          widget.parts.shoppingCart = Cart(); 
          api.getCheckout(widget.parts.currentTerminal.channelSet,GlobalUtils.ActiveToken.accessToken).then((_checkout){
            widget.parts.currentCheckout = Checkout.toMap(_checkout);
            widget.parts.smsenabled = !widget.parts.currentCheckout.sections.firstWhere((test)=> test.code=="send_to_device").enabled;
            setState((){});
          });
        });
    }).catchError((onError){
      print(onError);
    });
    }else{
      widget.parts.currentTerminal = widget.terminal;
      widget.parts.shoppingCart = Cart(); 
      api.getCheckout(widget.terminal.channelSet,GlobalUtils.ActiveToken.accessToken).then((_checkout){
        widget.parts.currentCheckout = Checkout.toMap(_checkout);
        widget.parts.smsenabled = !widget.parts.currentCheckout.sections.firstWhere((test)=> test.code=="send_to_device").enabled;
      });
    }
    widget.parts.haveProducts.addListener(listener);
    widget.parts.dataFetched.addListener(listener);
    widget.parts.loadMore.addListener(listener);
  }

  listener(){ 
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    widget.parts.isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    widget.parts.isTablet = widget.parts.isPortrait? MediaQuery.of(context).size.width > 600:MediaQuery.of(context).size.height > 600;   
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: widget.parts.loadMore.value ? Measurements.height * 0.0001:0,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.parts.loadMore.value?Loader(widget.parts):Container(),
          ],
        ),
        ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close,color: Colors.black,),
          onPressed: ()=>Navigator.pop(context),
        ),centerTitle: true,
        title: Container(
          child:Text(widget.parts.currentTerminal?.name??"",style: TextStyle(color: Colors.black),),
        ),
        actions: <Widget>[
          IconButton(
            icon: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SvgPicture.asset("images/shopicon.svg",color:Colors.black,height: Measurements.height * 0.035,),
                widget.parts.haveProducts.value?CustomPaint(painter: Dot(color: Color(0XFF0084FF), dotSize: Measurements.height * (widget.parts.isTablet?0.003:0.005), canvasSize: Measurements.height * 0.035),):Container(),
              ],
            ),
            onPressed: (){
              Navigator.push(context, PageTransition(child:POSCart(parts:widget.parts,),type:PageTransitionType.fade,duration: Duration(milliseconds: 10)));
            },
          ),
        ],
      ),
      body: !widget.parts.dataFetched.value?Loader(widget.parts):PosBody(parts: widget.parts,),
    );
  }
}

class PosBody extends StatefulWidget {
  PosScreenParts parts;
  PosBody({@required this.parts});
  @override
  _PosBodyState createState() => _PosBodyState();
}

class _PosBodyState extends State<PosBody> {
  ScrollController controller;
    void _scrollListener(){
    if (controller.position.extentAfter < 800) {
      if(widget.parts.page < widget.parts.pageCount && !widget.parts.loadMore.value){
        setState(() {
          widget.parts.page ++;
          widget.parts.loadMore.value = true;
        });
      }
    }
  }

  
  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    int index;
    List<Widget> prodList = List();
    widget.parts.productList.forEach((prod){
      var temp = widget.parts.productStock[prod.sku]??"0";
      var _variants = prod.variants;
      bool oneVariant = true;
      if(_variants.isNotEmpty){
        var _varEmpty = widget.parts.productStock[_variants[0].sku]??"0";
        oneVariant = ((_varEmpty.contains("null")? 0:int.parse(_varEmpty??"0")) > 0);
      }
      if(!(!((temp.contains("null")? 0:int.parse(temp??"0")) > 0) && prod.variants.isEmpty) && !((prod.variants.length == 1) && !oneVariant))
        prodList.add( ProductItem(currentProduct: prod, parts: widget.parts) );
    });

    return Container(
      padding: EdgeInsets.symmetric(horizontal:Measurements.width * (widget.parts.isTablet? 0.03:0.05)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height:Measurements.height * (widget.parts.isTablet? 0.05:0.1),
            width: Measurements.width  * (widget.parts.isTablet? 0.3: 0.8),
            padding: EdgeInsets.symmetric(vertical:Measurements.height * (widget.parts.isTablet?0.01:0.02)),
            child: InkWell(
              child:Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Center(
                  child: Text("Type Amount",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold)),
                ),
              ),
              onTap:(){
                Navigator.push(context,PageTransition(child:WebViewPayments(parts: widget.parts,url: null,),type:PageTransitionType.fade,duration: Duration(milliseconds: 10)) );            
              },
            ),
          ),
          //testing search
          // TextFormField(
          //   decoration: InputDecoration(
          //     hintText: "Search",
          //     border: InputBorder.none,
          //     icon: Container(child:SvgPicture.asset("images/searchicon.svg",height: Measurements.height * 0.0175,color:Colors.white,))
          //   ),
          //   onFieldSubmitted: (doc){
          //     widget.parts.productList.clear();
          //     widget.parts.search = doc; 
          //     widget.parts.page = 1;
          //     widget.parts.searching.value = true;
          //   },
          // ),
          //
          //widget.parts.searching.value?Center(child:CircularProgressIndicator()):
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top:Measurements.height * 0.02),
              child: !widget.parts.isTablet? 
              ListView.builder(
                controller:controller,
                shrinkWrap: true,
                itemCount: prodList.length,
                itemBuilder: (BuildContext context, int index) {
                  return prodList[index];
                },
            ):
            GridView.builder(
                controller:controller,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.parts.isPortrait?3:4,childAspectRatio:0.65
                ),
                itemCount:prodList.length,
                itemBuilder: (BuildContext context, int index) {
                  return prodList[index];
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItem extends StatefulWidget {
  ProductsModel currentProduct;
  PosScreenParts parts;
  ProductItem({this.currentProduct,this.parts});
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color:Colors.white,
      child: InkWell(
        child: Container(
          width:  Measurements.width *(widget.parts.isTablet? (widget.parts.isPortrait? 0.3:0.3): 0.8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    height: Measurements.width *(widget.parts.isTablet? (widget.parts.isPortrait? 0.3:0.3): 0.8),
                    width:  Measurements.width *(widget.parts.isTablet? (widget.parts.isPortrait? 0.3:0.3): 0.8),
                    decoration: BoxDecoration(
                      color: widget.currentProduct.images.isEmpty ? Colors.black.withOpacity(0.35):Colors.white,
                      borderRadius: BorderRadius.circular(widget.currentProduct.images.isEmpty ?0:12),
                      ),
                    ),
                    widget.currentProduct.images.isEmpty ?
                    Center(
                      child: SvgPicture.asset("images/noimage.svg",color: Colors.white.withOpacity(0.7),height: Measurements.width *(widget.parts.isTablet?0.1:0.2),),
                    ):
                    Container(
                      height: Measurements.width *(widget.parts.isTablet? 0.3: 0.8),
                      width:  Measurements.width *(widget.parts.isTablet? 0.3: 0.8),
                        child:CachedNetworkImage(
                        imageUrl: Env.Storage +"/products/"+ widget.currentProduct.images[0],
                        placeholder: (context, url) =>  Container(),
                        errorWidget: (context, url, error) => new Icon(Icons.error),
                        fit: BoxFit.contain,
                      ),
                    ),
                ],
              ),
              !widget.currentProduct.hidden?Container(
                alignment: Alignment.bottomCenter,
                height: Measurements.height * 0.03,
                child:Text("Sale",style: TextStyle(fontSize: 15,color: widget.parts.saleColor,fontWeight: FontWeight.w300),),
              ):
              Container(height: Measurements.height * 0.03,),
              Container(
                height: Measurements.height * 0.03,
                width:  Measurements.width *(widget.parts.isTablet? 0.4: 0.8),
                alignment: Alignment.center,
                child: Text("${widget.currentProduct.title}",style: TextStyle(fontSize: 15,color: widget.parts.titleColor,fontWeight: FontWeight.bold),)
              ),
              Container(
                height: Measurements.height * 0.03,
                alignment: Alignment.center,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("${widget.parts.f.format(widget.currentProduct.price)}${Measurements.currency(widget.parts.business.currency)}",style: TextStyle(fontSize: 15,color: widget.parts.titleColor,fontWeight: FontWeight.w400,decoration: !widget.currentProduct.hidden?TextDecoration.lineThrough:TextDecoration.none),),
                       !widget.currentProduct.hidden?Text("  ${widget.parts.f.format(widget.currentProduct.salePrice)}${Measurements.currency(widget.parts.business.currency)}",style: TextStyle(fontSize: 15,color: widget.parts.saleColor,fontWeight: FontWeight.w400),):Container(),
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
        onTap: (){
          Navigator.push(context, PageTransition(child:DetailScreen(parts:widget.parts,currentProduct: widget.currentProduct,),type:PageTransitionType.fade,duration: Duration(milliseconds: 10)));
        },
      ),
    );
  }
}


class Loader extends StatefulWidget {
  PosScreenParts parts;
  Loader(this.parts);
  int page = 1;
  int limit = 36;
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.parts.currentTerminal == null? 
    Center(child: const CircularProgressIndicator(backgroundColor: Colors.black,),):
    GraphQLProvider(
        client: widget.parts.client,
        child: Query(
          options: QueryOptions(
            variables: <String,dynamic>{},
            document:''' 
              query getProductsByChannelSet{
                  getProductsByChannelSet(businessId: "${widget.parts.business.id}", channelSetId: "${widget.parts.currentTerminal.channelSet}",search: "${widget.parts.search}",existInChannelSet: true, paginationLimit: ${widget.limit}, pageNumber: ${widget.parts.page}) {
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
              '''),
          builder: (QueryResult result,{VoidCallback refetch}) {
            if (result.errors != null) {
              print(result.errors);
              return Center(child: Text("Error while fetching data"));
            }
            if (result.loading) {
              return Center(
                child: const CircularProgressIndicator(backgroundColor: Colors.black,),
              );
            }
            widget.parts.pageCount = result.data["getProductsByChannelSet"]["info"]["pagination"]["page_count"];
            print(result.data["getProductsByChannelSet"]["products"].length);
            result.data["getProductsByChannelSet"]["products"].forEach((prod){
              var tempProduct = ProductsModel.toMap(prod);
              print("TITLE ${tempProduct.title}");
              if((widget.parts.productList.indexWhere((test) => test.sku == tempProduct.sku)<0))
                widget.parts.productList.add(tempProduct);
            });
            if(widget.parts.productList.isNotEmpty){
              Future.delayed(Duration(microseconds: 1)).then((_){
                widget.parts.dataFetched.value = true;
                widget.parts.loadMore.value = false;
              });
            }
            return Container();
          },
      ) ,
    );
  }
}