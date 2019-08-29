import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

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
              itemCount: widget.parts.product.variants.length,
              itemBuilder: (BuildContext context, int index) {
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
                                child: Text(
                                  "${widget.parts.product.variants[index].title}",
                                  overflow: TextOverflow.ellipsis,
                                )),
                            Container(
                                width: Measurements.width * 0.18,
                                child: Text(
                                    "${widget.parts.product.variants[index].price} ${Measurements.currency(widget.parts.currency)}")),
                            InkWell(
                              highlightColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                  padding: EdgeInsets.all(16),
                                  child: SvgPicture.asset(
                                      "assets/images/xsinacircle.svg")),
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
                    padding: EdgeInsets.all(16),
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
                          editVariant: Variants(),
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
  final Variants editVariant;
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
  Variants currentVariant = Variants();

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

  List<Widget> optionsList = List<Widget>();

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
                            newAmount: amount,
                            barcode: currentVariant.barcode,
                            sku: currentVariant.sku,
                            tracking: trackInv));
                        Navigator.pop(context);
                      });
                    } else {
                      widget.parts.invManager.addInventory(Inventory(
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
                            currentVariant.hidden = !onSale;

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
                            currentVariant.hidden = !onSale;

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
                padding: EdgeInsets.all(8),
                child: InkWell(
                  child: Text(
                    "+ Add Option",
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
              bottomLeft: Radius.circular(16))),
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
                color: descriptionError
                    ? Colors.red
                    : Colors.white.withOpacity(0.5)),
            labelText: Language.getProductStrings(
                "variantEditor.placeholders.description")),
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
