import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/settings/widgets/save_button.dart';

class BusinessInfoScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;

  BusinessInfoScreen(
      {this.globalStateModel, this.setScreenBloc});

  @override
  _BusinessInfoScreenState createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  bool isGridMode = true;
  bool _isPortrait;
  bool _isTablet;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController myController = TextEditingController();
  String blobName = '';

  @override
  void initState() {
    super.initState();
    myController.text = widget.globalStateModel.currentBusiness.name;
    blobName = widget.globalStateModel.currentBusiness.logo;

  }

  @override
  void dispose() {
    myController.dispose();
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
      bloc: widget.setScreenBloc,
      listener: (BuildContext context, SettingScreenState state) async {
        if (state is SettingScreenStateFailure) {
          Fluttertoast.showToast(msg: state.error);
        } else if (state is SettingScreenUpdateSuccess) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (BuildContext context, SettingScreenState state) {
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomPadding: true,
            appBar: Appbar('Business Info'),
            body: SafeArea(
              child: BackgroundBase(
                true,
                backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
                body: state.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _getBody(state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(SettingScreenState state) {
    if (state.blobName != null && state.blobName != '') {
      setState(() {
        blobName = state.blobName;
      });
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.25),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10)),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 60,
                          width: 60,
                          child: InkWell(
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: <Widget>[
                                state.isUpdatingBusinessImg ?
                                    Center(
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    ) :
                                blobName != null && blobName != ''
                                    ? Center(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: NetworkImage('$imageBase$blobName'),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                ): Center(
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
                                state.isLoading
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
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(8.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: myController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter valid name.';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Business name',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 10, 8),
                    child: MaterialButton(
                      onPressed: () {

                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 24,
                      color: Colors.black54,
                      elevation: 0,
                      child: Text(
                        'Delete Business',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  SaveBtn(
                    isUpdating: state.isUpdating,
                    onUpdate: () {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState.validate() && !state.isUpdating) {
                        Map<String, dynamic> body = {
                          'logo': blobName,
                          'name': myController.text
                        };
                        widget.setScreenBloc.add(BusinessUpdateEvent(body));
                      }
                    },
                  ),
                ],
              ),
            )),
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
      widget.setScreenBloc.add(UploadBusinessImage(file: croppedFile,));
    }

  }
}
