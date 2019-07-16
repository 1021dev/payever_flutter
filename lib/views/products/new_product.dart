import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/models/pos.dart';
import 'package:payever/models/products.dart';
import 'package:payever/models/shop.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/network/rest_ds.dart' as prefix0;
import 'package:payever/utils/env.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:payever/views/login/login_page.dart';
import 'package:payever/views/products/inventory.dart';
import 'package:payever/views/products/product_type.dart';
import 'package:uuid/uuid.dart';

ValueNotifier<GraphQLClient> clientFor({
  @required String uri,
  String subscriptionUri,
}) {
  Link link = HttpLink(uri: uri) as Link;
  if (subscriptionUri != null) {
    WebSocketLink websocketLink = WebSocketLink(
      headers: {
        HttpHeaders.AUTHORIZATION:
            "Bearer ${GlobalUtils.ActiveToken.accessToken}",
        HttpHeaders.CONTENT_TYPE: "application/json"
      },
      url: uri,
      config: SocketClientConfig(
        autoReconnect: true, 
        inactivityTimeout: Duration(seconds: 10),
      ),
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

class NewProductScreenParts {

  bool isPortrait;
  bool isTablet;
  bool editMode;
  bool enabled = true;
  Color switchColor = Color(0XFF0084ff);
  ValueNotifier  isLoading;
  bool havePOS  = false;
  bool haveShop = false;
  
  String wallpaper;

  List<String> categoryList = List();
  List<String> images = List();
  List<Categories> categories = List();
  List<Inventory> inventories = List();
  List<Terminal> terminals = List();
  List<Shop>     shops     = List();
  List<ChannelSet> channels = List();

  var qkey = GlobalKey();
  final GlobalKey<FormState> popupkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final popupscaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<AutoCompleteTextFieldState<String>> atfKey = new GlobalKey();

  var openedRow = ValueNotifier(0);
  String business;
  String type;
  String currency;
  Widget mainForm;
  Widget inventoryForm;
  Widget shippingForm;
  Widget visibilityForm;
  Widget taxForm;
  Widget variantForm;
  Widget categoryForm;
  Widget channelForm;
  ProductsModel product = ProductsModel();
  List<Variants> variants = List();
  InventoryManagement invManager = InventoryManagement();

  final ValueNotifier<GraphQLClient> client = clientFor(
    uri: Env.Products + "/products",
  );
  bool skuError = false;

  bool prodTrackInv= false; 
  num prodStock = 0;    
}

class NewProductScreen extends StatefulWidget {
  NewProductScreenParts _parts;
  String wallpaper;
  String business;
  String currency;
  State view;
  bool editMode;
  ValueNotifier isLoading;
  ProductsModel productEdit;
  String initialstate;
  NewProductScreen(
      {@required this.wallpaper,
      @required this.business,
      @required this.view,
      this.currency,
      this.editMode,
      this.productEdit,
      this.isLoading,
      });

  @override
  _NewProductScreenState createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {

  AppBar _appBar;
  ButtomRow buttomrow;
  MainRow mainrow;
  InventoryRow inventoryRow;
  CategoryRow categoryRow;
  ShippingRow shippingRow;
  VisibilityRow visibilityRow;
  TaxRow taxRow;
  VariantRow variantRow;
  ChannelRow channelRow;
  bool okToSave = false;

  listener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget._parts = NewProductScreenParts();
    widget._parts.wallpaper = widget.wallpaper;
    widget._parts.business = widget.business;
    widget._parts.openedRow.addListener(listener);
    widget._parts.currency = widget.currency;
    widget._parts.editMode = widget.editMode;
    widget._parts.isLoading = widget.isLoading;

    if(widget.editMode){
      
      widget._parts.channels = widget.productEdit.channels;
      widget._parts.product = widget.productEdit;
      widget._parts.type = widget.productEdit.type;
      if(widget._parts.product.variants.isNotEmpty){
        widget._parts.inventories = List();
        widget._parts.product.variants.forEach((f){
          //Store all inventories
          RestDatasource api = RestDatasource();
          api.getInvetory(widget.business, GlobalUtils.ActiveToken.accessToken, f.sku,context).then((inv){
            InventoryModel currentInventory = InventoryModel.toMap(inv);
            print("${currentInventory.sku} = ${currentInventory.stock}");
            widget._parts.invManager.addInventory(Inventory(amount: currentInventory.stock, barcode: currentInventory.barcode, sku: currentInventory.sku, tracking: currentInventory.isTrackable));
          });
        });
      }else{
        RestDatasource().getInvetory(widget.business, GlobalUtils.ActiveToken.accessToken, widget._parts.product.sku,context).then((inv){
          InventoryModel currentInventory = InventoryModel.toMap(inv);
          widget._parts.invManager.addInventory(Inventory(amount: currentInventory.stock, barcode: currentInventory.barcode, sku: currentInventory.sku, tracking: currentInventory.isTrackable));
        });
      }
    }
    // HERE
    buttomrow = ButtomRow(widget._parts.openedRow, widget._parts);
    mainrow = MainRow(parts: widget._parts, openedRow: widget._parts.openedRow);
    channelRow    = ChannelRow(parts: widget._parts, openedRow: widget._parts.openedRow);
    inventoryRow  = InventoryRow(parts: widget._parts, openedRow: widget._parts.openedRow);
    categoryRow =
        CategoryRow(parts: widget._parts, openedRow: widget._parts.openedRow);
    shippingRow =
        ShippingRow(parts: widget._parts, openedRow: widget._parts.openedRow);
    visibilityRow =
        VisibilityRow(parts: widget._parts, openedRow: widget._parts.openedRow);
    taxRow = TaxRow(parts: widget._parts, openedRow: widget._parts.openedRow);
    variantRow =
        VariantRow(parts: widget._parts, openedRow: widget._parts.openedRow);
    
  }

  Scaffold scaffold;

  @override
  Widget build(BuildContext context) {
    _appBar = AppBar(
      elevation: 0,
      actions: <Widget>[
        InkWell(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: Measurements.width * 0.02),
            child: Text(Language.getProductStrings("save"))
          ),
          onTap: () {
            save();
          },
        ),
      ],
      title: Text(Language.getProductStrings("title")),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      leading: InkWell(
        radius: 20,
        child: Icon(IconData(58829, fontFamily: 'MaterialIcons')),
        onTap: () {
          this.dispose();
          Navigator.pop(context);
        },
      ),
    );
    scaffold = Scaffold(
      key: widget._parts.scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar: _appBar,
      body: ListView(
        children: <Widget>[
          Form(
            key: widget._parts._formKey,
            child: Container(
              child: Column(
                children: <Widget>[
                  buttomrow,
                  mainrow,
                  widget._parts.product.variants.length == 0 ? inventoryRow:Container(),
                  categoryRow,
                  variantRow,
                  channelRow,
                  shippingRow,
                  taxRow,
                  visibilityRow
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        widget._parts.isPortrait = orientation == Orientation.portrait;
        widget._parts.isTablet = widget._parts.isPortrait
            ? MediaQuery.of(context).size.width > 600
            : MediaQuery.of(context).size.height > 600;
        return Stack(
          children: <Widget>[
            Positioned(
              height: widget._parts.isPortrait
                  ? Measurements.height
                  : Measurements.width,
              width: widget._parts.isPortrait
                  ? Measurements.width
                  : Measurements.height,
              child: CachedNetworkImage(
                imageUrl: widget.wallpaper,
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            Container(
                color: Colors.black.withOpacity(0.2),
                height: widget._parts.isPortrait
                    ? Measurements.height
                    : Measurements.width,
                width: widget._parts.isPortrait
                    ? Measurements.width
                    : Measurements.height,
                child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 25,
                      sigmaY: 40,
                    ),
                    child: Container(
                      height: widget._parts.isPortrait
                          ? Measurements.height
                          : Measurements.width,
                      width: widget._parts.isPortrait
                          ? Measurements.width
                          : Measurements.height,
                      child: scaffold,
                    )))
          ],
        );
      },
    );
  }
  
  void save() {
    widget._parts.invManager.printAll();
    var a = widget._parts._formKey.currentState;
    a.validate();
    okToSave = mainrow.isMainRowOK &&
        inventoryRow.isInventoryRowOK &&
        shippingRow.isShippingRowOK;
    print("____________________");
    print("MAIN ROW      = ${mainrow.isMainRowOK}");
    print("INVENTORY ROW = ${inventoryRow.isInventoryRowOK}");
    print("Shipping ROW  = ${shippingRow.isShippingRowOK}");
    print("Ok to save    = $okToSave");
    print("--------------------");
    print("Category List\n ${widget._parts.categoryList}");
    RestDatasource().getBusinesses(GlobalUtils.ActiveToken.accessToken, context).then((_){
      if (okToSave) {
      a.save();
      String _images = "";
      widget._parts.images.forEach((name) {
        _images += '"$name"';
      });
      String variants = "";
      widget._parts.product.variants.forEach((v){
        String images = "";
        v.images.forEach((name) {
          images += '"$name"';
        });
        String id = '"${Uuid().v4()}"';
        variants += '{title: "${v.title}", description: "${v.description}",price: ${v.price}, images: [$images], hidden: ${v.hidden}, salePrice: ${v.salePrice}, sku: "${v.sku}", barcode: "${v.barcode}",id: $id}';
      });
      String stringCategories = "";
      widget._parts.categoryList.forEach((f){
        Categories c =widget._parts.categories.where((test) => test.title.toLowerCase() == f.toLowerCase()).toList()[0];
        stringCategories += '{_id: "${c.id}", businessUuid: "${widget.business}", title: "${c.title}",slug: "${c.slug}"}';
      });
      String channels = "";
      widget._parts.channels.forEach((ch){
        channels += '{id:"${ch.id}", type: "${ch.type}", name: "${ch.name}"}';
      });

      print(channels);

      String doc = !widget._parts.editMode?
       '''
        mutation createProduct {
            createProduct(product: {businessUuid: "${widget._parts.business}", images: [$_images], title: "${widget._parts.product.title}", description: "${widget._parts.product.description}", hidden: ${widget._parts.product.hidden} , price: ${widget._parts.product.price}, salePrice: ${widget._parts.product.salePrice}, sku: "${widget._parts.product.sku == null?"":widget._parts.product.sku}", barcode: "${widget._parts.product.barcode == null?"":widget._parts.product.barcode}", type: "${widget._parts.type}", enabled: ${widget._parts.enabled}, channelSets: [$channels], categories: [$stringCategories], variants: [$variants], shipping: {free: ${widget._parts.product.shipping.free}, general: ${widget._parts.product.shipping.general}, weight: ${widget._parts.product.shipping.weight}, width: ${widget._parts.product.shipping.width}, length: ${widget._parts.product.shipping.length}, height:  ${widget._parts.product.shipping.height}}}) {
                title
                uuid
                }
              }
        ''':
        '''
        mutation updateProduct {
            updateProduct(product: {businessUuid: "${widget._parts.business}", images: [$_images], uuid: "${widget.productEdit.uuid}", title: "${widget._parts.product.title}", description: "${widget._parts.product.description}", hidden: ${widget._parts.product.hidden} , price: ${widget._parts.product.price}, salePrice: ${widget._parts.product.salePrice}, sku: "${widget._parts.product.sku == null?"":widget._parts.product.sku}", barcode: "${widget._parts.product.barcode == null?"":widget._parts.product.barcode}", type: "${widget._parts.type}", enabled: ${widget._parts.product.enabled}, channelSets: [$channels], categories: [$stringCategories], variants: [$variants], shipping: {free: ${widget._parts.product.shipping.free}, general: ${widget._parts.product.shipping.general}, weight: ${widget._parts.product.shipping.weight}, width: ${widget._parts.product.shipping.width}, length: ${widget._parts.product.shipping.length}, height:  ${widget._parts.product.shipping.height}}}) {
                title
                uuid
                }
              }
        ''' ;
      print(doc);
      showDialog(barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2,sigmaY: 2),
                child: Container(
                  color: Colors.transparent,
                  height: Measurements.width * 0.3,
                  width:  Measurements.width * 0.3,
                  child: GraphQLProvider(
                    client: widget._parts.client,
                    child: Query(
                      options: QueryOptions(
                          variables: <String, dynamic>{}, document: doc),
                      builder: (QueryResult result, {VoidCallback refetch}) {
                        if (result.errors != null) {
                          return Column(
                            children: <Widget>[
                              Text("Error while creating/updating a product"),
                              IconButton(icon: Icon(Icons.close), onPressed: () {
                                Navigator.pop(context);//popon error
                              },)
                            ],
                          );
                        }
                        if (result.loading) {
                          return Center(
                            child: const CircularProgressIndicator(),
                          );
                        }
                        return OrientationBuilder(
                          builder:
                            (BuildContext context, Orientation orientation) {
                              widget._parts.invManager.saveInventories(widget.business,context);
                                return Container(
                                  height: Measurements.width * 0.3,
                                  width:  Measurements.width * 0.3,
                                  child: Center(child: CircularProgressIndicator(),)
                                );
                            },
                          );
                        },
                      ),
                    ),
                  ),
              ),
              );
            });
      } else {
        SnackBar snackBar = SnackBar(
          backgroundColor: Colors.black.withOpacity(0.5),
          content: Text("Please fill required fields"),
        );
        widget._parts.scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }).catchError((onError){
      if(onError.toString().contains("401")){
        GlobalUtils.clearCredentials();
        Navigator.pushReplacement(context,PageTransition(child:LoginScreen() ,type: PageTransitionType.fade));
      }
    });
  }
    
}

class MainRow extends StatefulWidget {
  ValueNotifier openedRow;
  NewProductScreenParts parts;

  String currentImage;
  MainRow({this.openedRow, this.parts});
  bool nameError = false;
  bool priceError = false;
  bool descriptionError = false;
  bool onSaleError = false;
  bool onSale = false;
  get isMainRowOK {
    return !(nameError || priceError || descriptionError) &&
        !(onSale && onSaleError);
  }
  bool isOpen = true;
  bool haveImage = false;
  @override
  _MainRowState createState() => _MainRowState();
}

class _MainRowState extends State<MainRow> {
  listener() {
    setState(() {
      if (widget.openedRow.value == 0) {
        widget.isOpen = !widget.isOpen;
      } else {
        widget.isOpen = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.openedRow.addListener(listener);
    if(widget.parts.editMode){
      widget.haveImage = widget.parts.product.images.length>0;
      widget.onSale = !widget.parts.product.hidden;
      if(widget.haveImage){
        widget.currentImage = widget.parts.product.images[0];
        widget.parts.images = widget.parts.product.images;
      }
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image.existsSync())
      setState(() {
        RestDatasource api = RestDatasource();
        api
            .postImage(image, widget.parts.business,
                GlobalUtils.ActiveToken.accessToken)
            .then((dynamic res) {
          widget.parts.images.add(res["blobName"]);
          if (widget.currentImage == null) {
            widget.currentImage = res["blobName"];
          }
          setState(() {
            widget.haveImage = true;
          });
        }).catchError((onError) {
          setState(() {
            print(onError);
          });
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    widget.parts.mainForm = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: Measurements.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(16))),
                  width: Measurements.width * 0.5475,
                  height: Measurements.height *
                      (widget.parts.isTablet ? 0.05 : 0.07),
                  child: TextFormField(style: TextStyle(fontSize: Measurements.height * 0.02),
                    initialValue: widget.parts.editMode?widget.parts.product.title:"",
                    inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]"))],
                    decoration: InputDecoration(
                      hintText: Language.getProductStrings("name.title"),
                      hintStyle: TextStyle(
                          color: widget.nameError
                              ? Colors.red
                              : Colors.white.withOpacity(0.5)),
                      border: InputBorder.none,
                    ),
                    onSaved: (name) {
                      widget.parts.product.title = name;
                      widget.parts.product.hidden = !widget.onSale;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          widget.nameError = true;
                        });
                        return;
                      } else {
                        setState(() {
                          widget.nameError = false;
                        });
                      }
                    },
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Measurements.width * 0.025),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(16))),
                    width: Measurements.width * 0.3475,
                    height: Measurements.height *
                        (widget.parts.isTablet ? 0.05 : 0.07),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          //width: (Measurements.width * 0.2475)*2/3,
                          child: AutoSizeText(Language.getProductStrings("price.sale"),style: TextStyle(fontSize: Measurements.height * 0.02))),
                        Switch(
                          activeColor: widget.parts.switchColor,
                          value: widget.onSale,
                          onChanged: (value) {
                            setState(() {
                              widget.onSale = value;
                            });
                          },
                        )
                      ],
                    )),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.005),
          ),
          Container(
            width: Measurements.width * 0.9,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.025),
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.05),
                  width: Measurements.width * 0.4475,
                  height: Measurements.height *
                      (widget.parts.isTablet ? 0.05 : 0.07),
                  child: TextFormField(
                    style: TextStyle(fontSize: Measurements.height * 0.02),
                    initialValue: widget.parts.editMode?widget.parts.product.price.toString():"",
                    inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
                    decoration: InputDecoration(
                      hintText: Language.getProductStrings("price.placeholders.price"),
                      hintStyle: TextStyle(
                          color: widget.priceError
                              ? Colors.red
                              : Colors.white.withOpacity(0.5)),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (price) {
                      widget.parts.product.price = num.parse(price);
                    },
                    validator: (value) {
                      if (value.isEmpty || num.parse(value) >= 1000000) {
                        setState(() {
                          widget.priceError = true;
                        });
                        return;
                      } else if(value.split(".").length>2){
                          setState(() {
                            widget.priceError = true;
                          });
                        }else {
                        setState(() {
                          widget.priceError = false;
                        });
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.025),
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.05),
                  width: Measurements.width * 0.4475,
                  height: Measurements.height *
                      (widget.parts.isTablet ? 0.05 : 0.07),
                  child: TextFormField(
                    style: TextStyle(fontSize: Measurements.height * 0.02),
                    initialValue: widget.parts.editMode?widget.parts.product.salePrice==null?"":widget.parts.product.salePrice.toString():"",
                    inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: Language.getProductStrings("placeholders.salePrice"),
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          color: (widget.onSale && widget.onSaleError)
                              ? Colors.red
                              : Colors.white.withOpacity(0.5)),
                    ),
                    onSaved: (saleprice) {
                      
                      widget.parts.product.salePrice =
                          saleprice.isEmpty ? null : num.parse(saleprice);
                    },
                    validator: (value) {
                      if (widget.onSale) {
                        if (value.isEmpty) {
                          setState(() {
                            widget.onSaleError = true;
                          });
                          return;
                        } else if(value.split(".").length>2){
                            setState(() {
                              widget.onSaleError = true;
                            });
                          }else {
                          setState(() {
                            widget.onSaleError = false;
                          });
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.005),
          ),
          Expanded(
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16))),
              width: Measurements.width * 0.9,
              child: TextFormField(
                style: TextStyle(fontSize: Measurements.height * 0.02),
                initialValue: widget.parts.editMode?widget.parts.product.description:"",
                inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]"))],
                maxLines: 99,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                        color: widget.descriptionError
                            ? Colors.red
                            : Colors.white.withOpacity(0.5)),
                    labelText: Language.getProductStrings("mainSection.form.description.label")),
                onSaved: (description) {
                  widget.parts.product.description = description;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      widget.descriptionError = true;
                    });
                    return;
                  } else {
                    setState(() {
                      widget.descriptionError = false;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(Language.getProductStrings("sections.main")),
                  padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.05),
                ), 
                IconButton(
                  icon:Icon(widget.isOpen ? Icons.remove : Icons.add),
                  onPressed: () {
                    widget.openedRow.notifyListeners();
                    widget.openedRow.value = 0;
                  },),
              ],
            ),
            onTap: (){
              widget.openedRow.notifyListeners();
              widget.openedRow.value = 0;
            },
          ),
        ),
        AnimatedContainer(
          color: Colors.white.withOpacity(0.05),
          height: widget.isOpen ? Measurements.height * 0.62 : 0,
          duration: Duration(milliseconds: 200),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
            color: Colors.black.withOpacity(0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            height: Measurements.height * 0.3,
                            child: !widget.haveImage
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          child: SvgPicture.asset(
                                        "images/insertimageicon.svg",
                                        height: Measurements.height * 0.1,
                                        color: Colors.white.withOpacity(0.7),
                                      )),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: Measurements.height * 0.05),
                                      ),
                                      Container(
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          child: Text(
                                            Language.getProductStrings("pictures.add_image"),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline
                                                    ),
                                          ),
                                          onTap: () {
                                            getImage();
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    height: Measurements.height * 0.3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          height: Measurements.height * 0.19,
                                          width: Measurements.width * 0.9,
                                          child: Image.network(
                                            Env.Storage +
                                                "/products/" +
                                                widget.currentImage,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Container(
                                          height: Measurements.height * 0.1,
                                          width: Measurements.width * 0.9,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                widget.parts.images.length + 1,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return index !=
                                                      widget.parts.images.length
                                                  ? Stack(
                                                    alignment: Alignment.topRight,
                                                    children:<Widget>[
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                          Measurements.width *
                                                              0.02),
                                                      child: InkWell(
                                                        child: Container(
                                                          height: Measurements
                                                                  .height *
                                                              0.07,
                                                          width: Measurements
                                                                  .height *
                                                              0.07,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: Image.network(
                                                            Env.Storage +
                                                                "/products/" +
                                                                widget.parts
                                                                        .images[
                                                                    index],
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            widget.currentImage =
                                                                widget.parts
                                                                        .images[
                                                                    index];
                                                          });
                                                        },
                                                      )),
                                                      InkWell(
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          height:Measurements.height * 0.03,
                                                          width:Measurements.height * 0.03,
                                                          decoration: BoxDecoration(color:Colors.black,shape: BoxShape.circle),
                                                          child: Icon(Icons.close,size:Measurements.height * 0.02,)),
                                                        onTap: () {
                                                          setState(() {
                                                            widget.parts.images.removeAt(index);
                                                            if(widget.parts.images.length==0){
                                                              widget.haveImage =false;
                                                            }
                                                          });
                                                        },),])
                                                  : Container(
                                                      padding: EdgeInsets.all(
                                                          Measurements.width *
                                                              0.02),
                                                      child: Container(
                                                          height: Measurements
                                                                  .height *
                                                              0.07,
                                                          width: Measurements
                                                                  .height *
                                                              0.07,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: InkWell(
                                                            child: Icon(
                                                              Icons.add,
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.7),
                                                            ),
                                                            onTap: () {
                                                              getImage();
                                                            },
                                                          )),
                                                    );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                        Container(
                          height: Measurements.height * 0.3,
                          child: widget.parts.mainForm,
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        //--
        Container(
            color: Colors.white.withOpacity(0.1),
            child: widget.isOpen
                ? Divider(
                    color: Colors.white.withOpacity(0),
                  )
                : Divider(
                    color: Colors.white,
                  )),
        //
      ],
    );
  }
}
// Inventory
class InventoryRow extends StatefulWidget {
  ValueNotifier openedRow;
  NewProductScreenParts parts;
  num inv = 0;
  
  bool isOpen = false;
  bool trackInv = false;

  bool get isInventoryRowOK {
    return parts.product.variants.length>0? 
     true:
     !parts.skuError;
  }

  InventoryRow({this.openedRow, this.parts});

  @override
  _InventoryRowState createState() => _InventoryRowState();
}

class _InventoryRowState extends State<InventoryRow> {
  listener() {
    setState(() {
      if (widget.openedRow.value == 1) {
        widget.isOpen = !widget.isOpen;
      } else {
        widget.isOpen = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.openedRow.addListener(listener);
    if(widget.parts.editMode){
      if(widget.parts.inventories.isNotEmpty){
        print(widget.parts.inventories);
        RestDatasource api = RestDatasource();
        api.getInvetory(widget.parts.business, GlobalUtils.ActiveToken.accessToken, widget.parts.product.sku,context).
          then((inv){
            var _inv = InventoryModel.toMap(inv);
            setState(() {
              widget.trackInv = _inv.isTrackable;
              widget.inv      = _inv.stock;
            });
          });}
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.parts.inventoryForm = ProductInventoryRow(parts: widget.parts);
    return Column(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
        ),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(Language.getProductStrings("sections.inventory")),
                padding:
                    EdgeInsets.symmetric(horizontal: Measurements.width * 0.05),
              ),
              IconButton(
                icon: Icon(widget.isOpen ? Icons.remove : Icons.add),
                onPressed: () {
                  widget.openedRow.notifyListeners();
                  widget.openedRow.value = 1;
                },
              )
            ],
          ),
          onTap: (){
              widget.openedRow.notifyListeners();
              widget.openedRow.value = 1;
            },
        ),
      ),
      AnimatedContainer(
        color: Colors.white.withOpacity(0.05),
        height: widget.isOpen
            ? Measurements.height * (widget.parts.isTablet ? 0.12 : 0.16)
            : 0,
        duration: Duration(milliseconds: 200),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
          color: Colors.black.withOpacity(0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: Measurements.height *
                            (widget.parts.isTablet ? 0.11 : 0.15),
                        child: widget.parts.inventoryForm,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      Container(
          color: Colors.white.withOpacity(0.1),
          child: widget.isOpen
              ? Divider(
                  color: Colors.white.withOpacity(0),
                )
              : Divider(
                  color: Colors.white,
                )),
    ]);
  }
}
//Inventory
//--------
//Category
class CategoryRow extends StatefulWidget {
  ValueNotifier openedRow;
  NewProductScreenParts parts;
  bool trackInv = false;
  bool isOpen = false;
  List<String> sugestions = List();
  String doc = "";
  String currentCat= "";

  CategoryRow({this.parts, this.openedRow});
  @override
  _CategoryRowState createState() => _CategoryRowState();
}

class _CategoryRowState extends State<CategoryRow> {
  listener() {
    setState(() {
      if (widget.openedRow.value == 2) {
        widget.isOpen = !widget.isOpen;
      } else {
        widget.isOpen = false;
      }
    });
  }
  String getCat;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.openedRow.addListener(listener);
    if(widget.parts.editMode){
      widget.parts.product.categories.forEach((f){
        widget.parts.categoryList.add(f.title);
      });
    }
    getCat= '''
     query getCategory{getCategories(businessUuid: "${widget.parts.business}", title: "", pageNumber: 1, paginationLimit: 1000) {
           _id    
           slug    
           title    
           businessUuid
          }
          }
        ''';
        widget.doc  = getCat;
  }

  @override
  Widget build(BuildContext context) {
    widget.parts.categoryForm = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: Measurements.width * 0.9,
          height: Measurements.height *(widget.parts.isTablet?0.05:0.07),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.parts.categoryList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.only(right: Measurements.width *0.015),
                child: Chip(
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  label:Text( widget.parts.categoryList[index]),
                  deleteIcon: Icon(Icons.close),
                  onDeleted: (){
                    setState((){
                      widget.parts.categoryList.removeAt(index);
                    });
                  },
                ),
              );
            },
          )
        ),
        GraphQLProvider(
          client:widget.parts.client,
          child: Query(
            key: widget.parts.qkey,
            options: QueryOptions(variables: <String, dynamic>{}, document: widget.doc),
            builder: (QueryResult result, {VoidCallback refetch}) {
              if(result.errors != null){
                print(result.errors);
                return Center(
                  child:  Text("Error loading"),
                );
              }
              if(result.loading){
                return Center(
                  child:CircularProgressIndicator(),
                );
              }
              widget.sugestions = List();
              if(result.data["createCategory"] != null){
                widget.parts.categories.add(Categories.toMap(result.data["createCategory"]));
                widget.doc = getCat;
              }
              if(result.data["getCategories"] != null ){
                result.data["getCategories"].forEach((a){
                  widget.parts.categories.add(Categories.toMap(a));
                  widget.sugestions.add(a["title"]);
                });
              }
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left:Measurements.width * 0.025),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16)
                ),
                width: Measurements.width * 0.9,
                height: Measurements.height *(widget.parts.isTablet?0.05:0.07),
                child:SimpleAutoCompleteTextField (
                  textSubmitted: (text){
                    setState(() {
                      bool contained = true;
                      widget.parts.categories.forEach((s){
                        if(s.title.toLowerCase().compareTo(text.toLowerCase()) == 0) contained =false;
                      });
                      if(contained){
                        print("NEW Category");
                        widget.doc = '''mutation createCategory {
                            createCategory(category: {businessUuid: "${widget.parts.business}", title: "$text"}) {
                                _id
                                businessUuid
                                title
                                slug
                              }
                            }''';
                            refetch();
                      }else{
                        print("OLD");
                      }
                      widget.parts.categoryList.add(text);
                    });
                    
                  },
                  suggestionsAmount: 5,
                  decoration: InputDecoration(
                    hintText: Language.getProductStrings("category.add_category"),
                    border: InputBorder.none,
                  ), 
                  key: widget.parts.atfKey,
                  suggestions: widget.sugestions, 
                ),
              );
            }, 
          ),
        ),
      ],
    );
    return Column(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
        ),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(Language.getProductStrings("sections.category")),
                padding:
                    EdgeInsets.symmetric(horizontal: Measurements.width * 0.05),
              ),
              IconButton(
                icon: Icon(widget.isOpen ? Icons.remove : Icons.add),
                onPressed: () {
                  widget.openedRow.notifyListeners();
                  widget.openedRow.value = 2;
                },
              )
            ],
          ),
          onTap: (){
              widget.openedRow.notifyListeners();
              widget.openedRow.value = 2;
            },
        ),
      ),
      AnimatedContainer(
        color: Colors.white.withOpacity(0.05),
        height: widget.isOpen ? Measurements.height * (widget.parts.isTablet?0.12:0.16) : 0,
        duration: Duration(milliseconds: 200),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
          color: Colors.black.withOpacity(0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: Measurements.height * (widget.parts.isTablet?0.1:0.14),
                        child: widget.parts.categoryForm,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      Container(
          color: Colors.white.withOpacity(0.1),
          child: widget.isOpen
              ? Divider(
                  color: Colors.white.withOpacity(0),
                )
              : Divider(
                  color: Colors.white,
                )),
    ]);
  }
}

//Category
//------
//Variant

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class VariantRow extends StatefulWidget {
  ValueNotifier openedRow;
  NewProductScreenParts parts;
  bool trackInv = false;
  bool isOpen = false;
  ValueNotifier quantity = ValueNotifier(0);
  VariantRow({this.parts, this.openedRow});

  @override
  _VariantRowState createState() => _VariantRowState();
}

class _VariantRowState extends State<VariantRow> {
  listener() {
    setState(() {
      if (widget.openedRow.value == 3) {
        widget.isOpen = !widget.isOpen;
      } else {
        widget.isOpen = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.openedRow.addListener(listener);
    widget.quantity.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    widget.parts.variantForm = Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: Measurements.width * 0.9,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics() ,
                shrinkWrap: true,
                itemCount: widget.parts.product.variants.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: Measurements.height* (widget.parts.isTablet?0.05:0.07),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(width: Measurements.width * 0.4 ,child: Text("${widget.parts.product.variants[index].title}",overflow: TextOverflow.ellipsis,)),
                            Container(width: Measurements.width * 0.18,child: Text("${widget.parts.product.variants[index].price} ${Measurements.currency(widget.parts.currency)}")),
                            Container(
                              width: Measurements.width * 0.2,
                              child: IconButton(icon: AutoSizeText(Language.getProductStrings("variantEditor.edit"),minFontSize: 11,maxLines: 1,) , onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child:VariantPopUp(
                                      parts: widget.parts,
                                      wallpaper: widget.parts.wallpaper,
                                      onEdit: true,
                                      editVariant: widget.parts.product.variants[index],
                                      index: index,
                                    ),
                                    type: PageTransitionType.downToUp,
                                  )
                                );
                              },splashColor: Colors.transparent),
                            ),
                            Container(
                              width: Measurements.width * 0.1,
                              child: IconButton(
                                icon: Icon(Icons.close),splashColor: Colors.transparent, 
                                onPressed: () {
                                  setState(() {
                                    widget.parts.product.variants.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              )
            ),
            Container(
              child: InkWell(
                splashColor: Colors.transparent,
                child: Container(
                    height: Measurements.height * 0.03,
                    child: Center(
                        child: Text(
                      Language.getProductStrings("variantEditor.add_variant")
                    ))),
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child:VariantPopUp(
                        parts: widget.parts,
                        wallpaper: widget.parts.wallpaper,
                        onEdit: false,
                        editVariant: Variants(),
                      ),
                      type:PageTransitionType.downToUp ,
                    )
                  );
                },
              ),
            )
          ]),
    );

    return Column(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
        ),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(Language.getProductStrings("sections.variants")),
                padding:
                    EdgeInsets.symmetric(horizontal: Measurements.width * 0.05),
              ),
              Container(
                child: Text("${widget.parts.product.variants.length} ${Language.getProductStrings("menu.common.sub.variants")}"),
              ),
              IconButton(
                icon: Icon(widget.isOpen ? Icons.remove : Icons.add),
                onPressed: () {
                  widget.openedRow.notifyListeners();
                  widget.openedRow.value = 3;
                },
              )
            ],
          ),
          onTap: (){
              widget.openedRow.notifyListeners();
              widget.openedRow.value = 3;
            },
        ),
      ),
      AnimatedContainer(
        color: Colors.white.withOpacity(0.05),
        height: widget.isOpen
            ? (Measurements.height * (widget.parts.isTablet ? 0.07 : 0.09) +
                (Measurements.height *
                    (widget.parts.isTablet ? 0.05 : 0.07) *
                    widget.parts.product.variants.length))
            : 0,
        duration: Duration(milliseconds: 200),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
          color: Colors.black.withOpacity(0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: Measurements.height *
                                (widget.parts.isTablet ? 0.05 : 0.07) +
                            (Measurements.height *
                                (widget.parts.isTablet ? 0.05 : 0.07) *
                                widget.parts.product.variants.length ),
                        child: widget.parts.variantForm,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      Container(
          color: Colors.white.withOpacity(0.1),
          child: widget.isOpen
              ? Divider(
                  color: Colors.white.withOpacity(0),
                )
              : Divider(
                  color: Colors.white,
                )),
    ]);
  }
}

//PopUp
class VariantPopUp extends StatefulWidget {

  NewProductScreenParts parts;
  InventoryModel _inventoryModel;
  String wallpaper;
  bool skuError = false;
  bool onSale = false;
  bool nameError = false;
  bool priceError = false;
  bool onSaleError = false;
  bool trackInv = false;
  var  inv = 0;
  var  originalStock;
  bool descriptionError = false;
  bool onEdit = false;
  int index;
  num amount;
  Variants editVariant;
  final fkey = GlobalKey<FormState>();
  final scKey = GlobalKey<ScaffoldState>();
  Variants currentVariant = Variants();

  List<String> variantImages = List();
  String currentImage;

  bool haveImage = false;

  VariantPopUp({@required this.parts, @required this.wallpaper,@required this.onEdit,@required this.editVariant,this.index}){
    print(" Variant title ${editVariant.title} => is Editing on? $onEdit");
    if(onEdit){
      variantImages = editVariant.images;
      currentVariant = editVariant; 
      haveImage = variantImages.isNotEmpty;
      if(haveImage)currentImage = variantImages[0];
    }
  }

  @override
  _VariantPopUpState createState() => _VariantPopUpState();
}

class _VariantPopUpState extends State<VariantPopUp> {

  @override
  initState(){
    //if(widget.parts.editMode)
    super.initState();
    RestDatasource api = RestDatasource();
    api.getInvetory(widget.parts.business, GlobalUtils.ActiveToken.accessToken, widget.currentVariant.sku,context).then((obj){
      InventoryModel inventory = InventoryModel.toMap(obj);
      widget._inventoryModel  = inventory;
      widget.inv              = inventory.stock;
      widget.originalStock    = inventory.stock;
      widget.trackInv         = inventory.isTrackable;
      setState(() {});
    });

  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image.existsSync())
      setState(() {
        RestDatasource api = RestDatasource();
        api
            .postImage(image, widget.parts.business,
                GlobalUtils.ActiveToken.accessToken)
            .then((dynamic res) {
          widget.variantImages.add(res["blobName"]);
          if (widget.currentImage == null) {
            widget.currentImage = res["blobName"];
          }
          setState(() {
            widget.haveImage = true;
          });
        }).catchError((onError) {
          setState(() {
            print(onError);
          });
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        widget.parts.isPortrait = orientation == Orientation.portrait;
        widget.parts.isTablet = widget.parts.isPortrait
            ? MediaQuery.of(context).size.width > 600
            : MediaQuery.of(context).size.height > 600;
        return Stack(
          children: <Widget>[
            Positioned(
              height: widget.parts.isPortrait
                  ? Measurements.height
                  : Measurements.width,
              width: widget.parts.isPortrait
                  ? Measurements.width
                  : Measurements.height,
              child: CachedNetworkImage(
                imageUrl: widget.wallpaper,
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            Container(
                color: Colors.black.withOpacity(0.2),
                height: widget.parts.isPortrait
                    ? Measurements.height
                    : Measurements.width,
                width: widget.parts.isPortrait
                    ? Measurements.width
                    : Measurements.height,
                child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 25,
                      sigmaY: 40,
                    ),
                    child: Container(
                      height: widget.parts.isPortrait
                          ? Measurements.height
                          : Measurements.width,
                      width: widget.parts.isPortrait
                          ? Measurements.width
                          : Measurements.height,
                      child: Scaffold(
                        key: widget.scKey,
                          backgroundColor: Colors.transparent,
                          appBar: AppBar(
                            title: Text(!widget.onEdit?Language.getProductStrings("variantEditor.title"):Language.getProductStrings("variantEditor.edit_variant")),
                            centerTitle: true,
                            leading:IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.pop(context);
                              },) ,
                            actions: <Widget>[
                              InkWell(
                                // sav PopUp
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(right: Measurements.width * 0.02),
                                  child: Text(Language.getProductStrings("save"))),
                                onTap:() {
                                  widget.fkey.currentState.validate();
                                  if(!(widget.priceError || widget.skuError || widget.descriptionError || widget.nameError) && !(widget.onSale && widget.onSaleError)){
                                    widget.fkey.currentState.save();
                                    if(!widget.onEdit){
                                      RestDatasource api = RestDatasource();
                                      api.checkSKU(widget.parts.business, GlobalUtils.ActiveToken.accessToken, widget.currentVariant.sku).then((onValue){
                                        widget.skuError = true;
                                        widget.scKey.currentState.showSnackBar(SnackBar(content: Text("Sku already exist"),));
                                      }).catchError((onError){
                                        print(onError);
                                        widget.currentVariant.images = widget.variantImages;
                                        widget.parts.product.variants.add(widget.currentVariant);
                                        print("inventory Stock ${widget.amount}");
                                        widget.parts.invManager.addInventory(Inventory(newAmount: widget.amount, barcode: widget.currentVariant.barcode, sku: widget.currentVariant.sku, tracking: widget.trackInv));   
                                        Navigator.pop(context);
                                      });
                                    }else{
                                      print("ON_EDIT_MODE");
                                      print("${widget.currentVariant.sku}");
                                      widget.parts.invManager.addInventory(Inventory(amount: widget.originalStock,newAmount: widget.amount, barcode: widget.currentVariant.barcode, sku: widget.currentVariant.sku, tracking: widget.trackInv));
                                      
                                      widget.currentVariant.images = widget.variantImages;
                                      widget.parts.product.variants.removeAt(widget.index);
                                      widget.parts.product.variants.insert(widget.index, widget.currentVariant);
                                      Navigator.pop(context);
                                    } 
                                  }
                                },
                              )
                            ],
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                          body: ListView(
                            children: <Widget>[
                              Container(
                                width: Measurements.width *0.9,
                                  height: Measurements.height * 0.4,
                                  child: !widget.haveImage
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                                child: SvgPicture.asset(
                                              "images/insertimageicon.svg",
                                              height: Measurements.height * 0.1,
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                            )),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: Measurements.height *
                                                      0.05),
                                            ),
                                            Container(
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                child: Text(
                                                  Language.getProductStrings("pictures.add_image"),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration: TextDecoration
                                                          .underline),
                                                ),
                                                onTap: () {
                                                  getImage();
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          height: Measurements.height * 0.4,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                height:
                                                    Measurements.height * 0.29,
                                                width:
                                                    Measurements.width * 0.75,
                                                child: Image.network(
                                                  Env.Storage +
                                                      "/products/" +
                                                      widget.currentImage,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              Container(
                                                height:
                                                    Measurements.height * 0.1,
                                                width:
                                                    Measurements.width * 0.75,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: widget
                                                          .variantImages
                                                          .length +
                                                      1,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return index !=
                                                            widget.variantImages
                                                                .length
                                                        ? Stack(
                                                          alignment: Alignment.topRight,
                                                          children:<Widget>[Container(
                                                            padding: EdgeInsets
                                                                .all(Measurements
                                                                        .width *
                                                                    0.02),
                                                            child: InkWell(
                                                              child: Container(
                                                                height: Measurements
                                                                        .height *
                                                                    0.07,
                                                                width: Measurements
                                                                        .height *
                                                                    0.07,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                child: Image
                                                                    .network(
                                                                  Env.Storage +
                                                                      "/products/" +
                                                                      widget.variantImages[
                                                                          index],
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                setState(() {
                                                                  widget.currentImage =
                                                                      widget.variantImages[
                                                                          index];
                                                                });
                                                              },
                                                            )),
                                                            InkWell(
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                height:Measurements.height * 0.03,
                                                                width:Measurements.height * 0.03,
                                                                decoration: BoxDecoration(color:Colors.black,shape: BoxShape.circle),
                                                                child: Icon(Icons.close,size:Measurements.height * 0.02,)),
                                                              onTap: () {
                                                                setState(() {
                                                                  widget.variantImages.removeAt(index);
                                                                  if( widget.variantImages.length==0){
                                                                    widget.haveImage = false;
                                                                  }
                                                                });
                                                              },
                                                            )
                                                            ]
                                                          )
                                                        : Container(
                                                            padding: EdgeInsets
                                                                .all(Measurements
                                                                        .width *
                                                                    0.02),
                                                            child: Container(
                                                                height: Measurements
                                                                        .height *
                                                                    0.07,
                                                                width: Measurements
                                                                        .height *
                                                                    0.07,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                child: InkWell(
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.7),
                                                                  ),
                                                                  onTap: () {
                                                                    getImage();
                                                                  },
                                                                )),
                                                          );
                                                  },
                                                ),
                                              ),
                                              
                                            ],
                                          ),
                                        )),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Measurements.width * 0.05),
                                child: Form(
                                  key: widget.fkey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      Measurements.width *
                                                          0.025),
                                              decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.05),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  16))),
                                              width: Measurements.width * 0.5475,
                                              height: Measurements.height *
                                                  (widget.parts.isTablet
                                                      ? 0.05
                                                      : 0.07),
                                              child: TextFormField(
                                                style: TextStyle(fontSize: Measurements.height * 0.02),
                                                initialValue: widget.onEdit?widget.currentVariant.title:"",
                                                inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]"))],
                                                decoration: InputDecoration(
                                                  hintText: Language.getProductStrings("variantEditor.placeholders.name"),
                                                  hintStyle: TextStyle(
                                                      color: widget.nameError
                                                          ? Colors.red
                                                          : Colors.white
                                                              .withOpacity(
                                                                  0.5)),
                                                  border: InputBorder.none,
                                                ),
                                                onSaved: (name) {
                                                  widget.currentVariant.title =
                                                      name;
                                                  widget.currentVariant.hidden =
                                                      !widget.onSale;
                                                },
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    setState(() {
                                                      widget.nameError = true;
                                                    });
                                                    return;
                                                  } else {
                                                    setState(() {
                                                      widget.nameError = false;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Measurements
                                                            .width *
                                                        0.025),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.05),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    16))),
                                                width: Measurements.width * 0.3475,
                                                height: Measurements.height *
                                                    (widget.parts.isTablet
                                                        ? 0.05
                                                        : 0.07),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Container(child: AutoSizeText(Language.getProductStrings("price.sale"),style: TextStyle(fontSize: Measurements.height * 0.02))),
                                                    Switch(
                                                      activeColor: widget.parts.switchColor,
                                                      value: widget.onSale,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          widget.onSale = value;
                                                        });
                                                      },
                                                    )
                                                  ],
                                                )),
                                          ],
                                        ),
                                        width: Measurements.width *0.9,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: Measurements.width * 0.005),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      Measurements.width *
                                                          0.025),
                                              alignment: Alignment.center,
                                              color: Colors.white
                                                  .withOpacity(0.05),
                                              width:
                                                  Measurements.width * 0.4475,
                                              height: Measurements.height *
                                                  (widget.parts.isTablet
                                                      ? 0.05
                                                      : 0.07),
                                              child: TextFormField(
                                                style: TextStyle(fontSize: Measurements.height * 0.02),
                                                initialValue: widget.onEdit?widget.currentVariant.price.toString():"",
                                                decoration: InputDecoration(
                                                  hintText: Language.getProductStrings("variantEditor.placeholders.price"),
                                                  hintStyle: TextStyle(
                                                      color: widget.priceError
                                                          ? Colors.red
                                                          : Colors.white
                                                              .withOpacity(
                                                                  0.5)),
                                                  border: InputBorder.none,
                                                ),
                                                inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
                                                keyboardType:
                                                    TextInputType.number,
                                                onSaved: (price) {
                                                  widget.currentVariant.price =
                                                      num.parse(price);
                                                },
                                                validator: (value) {
                                                  if (value.isEmpty || num.parse(value) >= 1000000) {
                                                    setState(() {
                                                      widget.priceError = true;
                                                    });
                                                    return;
                                                  } else if(value.split(".").length>2){
                                                    setState(() {
                                                      widget.priceError = true;
                                                    });
                                                  }else {
                                                    setState(() {
                                                      widget.priceError = false;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      Measurements.width *
                                                          0.025),
                                              alignment: Alignment.center,
                                              color: Colors.white
                                                  .withOpacity(0.05),
                                              width:
                                                  Measurements.width * 0.4475,
                                              height: Measurements.height *
                                                  (widget.parts.isTablet
                                                      ? 0.05
                                                      : 0.07),
                                              child: TextFormField(
                                                style: TextStyle(fontSize: Measurements.height * 0.02),
                                                inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
                                                keyboardType: TextInputType.number,
                                                initialValue: widget.onEdit && widget.currentVariant.salePrice != null ?widget.currentVariant.salePrice.toString():"",
                                                decoration: InputDecoration(
                                                  hintText:
                                                      Language.getProductStrings("variantEditor.placeholders.sale_price"),
                                                  border: InputBorder.none,
                                                  hintStyle: TextStyle(
                                                      color: (widget.onSale &&
                                                              widget
                                                                  .onSaleError)
                                                          ? Colors.red
                                                          : Colors.white
                                                              .withOpacity(
                                                                  0.5)),
                                                ),
                                                onSaved: (saleprice) {
                                                  widget.currentVariant
                                                      .salePrice = saleprice
                                                          .isEmpty
                                                      ? null
                                                      : num.parse(saleprice);
                                                },
                                                validator: (value) {
                                                  if (widget.onSale) {
                                                    if (value.isEmpty) {
                                                      setState(() {
                                                        widget.onSaleError =
                                                            true;
                                                      });
                                                      return;
                                                    } else if(value.split(".").length>2){
                                                      setState(() {
                                                        widget.onSaleError = true;
                                                      });
                                                    }else {
                                                      setState(() {
                                                        widget.onSaleError =
                                                            false;
                                                      });
                                                    }
                                                  }
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                        width: Measurements.width *0.9,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: Measurements.width * 0.005),
                                      ),
                                      Container(
                                        width: Measurements.width *0.9,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      Measurements.width *
                                                          0.025),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.05),
                                              ),
                                              width:
                                                  Measurements.width * 0.4475,
                                              height: Measurements.height *
                                                  (widget.parts.isTablet
                                                      ? 0.05
                                                      : 0.07),
                                              child: TextFormField(
                                                style: TextStyle(fontSize: Measurements.height * 0.02),
                                                onSaved: (sku) {
                                                  widget.currentVariant.sku =
                                                      sku;
                                                },
                                                validator: (sku) {
                                                  if (sku.isEmpty) {
                                                    setState(() {
                                                      widget.skuError = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      widget.skuError = false;
                                                    });
                                                  }
                                                },
                                                
                                                initialValue: widget.onEdit?widget.currentVariant.sku:"",
                                                inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]"))],
                                                decoration: InputDecoration(
                                                  hintText: Language.getProductStrings("variantEditor.placeholders.sku"),
                                                  border: InputBorder.none,
                                                  hintStyle: TextStyle(
                                                      color: widget.skuError
                                                          ? Colors.red
                                                          : Colors.white
                                                              .withOpacity(
                                                                  0.5)),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      Measurements.width *
                                                          0.025),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.05),
                                              ),
                                              width:
                                                  Measurements.width * 0.4475,
                                              height: Measurements.height *
                                                  (widget.parts.isTablet
                                                      ? 0.05
                                                      : 0.07),
                                              child: TextFormField(
                                                style: TextStyle(fontSize: Measurements.height * 0.02),
                                                onSaved: (bar) {
                                                  widget.currentVariant.barcode =
                                                      bar;
                                                },
                                                initialValue: widget.onEdit?widget.currentVariant.barcode:"",
                                                inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]"))],
                                                decoration: InputDecoration(
                                                  hintText: Language.getProductStrings("variantEditor.placeholders.barcode"),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: Measurements.width * 0.005),
                                      ),
                                      Container(
                                        width: Measurements.width *0.9,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Measurements.width *
                                                            0.025),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.05),
                                                ),
                                                width:
                                                    Measurements.width * 0.565,
                                                height: Measurements.height *
                                                    (widget.parts.isTablet
                                                        ? 0.05
                                                        : 0.07),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Switch(
                                                      activeColor: widget.parts.switchColor,
                                                      value: widget.trackInv,
                                                      onChanged: (bool value) {
                                                        setState(() {
                                                          widget.trackInv =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        Language.getProductStrings("info.placeholders.inventoryTrackingEnabled"),minFontSize: 12,maxLines: 1,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.05),
                                              ),
                                              width: Measurements.width * 0.33,
                                              height: Measurements.height *
                                                  (widget.parts.isTablet
                                                      ? 0.05
                                                      : 0.07),
                                              child: TextFormField(
                                                style: TextStyle(fontSize: Measurements.height * 0.02),
                                                inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
                                                onFieldSubmitted: (qtt){
                                                  widget.inv = num.parse(qtt??0);
                                                },
                                                onSaved: (value) {
                                                  print("value =  $value");
                                                  widget.amount = num.parse(value);
                                                },
                                                textAlign: TextAlign.center,
                                                controller:
                                                    TextEditingController(
                                                  text: "${widget.inv}",
                                                ),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  prefixIcon: IconButton(
                                                    icon: Icon(Icons.remove),
                                                    onPressed: () {
                                                      setState(() {
                                                        if (widget.inv > 0)
                                                          widget.inv--;
                                                      });
                                                    },
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(Icons.add),
                                                    onPressed: () {
                                                      setState(() {
                                                        widget.inv++;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: Measurements.width * 0.005),
                                      ),
                                      Container(
                                        width: Measurements.width *0.9,
                                        height: Measurements.height * 0.2,
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Measurements.width * 0.025),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.05),
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(16),
                                                bottomLeft:
                                                    Radius.circular(16))),
                                        child: TextFormField(
                                          style: TextStyle(fontSize: Measurements.height * 0.02),
                                          inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]"))],
                                          initialValue: widget.onEdit?widget.currentVariant.description:"",
                                          maxLines: 100,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelStyle: TextStyle(
                                                  color: widget.descriptionError
                                                      ? Colors.red
                                                      : Colors.white
                                                          .withOpacity(0.5)),
                                              labelText: Language.getProductStrings("variantEditor.placeholders.description")),
                                          onSaved: (description) {
                                            widget.currentVariant.description =
                                                description;
                                          },
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              setState(() {
                                                widget.descriptionError = true;
                                              });
                                              return;
                                            } else {
                                              setState(() {
                                                widget.descriptionError = false;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    )))
          ],
        );
      },
    );
  }
}

//Variant
//-------
//Shipping

class ShippingRow extends StatefulWidget {
  ValueNotifier openedRow;
  NewProductScreenParts parts;
  bool isOpen = false;

  bool freeShipping = false;
  bool generalShipping = false;

  bool weightError = false;
  bool widthError = false;
  bool lenghtError = false;
  bool heightError = false;

  get isShippingRowOK {
    
    return !(weightError || widthError || lenghtError || heightError);
  }

  ShippingRow({@required this.parts, @required this.openedRow});

  @override
  _ShippingRowState createState() => _ShippingRowState();
}

class _ShippingRowState extends State<ShippingRow> {
  List<Widget> wlh;
  listener() {
    setState(() {
      if (widget.openedRow.value == 5) {
        widget.isOpen = !widget.isOpen;
      } else {
        widget.isOpen = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.openedRow.addListener(listener);
    if(widget.parts.editMode){
      widget.freeShipping    = widget.parts.product.shipping.free??false;
      widget.generalShipping = widget.parts.product.shipping.general??false;
    }
  }

  @override
  Widget build(BuildContext context) {
    wlh = List();
    wlh = <Widget>[
      Container(
        padding: EdgeInsets.only(left: Measurements.width * 0.025),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(widget.parts.isTablet ? 16 : 0)),
          color: Colors.white.withOpacity(0.05),
        ),
        width: Measurements.width * (widget.parts.isTablet ? 0.2966 : 0.9),
        height: Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
        child: TextFormField(
          style: TextStyle(fontSize: Measurements.height * 0.02),
          validator: (value) {
            if (value.isEmpty) {
              setState(() {
                widget.widthError = true;
              });
            } else if(value.split(".").length>2){
                setState(() {
                  widget.widthError = true;
                });
              }else {
              setState(() {
                widget.widthError = false;
              });
            }
          },
          onSaved: (value) {
            widget.parts.product.shipping.width = num.parse(value);
          },
          initialValue: widget.parts.editMode?widget.parts.product.shipping.width.toString():"",
          inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
          decoration: InputDecoration(
            hintText: Language.getProductStrings("shipping.placeholders.width"),
            border: InputBorder.none,
            hintStyle: TextStyle(
                color: widget.widthError
                    ? Colors.red
                    : Colors.white.withOpacity(0.5)),
            suffixIcon: Container(
              color: Colors.white.withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(Language.getProductStrings("shippingSection.measure.cm"),
                      style: TextStyle(color: Colors.white.withOpacity(0.6))),
                ],
              ),
            ),
          ),
          keyboardType:
              TextInputType.number,
        ),
      ),
      widget.parts.isTablet
          ? Container()
          : Padding(
              padding: EdgeInsets.only(top: Measurements.width * 0.005),
            ),
      Container(
        padding: EdgeInsets.only(left: Measurements.width * 0.025),
        alignment: Alignment.center,
        color: Colors.white.withOpacity(0.05),
        width: Measurements.width * (widget.parts.isTablet ? 0.2966 : 0.9),
        height: Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
        child: TextFormField(
          style: TextStyle(fontSize: Measurements.height * 0.02),
          validator: (value) {
            if (value.isEmpty) {
              setState(() {
                widget.lenghtError = true;
              });
            } else if(value.split(".").length>2){
                setState(() {
                  widget.lenghtError = true;
                });
              }else {
              setState(() {
                widget.lenghtError = false;
              });
            }
          },
          onSaved: (value) {
            widget.parts.product.shipping.length = num.parse(value);
          },
          keyboardType: TextInputType.number,
          inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
          initialValue: widget.parts.editMode?widget.parts.product.shipping.length.toString():"",
          decoration: InputDecoration(
            hintText: Language.getProductStrings("shipping.placeholders.length"),
            hintStyle: TextStyle(
                color: widget.lenghtError
                    ? Colors.red
                    : Colors.white.withOpacity(0.5)),
            border: InputBorder.none,
            suffixIcon: Container(
              color: Colors.white.withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(Language.getProductStrings("shippingSection.measure.cm"),
                      style: TextStyle(color: Colors.white.withOpacity(0.6))),
                ],
              ),
            ),
          ),
        ),
      ),
      widget.parts.isTablet
          ? Container()
          : Padding(
              padding: EdgeInsets.only(top: Measurements.width * 0.005),
            ),
      Container(
        padding: EdgeInsets.only(left: Measurements.width * 0.025),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(widget.parts.isTablet ? 0 : 16)),
          color: Colors.white.withOpacity(0.05),
        ),
        width: Measurements.width * (widget.parts.isTablet ? 0.2966 : 0.9),
        height: Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
        child: TextFormField(
          style: TextStyle(fontSize: Measurements.height * 0.02),
          validator: (value) {
            if (value.isEmpty) {
              setState(() {
                widget.heightError = true;
              });
            } else if(value.split(".").length>2){
                setState(() {
                  widget.heightError = true;
                });
              }else {
              setState(() {
                widget.heightError = false;
              });
            }
          },
          onSaved: (value) {
            widget.parts.product.shipping.height = num.parse(value);
          },
          keyboardType: TextInputType.number,
          inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
          initialValue: widget.parts.editMode?widget.parts.product.shipping.height.toString():"",
          decoration: InputDecoration(
            hintText:  Language.getProductStrings("shipping.placeholders.height"),
            hintStyle: TextStyle(
                color: widget.heightError
                    ? Colors.red
                    : Colors.white.withOpacity(0.5)),
            border: InputBorder.none,
            suffixIcon: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(16)),
                color: Colors.white.withOpacity(0.1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(Language.getProductStrings("shippingSection.measure.cm"),
                      style: TextStyle(color: Colors.white.withOpacity(0.6))),
                ],
              ),
            ),
          ),
        ),
      )
    ];

    widget.parts.shippingForm = Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: Measurements.width * 0.9,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                width: Measurements.width * 0.9,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Measurements.width * 0.025),
                        alignment: Alignment.center,
                        height: Measurements.height *
                            (widget.parts.isTablet ? 0.05 : 0.07),
                        child: Text(Language.getProductStrings("shippingSection.form.free.label"),style: TextStyle(fontSize: Measurements.height * 0.02),)),
                    Switch(
                      activeColor: widget.parts.switchColor,
                      value: widget.freeShipping,
                      onChanged: (bool value) {
                        setState(() {
                          widget.freeShipping = value;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Measurements.width * 0.005),
            ),
            Container(
              width: Measurements.width * 0.9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                ),
                width: Measurements.width * 0.9,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Measurements.width * 0.025),
                        alignment: Alignment.center,
                        height: Measurements.height *
                            (widget.parts.isTablet ? 0.05 : 0.07),
                        child: Text(Language.getProductStrings("shippingSection.form.general.label"),style: TextStyle(fontSize: Measurements.height * 0.02),)),
                    Switch(
                      activeColor: widget.parts.switchColor,
                      value: widget.generalShipping,
                      onChanged: (bool value) {
                        setState(() {
                          widget.generalShipping = value;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Measurements.width * 0.005),
            ),
            Container(
              width: Measurements.width * 0.9,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: Measurements.width * 0.025),
                    alignment: Alignment.center,
                    color: Colors.white.withOpacity(0.05),
                    width: Measurements.width * 0.9,
                    height: Measurements.height *
                        (widget.parts.isTablet ? 0.05 : 0.07),
                    child: TextFormField(
                      style: TextStyle(fontSize: Measurements.height * 0.02),
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            widget.weightError = true;
                          });
                        } else if(value.split(".").length>2){
                            setState(() {
                              widget.weightError = true;
                            });
                          }else {
                          setState(() {
                            widget.weightError = false;
                          });
                        }
                      },
                      onSaved: (value) {
                        widget.parts.product.shipping.weight = num.parse(value);
                        widget.parts.product.shipping.free =
                            widget.freeShipping;
                        widget.parts.product.shipping.general =
                            widget.generalShipping;
                      },

                      inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
                      initialValue: widget.parts.editMode?widget.parts.product.shipping.weight.toString():"",
                      decoration: InputDecoration(
                        hintText: Language.getProductStrings("shippingSection.form.weight.label"),
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: widget.weightError
                                ? Colors.red
                                : Colors.white.withOpacity(0.5)),
                        suffixIcon: Container(
                          color: Colors.white.withOpacity(0.1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(Language.getProductStrings("shippingSection.measure.kg"),
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.6))),
                            ],
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Measurements.width * 0.005),
            ),
            Container(
              width: Measurements.width * 0.9,
              child: widget.parts.isTablet
                  ? Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: wlh,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: wlh,
                    ),
            ),
          ]),
    );
    return Column(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
        ),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(Language.getProductStrings("sections.shipping")),
                padding:
                    EdgeInsets.symmetric(horizontal: Measurements.width * 0.05),
              ),
              IconButton(
                icon: Icon(widget.isOpen ? Icons.remove : Icons.add),
                onPressed: () {
                  widget.openedRow.notifyListeners();
                  widget.openedRow.value = 5;
                },
              )
            ],
          ),
          onTap: (){
              widget.openedRow.notifyListeners();
              widget.openedRow.value = 5;
            },
        ),
      ),
      AnimatedContainer(
        color: Colors.white.withOpacity(0.05),
        height: widget.isOpen
            ? Measurements.height * (widget.parts.isTablet ? 0.25 : 0.50)
            : 0,
        duration: Duration(milliseconds: 200),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
          color: Colors.black.withOpacity(0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: Measurements.height *
                            (widget.parts.isTablet ? 0.22 : 0.45),
                        child: widget.parts.shippingForm,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      Container(
          color: Colors.white.withOpacity(0.1),
          child: widget.isOpen
              ? Divider(
                  color: Colors.white.withOpacity(0),
                )
              : Divider(
                  color: Colors.white,
                )),
    ]);
  }
}

class TaxRow extends StatefulWidget {
  ValueNotifier openedRow;
  NewProductScreenParts parts;
  bool isOpen = false;

  bool freeShipping = false;
  bool generalShipping = false;

  TaxRow({@required this.parts, @required this.openedRow});

  @override
  _TaxRowState createState() => _TaxRowState();
}

class _TaxRowState extends State<TaxRow> {
  listener() {
    setState(() {
      if (widget.openedRow.value == 6) {
        widget.isOpen = !widget.isOpen;
      } else {
        widget.isOpen = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.openedRow.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    widget.parts.taxForm = Container(
      width: Measurements.width * 0.9,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        width: Measurements.width * 0.9,
        child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
            alignment: Alignment.center,
            height: Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
            child: PopupMenuButton(
              padding: EdgeInsets.zero,
              child: ListTile(
                title: const Text('Default taxes apply'),
              ),
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[],
            )),
      ),
    );
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
          ),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(Language.getProductStrings("sections.taxes")),
                  padding:
                      EdgeInsets.symmetric(horizontal: Measurements.width * 0.05),
                ),
                IconButton(
                  icon: Icon(widget.isOpen ? Icons.remove : Icons.add),
                  onPressed: () {
                    widget.openedRow.notifyListeners();
                    widget.openedRow.value = 6;
                  },
                )
              ],
            ),
            onTap: (){
              widget.openedRow.notifyListeners();
              widget.openedRow.value = 6;
            },
          ),
        ),
        AnimatedContainer(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
          ),
          height: widget.isOpen
              ? Measurements.height * (widget.parts.isTablet ? 0.07 : 0.09)
              : 0,
          duration: Duration(milliseconds: 200),
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
            color: Colors.black.withOpacity(0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: Measurements.height *
                              (widget.parts.isTablet ? 0.05 : 0.07),
                          child: widget.parts.taxForm,
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
            color: Colors.white.withOpacity(0.1),
            child: widget.isOpen
                ? Divider(
                    color: Colors.white.withOpacity(0),
                  )
                : Divider(
                    color: Colors.white,
                  )),
      ],
    );
  }
}

class VisibilityRow extends StatefulWidget {
  ValueNotifier openedRow;
  NewProductScreenParts parts;
  bool isOpen = false;
  bool enabled = false;

  VisibilityRow({@required this.parts, @required this.openedRow});

  @override
  _VisibilityRowState createState() => _VisibilityRowState();
}

class _VisibilityRowState extends State<VisibilityRow> {
  listener() {
    setState(() {
      if (widget.openedRow.value == 7) {
        widget.isOpen = !widget.isOpen;
      } else {
        widget.isOpen = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.openedRow.addListener(listener);
    if(widget.parts.editMode){
      widget.enabled = widget.parts.product.enabled??true;
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.parts.visibilityForm = Container(
      width: Measurements.width * 0.9,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        width: Measurements.width * 0.9,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Measurements.width * 0.025),
                alignment: Alignment.center,
                height:
                    Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
                child: Text("Show this product")),
            Switch(
              activeColor: widget.parts.switchColor,
              value: widget.parts.enabled,
              onChanged: (bool value) {
                setState(() {
                  widget.parts.enabled = value;
                });
              },
            )
          ],
        ),
      ),
    );
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(widget.isOpen ? 0 : 16),
                  bottomRight: Radius.circular(widget.isOpen ? 0 : 16))),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(Language.getProductStrings("sections.visibility")),
                  padding:
                      EdgeInsets.symmetric(horizontal: Measurements.width * 0.05),
                ),
                IconButton(
                  icon: Icon(widget.isOpen ? Icons.remove : Icons.add),
                  onPressed: () {
                    widget.openedRow.notifyListeners();
                    widget.openedRow.value = 7;
                  },
                )
              ],
            ),
            onTap: (){
              widget.openedRow.notifyListeners();
              widget.openedRow.value = 7;
            },
          ),
        ),
        AnimatedContainer(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(widget.isOpen ? 16 : 0),
                  bottomRight: Radius.circular(widget.isOpen ? 16 : 0))),
          height: widget.isOpen
              ? Measurements.height * (widget.parts.isTablet ? 0.07 : 0.09)
              : 0,
          duration: Duration(milliseconds: 200),
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
            color: Colors.black.withOpacity(0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: Measurements.height *
                              (widget.parts.isTablet ? 0.05 : 0.07),
                          child: widget.parts.visibilityForm,
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}


class ChannelRow extends StatefulWidget {
  ValueNotifier openedRow;
  NewProductScreenParts parts;
  bool isOpen = false;
  num size = 0;
  ChannelRow({@required this.openedRow,@required this.parts});

  @override
  _ChannelRowState createState() => _ChannelRowState();
}

class _ChannelRowState extends State<ChannelRow> {

  listener() {
    setState(() {
      if (widget.openedRow.value == 4) {
        widget.isOpen = !widget.isOpen;
      } else {
        widget.isOpen = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.openedRow.addListener(listener);
    RestDatasource api = RestDatasource();
    api.getTerminal(widget.parts.business, GlobalUtils.ActiveToken.accessToken,context).then((terminals){
      terminals.forEach((term){
        widget.parts.terminals.add(Terminal.toMap(term));
      });
      widget.size += terminals.length;
      setState(() {
        widget.parts.havePOS = terminals.isNotEmpty;
      });
    }).catchError((onError){
      print(onError);
    });
    api.getShop(widget.parts.business, GlobalUtils.ActiveToken.accessToken,context).then((shops){
      
      shops.forEach((shop){
        widget.parts.shops.add(Shop.toMap(shop));
      });
      widget.size += shops.length;
      setState(() {
        widget.parts.haveShop = shops.isNotEmpty;
      });
    }).catchError((onError){
      print(onError);
    });
                    
  }
  @override
  Widget build(BuildContext context) {

    widget.parts.channelForm = Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //POS
            widget.parts.havePOS? Container(
              height: Measurements.height* (widget.parts.isTablet?0.05:0.07),
              width: Measurements.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SvgPicture.asset("images/posicon.svg", height: Measurements.height  * (widget.parts.isTablet?0.02:0.025),),
                  Padding(padding: EdgeInsets.only(right: Measurements.width * 0.02),),
                  Text(Language.getWidgetStrings("widgets.pos.title"))
                ],)
              ,)
              :Container(),
            widget.parts.havePOS? Container(
              width: Measurements.width * 0.8,
              child: Center(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics() ,
                  shrinkWrap: true,
                  itemCount: widget.parts.terminals.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool channelEnabled = false;
                    widget.parts.channels.forEach((ch){
                      if(ch.id == widget.parts.terminals[index].channelSet ) channelEnabled=true;
                    }); 
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.only(
                              bottomLeft:  Radius.circular(index == (widget.parts.terminals.length-1)? 16 : 0),
                              bottomRight: Radius.circular(index == (widget.parts.terminals.length-1)? 16 : 0),
                              topLeft: Radius.circular(index==0 ? 16 : 0),
                              topRight: Radius.circular(index==0 ? 16 : 0)
                            ),
                          ),
                          height: Measurements.height* (widget.parts.isTablet?0.05:0.07),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(widget.parts.terminals[index].name),
                              Switch(
                                activeColor: widget.parts.switchColor,
                                value: channelEnabled,
                                onChanged: (bool value) {
                                  var term =widget.parts.terminals[index];
                                  if(value){
                                    widget.parts.channels.add(ChannelSet(term.channelSet,term.name,GlobalUtils.CHANNEL_POS));
                                  }else{
                                    widget.parts.channels.removeWhere((ch) => term.channelSet == ch.id);
                                  }
                                  setState(() {
                                    channelEnabled = value;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: Measurements.width * 0.005),
                        ),
                      ],
                    );
                  },
                ),
              )
            ):Container(),
            //-----
            //SHOP
            widget.parts.haveShop? Container(
              height: Measurements.height* (widget.parts.isTablet?0.05:0.07),
              width: Measurements.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SvgPicture.asset("images/shopicon.svg", height: Measurements.height  * (widget.parts.isTablet?0.02:0.025),),
                  Padding(padding: EdgeInsets.only(right: Measurements.width * 0.02),),
                  Text(Language.getWidgetStrings("widgets.store.title"))
                ],)
              ,)
              :Container(),
            widget.parts.haveShop? Container(
              width: Measurements.width * 0.8,
              child: Center(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics() ,
                  shrinkWrap: true,
                  itemCount: widget.parts.shops.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool shopEnabled = false;
                    widget.parts.channels.forEach((ch){
                      
                      if(ch.id == widget.parts.shops[index].channelSet ) shopEnabled=true;
                    });
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.only(
                              bottomLeft:  Radius.circular(index == (widget.parts.shops.length-1)? 16 : 0),
                              bottomRight: Radius.circular(index == (widget.parts.shops.length-1)? 16 : 0),
                              topLeft: Radius.circular( index==0 ? 16 : 0),
                              topRight: Radius.circular(index==0 ? 16 : 0)
                            ),
                          ),
                          height: Measurements.height* (widget.parts.isTablet?0.05:0.07),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(widget.parts.shops[index].name),
                              Switch(
                                activeColor: widget.parts.switchColor,
                                value: shopEnabled,
                                onChanged: (bool value) {
                                  print("ONCHANGED");
                                  var shop =widget.parts.shops[index];
                                  if(value){
                                    widget.parts.channels.add(ChannelSet(shop.channelSet,shop.name,GlobalUtils.CHANNEL_SHOP));
                                  }else{
                                    widget.parts.channels.removeWhere((ch) => shop.channelSet == ch.id);
                                  }
                                  setState(() {
                                    shopEnabled = value;
                                  });
                                  
                                  
                                },
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: Measurements.width * 0.005),
                        ),
                      ],
                    );
                  },
                ),
              )
            ):Container(),
          ]),
    );
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
          ),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(Language.getProductStrings("sections.channels")),
                  padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.05),
                ),
                Row(
                  children: <Widget>[
                  widget.parts.havePOS?  Container(padding: EdgeInsets.only(right: Measurements.width * (0.02)) ,child:SvgPicture.asset("images/posicon.svg" ,height: Measurements.height * 0.02)):Container(), 
                  widget.parts.haveShop? Container(padding: EdgeInsets.only(right: Measurements.width * (0.02)) ,child:SvgPicture.asset("images/shopicon.svg",height: Measurements.height * 0.02)):Container(),  
                  ],
                ),
                IconButton(
                  icon: Icon(widget.isOpen ? Icons.remove : Icons.add),
                  onPressed: () {
                    widget.openedRow.notifyListeners();
                    widget.openedRow.value = 4;
                  },
                )
              ],
            ),
            onTap: (){
              widget.openedRow.notifyListeners();
              widget.openedRow.value = 4;
            },
          ),
        ),
        AnimatedContainer(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
          ),
          height: widget.isOpen
              ? ((Measurements.height * (widget.parts.isTablet ? 0.07 : 0.09))+(Measurements.height * (widget.parts.isTablet ? 0.055 : 0.075))*widget.size)+ (Measurements.height * ((widget.parts.haveShop && widget.parts.havePOS)? (widget.parts.isTablet ? 0.05 : 0.07):0))
              : 0,
          duration: Duration(milliseconds: 200),
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
            color: Colors.black.withOpacity(0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: Measurements.height *
                              (widget.parts.isTablet ? 0.05 : 0.07) +((Measurements.height * (widget.parts.isTablet ? 0.055 : 0.075))*widget.size) + (Measurements.height * ((widget.parts.haveShop && widget.parts.havePOS)? (widget.parts.isTablet ? 0.05 : 0.07):0)),
                          child: widget.parts.channelForm,
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
            color: Colors.white.withOpacity(0.1),
            child: widget.isOpen
                ? Divider(
                    color: Colors.white.withOpacity(0),
                  )
                : Divider(
                    color: Colors.white,
                  )),
      ],
    );
  }
}
