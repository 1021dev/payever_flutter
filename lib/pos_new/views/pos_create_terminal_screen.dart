import 'dart:io';
import 'dart:ui';
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
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';

bool _isPortrait;
bool _isTablet;

class PosCreateTerminalScreen extends StatefulWidget {

  PosScreenBloc screenBloc;
  String businessId;

  PosCreateTerminalScreen({
    this.screenBloc,
    this.businessId,
  });

  @override
  createState() => _PosCreateTerminalScreenState();
}

class _PosCreateTerminalScreenState extends State<PosCreateTerminalScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String wallpaper;
  final TextEditingController terminalNameController = TextEditingController();
  File image;
  bool isLoading = false;

  @override
  void initState() {
    widget.screenBloc.add(GetPosDevicePaymentSettings(businessId: widget.businessId));
    super.initState();
  }

  @override
  void dispose() {
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
      listener: (BuildContext context, PosScreenState state) async {
        if (state is PosScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<PosScreenBloc, PosScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, PosScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _appBar(PosScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            'Create Terminal',
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

  Widget _body(PosScreenState state) {
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
          ): Column(
            children: <Widget>[
              Expanded(
                child: _getBody(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody(PosScreenState state) {
    if (state.devicePaymentSettings == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 90.0 + 64.0,
        child: BlurEffectView(
          color: Color.fromRGBO(50, 50, 50, 0.2),
          blur: 5,
          radius: 12,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: <Widget>[
              Container(
                  height: 90,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: 60,
                          child: InkWell(
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: <Widget>[
                                image != null
                                    ? Center(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage: NetworkImage(imageBase + image.path),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                      ),
                                    ),
                                )
                                    : Center(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/images/newpicicon.svg",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                image != null
                                    ? Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                )
                                    : Container(),
                                isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : Container(),
                              ],
                            ),
                            onTap: () {
                              if (image != null) {
                                setState(() {
                                  isLoading = false;
                                  image = null;
                                });
                              } else {
                                getImage();
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 24),
                        ),
                        Expanded(
                          child: Container(
                            height: 60,
                            child: BlurEffectView(
                              color: Color.fromRGBO(100, 100, 100, 0.2),
                              blur: 15,
                              radius: 12,
                              padding: EdgeInsets.only(left: 12, right: 12),
                              child: TextFormField(
                                controller: terminalNameController,
                                onSaved: (val) {},
                                onChanged: (val) {
                                  setState(() {
                                  });
                                },
                                decoration: new InputDecoration(
                                  labelText: "Terminal name",
                                  border: InputBorder.none,
                                  contentPadding: _isTablet
                                      ? EdgeInsets.all(
                                      Measurements.height * 0.007)
                                      : null,
                                ),
                                style: TextStyle(fontSize: 16),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              Container(
                height: 64,
                color: Color(0xFF424141),
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () {
                    },
                    child: Text(
                      'Done',
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
        ),
      ),
    );
  }

  Future getImage() async {
    isLoading = true;
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img.existsSync())
      setState(() {
        image = img;
        print("_image: $image");
//        PosApi api = PosApi();
//        api
//            .postTerminalImage(
//            image, widget._business, GlobalUtils.activeToken.accessToken)
//            .then((dynamic res) {
//          _logo = res["blobName"];
//          api
//              .postEditTerminal(widget._id, newName, widget._logo,
//              widget._business, GlobalUtils.activeToken.accessToken)
//              .then((res) {
//            print(res);
//            setState(() {
//              _isLoading = false;
//            });
//          });
//        }).catchError((onError) {
//          setState(() {
//            print(onError);
//            _isLoading = false;
//          });
//          if (onError.toString().contains("401")) {
//            GlobalUtils.clearCredentials();
//            Navigator.pushReplacement(
//                context,
//                PageTransition(
//                    child: LoginScreen(), type: PageTransitionType.fade));
//          }
//        });
      });
  }


}

