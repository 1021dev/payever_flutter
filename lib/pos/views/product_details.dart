import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/checkout_process/views/views.dart';
import 'package:payever/commons/views/custom_elements/appbar_avatar.dart';
import '../views/views.dart';
import 'package:provider/provider.dart';
import '../../commons/views/custom_elements/custom_elements.dart';
import '../view_models/view_models.dart';
import '../models/models.dart';
import '../utils/utils.dart';

CustomCarouselSlider customCarouselSlider;

class ProductDetailsScreen extends StatefulWidget {
  final PosStateModel parts;
  final ProductsModel currentProduct;
  final int index;

  ProductDetailsScreen({
    this.parts,
    this.currentProduct,
    this.index,
  });

  @override
  createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isPortrait = true;
  bool isTablet = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PosCartStateModel cartStateModel = Provider.of<PosCartStateModel>(context);
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    isTablet = isPortrait
        ? MediaQuery.of(context).size.width > 600
        : MediaQuery.of(context).size.height > 600;
    return OKToast(
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: AppBarAvatar(),
          backgroundColor: Color(
              Provider.of<GlobalStateModel>(context).currentBusiness.primary ??
                  0xFFFFFFFF),
          actions: <Widget>[
            IconButton(
              icon: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/images/shopicon.svg",
                    color: Colors.black,
                    height: Measurements.height * 0.035,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(),
                        ),
                        cartStateModel.getCartHasItems
                            ? Icon(Icons.brightness_1,
                                color: Color(0XFF0084FF),
                                size: Measurements.height *
                                    (isTablet ? 0.01 * 1 : 0.01 * 1.2))
                            : Container(),
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: CheckOutScreen(
                      channelSet: widget.parts.currentTerminal.channelSet,
                      posCartStateModel: cartStateModel,
                      posStateModel: Provider.of<PosStateModel>(context),
                    ),
                    // child: POSCart(parts: posStateModel),
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 10),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: DetailedProduct(
          currentProduct: widget.currentProduct,
          parts: widget.parts,
          cartStateModel: cartStateModel,
          defaultVariantIndex: widget.index,
        )),
      ),
    );
  }
}

class DetailedProduct extends StatefulWidget {
  final ProductsModel currentProduct;
  final PosStateModel parts;
  final ValueNotifier<bool> stockCount = ValueNotifier(false);
  final PosCartStateModel cartStateModel;
  final int defaultVariantIndex;

  DetailedProduct({
    @required this.currentProduct,
    @required this.parts,
    @required this.cartStateModel,
    @required this.defaultVariantIndex,
  });

  @override
  _DetailedProductState createState() => _DetailedProductState();
}

class _DetailedProductState extends State<DetailedProduct> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Measurements.width * 0.05,
        ),
        child: ListView(
          shrinkWrap: false,
          children: <Widget>[
            DetailsInfo(
              parts: widget.parts,
              currentProduct: widget.currentProduct,
              haveVariants: widget.currentProduct.variants.isNotEmpty,
              stockCount: widget.stockCount,
              cartStateModel: widget.cartStateModel,
              defaultVariantIndex: widget.defaultVariantIndex,
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsInfo extends StatefulWidget {
  final PosStateModel parts;
  final ProductsModel currentProduct;
  final bool haveVariants;
  final ValueNotifier<bool> stockCount;
  final PosCartStateModel cartStateModel;
  final int defaultVariantIndex;

  DetailsInfo({
    @required this.parts,
    @required this.currentProduct,
    @required this.haveVariants,
    @required this.stockCount,
    @required this.cartStateModel,
    @required this.defaultVariantIndex,
  });

  @override
  _DetailsInfoState createState() => _DetailsInfoState();
}

class _DetailsInfoState extends State<DetailsInfo> {
  List<String> imagesVariants = List();
  List<String> imagesBase = List();
  bool onSale, haveVariants;

  ValueNotifier<int> currentVariant = ValueNotifier(0);

  num price, salePrice;
  String description;
  TextStyle textStyle = TextStyle(color: Colors.black);

  String selectedVariantName = "";

  int selectedIndex = 0;

  bool isPortrait = true;
  bool isTablet = false;
  ProductVariantModel initialVariant;

  @override
  void initState() {
    super.initState();
    currentVariant.value = 0;
    haveVariants = widget.currentProduct.variants.isNotEmpty;
    currentVariant.addListener(
      () => setState(
        () {},
      ),
    );
    if (widget.currentProduct.variants != null) {
      if (widget.currentProduct.variants.isNotEmpty)
        initialVariant = widget.currentProduct?.variants?.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    PosStateModel posProvider = Provider.of<PosStateModel>(context);
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    isTablet = isPortrait
        ? MediaQuery.of(context).size.width > 600
        : MediaQuery.of(context).size.height > 600;
    if (widget.haveVariants) {
      imagesVariants = imagesBase +
          widget.currentProduct.variants[currentVariant.value].images;
    } else {
      imagesBase = imagesVariants = widget.currentProduct.images;
    }

    if (widget.haveVariants) {
      var index = 0;
      description = (widget.currentProduct.variants[currentVariant.value]
                  .description?.isEmpty ??
              true)
          ? widget.currentProduct.description
          : widget.currentProduct.variants[currentVariant.value].description;
      selectedVariantName =
          "- ${widget.currentProduct.variants[currentVariant.value].title}";
      onSale = widget.currentProduct.variants[currentVariant.value].onSales;
    } else {
      posProvider.selectedValue = Map();
      posProvider.optionName = List();
      price = widget.currentProduct.price;
      salePrice = widget.currentProduct.salePrice;
      onSale = widget.currentProduct.onSales;
      description = widget.currentProduct.description;
    }
    String _stc = widget.haveVariants
        ? widget.currentProduct.variants[currentVariant.value].sku
        : widget.currentProduct.sku;
    posProvider.selectedProduct = widget.currentProduct;
    if (haveVariants) {
      posProvider.setOptions(variant: initialVariant);
      posProvider.setSelectedValues(
        widget.currentProduct.variants[currentVariant.value],
      );
    }
    posProvider.setValues();
    return Container(
      alignment: Alignment.center,
      width: Measurements.height * 0.4,
      child: CustomFutureBuilder<int>(
        future: getInventoryState(posProvider, _stc),
        errorMessage: "Error loading product details",
        loadingWidget: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            ),
          ],
        ),
        onDataLoaded: (results) {
          Color color = Color(Provider.of<GlobalStateModel>(context)
                  .currentBusiness
                  .secondary ??
              0xff000000);
          return isTablet
              ? Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            DetailImage(
                              haveVariants: haveVariants,
                              currentVariant: currentVariant,
                              parts: posProvider,
                              imagesBase: imagesBase,
                              index: (widget.haveVariants &&
                                      (widget
                                          .currentProduct
                                          .variants[currentVariant.value]
                                          .images
                                          .isNotEmpty))
                                  ? imagesBase.length
                                  : 0,
                            ),
                            Description(
                              currentProduct: widget.currentProduct,
                              currentVariant: currentVariant,
                              haveVariants: haveVariants,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              NameNPrice(
                                currentProduct: widget.currentProduct,
                                currentVariant: currentVariant,
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: VariantSection(currentVariant),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: isTablet
                                    ? Measurements.width * 0.8
                                    : Measurements.width * 0.9,
                                child: InkWell(
                                  child: Container(
                                    // width: Measurements.width *
                                    //     (isTablet ? 0.35 : 0.8),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: results == 0
                                          ? color.withOpacity(0.5)
                                          : color,
                                    ),
                                    child: Center(
                                      child: Text(
                                        Language.getCustomStrings(
                                          "checkout_cart_add_to_cart",
                                        ),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () => addProduct(
                                    Provider.of<PosStateModel>(context),
                                    results,
                                  ),
                                ),
                              ),
                              isTablet
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        bottom: Measurements.height * 0.02,
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ])
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DetailImage(
                      haveVariants: haveVariants,
                      currentVariant: currentVariant,
                      parts: posProvider,
                      imagesBase: imagesBase,
                      index: (widget.haveVariants &&
                              (widget
                                  .currentProduct
                                  .variants[currentVariant.value]
                                  .images
                                  .isNotEmpty))
                          ? imagesBase.length
                          : 0,
                    ),
                    //name
                    NameNPrice(
                      currentProduct: widget.currentProduct,
                      currentVariant: currentVariant,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: VariantSection(currentVariant),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: isTablet
                          ? Measurements.width * 0.8
                          : Measurements.width * 0.9,
                      child: InkWell(
                        child: Container(
                          // width: Measurements.width * (isTablet ? 0.35 : 0.8),
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                results == 0 ? color.withOpacity(0.5) : color,
                          ),
                          child: Center(
                            child: Text(
                              Language.getCustomStrings(
                                "checkout_cart_add_to_cart",
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          addProduct(
                            Provider.of<PosStateModel>(context),
                            results,
                          );
                        },
                      ),
                    ),
                    Description(
                      currentProduct: widget.currentProduct,
                      currentVariant: currentVariant,
                      haveVariants: haveVariants,
                    ),
                    //test section
                    //
                    //
                    isTablet
                        ? Padding(
                            padding: EdgeInsets.only(
                              bottom: Measurements.height * 0.02,
                            ),
                          )
                        : Container(),
                  ],
                );
        },
      ),
    );
  }

  addProduct(PosStateModel posProvider, results) {
    if (widget.cartStateModel.getIsButtonAvailable) {
      if (results != 0) {
        if (widget.haveVariants) {
          var image = widget.currentProduct.variants[currentVariant.value]
                  .images.isNotEmpty
              ? widget.currentProduct.variants[currentVariant.value].images[0]
              : widget.currentProduct.images.isNotEmpty
                  ? widget.currentProduct.images[0]
                  : null;
          posProvider.add2cart(
            id: widget.currentProduct.variants[currentVariant.value].id,
            image: image,
            uuid: widget.currentProduct.variants[currentVariant.value].id,
            name: widget.currentProduct.title,
            price: onSale
                ? widget.currentProduct.variants[currentVariant.value].salePrice
                : widget.currentProduct.variants[currentVariant.value].price,
            qty: 1,
            sku: widget.currentProduct.variants[currentVariant.value].sku,
            isVariant: true,
            options:
                widget.currentProduct.variants[currentVariant.value].options,
          );
        } else {
          var image = widget.currentProduct.images.isNotEmpty
              ? widget.currentProduct.images[0]
              : null;
          posProvider.add2cart(
            id: widget.currentProduct.id,
            image: image,
            uuid: widget.currentProduct.id,
            name: widget.currentProduct.title,
            price: onSale
                ? widget.currentProduct.salePrice
                : widget.currentProduct.price,
            qty: 1,
            sku: widget.currentProduct.sku,
          );
        }
        widget.cartStateModel.updateBuyButton(false);
        widget.cartStateModel.updateCart(true);
        ToastFuture toastFuture = showToastWidget(
          CustomToastNotification(
            icon: Icons.check_circle_outline,
            toastText: "Product added to Bag",
          ),
          duration: Duration(seconds: 2),
          onDismiss: () {
            print("The toast was dismised");
            widget.cartStateModel.updateBuyButton(true);
          },
        );
        Future.delayed(
          Duration(seconds: 2),
          () {
            toastFuture.dismiss();
          },
        );
      }
    }
  }

  ColorButtonController controller = ColorButtonController();

  Future<int> getInventoryState(
      PosStateModel posStateModel, String productSku) async {
    var inventory;
    try {
      inventory = await posStateModel.getInventory(productSku);
    } catch (e) {
      print("error: $e");
    }

    var inventoryData = InventoryModel.toMap(inventory);

    int stockData = 0;

    if (inventoryData.isTrackable) {
      if (inventoryData.stock != null) {
        if (inventoryData.stock <= 0) {
          stockData = 0;
        } else {
          stockData = inventoryData.stock;
        }
      } else {
        stockData = 0;
      }
    } else {
      stockData = 10;
    }

    return stockData;
  }
}

class Description extends StatefulWidget {
  final ProductsModel currentProduct;
  final ValueNotifier<int> currentVariant;
  final bool haveVariants;
  Description({
    @required this.currentVariant,
    @required this.currentProduct,
    this.haveVariants,
  });
  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  void initState() {
    super.initState();
    // widget.currentVariant.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    // print("From description ${widget.currentVariant.value}");

    String description;
    if (widget.haveVariants) {
      description = (widget.currentProduct.variants[widget.currentVariant.value]
                  .description?.isEmpty ??
              true)
          ? widget.currentProduct.description
          : widget
              .currentProduct.variants[widget.currentVariant.value].description;
      // description = widget
      //     .currentProduct.variants[widget.currentVariant.value].description;
    } else {
      description = widget.currentProduct.description;
    }

    return Container(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: Measurements.height * 0.04, top: 25),
        child: Html(
          data: description,
          defaultTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}

class NameNPrice extends StatefulWidget {
  final ProductsModel currentProduct;
  final ValueNotifier<int> currentVariant;
  NameNPrice({@required this.currentProduct, @required this.currentVariant});
  @override
  _NameNPriceState createState() => _NameNPriceState();
}

class _NameNPriceState extends State<NameNPrice> {
  @override
  void initState() {
    super.initState();
    // widget.currentVariant.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    PosStateModel posProvider = Provider.of<PosStateModel>(context);
    bool haveVariants = widget.currentProduct.variants.isNotEmpty;
    num price = haveVariants
        ? widget.currentProduct.variants[widget.currentVariant.value].price
        : widget.currentProduct.price;
    num salePrice = haveVariants
        ? widget.currentProduct.variants[widget.currentVariant.value].salePrice
        : widget.currentProduct.salePrice;
    bool onSale = haveVariants
        ? widget.currentProduct.variants[widget.currentVariant.value].onSales
        : widget.currentProduct.onSales;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Text(
                  "${widget.currentProduct.title}",
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        //price
        Container(
          padding: EdgeInsets.only(
            bottom: 25,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "${posProvider.f.format(price)}${Measurements.currency(posProvider.getBusiness.currency)}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  decoration:
                      onSale ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              onSale
                  ? Text(
                      "  ${posProvider.f.format(salePrice ?? 0)}${Measurements.currency(posProvider.getBusiness.currency)}",
                      style: TextStyle(
                        fontSize: 22,
                        color: posProvider.saleColor,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}

class StockText extends StatefulWidget {
  final PosStateModel parts;
  final String sku;
  final productStock;
  final int stc;

  StockText({this.parts, this.sku, @required this.productStock, this.stc});

  @override
  _StockTextState createState() => _StockTextState();
}

class _StockTextState extends State<StockText> {
  String value = "";
  Color color = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    value = (widget.stc > 0)
        ? Language.getProductListStrings("filters.quantity.inStock")
        : Language.getProductListStrings("filters.quantity.outStock");
    color = (widget.stc > 6)
        ? Colors.green
        : widget.stc > 0 ? Colors.orangeAccent : Colors.red;
    return Text(
      value,
      style: TextStyle(
        color: color,
      ),
    );
  }
}

/// ***
/// 
/// Widget that manage the image as a carousel and the previews.
/// 
/// ***

class DetailImage extends StatefulWidget {
  final ValueNotifier<int> currentVariant;

  final PosStateModel parts;
  List<String> imagesBase;
  final int index;
  final bool haveVariants;

  DetailImage({
    @required this.currentVariant,
    @required this.parts,
    @required this.imagesBase,
    @required this.index,
    this.haveVariants = false,
  });

  @override
  createState() => _DetailImageState();
}

class _DetailImageState extends State<DetailImage> {
  ProductsModel currentProduct;
  int imageIndex;

  bool isPortrait = true;
  bool isTablet = false;

  @override
  void initState() {
    super.initState();
    widget.currentVariant.addListener(listener);
    setState(
      () {
        imageIndex = widget.index;
      },
    );
  }

  listener() {
    setState(() {});
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    isTablet = isPortrait
        ? MediaQuery.of(context).size.width > 600
        : MediaQuery.of(context).size.height > 600;
    List<String> _images = List();
    if (widget.haveVariants) {
      _images = widget.imagesBase +
          Provider.of<PosStateModel>(context)
              .selectedProduct
              .variants[widget.currentVariant.value]
              .images;
    } else {
      _images = widget.imagesBase;
    }
    List<Widget> images = List();
    _images.forEach(
      (f) {
        if (f != null)
          images.add(
            Container(
              height: isTablet
                  ? Measurements.width * 0.45
                  : Measurements.height * 0.4,
              // width: isTablet
              //     ? Measurements.width * 0.45
              //     : Measurements.height * 0.4,
              child: CachedNetworkImage(
                imageUrl: Env.storage + "/products/" + f,
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.contain,
              ),
            ),
          );
      },
    );

    int _currentImage = imageIndex;

    customCarouselSlider = CustomCarouselSlider(
      realPage: imageIndex,
      startingPage: imageIndex,
      items: images,
      enableInfiniteScroll: false,
      viewportFraction: 1.0,
      aspectRatio: 1,
      scrollDirection: Axis.horizontal,
      onPageChanged: (index) {
        setState(
          () {
            _currentImage = index;
            imageIndex = index;
          },
        );
      },
    );

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10, top: 10),
            // height: isTablet
            //     ? Measurements.width * 0.45
            //     : Measurements.height * 0.4,
            // width: isTablet
            //     ? Measurements.width * 0.45
            //     : Measurements.height * 0.4,
            child: customCarouselSlider,
          ),
          Container(
            alignment: Alignment.centerLeft,
            // width: isTablet
            //     ? Measurements.width * 0.45
            //     : Measurements.height * 0.4,
            height: Measurements.height * 0.1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: _images.length,
              itemBuilder: (BuildContext context, int index) {
                if (_images[index] == null) return Container();
                return InkWell(
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Container(
                      // padding: EdgeInsets.all(2.0),
                      height: Measurements.height * 0.1,
                      width: Measurements.height * 0.1,
                      decoration: BoxDecoration(
                        /// ***
                        /// used to display the line that indicate which image is picked
                        border: Border(
                            // bottom: BorderSide(color: index == imageIndex? Colors.grey:Colors.white ,width: 2)
                            ),
                      ),
                      child: CachedNetworkImage(
                        // child: Image.network(
                        imageUrl: Env.storage +
                            "/products/" +
                            /// ***
                            /// use of thumbnail to gain speed by fetching smaller sized images
                            _images[index], // +"-thumbnail"
                        placeholder: (context, url) => Container(),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          color: Colors.black,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(
                      () {
                        imageIndex = index;
                        customCarouselSlider.jumpToPage(imageIndex);
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

// Container(
//   padding: EdgeInsets.symmetric(vertical: 50),
//   child: ColorButtonGrid(
//     colors: <Color>[
//       Colors.red,
//       Colors.blue,
//       Colors.green,
//       Colors.deepOrange,
//       Colors.red,
//       Colors.blue,
//       Colors.green,
//       Colors.deepOrange,
//       Colors.white,
//       Colors.black,
//       Colors.orange
//     ],
//     controller: controller,
//     size: Measurements.height * 0.03,
//   ),
// ),
