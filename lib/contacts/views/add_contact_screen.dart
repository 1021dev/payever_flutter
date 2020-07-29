import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/connect/models/connect.dart';

bool _isPortrait;
bool _isTablet;

class AddContactScreen extends StatefulWidget {

  final ContactScreenBloc screenBloc;

  AddContactScreen({
    this.screenBloc,
  });

  @override
  createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ContactDetailScreenBloc screenBloc;
  String wallpaper;
  String selectedState = '';
  bool openGeneral = true;
  bool openAdditional = true;
  final String contactPlaceholder = 'https://payeverstage.azureedge.net/placeholders/contact-placeholder.png';

  var imageData;

  Business business;

  @override
  void initState() {
    screenBloc = ContactDetailScreenBloc(contactScreenBloc: widget.screenBloc);
    business = widget.screenBloc.dashboardScreenBloc.state.activeBusiness;

    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
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
      bloc: screenBloc,
      listener: (BuildContext context, ContactDetailScreenState state) async {
        if (state is ContactDetailScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<ContactDetailScreenBloc, ContactDetailScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, ContactDetailScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _appBar(ContactDetailScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Text(
        Language.getPosConnectStrings('Add Contact'),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _body(ContactDetailScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(state),
      body: SafeArea(
        child: BackgroundBase(
          true,
          body: state.isLoading ?
          Center(
            child: CircularProgressIndicator(),
          ): Center(
            child: SingleChildScrollView(
              child: Container(
                width: Measurements.width,
                child: Column(
                  children: <Widget>[
                    _getBody(state),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBody(ContactDetailScreenState state) {

    List<Widget> widgets = [];
    Widget header = Container(
      height: 56,
      color: Colors.black54,
      child: SizedBox.expand(
        child: MaterialButton(
          onPressed: () {
            setState(() {
              openGeneral = !openGeneral;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'GENERAL',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                openGeneral ? Icons.add : Icons.remove,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );

    widgets.add(header);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    // Photo section;
    Widget photoSection = openGeneral ? Container(
        height: Measurements.width * 0.5,
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: true ? SvgPicture.asset('assets/images/add_contacts.svg')
                        : CachedNetworkImage(
                      imageUrl: contactPlaceholder,
                      imageBuilder: (context, imageProvider) => Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xffededf4), Color(0xffaeb0b7)],
                          ),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        child: Center(
                          child: Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>  Container(
                        child: SvgPicture.asset('assets/images/noimage.svg', color: Colors.black54, width: 100, height: 100,),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 120,
                  child: MaterialButton(
                    onPressed: () {
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
                    minWidth: 0,
                    padding: EdgeInsets.all(4),
                    height: 24,
                    color: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset('assets/images/add.svg'),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                          ),
                          Text(
                            'Add Media',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Helvetica Neue',
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
        )
    ) : Container();

    widgets.add(photoSection);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget typeField = openGeneral ? Container(
      height: 64,
      child: Center(
        child: TextFormField(
          style: TextStyle(fontSize: 16),
          onTap: () {

          },
          onChanged: (val) {
            setState(() {
            });
          },
          initialValue: '',
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            labelText: Language.getPosTpmStrings('Type'),
            labelStyle: TextStyle(
              color: Colors.grey,
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 0.5),
            ),
          ),
          keyboardType: TextInputType.text,
        ),
      ),
    ): Container();

    widgets.add(typeField);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget nameSection = openGeneral ? Container(
      height: 64,
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('First Name'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          Container(
            width: 0.5,
            color: Colors.black,
          ),
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Last Name'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ],
      ),
    ): Container();

    widgets.add(nameSection);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget phoneSection = openGeneral ? Container(
      height: 64,
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Mobile Phone'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          Container(
            width: 0.5,
            color: Colors.black,
          ),
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Email'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ],
      ),
    ): Container();

    widgets.add(phoneSection);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget homepageField = openGeneral ? Container(
      height: 64,
      child: Center(
        child: TextFormField(
          style: TextStyle(fontSize: 16),
          onTap: () {

          },
          onChanged: (val) {
            setState(() {
            });
          },
          initialValue: '',
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            labelText: Language.getPosTpmStrings('Homepage'),
            labelStyle: TextStyle(
              color: Colors.grey,
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 0.5),
            ),
          ),
          keyboardType: TextInputType.text,
        ),
      ),
    ): Container();

    widgets.add(homepageField);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget streetField = openGeneral ? Container(
      height: 64,
      child: Center(
        child: TextFormField(
          style: TextStyle(fontSize: 16),
          onTap: () {

          },
          onChanged: (val) {
            setState(() {
            });
          },
          initialValue: '',
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            labelText: Language.getPosTpmStrings('Street'),
            labelStyle: TextStyle(
              color: Colors.grey,
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 0.5),
            ),
          ),
          keyboardType: TextInputType.text,
        ),
      ),
    ): Container();

    widgets.add(streetField);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget citySection = openGeneral ? Container(
      height: 64,
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('City'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          Container(
            width: 0.5,
            color: Colors.black,
          ),
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('State'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ],
      ),
    ): Container();

    widgets.add(citySection);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget zipSection = openGeneral ? Container(
      height: 64,
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Zip'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          Container(
            width: 0.5,
            color: Colors.black,
          ),
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Country'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ],
      ),
    ): Container();

    widgets.add(zipSection);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    // Additional Section
    Widget additionalSection = Container(
      height: 56,
      color: Colors.black54,
      child: SizedBox.expand(
        child: MaterialButton(
          onPressed: () {
            setState(() {
              openAdditional = !openAdditional;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'ADDITIONAL',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                openAdditional ? Icons.add : Icons.remove,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );

    widgets.add(additionalSection);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget optionsSection = openAdditional ? Container(
      height: 56,
      color: Colors.black38,
      child: SizedBox.expand(
        child: MaterialButton(
          onPressed: () {
            setState(() {
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Expanded(
                      child: Text(
                        'Company',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    ) : Container();

    widgets.add(optionsSection);

    return Center(
      child: Wrap(
        runSpacing: 16,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16),
            child: BlurEffectView(
              color: Color.fromRGBO(20, 20, 20, 0.2),
              blur: 15,
              radius: 12,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widgets.map((e) => e).toList(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
          ),
          Container(
            height: 56,
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: SizedBox.expand(
              child: MaterialButton(
                onPressed: () {
                },
                color: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Save',
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
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
      screenBloc.add(AddContactPhotoEvent(file: croppedFile));
    }

  }

}

//DropDownFormField(
//filled: false,
//titleText: Language.getProductStrings('Product must match'),
//hintText: Language.getProductStrings('Product must match'),
//value: conditionOption,
//onChanged: (value) {
//setState(() {
//conditionOption = value;
//if (conditionOption != 'No Conditions') {
//CollectionModel collection = state.collectionDetail;
//FillCondition fillCondition = collection
//    .automaticFillConditions;
//fillCondition.strict =
//conditionOption == 'All Conditions';
//collection.automaticFillConditions = fillCondition;
//widget.screenBloc.add(
//UpdateCollectionDetail(collectionModel: collection));
//}
//});
//},
//dataSource: productConditionOptions.map((e) {
//return {
//'display': e,
//'value': e,
//};
//}).toList(),
//textField: 'display',
//valueField: 'value',
//)