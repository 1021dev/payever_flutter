import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:payever/view_models/cart_state_model.dart';
import 'package:payever/views/customelements/custom_toast_notification.dart';
import 'package:payever/views/customelements/color_picker.dart';
import 'package:payever/views/customelements/drop_down_menu.dart';
import 'package:payever/views/pos/native_pos_screen.dart';
import 'package:payever/views/pos/pos_cart.dart';
import 'package:payever/models/products.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/utils/env.dart';


CarouselSlider customCarouselSlider;

class DetailScreen extends StatefulWidget {
  final PosScreenParts parts;
  final ProductsModel currentProduct;

  DetailScreen({this.parts, this.currentProduct});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    CartStateModel cartStateModel = Provider.of<CartStateModel>(context);

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
          title: Text(
            "Product details",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    "images/shopicon.svg",
                    color: Colors.black,
                    height: Measurements.height * 0.035,
                  ),
                  Positioned(
                    top: widget.parts.isTablet
                        ? Measurements.height * 0.016
                        : Measurements.height * 0.014,
                    child: cartStateModel.getIsCartEmpty
                        ? Container()
                        : Icon(
                            Icons.brightness_1,
                            color: Color(0XFF0084FF),
                            size: Measurements.height *
                                (widget.parts.isTablet
                                    ? 0.01 * 1.2
                                    : 0.01 * 1.3),
                          ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: POSCart(
                          parts: widget.parts,
                        ),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 10)));
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
        )),
      ),
    );
  }
}

class DetailedProduct extends StatefulWidget {
  final ProductsModel currentProduct;
  final PosScreenParts parts;
  final int currentVariantIndex = 0;
  final ValueNotifier<bool> stockCount = ValueNotifier(false);
  final ValueNotifier<int> currentVariant = ValueNotifier(0);
  final Map<String, String> productStock = Map();
  final CartStateModel cartStateModel;

  DetailedProduct(
      {@required this.currentProduct,
      @required this.parts,
      @required this.cartStateModel});

  @override
  _DetailedProductState createState() => _DetailedProductState();
}

class _DetailedProductState extends State<DetailedProduct> {
  List<String> imagesVariants = List();
  List<String> imagesBase = List();
  bool haveVariants;

  @override
  void initState() {
    super.initState();
    widget.currentVariant.addListener(listener);

    setState(() {
      haveVariants = widget.currentProduct.variants.isNotEmpty;
      imagesBase = widget.currentProduct.images;
    });
  }

  listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.05),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            DetailDetails(
              currentVariant: widget.currentVariant,
              parts: widget.parts,
              currentProduct: widget.currentProduct,
              haveVariants: haveVariants,
              stockCount: widget.stockCount,
              productStock: widget.productStock,
              cartStateModel: widget.cartStateModel,
            ),
          ],
        ),
      ),
    );
  }
}

class DetailImage extends StatefulWidget {
  final ValueNotifier<int> currentVariant;
  final PosScreenParts parts;
  final List<String> images;
  final int index;
  final bool haveVariants;
  final int selectedIndex;

  DetailImage({
    @required this.currentVariant,
    @required this.parts,
    @required this.images,
    @required this.index,
    @required this.selectedIndex,
    this.haveVariants,
  });

  @override
  createState() => _DetailImageState();
}

class _DetailImageState extends State<DetailImage> {
  ProductsModel currentProduct;
  int imageIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.currentVariant.addListener(listener);

    setState(() {
      imageIndex = widget.index;
    });
  }

  listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> images = List();
    widget.images.forEach((f) {
      images.add(Container(
//        color: Colors.red,
        height: widget.parts.isTablet
            ? Measurements.width * 0.45
            : Measurements.height * 0.4,
        width: widget.parts.isTablet
            ? Measurements.width * 0.45
            : Measurements.height * 0.4,
        child: CachedNetworkImage(
          imageUrl: Env.Storage + "/products/" + f,
          placeholder: (context, url) => Container(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.contain,
        ),
      ));
    });

    customCarouselSlider = CarouselSlider(
      aspectRatio: 1,
      realPage: imageIndex,
      initialPage: imageIndex,
      items: images,
      enableInfiniteScroll: false,
    );

    return Container(
      child: Column(
        children: <Widget>[
          Container(
//            color: Colors.green,
            height: widget.parts.isTablet
                ? Measurements.width * 0.45
                : Measurements.height * 0.4,
            width: widget.parts.isTablet
                ? Measurements.width * 0.45
                : Measurements.height * 0.4,
            child: customCarouselSlider,
          ),
          Container(
            width: widget.parts.isTablet
                ? Measurements.width * 0.45
                : Measurements.height * 0.4,
            height: Measurements.height * 0.1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.images.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: Container(
                      height: Measurements.height * 0.1,
                      width: Measurements.height * 0.1,
                      padding: EdgeInsets.all(Measurements.width * 0.01),
                      child: CachedNetworkImage(
                        imageUrl:
                            Env.Storage + "/products/" + widget.images[index],
                        placeholder: (context, url) => Container(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.contain,
                      )),
                  onTap: () {
                    setState(() {
                      imageIndex = index;
                      customCarouselSlider.jumpToPage(imageIndex);
                    });

                    print("index: $index");
                    print("imageIndex: $imageIndex");
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

class DetailDetails extends StatefulWidget {
  final ValueNotifier<int> currentVariant;
  final PosScreenParts parts;
  final ProductsModel currentProduct;
  final bool haveVariants;
  final ValueNotifier<bool> stockCount;
  final Map<String, String> productStock;
  final CartStateModel cartStateModel;

  DetailDetails(
      {@required this.currentVariant,
      @required this.parts,
      @required this.currentProduct,
      @required this.haveVariants,
      @required this.stockCount,
      @required this.productStock,
      @required this.cartStateModel});

  @override
  _DetailDetailsState createState() => _DetailDetailsState();
}

class _DetailDetailsState extends State<DetailDetails> {
  List<String> imagesVariants = List();
  List<String> imagesBase = List();
  bool onSale, haveVariants;

  num price, salePrice;
  String description;
  List<PopupMenuItem<String>> products;
  List<String> productsList = List<String>();
  TextStyle textStyle = TextStyle(color: Colors.black);

  String selectedVariantName = "";

  int selectedIndex = 0;

  listener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.stockCount.addListener(listener);
    widget.currentVariant.addListener(listener);

    setState(() {
      imagesBase = widget.currentProduct.images;
//      haveVariants = widget.haveVariants;
      haveVariants = widget.currentProduct.variants.isNotEmpty;

      selectedVariantName =
          haveVariants ? "- ${widget.currentProduct.variants[0].title}" : "";
    });

  }

  @override
  Widget build(BuildContext context) {
    if (widget.haveVariants) {
      imagesVariants = imagesBase +
          widget.currentProduct.variants[widget.currentVariant.value].images;
    } else {
      imagesVariants = imagesBase;
    }

    if (widget.haveVariants) {
      var index = 0;
      products = List();
      productsList = [];
      widget.currentProduct.variants.forEach((f) {
        var temp = widget.parts.productStock[f.sku];
        if (((temp.contains("null") ? 0 : int.parse(temp ?? "0")) > 0)) {
          PopupMenuItem<String> variant = PopupMenuItem(
            value: "$index",
            child: Container(
              width: Measurements.width,
              child: ListTile(
                dense: true,
                title: Container(
                  width: Measurements.width,
                  child: Text(
                    f.title,
                    style: textStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
          products.add(variant);

          productsList.add(f.title);
        }
        index++;
      });
      if (widget.currentVariant.value == 0) {
        print(
            "${widget.currentVariant.value}  =  ${int.parse(products.first.value)}");
        widget.currentVariant.value = int.parse(products.first.value);
      }
      price = widget.currentProduct.variants[widget.currentVariant.value].price;
      salePrice =
          widget.currentProduct.variants[widget.currentVariant.value].salePrice;
      onSale =
          !widget.currentProduct.variants[widget.currentVariant.value].hidden;
      description = widget
          .currentProduct.variants[widget.currentVariant.value].description;
    } else {
      price = widget.currentProduct.price;
      salePrice = widget.currentProduct.salePrice;
      onSale = !widget.currentProduct.hidden;
      description = widget.currentProduct.description;
    }
    String _stc = widget.parts.productStock[widget.haveVariants
        ? widget.currentProduct.variants[widget.currentVariant.value].sku
        : widget.currentProduct.sku];
    int stc =
        _stc == null ? 0 : _stc.contains("null") ? 0 : int.parse(_stc ?? "0");
    return Container(
      width: Measurements.height * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //for sale
          Container(
              alignment: Alignment.center,
              height: Measurements.height * 0.05,
              child: onSale
                  ? Text(
                      "Sale",
                      style: TextStyle(color: widget.parts.saleColor),
                    )
                  : Container()),
          //name
          Container(
            alignment: Alignment.center,
            child: Text(
              "${widget.currentProduct.title} $selectedVariantName",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          //price
          Container(
            height: Measurements.height * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${widget.parts.f.format(price)}${Measurements.currency(widget.parts.business.currency)}",
                  style: TextStyle(
                      fontSize: 17,
                      color: widget.parts.titleColor.withOpacity(0.5),
                      fontWeight: FontWeight.w300,
                      decoration: onSale
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
                onSale
                    ? Text(
                        "  ${widget.parts.f.format(salePrice)}${Measurements.currency(widget.parts.business.currency)}",
                        style: TextStyle(
                            fontSize: 17,
                            color: widget.parts.saleColor,
                            fontWeight: FontWeight.w300),
                      )
                    : Container(),
              ],
            ),
          ),
          //Stock
          Container(
            child: StockText(
              parts: widget.parts,
              stc: stc,
              productStock: widget.productStock,
            ),
          ),
          //images
          DetailImage(
            currentVariant: widget.currentVariant,
            parts: widget.parts,
            images: imagesVariants,
            index: (widget.haveVariants &&
                    (widget.currentProduct.variants[widget.currentVariant.value]
                        .images.isNotEmpty))
                ? imagesBase.length
                : 0,
            selectedIndex: selectedIndex,
          ),
          //variant Picker
          Padding(
            padding: EdgeInsets.symmetric(vertical: Measurements.height * 0.01),
          ),

          widget.haveVariants
              ? Container(
//                  padding: EdgeInsets.symmetric(
//                      horizontal: Measurements.width *
//                          (widget.parts.isTablet ? 0.15 : 0)),
                  height: Measurements.height * 0.07,
                  child: Theme(
                    data: ThemeData.light(),
                    child: Container(
                      width: Measurements.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
//                        color: Colors.grey.withOpacity(0.2),
                        border: Border.all(
                          width: 1,
                          color: Colors.grey.withOpacity(0.2)
                        ),
                      ),
                      child: DropDownMenu(
                        backgroundColor: Colors.white,
                        fontColor: Colors.black.withOpacity(0.6),
                        optionsList: productsList,
//                  defaultValue: products[0].value,
//                        defaultValue: "Something",
                        placeHolderText: productsList[0],
                        onChangeSelection: (String value, int index) {
                          setState(() {
                            widget.currentVariant.value = index;
//                            widget.currentVariant.notifyListeners();
                            selectedVariantName =
                                "- ${widget.currentProduct.variants[index].title}";

                            selectedIndex = index;

                            customCarouselSlider.jumpToPage(imagesBase.length + 1);

                          });
                        },
                      ),
                    ),
                  ),
                )
              : Container(),

//          Padding(
//            padding: EdgeInsets.symmetric(vertical: Measurements.height * 0.01),
//          ),
//
//          widget.haveVariants
//              ? Container(
//                  padding: EdgeInsets.symmetric(
//                      horizontal: Measurements.width *
//                          (widget.parts.isTablet ? 0.15 : 0)),
//                  height: Measurements.height * 0.07,
//                  child: Theme(
//                    data: ThemeData.light(),
//                    child: Container(
//                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(12),
//                        color: Colors.grey.withOpacity(0.2),
//                      ),
//                      child: PopupMenuButton(
//                        initialValue: "${widget.currentVariant.value}",
//                        onSelected: (value) {
//                          setState(() {
//                            widget.currentVariant.value = int.parse(value);
////                            widget.currentVariant.notifyListeners();
//                            selectedVariantName =
//                                "- ${widget.currentProduct.variants[int.parse(value)].title}";
//
//                            selectedIndex = int.parse(value);
//                          });
//                        },
//                        child: ListTile(
//                          dense: true,
//                          trailing: Icon(Icons.keyboard_arrow_down),
//                          title: Container(
//                            width: Measurements.width,
//                            child: Text(
//                              widget.currentProduct
//                                  .variants[widget.currentVariant.value].title,
//                              style: textStyle,
//                              overflow: TextOverflow.ellipsis,
//                            ),
//                          ),
//                        ),
//                        itemBuilder: (BuildContext context) => products,
//                      ),
//                    ),
//                  ),
//                )
//              : Container(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Measurements.height * 0.01),
          ),
          Container(
            alignment: Alignment.center,
            height: Measurements.height * 0.08,
            padding: EdgeInsets.symmetric(
                vertical: Measurements.height * 0.01,
                horizontal:
                    Measurements.width * (widget.parts.isTablet ? 0.15 : 0)),
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: stc == 0 ? Colors.grey : Colors.black,
                ),
                child: Center(
                    child: Text(
                  "Add to cart",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )),
              ),
              onTap: () {
                ToastFuture toastFuture = showToastWidget(
                  CustomToastNotification(
                    icon: Icons.check_circle_outline,
                    toastText: "Product added to Bag",
                  ),
                  duration: Duration(seconds: 3),
                  onDismiss: () {
                    print(
                        "The toast was dismised"); // the method will be called on toast dismiss.
                  },
                );

                Future.delayed(Duration(seconds: 3), () {
                  toastFuture.dismiss();
                });

                if (stc != 0) {
                  if (widget.haveVariants) {
                    var image = widget
                            .currentProduct
                            .variants[widget.currentVariant.value]
                            .images
                            .isNotEmpty
                        ? widget.currentProduct
                            .variants[widget.currentVariant.value].images[0]
                        : widget.currentProduct.images.isNotEmpty
                            ? widget.currentProduct.images[0]
                            : null;
                    widget.parts.add2cart(
                        id: widget.currentProduct
                            .variants[widget.currentVariant.value].id,
                        image: image,
                        uuid: widget.currentProduct
                            .variants[widget.currentVariant.value].id,
                        name: widget.currentProduct
                            .variants[widget.currentVariant.value].title,
                        price: onSale
                            ? widget.currentProduct
                                .variants[widget.currentVariant.value].salePrice
                            : widget.currentProduct
                                .variants[widget.currentVariant.value].price,
                        qty: 1,
                        sku: widget.currentProduct
                            .variants[widget.currentVariant.value].sku);
                  } else {
                    var image = widget.currentProduct.images.isNotEmpty
                        ? widget.currentProduct.images[0]
                        : null;
                    widget.parts.add2cart(
                        id: widget.currentProduct.uuid,
                        image: image,
                        uuid: widget.currentProduct.uuid,
                        name: widget.currentProduct.title,
                        price: onSale
                            ? widget.currentProduct.salePrice
                            : widget.currentProduct.price,
                        qty: 1,
                        sku: widget.currentProduct.sku);
                  }

                  widget.cartStateModel.updateCart(false);

//                  Navigator.pop(context);
                }
              },
            ),
          ),

          Container(
              padding: EdgeInsets.only(
                  bottom: Measurements.height * 0.04,
                  top: Measurements.height * 0.02),
              child: Text(
                "$description",
                style: TextStyle(color: Colors.black, fontSize: 13),
              )),
//          ColorButtonGrid(
//            colors: <Color>[
//              Colors.red,
//              Colors.blue,
//              Colors.green,
//              Colors.deepOrange,
//              Colors.red,
//              Colors.blue,
//              Colors.green,
//              Colors.deepOrange,
//              Colors.red,
//              Colors.blue,
//              Colors.green,
//              Colors.deepOrange
//            ],
//            controller: controller,
//            size: Measurements.height * 0.03,
//          ),
//          ColorButtonContainer(
//            displayColor: Colors.red,
//            size: Measurements.height * 0.03,
//            controller: controller,
//          ),
          widget.parts.isTablet
              ? Padding(
                  padding: EdgeInsets.only(bottom: Measurements.height * 0.02),
                )
              : Container(),
        ],
      ),
    );
  }

  ColorButtomController controller = ColorButtomController();
}

class StockText extends StatefulWidget {
  final PosScreenParts parts;
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
    return Text(value, style: TextStyle(color: color));
  }
}