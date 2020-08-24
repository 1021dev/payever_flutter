import 'dart:io';
import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/settings/widgets/profile_image_view.dart';
import 'package:payever/settings/widgets/save_button.dart';

class PersonalInformationScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;
  PersonalInformationScreen({
    this.globalStateModel,
    this.setScreenBloc,
  });

  @override
  _PersonalInformationScreenState createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  Business activeBusiness;
  User user;

  String salutation;
  String firstName;
  String lastName;
  String phone;
  String email;
  String birthday;
  String logo;
  DateTime birthDate;

  TextEditingController birthdayController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    activeBusiness =
        widget.globalStateModel.currentBusiness;
    user = widget.setScreenBloc.state.user;
    if (user != null) {
      salutation = user.salutation;
      firstName = user.firstName;
      lastName = user.lastName;
      phone = user.phone;
      email = user.email;
      logo = user.logo;
      birthday = user.birthday;
      if (birthday != null && birthday != '') {
        birthDate = DateTime.parse(birthday);
      }
    }
    birthdayController.text = birthDate != null ? formatDate(birthDate, [dd, '/', mm, '/', yyyy]):'';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  get _body {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: Appbar('Personal Information'),
      body: SafeArea(
        child: BackgroundBase(
          true,
          backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
          body: _updateForm,
        ),
      ),
    );
  }

  get _updateForm {
    return BlocListener(
      bloc: widget.setScreenBloc,
      listener: (BuildContext context, state) {
        if (state is SettingScreenUpdateSuccess) {
          Navigator.pop(context);
        } else if (state is SettingScreenStateFailure) {}
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (context, state) {
          return Center(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(16),
                width: Measurements.width,
                child: BlurEffectView(
                  color: Color.fromRGBO(20, 20, 20, 0.4),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 88,
                            padding: EdgeInsets.only(
                              top: 16,
                              bottom: 16,
                            ),
                            child: GestureDetector(
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
                              child: ProfileImageView(
                                isUploading: state.uploadUserImage,
                                imageUrl: logo != null
                                    ? 'https://payeverproduction.blob.core.windows.net/images/$logo'
                                    : '',
                                avatarSize: 56,
                              )
                            ),
                          ),
                          SizedBox(height: 2,),
                          Container(
                            height: 64,
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: BlurEffectView(
                                    color: Color.fromRGBO(100, 100, 100, 0.05),
                                    radius: 0,
                                    child: Container(
                                      height: 64,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 16, right: 8),
                                      child: DropdownButtonFormField(
                                        items: List.generate(2, (index) {
                                          return DropdownMenuItem(
                                            child: Text(
                                              Language.getConnectStrings(index == 0 ?
                                              'user_business_form.form.contactDetails.salutation.options.SALUTATION_MR':
                                              'user_business_form.form.contactDetails.salutation.options.SALUTATION_MRS'),
                                            ),
                                            value: index == 0 ? 'SALUTATION_MR': 'SALUTATION_MRS',
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            salutation = val;
                                          });
                                        },
                                        value: salutation != '' ? salutation : null,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.black54,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        hint: Text(
                                          Language.getSettingsStrings('form.create_form.contact.salutation.label'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2),
                                ),
                                Flexible(
                                  child: BlurEffectView(
                                    color: Color.fromRGBO(100, 100, 100, 0.05),
                                    radius: 0,
                                    child: Container(
                                      height: 64,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16),
                                        onChanged: (val) {
                                          setState(() {
                                            firstName = val;
                                          });
                                        },
                                        initialValue: firstName ?? '',
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
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2),
                                ),
                                Flexible(
                                  child: BlurEffectView(
                                    color: Color.fromRGBO(100, 100, 100, 0.05),
                                    radius: 0,
                                    child: Container(
                                      height: 64,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16),
                                        onChanged: (val) {
                                          setState(() {
                                            lastName = val;
                                          });
                                        },
                                        initialValue: lastName ?? '',
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2,),
                          Container(
                            height: 64,
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: BlurEffectView(
                                    color: Color.fromRGBO(100, 100, 100, 0.05),
                                    radius: 0,
                                    child: Container(
                                      height: 64,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16),
                                        onChanged: (val) {
                                          setState(() {
                                            phone = val;
                                          });
                                        },
                                        initialValue: phone ?? '',
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 16, right: 16),
                                          labelText: Language.getPosTpmStrings('Phone (optional)'),
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
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2),
                                ),
                                Flexible(
                                  child: BlurEffectView(
                                    color: Color.fromRGBO(100, 100, 100, 0.05),
                                    radius: 0,
                                    child: Container(
                                      height: 64,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16),
                                        onChanged: (val) {
                                          setState(() {
                                            email = val;
                                          });
                                        },
                                        initialValue: email ?? '',
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 16, right: 16),
                                          labelText: Language.getPosTpmStrings('E-email'),
                                          labelStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                          ),
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2,),
                          BlurEffectView(
                            color: Color.fromRGBO(100, 100, 100, 0.05),
                            radius: 0,
                            child: Container(
                              height: 64,
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      controller: birthdayController,
                                      style: TextStyle(fontSize: 16),
                                      onTap: () {

                                      },
                                      onChanged: (val) {
                                        setState(() {
                                          birthday= val;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 16, right: 16),
                                        labelText: Language.getSettingsStrings('form.create_form.personal_information.birthday.label'),
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                        ),
                                      ),
                                      keyboardType: TextInputType.text,
                                      readOnly: true,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final result = await showDatePicker(
                                        context: context,
                                        initialDate: birthDate ?? DateTime.now(),
                                        firstDate: DateTime(1950, 1, 1),
                                        lastDate: DateTime.now(),
                                      );
                                      if (result != null) {
                                        setState(() {
                                          birthDate = result;
                                          birthdayController.text = birthDate != null ? formatDate(birthDate, [dd, '/', mm, '/', yyyy]):'';
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: SvgPicture.asset(
                                        'assets/images/ic_calendar.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 2,),
                          SaveBtn(
                            isUpdating: state.isUpdating,
                            color: Colors.black45,
                            isBottom: false,
                            onUpdate: () {
                              if (_formKey.currentState.validate() &&
                                  !state.isUpdating) {
                                Map<String, dynamic> body = {};
                                body['salutation'] = salutation;
                                body['firstName'] = firstName;
                                body['lastName'] = lastName;
                                body['phone'] = phone;
                                body['email'] = email;
                                body['birthday'] = birthDate != null ? birthDate.toIso8601String() : '';
                                body['logo'] = user.logo;
                                print(body);
                                widget.setScreenBloc.add(UpdateCurrentUserEvent(
                                  body: body,
                                ));
                              }
                            },
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
      widget.setScreenBloc.add(UploadUserPhotoEvent(image: croppedFile));
    }

  }
}