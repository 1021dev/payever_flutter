import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/products/variants/variants.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/products/models/models.dart';

class EditVariantScreen extends StatefulWidget {

  final Variants variants;
  final ProductsScreenBloc productsScreenBloc;

  EditVariantScreen({this.variants, this.productsScreenBloc,});

  @override
  State<StatefulWidget> createState() {
    return _EditVariantScreenState();
  }
}

class _EditVariantScreenState extends State<EditVariantScreen> {

  VariantsScreenBloc screenBloc;
  bool isLoading = false;

  @override
  void initState() {
    screenBloc = VariantsScreenBloc(productsScreenBloc: widget.productsScreenBloc);
    screenBloc.add(VariantsScreenInitEvent(variants: widget.variants));
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, VariantsScreenState state) async {
        if (state is ProductsScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is ProductsScreenStateSuccess) {}
      },
      child: BlocBuilder<VariantsScreenBloc, VariantsScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, VariantsScreenState state) {
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomPadding: false,
            appBar: _appBar(),
            body: SafeArea(
              child: BackgroundBase(
                true,
                body: Form(
                  key: formKey,
                  autovalidate: false,
                  child: Container(
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
        },
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            'Edit Variant',
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
            child: isLoading ? Center(
              child: Container(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ) : Text(
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

  Widget _getBody(VariantsScreenState state) {
    String imgUrl = '';
    if (state.variants.images.length > 0) {
      imgUrl = widget.variants.images.first;
    }
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: BlurEffectView(
                child: Container(
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
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => CupertinoActionSheet(
                              title: const Text('Choose Photo'),
                              message: const Text('Your options are '),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: const Text('Take a Picture'),
                                  onPressed: () {
                                    Navigator.pop(context, 'Take a Picture');
                                    getImage(0);
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('Camera Roll'),
                                  onPressed: () {
                                    Navigator.pop(context, 'Camera Roll');
                                    getImage(1);
                                  },
                                )
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text('Cancel'),
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context, 'Cancel');
                                },
                              ),
                            ),
                          );
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
                      state.variants.images.length > 0 ? Container(
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
                            if (state.variants.images.length != index) {
                              img = state.variants.images[index];
                            }
                            return Container(
                              width: 64,
                              height: 64,
                              margin: EdgeInsets.only(left: 4, right: 4),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: <Widget>[
                                  img != '' ? CachedNetworkImage(
                                    imageUrl: '${Env.storage}/products/$img',
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
                                      showCupertinoModalPopup(
                                        context: context,
                                        builder: (BuildContext context) => CupertinoActionSheet(
                                          title: const Text('Choose Photo'),
                                          message: const Text('Your options are '),
                                          actions: <Widget>[
                                            CupertinoActionSheetAction(
                                              child: const Text('Take a Picture'),
                                              onPressed: () {
                                                Navigator.pop(context, 'Take a Picture');
                                                getImage(0);
                                              },
                                            ),
                                            CupertinoActionSheetAction(
                                              child: const Text('Camera Roll'),
                                              onPressed: () {
                                                Navigator.pop(context, 'Camera Roll');
                                                getImage(1);
                                              },
                                            )
                                          ],
                                          cancelButton: CupertinoActionSheetAction(
                                            child: const Text('Cancel'),
                                            isDefaultAction: true,
                                            onPressed: () {
                                              Navigator.pop(context, 'Cancel');
                                            },
                                          ),
                                        ),
                                      );
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
//                                      ProductsModel productModel = state.productDetail;
//                                      productModel.images.remove(img);
//                                      widget.screenBloc.add(UpdateProductDetail(
//                                        inventoryModel: state.inventory,
//                                        productsModel: productModel,
//                                      ));
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
                          itemCount: state.variants.images.length + 1,
                        ),
                      ): Container(),
                      ListView.separated(
                        itemCount: widget.variants.options.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return _buildOptionItems(context, index);
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 0,
                            color: Color(0x80888888),
                            thickness: 0.5,
                          );
                        },
                      ),
                      Divider(
                        height: 0,
                        thickness: 0.5,
                        color: Color(0x80888888),
                      ),
                      Container(
                        height: 44,
                        padding: EdgeInsets.only(bottom: 8, right: 8),
                        alignment: Alignment.centerRight,
                        child: MaterialButton(
                          child: Text(
                            Language.getProductStrings('+ Add option'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onPressed: () async {
//                            final result = await Navigator.push(
//                              context,
//                              PageTransition(
//                                child: AddVariantOptionScreen(),
//                                type: PageTransitionType.fade,
//                                duration: Duration(milliseconds: 500),
//                              ),
//                            );
//
//                            if (result != null) {
//                              if (result == 'color') {
//                                setState(() {
//                                  _children.add(TagVariantItem(name: 'Color', type: 'color', values: [], key: '${_children.length}'));
//                                });
//                              } else if (result == 'other') {
//                                setState(() {
//                                  _children.add(TagVariantItem(name: 'Default', type: 'string', values: [], key: '${_children.length}'));
//                                });
//                              }
//                            }
                          },
                        ),
                      ),
                      Container(
                        height: 56,
                        padding: EdgeInsets.only(left: 8, right: 8),
                        margin: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Color(0x80222222),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                        ),
                        child: TextFormField(
                          onTap: () {
                          },
                          onChanged: (val) {

                          },
                          initialValue: '${state.variants.price ?? 0}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                              fillColor: Color(0x80111111),
                              labelText: Language.getProductStrings('Variants price'),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w200,
                              ),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: Container(
                              height: 56,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Color(0x80222222),
                              ),
                              child: TextFormField(
                                onTap: () {
                                },
                                onChanged: (val) {

                                },
                                initialValue: '${state.variants.salePrice ?? 0}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                    fillColor: Color(0x80111111),
                                    labelText: Language.getProductStrings('Variants sale price'),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w200,
                                    ),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 56,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Color(0x80222222),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Sale',
                                  ),
                                  CupertinoSwitch(
                                    onChanged: (val) {

                                    },
                                    value: state.variants.onSales ?? false,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 56,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Color(0x80222222),
                              ),
                              child: TextFormField(
                                onTap: () {
                                },
                                onChanged: (val) {

                                },
                                initialValue: state.variants.sku ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                    fillColor: Color(0x80111111),
                                    labelText: Language.getProductStrings('SKU'),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w200,
                                    ),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 56,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Color(0x80222222),
                              ),
                              child: TextFormField(
                                onTap: () {
                                },
                                onChanged: (val) {

                                },
                                initialValue: state.variants.barcode ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                    fillColor: Color(0x80111111),
                                    labelText: Language.getProductStrings('Barcode'),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w200,
                                    ),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: Container(
                              height: 56,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Color(0x80222222),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      'Should payever track inventory',
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
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 56,
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Color(0x80222222),
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(8)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      Language.getProductStrings('info.placeholders.inventory'),
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        MaterialButton(
                                          padding: EdgeInsets.all(0),
                                          minWidth: 0,
                                          child: Icon(Icons.remove_circle_outline),
                                          onPressed: () {
                                          },
                                        ),
                                        Flexible(
                                          child: AutoSizeText(
                                            '0',
                                            minFontSize: 12,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        MaterialButton(
                                          padding: EdgeInsets.all(0),
                                          minWidth: 0,
                                          child: Icon(Icons.add_circle_outline),
                                          onPressed: () {
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 150,
                        padding: EdgeInsets.only(left: 8, right: 8),
                        margin: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Color(0x80222222),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                        ),
                        child: TextFormField(
                          onTap: () {
                          },
                          onChanged: (val) {

                          },
                          initialValue: state.variants.description ?? '',
                          textInputAction: TextInputAction.newline,
                          maxLines: 10,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                              fillColor: Color(0x80111111),
                              labelText: Language.getProductStrings('Variant description'),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w200,
                              ),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItems(BuildContext context, int index) {
    VariantOption option = widget.variants.options[index];
    return Container(
      margin: EdgeInsets.only(left: 8, top: 4, bottom: 4),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8),
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Color(0x80222222),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
              ),
              child: TextFormField(
                onTap: () {
//                if (isShownColorPicker)
//                  Navigator.pop(context);
//                setState(() {
//                  isShownColorPicker = false;
//                });
                },
                onChanged: (val) {

                },
                initialValue: option.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                    fillColor: Color(0x80111111),
                    labelText: Language.getProductStrings('Option name'),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8),
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Color(0x80222222),
                borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
              ),
              child: TextFormField(
                onTap: () {
//                if (isShownColorPicker)
//                  Navigator.pop(context);
//                setState(() {
//                  isShownColorPicker = false;
//                });
                },
                onChanged: (val) {

                },
                initialValue: option.value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                    fillColor: Color(0x80111111),
                    labelText: Language.getProductStrings('Option value'),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {

            },
            minWidth: 0,
            child: SvgPicture.asset(
              'assets/images/xsinacircle.svg',
            ),
          ),
        ],
      ),
    );
  }

  Future getImage(int type) async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.getImage(
      source: type == 1 ? ImageSource.gallery : ImageSource.camera,
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
//      widget.screenBloc.add(UploadImageToProduct(file: croppedFile));
    }

  }

}