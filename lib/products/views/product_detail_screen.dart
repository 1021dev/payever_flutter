import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/widgets/product_detail_header.dart';
import 'package:payever/shop/models/models.dart';

bool _isPortrait;
bool _isTablet;

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

  Widget _getBody(ProductsScreenState state) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ProductDetailHeaderView(
              title: 'MAIN',
              detail: 'Detail',
              isExpanded: false,
              onTap: () {

              },
            ),
            _getMainDetail(state),
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
        child: Column(
          children: <Widget>[
            imgUrl != '' ? Container(
              height: Measurements.width * 0.7,
              child: CachedNetworkImage(
                imageUrl: '${Env.storage}/products/$imgUrl}',
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
              height: 64,
              color: Color(0xcc111111),
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
                      decoration: const InputDecoration(
                        hintText: 'Product Name',
                      ),
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

