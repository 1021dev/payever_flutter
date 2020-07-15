import 'dart:io';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/widgets/product_detail_header.dart';
import 'package:payever/products/widgets/product_detail_subsection_header.dart';
import 'package:payever/shop/models/models.dart';

bool _isPortrait;
bool _isTablet;

List<String> productTypes = [
  'Service',
  'Digital',
  'Physical',
];
final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

// ignore: must_be_immutable
class ProductDetailScreen extends StatefulWidget {

  ProductsScreenBloc screenBloc;
  String businessId;
  ProductsModel productsModel;
  bool fromDashBoard;

  ProductDetailScreen({
    this.screenBloc,
    this.businessId,
    this.productsModel,
    this.fromDashBoard = false,
  });

  @override
  createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String imageBase = Env.storage + '/images/';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final formatter = new NumberFormat('###,###,###.00', 'en_US');

  String wallpaper;
  final TextEditingController shopNameController = TextEditingController();
  bool isError = false;
  bool isButtonPressed = false;
  bool buttonEnabled = false;

  int _selectedSectionIndex = 0;
  bool posExpanded = true;
  bool shopExpanded = true;

  TextEditingController _productNameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _salePriceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _skuController = TextEditingController();
  TextEditingController _barCodeController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _widthController = TextEditingController();
  TextEditingController _lengthController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _taxController = TextEditingController();

  NumberFormat numberFormat = NumberFormat();

  @override
  void initState() {
    widget.screenBloc.add(GetProductDetails(productsModel: widget.productsModel));
    if (widget.productsModel != null) {
//      _productNameController.text = widget.productsModel.title ?? '';
//      _descriptionController.text = widget.productsModel.description;
//      _priceController.text = '${widget.productsModel.price ?? 0}';
//      _salePriceController.text = '${widget.productsModel.salePrice ?? 0}';
//      _skuController.text = '${widget.productsModel.sku ?? ''}';
//      _barCodeController.text = '${widget.productsModel.barcode ?? ''}';
//      if (widget.productsModel.shipping != null) {
//        _weightController.text = '${widget.productsModel.shipping.weight}';
//        _widthController.text = '${widget.productsModel.shipping.width}';
//        _lengthController.text = '${widget.productsModel.shipping.length}';
//        _heightController.text = '${widget.productsModel.shipping.height}';
//      }
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.fromDashBoard) {
      widget.screenBloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    return BlocListener(
      bloc: widget.screenBloc,
      listener: (BuildContext context, ProductsScreenState state) async {
        if (state is ProductsScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is ProductsScreenStateSuccess) {

          if (widget.fromDashBoard) {
            Navigator.pop(context, 'refresh');
          } else {
            Navigator.pop(context);
          }
          widget.screenBloc.add(ProductsScreenInitEvent(currentBusinessId: widget.businessId));
        }
      },
      child: BlocBuilder<ProductsScreenBloc, ProductsScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, ProductsScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _appBar(ProductsScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            widget.productsModel != null ? Language.getProductStrings('edit_product'): Language.getProductStrings('add_product'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            height: 32,
            elevation: 0,
            minWidth: 0,
            color: Colors.black,
            child: Text(
              Language.getProductStrings('cancel'),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 8),
        ),
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 0,
            minWidth: 0,
            color: Colors.white24,
            child: Text(
              Language.getProductStrings('save'),
            ),
            onPressed: () {
              Navigator.pop(context);
              if (state.productDetail != null) {
                if (state.productDetail.sku == '') {

                } else {
                  widget.screenBloc.add(SaveProductDetail(productsModel: state.productDetail));
                }
              }
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _body(ProductsScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(state),
      body: SafeArea(
        child: BackgroundBase(
          true,
          body: Form(
            key: formKey,
            autovalidate: false,
            child: Container(
              color: Color(0xff2c2c2c),
              alignment: Alignment.center,
              child: Container(
                width: Measurements.width,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: _getBody(state),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Sections Body
  ///---------------------------------------------------------------------------

  Widget _getBody(ProductsScreenState state) {
    List<Tax> taxes = state.taxes;
    num vatRate = state.productDetail != null ? (state.productDetail.vatRate ?? 0): 0;
    Tax tax;
    if (state.taxes.length > 0) {
      List<Tax> vats = taxes.where((element) => vatRate == element.rate).toList();
      if (vats.length > 0) {
        tax = vats.first;
      }
    }
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.main').toUpperCase(),
              detail: '',
              isExpanded: _selectedSectionIndex == 0,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 0 ? -1 : 0;
                });
              },
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getMainDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('description.title').toUpperCase(),
              detail: '',
              isExpanded: _selectedSectionIndex == 1,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 1 ? -1 : 1;
                });
              },
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getDescriptionDetail(state),
            state.inventory != null ? ProductDetailHeaderView(
              title: Language.getProductStrings('sections.inventory').toUpperCase(),
              detail: '',
              isExpanded: _selectedSectionIndex == 2,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 2 ? -1 : 2;
                });
              },
            ): Container(),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            state.inventory != null ? _getInventoryDetail(state): Container(),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.category').toUpperCase(),
              detail: state.productDetail.categories.length > 0 ? '${state.productDetail.categories.map((e) => e.title).toList().join(', ')}': '',
              isExpanded: _selectedSectionIndex == 3,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 3 ? -1 : 3;
                });
              },
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getCategoryDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.variants').toUpperCase(),
              detail: state.productDetail.variants != null ? '${state.productDetail.variants.length} ${Language.getProductStrings('sections.variants').toLowerCase()}': '',
              isExpanded: _selectedSectionIndex == 4,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 4 ? -1 : 4;
                });
              },
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getVariantsDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.channels').toUpperCase(),
              detail: 'channel',
              isExpanded: _selectedSectionIndex == 5,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 5 ? -1 : 5;
                });
              },
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getChannelDetail(state),
            state.productDetail.type == 'physical' ? ProductDetailHeaderView(
              title: Language.getProductStrings('sections.shipping').toUpperCase(),
              detail: state.productDetail.shipping != null
                  ? '${state.productDetail.shipping.weight} ${Language.getProductStrings('shipping.placeholders.weight')} (${state.productDetail.shipping.width} * ${state.productDetail.shipping.length} * ${state.productDetail.shipping.height})'
                  : '',
              isExpanded: _selectedSectionIndex == 6,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 6 ? -1 : 6;
                });
              },
            ): Container(),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            state.productDetail.type == 'physical' ? _getShippingDetail(state): Container(),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.taxes').toUpperCase(),
              detail: tax != null
                  ? '${tax.description} ${tax.rate}%'
                  : '',
              isExpanded: _selectedSectionIndex == 7,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 7 ? -1 : 7;
                });
              },
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getTaxesDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.visibility').toUpperCase(),
              detail: '',
              isExpanded: _selectedSectionIndex == 8,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 8 ? -1 : 8;
                });
              },
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getVisibilityDetail(state),
          ],
        ),
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Main
  ///---------------------------------------------------------------------------

  Widget _getMainDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 0) return Container();
    String imgUrl = '';
    if (state.productDetail == null) {
      return Container();
    }
    imgUrl = state.productDetail.images != null ? (state.productDetail.images.length > 0 ? state.productDetail.images.first: ''): '';
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        children: <Widget>[
          imgUrl != '' ? Container(
            height: Measurements.width * 0.7,
            child: CachedNetworkImage(
              imageUrl: '${Env.storage}/products/$imgUrl',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) =>  Container(
                height: Measurements.width * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset('assets/images/insertimageicon.svg'),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),
                    Text(
                      'Upload images',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ): GestureDetector(
            onTap: () {
              getImage(0);
            },
            child: Container(
              height: Measurements.width * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              alignment: Alignment.center,
              child: state.isUploading ? Container(
                child: Center(child: CircularProgressIndicator()),
              ): Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset('assets/images/insertimageicon.svg'),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  Text(
                    'Upload images',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          state.productDetail.images.length > 0 ? Container(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
                top: 8,
                bottom: 8,
              ),
              itemBuilder: (context, index) {
                String img = '';
                if (state.productDetail.images.length != index) {
                  img = state.productDetail.images[index];
                }
                return Container(
                  width: 64,
                  height: 64,
                  margin: EdgeInsets.only(left: 4, right: 4),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      img != '' ? CachedNetworkImage(
                        imageUrl: '${Env.storage}/products/$imgUrl',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) =>  Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black12,
                          ),
                          child: Icon(Icons.terrain),
                        ),
                      ): GestureDetector(
                        onTap: () {
                          getImage(0);
                        },
                        child: Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black12,
                          ),
                          child: state.isUploading ? Container(
                            child: Center(child: CircularProgressIndicator()),
                          ): Icon(Icons.add),
                        ),
                      ),
                      img != '' ? InkWell(
                        onTap: () {
                          ProductsModel productModel = state.productDetail;
                          productModel.images.remove(img);
                          widget.screenBloc.add(UpdateProductDetail(
                            increaseStock: state.increaseStock,
                            productsModel: productModel,
                          ));
                        },
                        child: SvgPicture.asset('assets/images/xsinacircle.svg',),
                      ): Container(),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Container();
              },
              itemCount: state.productDetail.images.length + 1,
            ),
          ): Container(),
          Container(
            height: 64,
            color: Color(0x80111111),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: state.productDetail.title ?? '',
                    onChanged: (String text) {
                      ProductsModel product = state.productDetail;
                      product.title = text;
                      widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: state.increaseStock));
                    },
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: Language.getProductStrings('name.title'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      Language.getProductStrings('info.placeholders.inventory'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                    ),
                    CupertinoSwitch(
                      onChanged: (val) {
                        ProductsModel productModel = state.productDetail;
                        productModel.enabled = val;
                        widget.screenBloc.add(
                            UpdateProductDetail(
                              productsModel: productModel,
                              increaseStock: state.increaseStock,
                            )
                        );
                      },
                      value: state.productDetail.enabled ?? false,
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          Container(
            height: 64,
            color: Color(0x80111111),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          initialValue: state.productDetail.price != null ? '${state.productDetail.price}': '0',
                          onChanged: (String text) {
                            ProductsModel product = state.productDetail;
                            product.price = num.parse(text);
                            widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: state.increaseStock));
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: Language.getProductStrings('placeholders.price'),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w200,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        color: Color(0x80555555),
                        padding: EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
                        child: Text(
                          state.productDetail.currency ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          initialValue: state.productDetail.salePrice != null ? '${state.productDetail.salePrice}': '0',
                          onChanged: (String text) {
                            ProductsModel product = state.productDetail;
                            product.salePrice = num.parse(text);
                            widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: state.increaseStock));
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: Language.getProductStrings('placeholders.salePrice'),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w200,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        color: Color(0x80555555),
                        padding: EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
                        child: Text(
                          state.productDetail.currency ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          Container(
            height: 64,
            color: Color(0x80111111),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 4),
                ),
                Text(
                  'Product Type',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    icon: Container(),
                    underline: Container(),
                    isExpanded: true,
                    value: state.productDetail.type ?? 'physical',
                    onChanged: (value) {
                      ProductsModel productModel = state.productDetail;
                      productModel.type = value;
                      widget.screenBloc.add(
                          UpdateProductDetail(
                            productsModel: productModel,
                            increaseStock: state.increaseStock,
                          )
                      );
                    },
                    items: productTypes.map((label) => DropdownMenuItem(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      value: label.toLowerCase(),
                    ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Description
  ///---------------------------------------------------------------------------

  Widget _getDescriptionDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 1) return Container();
    return Container(
      height: 150,
      margin: EdgeInsets.only(top: 16, bottom: 16),
      color: Color(0x80111111),
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              Language.getProductStrings('description.title'),
            ),
          ),
          Expanded(
            child: TextFormField(
              initialValue: state.productDetail.description ?? '',
              onChanged: (String text) {
                ProductsModel product = state.productDetail;
                product.description = text;
                widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: state.increaseStock));
              },
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 10,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Inventory
  ///---------------------------------------------------------------------------

  Widget _getInventoryDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 2) return Container();
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 64,
            color: Color(0x80111111),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: state.productDetail.sku ?? '',
                    onChanged: (String text) {
                      ProductsModel product = state.productDetail;
                      product.sku = text;
                      widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: state.increaseStock));
                    },
                    validator: (text) {
                      if (text.isEmpty){
                        return 'sku required';
                      }
                      return null;
                    },
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: Language.getProductStrings('price.placeholders.skucode'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Expanded(
                  child: TextFormField(
                    onChanged: (String text) {
                      ProductsModel product = state.productDetail;
                      product.barcode = text;
                      widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: state.increaseStock));
                    },
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: Language.getProductStrings('price.placeholders.barcode'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          Container(
            height: 64,
            color: Color(0x80111111),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      CupertinoSwitch(
                        onChanged: (val) {

                        },
                        value: state.inventory.isTrackable,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          Language.getProductStrings('info.placeholders.inventoryTrackingEnabled'),
                          minFontSize: 10,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                    ),
                    Text(
                      Language.getProductStrings('info.placeholders.inventory'),
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            ProductsModel product = state.productDetail;
                            num stock = state.inventory.stock ?? 0 + state.increaseStock;
                            if (stock > 0) {
                              int increase = state.increaseStock - 1;
                              widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: increase));
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                        ),
                        AutoSizeText(
                          '${(state.inventory.stock ?? 0) + state.increaseStock}',
                          minFontSize: 12,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () {
                            ProductsModel product = state.productDetail;
                            int increase = state.increaseStock + 1;
                            widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: increase));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Category
  ///---------------------------------------------------------------------------

  Widget _getCategoryDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 3) return Container();
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: Color(0x80111111),
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Tags(
              key: _tagStateKey,
              textField: TagsTextField(
                hintText: 'Please enter to add a category',
                suggestions: state.categories.map((e) {
                  return e.title;
                }).toList(),

              ),
              itemCount: state.productDetail.categories.length,
              alignment: WrapAlignment.start,
              spacing: 4,
              runSpacing: 8,
              itemBuilder: (int index) {
                return ItemTags(
                  key: Key('filterItem$index'),
                  index: index,
                  title: state.productDetail.categories[index].title,
                  color: Colors.white12,
                  activeColor: Colors.white12,
                  textActiveColor: Colors.white,
                  textColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.only(
                    left: 16, top: 8, bottom: 8, right: 16,
                  ),
                  removeButton: ItemTagsRemoveButton(
                      backgroundColor: Colors.transparent,
                      onRemoved: () {
                        return true;
                      }
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Variants
  ///---------------------------------------------------------------------------

  Widget _getVariantsDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 4) return Container();
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Variants variant = state.productDetail.variants[index];
              String imgUrl = '';
              if (variant.images.length > 0 ) {
                imgUrl = variant.images.first;
              }
              print('${Env.storage}/products/$imgUrl-thumbnail');
              return Container(
                height: 60,
                padding: EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        imgUrl != '' ? CachedNetworkImage(
                          imageUrl: '${Env.storage}/products/$imgUrl-thumbnail',
                          imageBuilder: (context, imageProvider) => Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              image: DecorationImage(
                                image: imageProvider,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            return Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white10,
                              ),
                              child: Center(
                                child: SvgPicture.asset('assets/images/noimage.svg', width: 20, height: 20,),
                              ),
                            );
                          },
                        ) : Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4,),
                            color: Colors.white10,
                          ),
                          child: Center(
                            child: SvgPicture.asset('assets/images/noimage.svg', width: 20, height: 20,),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        Text(
                          '${variant.options.length} item${variant.options.length > 1 ? 's': ''}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        children: [
                          new TextSpan(
                            text: '${variant.price} ${numberFormat.simpleCurrencySymbol(state.productDetail.currency)} ',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          variant.salePrice != null ? new TextSpan(
                            text: '${variant.salePrice} ${numberFormat.simpleCurrencySymbol(state.productDetail.currency)}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ): TextSpan(text: ''),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {

                          },
                          color: Colors.black26,
                          height: 30,
                          elevation: 0,
                          minWidth: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            Language.getProductStrings('edit'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          visualDensity: VisualDensity.comfortable,
                        ),
                        MaterialButton(
                          onPressed: () {

                          },
                          height: 30,
                          elevation: 0,
                          minWidth: 0,
                          shape: CircleBorder(),
                          visualDensity: VisualDensity.comfortable,
                          child: SvgPicture.asset('assets/images/xsinacircle.svg', width: 30, height: 30,),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 0,
                thickness: 0,
                color: Color(0x80888888),
              );
            },
            itemCount: state.productDetail.variants.length,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: MaterialButton(
              child: Text(
                Language.getProductStrings('variantEditor.add_variant'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {

              },
            ),
          )
        ],
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Channels
  ///---------------------------------------------------------------------------

  Widget _getChannelDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 5) return Container();
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ProductDetailSubSectionHeaderView(
            onTap: () {
              setState(() {
                posExpanded = !posExpanded;
              });

            },
            isExpanded: posExpanded,
            type: 'pos',
          ),
          posExpanded ? ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Terminal terminal = state.terminals[index];
              List<ChannelSet> channelSets = state.productDetail.channels ?? [];
              List setList = channelSets.where((element) => element.id == terminal.channelSet).toList() ?? [];
              bool isSet = setList.length > 0;
              return Container(
                height: 60,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      terminal.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    CupertinoSwitch(
                      value: isSet,
                      onChanged: (val) {
                        ProductsModel productDetail = state.productDetail;
                        List<ChannelSet> channelSets = productDetail.channels;
                        if (val) {
                          channelSets.add(ChannelSet(terminal.channelSet, terminal.name, 'pos'));
                        } else {
                          channelSets.removeWhere((element) => element.id == terminal.channelSet);
                        }
                        productDetail.channels = channelSets;
                        widget.screenBloc.add(
                            UpdateProductDetail(
                              productsModel: productDetail,
                              increaseStock: state.increaseStock,
                            )
                        );
                      },
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 0,
                thickness: 0,
                color: Color(0x80888888),
              );
            },
            itemCount: state.terminals.length,
          ): Container(),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          ProductDetailSubSectionHeaderView(
            onTap: () {
              setState(() {
                shopExpanded = !shopExpanded;
              });
            },
            isExpanded: shopExpanded,
            type: 'shop',
          ),
          shopExpanded ? ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              ShopModel shop = state.shops[index];
              List<ChannelSet> channelSets = state.productDetail.channels ?? [];
              List setList = channelSets.where((element) => element.id == shop.channelSet).toList() ?? [];
              bool isSet = setList.length > 0;
              return Container(
                height: 60,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      shop.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    CupertinoSwitch(
                      value: isSet,
                      onChanged: (val) {
                        ProductsModel productDetail = state.productDetail;
                        List<ChannelSet> channelSets = productDetail.channels;
                        if (val) {
                          channelSets.add(ChannelSet(shop.channelSet, shop.name, 'shop'));
                        } else {
                          channelSets.removeWhere((element) => element.id == shop.channelSet);
                        }
                        productDetail.channels = channelSets;
                        widget.screenBloc.add(
                            UpdateProductDetail(
                              productsModel: productDetail,
                              increaseStock: state.increaseStock,
                            )
                        );
                      },
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 0,
                thickness: 0,
                color: Color(0x80888888),
              );
            },
            itemCount: state.shops.length,
          ): Container(),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
        ],
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Channels
  ///---------------------------------------------------------------------------

  Widget _getShippingDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 6) return Container();
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 64,
            color: Color(0x80111111),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: state.productDetail.shipping != null ? '${state.productDetail.shipping.weight ?? 0}': '0',
                    onChanged: (String text) {
                      ProductsModel product = state.productDetail;
                      Shipping shipping = product.shipping ?? Shipping();
                      shipping.weight = num.parse(text);
                      product.shipping = shipping;
                      widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: state.increaseStock));
                    },
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: Language.getProductStrings('shipping.placeholders.weight'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Container(
                  color: Color(0x80555555),
                  width: 40,
                  alignment: Alignment.centerRight,
                  height: 40,
                  padding: EdgeInsets.only(left: 4, right: 8, top: 8, bottom: 8),
                  child: Text(
                    Language.getProductStrings('shippingSection.measure.kg'),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          Container(
            height: 64,
            color: Color(0x80111111),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: state.productDetail.shipping != null ? '${state.productDetail.shipping.width ?? 0}': '0',
                    onChanged: (String text) {
                      ProductsModel product = state.productDetail;
                      Shipping shipping = product.shipping ?? Shipping();
                      shipping.width = num.parse(text);
                      product.shipping = shipping;
                      widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: state.increaseStock));
                    },
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: Language.getProductStrings('shipping.placeholders.width'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Container(
                  color: Color(0x80555555),
                  width: 40,
                  alignment: Alignment.centerRight,
                  height: 40,
                  padding: EdgeInsets.only(left: 4, right: 8, top: 8, bottom: 8),
                  child: Text(
                    Language.getProductStrings('shippingSection.measure.cm'),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          Container(
            height: 64,
            color: Color(0x80111111),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: state.productDetail.shipping != null ? '${state.productDetail.shipping.length ?? 0}': '0',
                    onChanged: (String text) {
                      ProductsModel product = state.productDetail;
                      Shipping shipping = product.shipping ?? Shipping();
                      shipping.length = num.parse(text);
                      product.shipping = shipping;
                      widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: state.increaseStock));
                    },
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: Language.getProductStrings('shipping.placeholders.length'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Container(
                  color: Color(0x80555555),
                  width: 40,
                  alignment: Alignment.centerRight,
                  height: 40,
                  padding: EdgeInsets.only(left: 4, right: 8, top: 8, bottom: 8),
                  child: Text(
                    Language.getProductStrings('shippingSection.measure.cm'),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          Container(
            height: 64,
            color: Color(0x80111111),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: state.productDetail.shipping != null ? '${state.productDetail.shipping.height ?? 0}': '0',
                    onChanged: (String text) {
                      ProductsModel product = state.productDetail;
                      Shipping shipping = product.shipping ?? Shipping();
                      shipping.height = num.parse(text);
                      product.shipping = shipping;
                      widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: state.increaseStock));
                    },
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: Language.getProductStrings('shipping.placeholders.height'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Container(
                  color: Color(0x80555555),
                  width: 40,
                  alignment: Alignment.centerRight,
                  height: 40,
                  padding: EdgeInsets.only(left: 4, right: 8, top: 8, bottom: 8),
                  child: Text(
                    Language.getProductStrings('shippingSection.measure.cm'),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
        ],
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Taxes
  ///---------------------------------------------------------------------------

  Widget _getTaxesDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 7) return Container();
    List<Tax> taxes = state.taxes;
    num vatRate = state.productDetail != null ? (state.productDetail.vatRate ?? 0): 0;
    Tax tax;
    if (state.taxes.length > 0) {
      List<Tax> vats = taxes.where((element) => vatRate == element.rate).toList();
      if (vats.length > 0) {
        tax = vats.first;
      }
    }
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        color: Color(0x80111111),
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: state.taxes.length == 0
            ? Container()
            : DropDownFormField(
          filled: false,
          titleText: '',
          hintText: Language.getProductStrings('price.headings.tax'),
          value: tax != null ? tax.rate: taxes.first.rate,
          onChanged: (value) {
            ProductsModel productModel = state.productDetail;
            productModel.vatRate = value;
            widget.screenBloc.add(
                UpdateProductDetail(
                  productsModel: productModel,
                  increaseStock: state.increaseStock,
                )
            );
          },
          dataSource: state.taxes.map((e) {
            return {
              'display': '${e.description} ${e.rate}%',
              'value': e.rate,
            };
          }).toList(),
          textField: 'display',
          valueField: 'value',
        ),
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Visibility
  ///---------------------------------------------------------------------------

  Widget _getVisibilityDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 8) return Container();
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: 64,
        color: Color(0x80111111),
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              Language.getProductStrings('Show this product'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            CupertinoSwitch(
              onChanged: (val) {
                ProductsModel productModel = state.productDetail;
                productModel.active = val;
                widget.screenBloc.add(
                    UpdateProductDetail(
                      productsModel: productModel,
                      increaseStock: state.increaseStock,
                    )
                );
              },
              value: state.productDetail.active ?? false,
            )
          ],
        ),
      ),
    );
  }

  Future getImage(int type) async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.getImage(
      source: type == 0 ? ImageSource.gallery : ImageSource.camera,
    );
    if (image != null) {
      await _cropImage(File(image.path));
    }
  }

  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    if (croppedFile != null) {
      widget.screenBloc.add(UploadImageToProduct(file: croppedFile));
    }

  }
}
