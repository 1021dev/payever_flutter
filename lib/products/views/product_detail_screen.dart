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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
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

  String wallpaper;
  final TextEditingController shopNameController = TextEditingController();
  bool isError = false;
  bool isButtonPressed = false;
  bool buttonEnabled = false;

  int _selectedSectionIndex = 0;

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
    if (widget.productsModel != null) {
      widget.screenBloc.add(GetProductDetails(productsModel: widget.productsModel));
      _productNameController.text = widget.productsModel.title ?? '';
      _descriptionController.text = widget.productsModel.description;
      _priceController.text = '${widget.productsModel.price ?? 0}';
      _salePriceController.text = '${widget.productsModel.salePrice ?? 0}';
      _skuController.text = '${widget.productsModel.sku ?? ''}';
      _barCodeController.text = '${widget.productsModel.barcode ?? ''}';
      if (widget.productsModel.shipping != null) {
        _weightController.text = '${widget.productsModel.shipping.weight}';
        _widthController.text = '${widget.productsModel.shipping.width}';
        _lengthController.text = '${widget.productsModel.shipping.length}';
        _heightController.text = '${widget.productsModel.shipping.height}';
      }
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
            state.productDetail.type == 'physical' ? _getShippingDetail(state): Container(),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.taxes').toUpperCase(),
              detail: '',
              isExpanded: _selectedSectionIndex == 7,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 7 ? -1 : 7;
                });
              },
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
    String imgUrl = state.productDetail.images.length > 0 ? state.productDetail.images.first: '';
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

            },
            child: Container(
              height: Measurements.width * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              alignment: Alignment.center,
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

                        },
                        child: Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black12,
                          ),
                          child: Icon(Icons.add),
                        ),
                      ),
                      img != '' ? InkWell(
                        onTap: () {

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
                  child: TextField(
                    controller: _productNameController,
                    onChanged: (String text) {},
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
                        child: TextField(
                          controller: _priceController,
                          onChanged: (String text) {},
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
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
                        child: TextField(
                          controller: _salePriceController,
                          onChanged: (String text) {},
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
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
            child: TextField(
              controller: _descriptionController,
              onChanged: (String text) {},
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
                  child: TextField(
                    controller: _skuController,
                    onChanged: (String text) {},
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
                  child: TextField(
                    controller: _barCodeController,
                    onChanged: (String text) {},
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
              print(variant.price);
              return Container(
                height: 60,
                padding: EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        imgUrl != '' ? CachedNetworkImage(
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
                          errorWidget: (context, url, error) => Container(
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
                          new TextSpan(
                            text: '${variant.price} ${numberFormat.simpleCurrencySymbol(state.productDetail.currency)}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
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

            },
            isExpanded: false,
            type: 'pos',
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          ProductDetailSubSectionHeaderView(
            onTap: () {

            },
            isExpanded: false,
            type: 'shop',
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
                  child: TextField(
                    controller: _weightController,
                    onChanged: (String text) {},
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
                  child: TextField(
                    controller: _widthController,
                    onChanged: (String text) {},
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
                  child: TextField(
                    controller: _lengthController,
                    onChanged: (String text) {},
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
                  child: TextField(
                    controller: _heightController,
                    onChanged: (String text) {},
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
          value: '',
          onSaved: (value) {
          },
          onChanged: (value) {
          },
          dataSource: state.taxes.map((e) {
            return {
              'display': '${e.description} ${e.rate}%',
              'value': '${e.description} ${e.rate}%',
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

              },
              value: !(state.productDetail.hidden ?? false),
            )
          ],
        ),
      ),
    );
  }
}

