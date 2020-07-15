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

List<String> productConditionOptions = [
  'No Conditions',
  'All Conditions',
  'Any Condition',
];
final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

// ignore: must_be_immutable
class CollectionDetailScreen extends StatefulWidget {

  ProductsScreenBloc screenBloc;
  String businessId;
  CollectionModel collection;
  bool fromDashBoard;

  CollectionDetailScreen({
    this.screenBloc,
    this.businessId,
    this.collection,
    this.fromDashBoard = false,
  });

  @override
  createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  String imageBase = Env.storage + '/images/';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final formatter = new NumberFormat('###,###,###.00', 'en_US');

  String wallpaper;
  bool isError = false;
  bool isButtonPressed = false;
  bool buttonEnabled = false;

  int _selectedSectionIndex = 0;

  TextEditingController _collectionTitleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  NumberFormat numberFormat = NumberFormat();

  @override
  void initState() {
    if (widget.collection != null) {
      widget.screenBloc.add(GetCollectionDetail(collection: widget.collection));

      _collectionTitleController.text = widget.collection.name;
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
            widget.collection != null ? Language.getProductStrings('Edit Collection'): Language.getProductStrings('Add Collection'),
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
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getMainDetail(state,),
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
            _getDescriptionDetail(state,),
            ProductDetailHeaderView(
              title: Language.getProductListStrings('products').toUpperCase(),
              detail: '',
              isExpanded: _selectedSectionIndex == 2,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 2 ? -1 : 2;
                });
              },
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getProductsList(state,)
          ],
        ),
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Collection Detail - Main
  ///---------------------------------------------------------------------------

  Widget _getMainDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 0) return Container();
    String imgUrl = state.collectionDetail.image ?? '';
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        children: <Widget>[
          imgUrl != '' ? Container(
            height: Measurements.width,
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
                height: Measurements.width,
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
                    'Upload image',
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
          Padding(
            padding: EdgeInsets.only(top: 16),
          ),
          Container(
            height: 64,
            color: Color(0x80111111),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              controller: _collectionTitleController,
              onChanged: (String text) {},
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: Language.getProductStrings('mainSection.form.title.label'),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w200,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Container(
              color: Color(0x80111111),
              padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: state.taxes.length == 0
                  ? Container()
                  : DropDownFormField(
                filled: false,
                titleText: '',
                hintText: Language.getProductStrings('Product must match'),
                value: '',
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
          )
        ],
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Collection Detail - Main
  ///---------------------------------------------------------------------------

  Widget _getDescriptionDetail(ProductsScreenState state) {
    return Container();
  }

  ///---------------------------------------------------------------------------
  ///                   Collection Detail - Main
  ///---------------------------------------------------------------------------

  Widget _getProductsList(ProductsScreenState state) {
    return Container();
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
