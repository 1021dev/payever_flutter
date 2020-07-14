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

  @override
  void initState() {
    if (widget.productsModel != null) {
      widget.screenBloc.add(GetProductDetails(productsModel: widget.productsModel));
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
              isExpanded: false,
              onTap: () {

              },
            ),
            _getMainDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('description.title').toUpperCase(),
              detail: '',
              isExpanded: false,
              onTap: () {

              },
            ),
            _getDescriptionDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.inventory').toUpperCase(),
              detail: '',
              isExpanded: false,
              onTap: () {

              },
            ),
            _getInventoryDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.category').toUpperCase(),
              detail: '',
              isExpanded: false,
              onTap: () {

              },
            ),
            _getCategoryDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.variants').toUpperCase(),
              detail: '',
              isExpanded: false,
              onTap: () {

              },
            ),
            _getVariantsDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.channels').toUpperCase(),
              detail: '',
              isExpanded: false,
              onTap: () {

              },
            ),
            _getChannelDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.shipping').toUpperCase(),
              detail: '',
              isExpanded: false,
              onTap: () {

              },
            ),
            _getShippingDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.taxes').toUpperCase(),
              detail: '',
              isExpanded: false,
              onTap: () {

              },
            ),
            _getTaxesDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.visibility').toUpperCase(),
              detail: '',
              isExpanded: false,
              onTap: () {

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
          ): Container(
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
          Container(
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
          ),
          Container(
            height: 64,
            color: Color(0x80111111),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
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
                      value: false,
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
                          'EUR',
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
                          'EUR',
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
                    value: productTypes[0],
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
                      value: label,
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
                        value: false,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4),
                      ),
                      AutoSizeText(
                        Language.getProductStrings('info.placeholders.inventoryTrackingEnabled'),
                        minFontSize: 10,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
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

                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                        ),
                        Text(
                          '0',
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
  ///                   Product Details - Inventory
  ///---------------------------------------------------------------------------

  Widget _getCategoryDetail(ProductsScreenState state) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Text(
              Language.getProductStrings('info.placeholders.inventory'),
              style: TextStyle(
                color: Colors.white60,
                fontSize: 10,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4, bottom: 4),
          ),
          Container(
            color: Color(0x80111111),
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Tags(
              key: _tagStateKey,
              itemCount: 1,
              alignment: WrapAlignment.start,
              spacing: 4,
              runSpacing: 8,
              itemBuilder: (int index) {
                return ItemTags(
                  key: Key('filterItem$index'),
                  index: index,
                  title: 'text',
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
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
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
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        color: Color(0x80111111),
        padding: EdgeInsets.only(left: 16, right: 16),
        child: DropDownFormField(
          titleText: Language.getProductStrings('price.headings.tax'),
          hintText: Language.getProductStrings('price.headings.tax'),
          value: '',
          onSaved: (value) {
          },
          onChanged: (value) {
          },
          dataSource: [
            {
              "display": "Running",
              "value": "Running",
            },
            {
              "display": "Climbing",
              "value": "Climbing",
            },
          ],
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
              value: false,
            )
          ],
        ),
      ),
    );
  }
}

