import 'dart:io';
import 'dart:ui';
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
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';
import 'package:payever/shop/models/models.dart';

bool _isPortrait;
bool _isTablet;

class CreateShopScreen extends StatefulWidget {

  ShopScreenBloc screenBloc;
  String businessId;
  bool fromDashBoard;

  CreateShopScreen({
    this.screenBloc,
    this.businessId,
    this.fromDashBoard = false,
  });

  @override
  createState() => _CreateShopScreenState();
}

class _CreateShopScreenState extends State<CreateShopScreen> {
  String imageBase = Env.storage + '/images/';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String wallpaper;
  final TextEditingController shopNameController = TextEditingController();
  bool isError = false;
  bool isButtonPressed = false;
  bool buttonEnabled = false;

  @override
  void initState() {
//    if (widget.editShop != null) {
//      terminalNameController.text = widget.editShop.name;
//      widget.screenBloc.add(UpdateBlobImage(logo: widget.editTerminal.logo));
//    }
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
      listener: (BuildContext context, ShopScreenState state) async {
        if (state is ShopScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is ShopScreenStateSuccess) {
            Navigator.pop(context);
        }
      },
      child: BlocBuilder<ShopScreenBloc, ShopScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, ShopScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _appBar(ShopScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            'Create  Shop',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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

  Widget _body(ShopScreenState state) {
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

  Widget _getBody(ShopScreenState state) {
    String blobName;// = state.blobName;
    String avatarName = '';
    if (shopNameController.text.isNotEmpty) {
      String name = shopNameController.text;
      if (name.contains(' ')) {
        avatarName = name.substring(0, 1);
        avatarName = avatarName + name.split(' ')[1].substring(0, 1);
      } else {
        avatarName = name.substring(0, 1) + name.substring(name.length - 1);
        avatarName = avatarName.toUpperCase();
      }
    }
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Wrap(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 64),
              child: GestureDetector(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    blobName != null && blobName != ''
                        ? Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage('$imageBase$blobName'),
                        child: Container(
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ): CircleAvatar(
                      minRadius: 40,
                      backgroundColor: Colors.grey,
                      child: Container(
                        child: Text(
                          avatarName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    state.isUploading
                        ? Center(
                      child: Container(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black87),
                        ),
                      ),
                    )
                        : Container(),
                  ],
                ),
                onTap: () async {
                  getImage();
                },
              ),
            ),
            BlurEffectView(
              color: Color.fromRGBO(50, 50, 50, 0.2),
              blur: 5,
              radius: 12,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: <Widget>[
                  Container(
                      height: 72,
                      padding: EdgeInsets.all(12),
                      child: Container(
                        child: Container(
                          height: 60,
                          child: BlurEffectView(
                            color: Color.fromRGBO(100, 100, 100, 0.2),
                            blur: 15,
                            radius: 12,
                            child: TextFormField(
                              controller: shopNameController,
                              onSaved: (val) {},
                              onChanged: (val) {
                                isButtonPressed = false;
                                if (isError) {
                                  formKey.currentState.validate();
                                }
                                setState(() {
                                  buttonEnabled = val.isNotEmpty;
                                });
                              },
                              onFieldSubmitted: (val) {
                                if (formKey.currentState.validate()) {
//                                    submitTerminal(state);
                                }
                              },
                              validator: (value) {
                                if (!isButtonPressed) {
                                  return null;
                                }
                                isError = true;
                                if (value.isEmpty) {
                                  return 'Shop name required';
                                } else {
                                  isError = false;
                                  return null;
                                }
                              },
                              decoration: new InputDecoration(
                                hintText: "Shop name",
                                border: InputBorder.none,
                                contentPadding: _isTablet
                                    ? EdgeInsets.all(
                                    Measurements.height * 0.007)
                                    : EdgeInsets.only(left: 12, right: 12),
                              ),
                              style: TextStyle(fontSize: 16),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      )
                  ),
                  Container(
                    height: 64,
                    color: Color(0xFF222222),
                    child: SizedBox.expand(
                      child: MaterialButton(
                        onPressed: buttonEnabled ? () {} : null,
                        child: state.isUpdating ? Center(
                          child: CircularProgressIndicator(),
                        ) : Text(
                          'Create',
                          style: TextStyle(
                            color: buttonEnabled ? Colors.white : Colors.white24,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        )
      ),
    );
  }

  void submitTerminal(ShopScreenState state) {
//    widget.screenBloc.add(CreatePosTerminalEvent(
//      businessId: widget.businessId,
//      name: terminalNameController.text,
//      logo: state.blobName != '' ? state.blobName : null,
//    ));
  }

  Future getImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img == null) {
      return;
    }
    if (img.existsSync()) {
      print("_image: $img");
      widget.screenBloc.add(UploadShopImage(file: img, businessId: widget.businessId));
    }
  }


}

