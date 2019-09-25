import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/products/view_models/view_models.dart';
import 'package:payever/products/views/custom_form_field.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:uuid/uuid.dart';

import '../../commons/views/custom_elements/custom_elements.dart';
import '../models/models.dart';
import '../network/network.dart';
import '../utils/utils.dart';
import 'product_inventory.dart';
import 'new_product.dart';

class ProductVariantsRow extends StatefulWidget {
  final NewProductScreenParts parts;

  ProductVariantsRow({@required this.parts});

  @override
  createState() => _VariantRowState();
}

class _VariantRowState extends State<ProductVariantsRow> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.parts.product?.variants?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                List<Widget> list = List();
                widget.parts.product.variants[index].options.forEach(
                  (f) {
                    list.add(
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                              text: "${f.name}: ",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                            ),
                            TextSpan(
                              text: "${f.value}",
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

                // var _inv = widget.parts.inventories.firstWhere((test) => test.sku == widget.parts.product.variants[index].sku);

                return InkWell(
                  highlightColor: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: Measurements.height *
                            (widget.parts.isTablet ? 0.05 : 0.07),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: Measurements.width * 0.4,
                              child: Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                children: list,
                              ),
                            ),
                            Container(
                                // child: Text("${_inv?.amount??0} items"),
                                ),
                            Container(
                              width: Measurements.width * 0.18,
                              child: Text(
                                  "${widget.parts.product.variants[index].price} ${Measurements.currency(widget.parts.currency)}"),
                            ),
                            InkWell(
                              highlightColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: SvgPicture.asset(
                                    "assets/images/xsinacircle.svg"),
                              ),
                              onTap: () {
                                setState(() {
                                  widget.parts.product.variants.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                          child: VariantPopUp(
                            parts: widget.parts,
                            wallpaper: widget.parts.wallpaper,
                            onEdit: true,
                            editVariant: widget.parts.product.variants[index],
                            index: index,
                          ),
                          duration: Duration(milliseconds: 100),
                          type: PageTransitionType.fade,
                        ));
                  },
                );
              },
            )),
            Container(
              child: InkWell(
                highlightColor: Colors.transparent,
                child: Container(
                    padding: EdgeInsets.all(25),
                    child: Center(
                        child: Text(
                      Language.getProductStrings("variantEditor.add_variant"),
                      style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
                    ))),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                        child: VariantPopUp(
                          parts: widget.parts,
                          wallpaper: widget.parts.wallpaper,
                          onEdit: false,
                          editVariant: ProductVariantModel(),
                        ),
                        duration: Duration(milliseconds: 100),
                        type: PageTransitionType.fade,
                      ));
                },
              ),
            )
          ]),
    );
  }
}

class VariantPopUp extends StatefulWidget {
  final NewProductScreenParts parts;
  final String wallpaper;
  final bool onEdit;
  final ProductVariantModel editVariant;
  final int index;

  VariantPopUp(
      {@required this.parts,
      @required this.wallpaper,
      @required this.onEdit,
      @required this.editVariant,
      this.index});

  @override
  _VariantPopUpState createState() => _VariantPopUpState();
}

class _VariantPopUpState extends State<VariantPopUp> {
  InventoryModel _inventoryModel;
  bool skuError = false;
  bool onSale = false;
  bool nameError = false;
  bool priceError = false;
  bool onSaleError = false;
  bool trackInv = false;
  TextEditingController textEditingController;

  var inv = 0;
  var originalStock;
  bool descriptionError = false;
  num amount;

  var fKey = GlobalKey<FormState>();
  var scKey = GlobalKey<ScaffoldState>();
  ProductVariantModel currentVariant = ProductVariantModel();

  List<String> variantImages = List();
  String currentImage;

  bool haveImage = false;

  List<VariantOptionValue> variantOptionValueList = List<VariantOptionValue>();

  @override
  initState() {
    super.initState();
    if (widget.onEdit) {
      variantImages = widget.editVariant.images;
      currentVariant = widget.editVariant;
      haveImage = variantImages.isNotEmpty;
      if (haveImage) currentImage = variantImages[0];

      ProductsApi api = ProductsApi();
      textEditingController = TextEditingController(text: "0");
      api
          .getInventory(widget.parts.business,
              GlobalUtils.activeToken.accessToken, currentVariant.sku, context)
          .then((obj) {
        InventoryModel inventory = InventoryModel.toMap(obj);
        _inventoryModel = inventory;
        print(_inventoryModel);
        inv = inventory.stock;
        originalStock = inventory.stock;
        trackInv = inventory.isTrackable;
        textEditingController = TextEditingController(
            text: (widget.parts.editMode
                ? (inventory.stock?.toString() ?? "0")
                : "0"));
        setState(() {});
      });
    }

    variantOptionValueList = [];
    addOptionValueToList();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (image.existsSync())
        setState(() {
          ProductsApi api = ProductsApi();
          api
              .postImage(image, widget.parts.business,
                  GlobalUtils.activeToken.accessToken)
              .then((dynamic res) {
            variantImages.add(res["blobName"]);
            if (currentImage == null) {
              currentImage = res["blobName"];
            }
            setState(() {
              haveImage = true;
            });
          }).catchError((onError) {
            setState(() {
              print(onError);
            });
          });
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        widget.parts.isPortrait = orientation == Orientation.portrait;
        widget.parts.isTablet = widget.parts.isPortrait
            ? MediaQuery.of(context).size.width > 600
            : MediaQuery.of(context).size.height > 600;
        return BackgroundBase(
          true,
          appBar: AppBar(
            title: Text(!widget.onEdit
                ? Language.getProductStrings("variantEditor.title")
                : Language.getProductStrings("variantEditor.edit_variant")),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              InkWell(
                // sav PopUp
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: Measurements.width * 0.02),
                    child: Text(Language.getProductStrings("save"))),
                onTap: () {
                  fKey.currentState.validate();

//                  if(!nameError) {
//                    print("currentVariant.titleData: ${currentVariant.title}");
//                  }

                  if (!(priceError ||
                          skuError ||
                          descriptionError ||
                          nameError) &&
                      !(onSale && onSaleError)) {
                    fKey.currentState.save();
                    if (!widget.onEdit) {
                      ProductsApi api = ProductsApi();
                      api
                          .checkSKU(
                              widget.parts.business,
                              GlobalUtils.activeToken.accessToken,
                              currentVariant.sku)
                          .then((onValue) {
                        skuError = true;
                        scKey.currentState.showSnackBar(SnackBar(
                          content: Text("Sku already exist"),
                        ));
                      }).catchError((onError) {
                        print(onError);
                        currentVariant.images = variantImages;
                        widget.parts.product.variants.add(currentVariant);
                        print("inventory Stock $amount");
                        widget.parts.invManager.addInventory(Inventory(
                            hiddenIndex: 0,
                            newAmount: amount,
                            barcode: currentVariant.barcode,
                            sku: currentVariant.sku,
                            tracking: trackInv));
                        Navigator.pop(context);
                      });
                    } else {
                      widget.parts.invManager.addInventory(Inventory(
                          hiddenIndex: 0,
                          amount: originalStock,
                          newAmount: amount,
                          barcode: currentVariant.barcode,
                          sku: currentVariant.sku,
                          tracking: trackInv));
                      currentVariant.images = variantImages;
                      widget.parts.product.variants.removeAt(widget.index);
                      widget.parts.product.variants
                          .insert(widget.index, currentVariant);
                      Navigator.pop(context);
                    }
                  }
                },
              )
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: InkWell(
            onTap: () => GlobalUtils.removeFocus(context),
            child: Container(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                      height: Measurements.height * 0.4,
                      child: !haveImage
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    child: SvgPicture.asset(
                                  "assets/images/insertimageicon.svg",
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
                                      Language.getProductStrings(
                                          "pictures.add_image"),
                                      style: TextStyle(
                                          fontSize: AppStyle.fontSizeTabTitle(),
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
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
                                            BorderRadius.circular(16)),
                                    height: Measurements.height * 0.29,
                                    child: Image.network(
                                      Env.storage + "/products/" + currentImage,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Container(
                                    height: Measurements.height * 0.1,
                                    width: Measurements.width * 0.75,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: variantImages.length + 1,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return index != variantImages.length
                                            ? Stack(
                                                alignment: Alignment.topRight,
                                                children: <Widget>[
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
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            child:
                                                                Image.network(
                                                              Env.storage +
                                                                  "/products/" +
                                                                  variantImages[
                                                                      index],
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            setState(() {
                                                              currentImage =
                                                                  variantImages[
                                                                      index];
                                                            });
                                                          },
                                                        )),
                                                    InkWell(
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: Measurements
                                                                  .height *
                                                              0.03,
                                                          width: Measurements
                                                                  .height *
                                                              0.03,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              shape: BoxShape
                                                                  .circle),
                                                          child: Icon(
                                                            Icons.close,
                                                            size: Measurements
                                                                    .height *
                                                                0.02,
                                                          )),
                                                      onTap: () {
                                                        setState(() {
                                                          variantImages
                                                              .removeAt(index);
                                                          if (variantImages
                                                                  .length ==
                                                              0) {
                                                            haveImage = false;
                                                          }
                                                        });
                                                      },
                                                    )
                                                  ])
                                            : Container(
                                                padding: EdgeInsets.all(
                                                    Measurements.width * 0.02),
                                                child: Container(
                                                    height:
                                                        Measurements.height *
                                                            0.07,
                                                    width: Measurements.height *
                                                        0.07,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: InkWell(
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors.white
                                                            .withOpacity(0.7),
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
                    child: Container(
                      child: Form(
                        key: fKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            variantOptionsList(),
                            dividerPadding(),
                            variantPrice(),
                            dividerPadding(),
                            variantSale(),
                            dividerPadding(),
                            variantSkuAndBarcode(),
                            dividerPadding(),
                            variantInventory(),
                            dividerPadding(),
                            variantDescription(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget dividerPadding() {
    return Padding(
      padding: EdgeInsets.only(top: 2.5),
    );
  }

  /// A new row is added is added by default
  addOptionValueToList() {
    setState(() {
      variantOptionValueList.add(VariantOptionValue("", ""));
    });
  }

  Widget variantOptionsList() {
    return Container(
      child: Column(
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              itemCount: variantOptionValueList.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 1),
                  child: Row(children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            horizontal: Measurements.width * 0.025),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16))),
                        width: Measurements.width * 0.5475,
                        height: Measurements.height *
                            (widget.parts.isTablet ? 0.05 : 0.07),
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeTabContent()),
                          initialValue:
                              widget.onEdit ? currentVariant.title : "",
                          inputFormatters: [
                            WhitelistingTextInputFormatter(
                                RegExp("[a-z A-Z 0-9]"))
                          ],
                          decoration: InputDecoration(
//                                          errorText: Language.getProductStrings(
//                                              "variantEditor.placeholders.name"),
//                                          errorStyle: TextStyle(color: Colors.red),
//                                          hintText: Language.getProductStrings(
//                                              "variantEditor.placeholders.name"),
                            hintText: "Option name",
                            hintStyle: TextStyle(
                                color: nameError
                                    ? Colors.red
                                    : Colors.white.withOpacity(0.5)),
                            border: InputBorder.none,
                          ),
                          onSaved: (name) {
                            currentVariant.title = name;
                            currentVariant.onSales = onSale;

                            print(
                                "currentVariant.titleOnSaved: ${currentVariant.title}");
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                nameError = true;
                              });
                            } else {
                              setState(() {
                                nameError = false;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2.5),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            horizontal: Measurements.width * 0.025),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16))),
                        width: Measurements.width * 0.5475,
                        height: Measurements.height *
                            (widget.parts.isTablet ? 0.05 : 0.07),
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeTabContent()),
                          initialValue:
                              widget.onEdit ? currentVariant.title : "",
                          inputFormatters: [
                            WhitelistingTextInputFormatter(
                                RegExp("[a-z A-Z 0-9]"))
                          ],
                          decoration: InputDecoration(
//                                          hintText: Language.getProductStrings(
//                                              "variantEditor.placeholders.name"),
                            hintText: "Option value",
                            hintStyle: TextStyle(
                                color: nameError
                                    ? Colors.red
                                    : Colors.white.withOpacity(0.5)),
                            border: InputBorder.none,
                          ),
                          onSaved: (name) {
                            currentVariant.title = name;
                            currentVariant.onSales = onSale;

                            print(
                                "currentVariant.titleOnSaved: ${currentVariant.title}");
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                nameError = true;
                              });
                            } else {
                              setState(() {
                                nameError = false;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2.5),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                            padding: EdgeInsets.all(16),
                            child: SvgPicture.asset(
                                "assets/images/xsinacircle.svg")),
                        onTap: () {
                          setState(() {
                            if (variantOptionValueList.length > 1) {
                              variantOptionValueList.removeAt(index);
                            }
                          });
                        },
                      ),
                    ),
                  ]),
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 15,
                ),
                child: InkWell(
                  child: Text(
                    "+ Add option",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    addOptionValueToList();
                    print("new option added");
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget variantPrice() {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16),
                  )),
              padding:
                  EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
              alignment: Alignment.center,
              height:
                  Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
              child: TextFormField(
                style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
                initialValue:
                    widget.onEdit ? currentVariant.price.toString() : "",
                decoration: InputDecoration(
                  hintText: Language.getProductStrings(
                      "variantEditor.placeholders.price"),
                  hintStyle: TextStyle(
                      color: priceError
                          ? Colors.red
                          : Colors.white.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[0-9.]"))
                ],
                keyboardType: TextInputType.number,
                onSaved: (price) {
                  currentVariant.price = num.parse(price);
                },
                validator: (value) {
                  if (value.isEmpty || num.parse(value) >= 1000000) {
                    setState(() {
                      priceError = true;
                    });
                    return;
                  } else if (value.split(".").length > 2) {
                    setState(() {
                      priceError = true;
                    });
                  } else {
                    setState(() {
                      priceError = false;
                    });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget variantSale() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
              alignment: Alignment.center,
              color: Colors.white.withOpacity(0.05),
              height:
                  Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
              child: TextFormField(
                style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[0-9.]"))
                ],
                keyboardType: TextInputType.number,
                initialValue: widget.onEdit && currentVariant.salePrice != null
                    ? currentVariant.salePrice.toString()
                    : "",
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Language.getProductStrings(
                      "variantEditor.placeholders.sale_price"),
                  hintStyle: TextStyle(
                      color: onSaleError
                          ? Colors.red
                          : Colors.white.withOpacity(0.5)),
                ),
                onSaved: (salePrice) {
                  currentVariant.salePrice =
                      salePrice.isEmpty ? null : num.parse(salePrice);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      onSaleError = true;
                    });
                    return;
                  } else if (value.split(".").length > 2) {
                    setState(() {
                      onSaleError = true;
                    });
                  } else {
                    setState(() {
                      onSaleError = false;
                    });
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.5),
          ),
          Expanded(
            flex: 2,
            child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Measurements.width * 0.025),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(16))),
                width: Measurements.width * 0.3475,
                height:
                    Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                        child: AutoSizeText(
                            Language.getProductStrings("price.sale"),
                            style: TextStyle(
                                fontSize: AppStyle.fontSizeTabContent()))),
                    Switch(
                      activeColor: widget.parts.switchColor,
                      value: onSale,
                      onChanged: (value) {
                        setState(() {
                          onSale = value;
                        });
                      },
                    )
                  ],
                )),
          ),
        ],
      ),
      // width: Measurements.width *0.9,
    );
  }

  Widget variantSkuAndBarcode() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
              ),
              height:
                  Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
              child: TextFormField(
                style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
                onSaved: (sku) {
                  currentVariant.sku = sku;
                },
                validator: (sku) {
                  if (sku.isEmpty) {
                    setState(() {
                      skuError = true;
                    });
                  } else {
                    setState(() {
                      skuError = false;
                    });
                  }
                },
                initialValue: widget.onEdit ? currentVariant.sku : "",
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]"))
                ],
                decoration: InputDecoration(
                  hintText: Language.getProductStrings(
                      "variantEditor.placeholders.sku"),
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: skuError
                          ? Colors.red
                          : Colors.white.withOpacity(0.5)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.5),
          ),
          Expanded(
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
              ),
              height:
                  Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
              child: TextFormField(
                style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
                onSaved: (bar) {
                  currentVariant.barcode = bar;
                },
                initialValue: widget.onEdit ? currentVariant.barcode : "",
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]"))
                ],
                decoration: InputDecoration(
                  hintText: Language.getProductStrings(
                      "variantEditor.placeholders.barcode"),
                  border: InputBorder.none,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget variantInventory() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    horizontal: Measurements.width * 0.025),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                ),
                height:
                    Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Switch(
                      activeColor: widget.parts.switchColor,
                      value: trackInv,
                      onChanged: (bool value) {
                        setState(() {
                          trackInv = value;
                        });
                      },
                    ),
                    Expanded(
                      child: AutoSizeText(
                        Language.getProductStrings(
                            "info.placeholders.inventoryTrackingEnabled"),
                        minFontSize: 12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )),
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.5),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
              ),
              height:
                  Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
              child: TextFormField(
                style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[0-9.]"))
                ],
                onFieldSubmitted: (qtt) {
                  inv = num.parse(qtt ?? "0");
                },
                onSaved: (value) {
                  print("value =  $value");
                  amount = num.parse(value);
                },
                textAlign: TextAlign.center,
                // controller: TextEditingController(
                //   text: "${widget.inv ?? 0}",
                // ),
                controller: textEditingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (num.parse(textEditingController.text) > 0)
                          textEditingController.text =
                              (num.parse(textEditingController.text) - 1)
                                  .toString();
                      });
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        textEditingController.text =
                            (num.parse(textEditingController.text) + 1)
                                .toString();
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget variantDescription() {
    return Container(
      height: Measurements.height * 0.2,
      padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      child: TextFormField(
        style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
        inputFormatters: [
          WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]"))
        ],
        initialValue: widget.onEdit ? currentVariant.description : "",
        maxLines: 100,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelStyle: TextStyle(
            color:
                descriptionError ? Colors.red : Colors.white.withOpacity(0.5),
          ),
          labelText: Language.getProductStrings(
              "variantEditor.placeholders.description"),
        ),
        onSaved: (description) {
          currentVariant.description = description;
        },
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              descriptionError = true;
            });
            return;
          } else {
            setState(() {
              descriptionError = false;
            });
          }
        },
      ),
    );
  }
}

class VariantOptionValue {
  String optionName;
  String optionValue;

  VariantOptionValue(this.optionName, this.optionValue);
}

// ^OLD VERSION
//
//
//
//
// NEW VERSION ->

class VariantImageSelector extends StatefulWidget {
  final ProductVariantModel variantModel;

  const VariantImageSelector({this.variantModel});

  @override
  _VariantImageSelectorState createState() => _VariantImageSelectorState();
}

class _VariantImageSelectorState extends State<VariantImageSelector> {
  ProductVariantModel productProvider;
  String currentImage;

  Future getImage(ProductVariantModel _currentVariant) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image?.existsSync() ?? false)
      setState(
        () {
          ProductsApi api = ProductsApi();
          api
              .postImage(
                  image,
                  Provider.of<GlobalStateModel>(context).currentBusiness.id,
                  GlobalUtils.activeToken.accessToken)
              .then((dynamic res) {
            _currentVariant.images.add(res["blobName"]);
            if (currentImage == null) {
              currentImage = res["blobName"];
            }
            setState(() {});
          }).catchError(
            (onError) {
              setState(
                () {
                  print(onError);
                },
              );
            },
          );
        },
      );
  }

  @override
  void initState() {
    super.initState();
    if (widget.variantModel.images.isNotEmpty)
      currentImage = widget.variantModel?.images[0] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    productProvider = widget.variantModel;
    GlobalStateModel globalProvider = Provider.of<GlobalStateModel>(context);
    return (productProvider?.images?.isEmpty ?? true)
        ? InkWell(
            child: Container(
              height: globalProvider.isTablet ? 400 : 200,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(
                        "assets/images/insertimageicon.svg",
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        Language.getProductStrings("pictures.add_image"),
                        style: TextStyle(
                          fontSize: AppStyle.fontSizeTabTitle(),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => getImage(productProvider),
          )
        : Container(
            height: globalProvider.isTablet ? 400 : 300,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(
                          Env.storage + "/products/" + currentImage,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: globalProvider.isTablet ? 100 : 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productProvider.images.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      return index != productProvider.images.length
                          ? Stack(
                              alignment: Alignment.topRight,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: InkWell(
                                    child: Container(
                                      height:
                                          globalProvider.isTablet ? 100 : 70,
                                      width: globalProvider.isTablet ? 90 : 65,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            Env.storage +
                                                "/products/" +
                                                productProvider.images[index],
                                          ),
                                        ),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(
                                        () {
                                          currentImage =
                                              productProvider.images[index];
                                        },
                                      );
                                    },
                                  ),
                                ),
                                InkWell(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 12,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(
                                      () {
                                        if((index == (productProvider.images.length -1)) && index != 0){
                                          currentImage = productProvider.images[index -1];
                                        }else if (index == 0 && productProvider.images.length>1 ){
                                          currentImage = productProvider.images[1];
                                        }
                                        productProvider.images.removeAt(index);
                                      },
                                    );
                                  },
                                ),
                              ],
                            )
                          : Container(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                height: globalProvider.isTablet ? 100 : 70,
                                width: globalProvider.isTablet ? 90 : 65,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: InkWell(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  onTap: () => getImage(
                                    productProvider,
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                )
              ],
            ),
          );
  }
}

class VariantBody extends StatefulWidget {
  @override
  _VariantBodyState createState() => _VariantBodyState();
}

class _VariantBodyState extends State<VariantBody> {
  @override
  Widget build(BuildContext context) {
    ProductStateModel productProvider = Provider.of<ProductStateModel>(context);
    SlidableController slidableController = SlidableController();
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            child: ListView.builder(
              itemCount: productProvider.editProduct.variants?.length ?? 0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    Variant(
                      variant: productProvider.editProduct.variants[index],
                      index: index,
                      action: () {
                        productProvider.editProduct.variants.removeAt(index);
                        productProvider.notifyListeners();
                      },
                      slidableController: slidableController,
                    ),
                    Divider(
                      height: 2,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  highlightColor: Colors.transparent,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(25.0),
                    child: Text(
                      Language.getProductStrings("variantEditor.add_variant"),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: VariantEditor(
                          index:
                              productProvider.editProduct.variants.length - 1,
                          onCreate: true,
                        ),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Variant extends StatelessWidget {
  final ProductVariantModel variant;
  final int index;
  final VoidCallback action;
  final SlidableController slidableController;
  Variant({
    this.variant,
    @required this.index,
    this.action,
    this.slidableController,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> _options = List();
    for (var _option in variant.options) {
      _options.add(
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.white),
            children: [
              TextSpan(
                text: "${_option.name}: ",
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
              TextSpan(
                text: "${_option.value}",
              ),
            ],
          ),
        ),
      );
    }
    return Slidable(
      key: Key(variant.id),
      controller: slidableController,
      child: InkWell(
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Container(
            height: 59,
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: (variant.images?.isEmpty ?? true)
                        ? Colors.grey.withOpacity(0.2)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: (variant.images?.isNotEmpty ?? false)
                          ? NetworkImage(
                              Env.storage + "/products/" + variant.images[0],
                            )
                          : MemoryImage(kTransparentImage),
                    ),
                  ),
                  height: 45,
                  width: 45,
                  alignment: Alignment.center,
                  child: (variant.images?.isEmpty ?? true)
                      ? SvgPicture.asset(
                          "assets/images/noimage.svg",
                          color: Colors.white.withOpacity(0.5),
                        )
                      : Container(),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Wrap(
                      spacing: 5,
                      children: _options,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text:
                                "${Provider.of<ProductStateModel>(context).inventories[variant.sku]?.newAmount ?? Provider.of<ProductStateModel>(context).inventories[variant.sku]?.amount ?? 0} ",
                          ),
                          TextSpan(
                            text: "items",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                        "${variant.price}${Measurements.currency(Provider.of<GlobalStateModel>(context).currentBusiness.currency)}"),
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              child: VariantEditor(
                index: index,
                onCreate: false,
                images: variant.images.toList(),
                barcode: variant.barcode,
                onSales: variant.onSales,
                options: variant.options.toList(),
                description: variant.description,
                amount: Provider.of<ProductStateModel>(context)
                    .inventories[variant.sku]
                    .amount,
                newAmount: Provider.of<ProductStateModel>(context)
                    .inventories[variant.sku]
                    .newAmount,
                tracking: Provider.of<ProductStateModel>(context)
                    .inventories[variant.sku]
                    .tracking,
                sku: variant.sku,
                price: variant.price,
                salePrice: variant.salePrice,
              ),
              type: PageTransitionType.fade,
            ),
          );
        },
      ),
      actionExtentRatio: 0.25,
      actionPane: SlidableScrollActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          // caption: Language.getProductStrings("delete"),
          color: Colors.redAccent,
          iconWidget: Text(Language.getProductStrings("delete")),
          // foregroundColor: Colors.redAccent.withOpacity(0.8),
          onTap: action,
        ),
      ],
    );
  }
}

class VariantEditor extends StatefulWidget {
  final int index;
  final bool onCreate;
  String id;
  String businessUuid;
  String title;
  String description;
  bool onSales;
  num price;
  num salePrice;
  String sku;
  String barcode;
  var hiddenIndex;
  var tracking;
  var amount;
  var newAmount;
  List<Option> options;
  List<String> images = List();
  VariantEditor({
    @required this.index,
    @required this.onCreate,
    this.id,
    this.businessUuid,
    this.title,
    this.description,
    this.onSales = false,
    this.price,
    this.salePrice,
    this.sku,
    this.images,
    this.barcode,
    this.hiddenIndex,
    this.tracking = false,
    this.amount,
    this.newAmount,
    this.options,
  }) {
    variant = ProductVariantModel(
      images: images ?? List(),
      options: options?.toList() ?? List(),
      id: id ?? Uuid().v4(),
      businessUuid: businessUuid,
      title: title,
      description: description,
      onSales: onSales,
      price: price,
      salePrice: salePrice,
      sku: sku,
      barcode: barcode,
    );
    inventory = Inventory(
      barcode: barcode,
      hiddenIndex: index + 1,
      sku: sku,
      tracking: tracking,
      amount: amount,
      newAmount: newAmount,
    );
  }
  Inventory inventory;
  ProductVariantModel variant;

  @override
  _VariantEditorState createState() => _VariantEditorState();
}

class _VariantEditorState extends State<VariantEditor> {
  bool priceError = false;
  bool salePriceError = false;
  bool skuError = false;
  bool descError = false;
  @override
  Widget build(BuildContext context) {
    return BackgroundBase(
      true,
      appBar: CustomAppBar(
        title: Text("Editor"),
        onTap: () {
          Navigator.pop(context);
        },
        actions: <Widget>[
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              child: Text("Save"),
            ),
            onTap: () {
              ProductStateModel productStateModel =
                  Provider.of<ProductStateModel>(context);

              try {
                productStateModel.variantFormKey.currentState.save();
                productStateModel.variantFormKey.currentState.validate();
                widget.variant.options.forEach(
                  (option) {
                    if (widget.variant.options.first != option) {
                      if (option.name.isEmpty) {
                        widget.variant.options.remove(option);
                      }
                    }
                  },
                );
                if (widget.onCreate) {
                  ProductsApi api = ProductsApi();
                  api
                      .checkSKU(
                    Provider.of<GlobalStateModel>(context).currentBusiness.id,
                    GlobalUtils.activeToken.accessToken,
                    widget.inventory.sku,
                  )
                      .then(
                    (onValue) {
                      skuError = true;
                      Scaffold.of(
                        productStateModel.variantFormKey.currentContext,
                      ).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          content: Text(
                            "invalid sku",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ).catchError(
                    (onError) {
                      productStateModel.addInventory(widget.inventory);
                      productStateModel.editProduct.variants
                          .add(widget.variant);
                      Navigator.pop(context);
                    },
                  );
                } else {
                  productStateModel.deleteInventory(widget.sku);
                  productStateModel.editProduct.variants.removeAt(widget.index);
                  productStateModel.addInventory(widget.inventory);
                  productStateModel.editProduct.variants
                      .insert(widget.index, widget.variant);
                  Navigator.pop(context);
                }
              } catch (e) {
                Scaffold.of(productStateModel.variantFormKey.currentContext)
                    .showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    content: Text(
                      "mandatory fields",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: Provider.of<ProductStateModel>(context).variantFormKey,
          child: ListView(
            children: <Widget>[
              VariantImageSelector(
                variantModel: widget.variant,
              ),
              OptionsRow(
                index: widget.index,
                variant: widget.variant,
              ),
              PriceRow(
                variant: widget.variant,
              ),
              SalesRow(
                variant: widget.variant,
              ),
              SkuNCodeRow(
                inventory: widget.inventory,
                variant: widget.variant,
              ),
              Row(
                children: <Widget>[
                  CustomSwitchField(
                    flex: 3,
                    value: widget.inventory.tracking,
                    bottomLeft: true,
                    text: Language.getProductStrings(
                        "info.placeholders.inventoryTrackingEnabled"),
                    onChange: (bool track) {
                      setState(() => widget.inventory.tracking = track);
                    },
                  ),
                  CustomInventoryField(
                    flex: 2,
                    bottomRight: true,
                    text: Language.getProductStrings(
                        "info.placeholders.inventory"),
                    controller: TextEditingController(
                        text: (widget.inventory.newAmount ??
                                    widget.inventory?.amount)
                                ?.toString() ??
                            ""),
                    onChange: (String text) {
                      num stock = num.tryParse(text) ?? 0;
                      widget.inventory.newAmount = stock;
                    },
                    validator: (String text) {
                      return null;
                    },
                  ),
                ],
              ),
              DescriptionRow(
                variant: widget.variant,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DescriptionRow extends StatefulWidget {
  final variant;

  const DescriptionRow({this.variant});
  @override
  _DescriptionRowState createState() => _DescriptionRowState();
}

class _DescriptionRowState extends State<DescriptionRow> {
  bool descError = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CustomFormField(
          text: Language.getProductStrings(
              "variantEditor.placeholders.description"),
          long: true,
          error: descError,
          bottomRight: true,
          bottomLeft: true,
          controller:
              TextEditingController(text: widget.variant.description ?? ""),
          onChange: (String text) {
            widget.variant.description = text;
          },
          validator: (String text) {
            setState(
              () {
                descError = (true && text.isEmpty);
              },
            );
            return descError ? true : null;
          },
        ),
      ],
    );
  }
}

class OptionsRow extends StatelessWidget {
  final int index;
  final ProductVariantModel variant;

  const OptionsRow({this.index, this.variant});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        VariantOptions(
          varIndex: index,
          variant: variant,
        ),
      ],
    );
  }
}

class PriceRow extends StatefulWidget {
  final ProductVariantModel variant;
  const PriceRow({this.variant});

  @override
  _PriceRowState createState() => _PriceRowState();
}

class _PriceRowState extends State<PriceRow> {
  bool priceError = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CustomFormField(
          text: Language.getProductStrings("variantEditor.placeholders.price"),
          topRight: true,
          topLeft: true,
          format: FieldType.numbers,
          error: priceError,
          controller: TextEditingController(
              text: widget.variant.price?.toString() ?? ""),
          onChange: (String text) {
            widget.variant.price = num.tryParse(text);
          },
          validator: (String text) {
            setState(
              () {
                priceError = (true && text.isEmpty);
              },
            );
            return priceError ? true : null;
          },
        ),
      ],
    );
  }
}

class SkuNCodeRow extends StatefulWidget {
  final variant;
  final inventory;

  const SkuNCodeRow({this.variant, this.inventory});

  @override
  _SkuNCodeRowState createState() => _SkuNCodeRowState();
}

class _SkuNCodeRowState extends State<SkuNCodeRow> {
  bool skuError = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CustomFormField(
          format: FieldType.sku,
          text: Language.getProductStrings("variantEditor.placeholders.sku"),
          error: skuError,
          controller: TextEditingController(text: widget.variant.sku ?? ""),
          onChange: (String text) {
            widget.variant.sku = text;
            widget.inventory.sku = text;
          },
          validator: (String text) {
            setState(
              () {
                skuError = (true && text.isEmpty);
              },
            );
            return skuError ? true : null;
          },
        ),
        CustomFormField(
          text:
              Language.getProductStrings("variantEditor.placeholders.barcode"),
          controller: TextEditingController(text: widget.variant.barcode ?? ""),
          onChange: (String text) {
            widget.inventory.barcode = text;
            widget.variant.barcode = text;
          },
          validator: (String text) {
            return null;
          },
        ),
      ],
    );
  }
}

class SalesRow extends StatefulWidget {
  final ProductVariantModel variant;
  const SalesRow({this.variant});

  @override
  _SalesRowState createState() => _SalesRowState();
}

class _SalesRowState extends State<SalesRow> {
  bool salePriceError = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CustomFormField(
          text: Language.getProductStrings(
              "variantEditor.placeholders.sale_price"),
          flex: 3,
          mandatory: widget.variant.onSales ?? false,
          format: FieldType.numbers,
          error: salePriceError,
          controller: TextEditingController(
              text: widget.variant.salePrice?.toString() ?? ""),
          onChange: (String text) {
            widget.variant.salePrice = num.tryParse(text);
          },
          validator: (String text) {
            setState(
              () {
                salePriceError = (widget.variant.onSales && text.isEmpty);
              },
            );
            return salePriceError ? true : null;
          },
        ),
        CustomSwitchField(
          flex: 2,
          value: widget.variant.onSales ?? false,
          text: Language.getProductStrings("price.sale"),
          onChange: (text) {
            setState(
              () {
                widget.variant.onSales = text;
              },
            );
          },
        ),
      ],
    );
  }
}

class VariantOptions extends StatefulWidget {
  final int varIndex;
  ProductVariantModel variant;

  VariantOptions({this.varIndex, this.variant}) {
    if (variant.options.isEmpty) {
      variant.options.add(Option(name: "", value: ""));
    }
  }
  @override
  _VariantOptionsState createState() => _VariantOptionsState();
}

class _VariantOptionsState extends State<VariantOptions> {
  @override
  Widget build(BuildContext context) {
    removeOption(int option) {
      if (widget.variant.options.length > 1) {
        widget.variant.options.removeAt(option);
      } else {
        widget.variant.options.removeAt(option);
        widget.variant.options.add(Option(name: "", value: ""));
      }
    }

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.variant.options.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return OptionItem(
                  option: widget.variant.options[index],
                  action: () {
                    setState(
                      () => removeOption(index),
                    );
                  },
                  index: index,
                  top: index == 0,
                  bot: index == widget.variant.options.length - 1,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                highlightColor: Colors.transparent,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 15,
                  ),
                  child: Text("+ Add Option"),
                ),
                onTap: () {
                  setState(
                    () {
                      widget.variant.options.add(
                        Option(
                          name: "",
                          value: "",
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OptionItem extends StatefulWidget {
  Option option;
  final bool top;
  final bool bot;
  final VoidCallback action;
  final int index;
  OptionItem({
    this.option,
    this.top = false,
    this.bot = false,
    this.action,
    this.index,
  });

  @override
  _OptionItemState createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem> {
  bool errorV = false;
  bool errorN = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CustomFormField(
          text: "Option name",
          topLeft: widget.top,
          bottomLeft: widget.bot,
          error: errorN,
          controller: TextEditingController(text: widget.option?.name ?? ""),
          onChange: (String text) {
            widget.option.name = text;
          },
          validator: (String text) {
            setState(
              () {
                errorN = (text.isEmpty && (widget.index == 0)) ||
                    (widget.option.value.isNotEmpty && text.isEmpty);
              },
            );
            return errorN ? true : null;
          },
        ),
        CustomFormField(
          text: "Option value",
          topRight: widget.top,
          bottomRight: widget.bot,
          error: errorV,
          controller: TextEditingController(text: widget.option?.value ?? ""),
          onChange: (String text) {
            widget.option.value = text;
          },
          validator: (String text) {
            setState(
              () {
                errorV = (text.isEmpty && (widget.index == 0)) ||
                    (text.isEmpty && widget.option.name.isNotEmpty);
              },
            );
            return errorV ? true : null;
          },
        ),
        InkWell(
          child: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: SvgPicture.asset("assets/images/xsinacircle.svg"),
          ),
          onTap: widget.action,
        ),
      ],
    );
  }
}
