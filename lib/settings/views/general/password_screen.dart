import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/commons/models/user.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/settings/widgets/save_button.dart';

class PasswordScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;

  const PasswordScreen({Key key, this.globalStateModel, this.setScreenBloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PasswordScreenState();
  }

}

class _PasswordScreenState extends State<PasswordScreen> {

  Business activeBusiness;

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool openChangePassword = true;

  @override
  void initState() {
    widget.setScreenBloc.add(GetAuthUserEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    currentPasswordController.dispose();
    repeatPasswordController.dispose();
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  get _body {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: Appbar('Password'),
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
      listener: (BuildContext context, SettingScreenState state) {
        if (state is SettingScreenUpdateSuccess) {
          Navigator.pop(context);
        } else if (state is SettingScreenStateFailure) {}
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (context, SettingScreenState state) {
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
                          BlurEffectView(
                            color: Color.fromRGBO(100, 100, 100, 0.05),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            child: Container(
                              height: 50,
                              padding: EdgeInsets.only(left: 16, right: 8),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    Language.getSettingsStrings('info_boxes.panels.general.menu_list.authentication_2fa.title'),
                                  ),
                                  Transform.scale(
                                    scale: 0.6,
                                    child: state.updating2FA ? CircularProgressIndicator() : CupertinoSwitch(
                                      onChanged: (val) {
                                        widget.setScreenBloc.add(UpdateAuthUserEvent(
                                          body: {'secondFactorRequired': val}
                                        ));
                                      },
                                      value: state.authUser != null ? state.authUser.secondFactorRequired ?? false: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          BlurEffectView(
                            color: Color.fromRGBO(100, 100, 100, 0.05),
                            radius: 0,
                            child: Container(
                              height: 50,
                              color: Colors.black38,
                              child: SizedBox.expand(
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      openChangePassword = !openChangePassword;
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
                                                Language.getSettingsStrings('info_boxes.panels.general.menu_list.change_password.title'),
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
                                        openChangePassword ? Icons.remove : Icons.add,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          openChangePassword ? Container(
                            child: Column(
                              children: <Widget>[
                                BlurEffectView(
                                  color: Color.fromRGBO(100, 100, 100, 0.05),
                                  radius: 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Center(
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16),
                                        onChanged: (val) {
                                          setState(() {
                                          });
                                        },
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            return '${Language.getSettingsStrings('form.create_form.password.current_password.label')} required';
                                          }
                                          return null;
                                        },
                                        controller: currentPasswordController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 16, right: 16),
                                          labelText: Language.getSettingsStrings('form.create_form.password.current_password.label'),
                                          labelStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                          ),
                                        ),
                                        obscureText: true,
                                        keyboardType: TextInputType.text,
                                      ),
                                    ),
                                  ),
                                ),
                                BlurEffectView(
                                  color: Color.fromRGBO(100, 100, 100, 0.05),
                                  radius: 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Center(
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16),
                                        onChanged: (val) {
                                          setState(() {
                                          });
                                        },
                                        controller: newPasswordController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 16, right: 16),
                                          labelText: Language.getSettingsStrings('form.create_form.password.new_password.placeholder'),
                                          labelStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                          ),
                                        ),
                                        obscureText: true,
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            return '${Language.getSettingsStrings('form.create_form.password.new_password.placeholder')} required';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.text,
                                      ),
                                    ),
                                  ),
                                ),
                                BlurEffectView(
                                  color: Color.fromRGBO(100, 100, 100, 0.05),
                                  radius: 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Center(
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16),
                                        onChanged: (val) {
                                          setState(() {
                                          });
                                        },
                                        controller: repeatPasswordController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 16, right: 16),
                                          labelText: Language.getSettingsStrings('form.create_form.password.repeat_password.label'),
                                          labelStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                          ),
                                        ),
                                        obscureText: true,
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            return '${Language.getSettingsStrings('form.create_form.password.repeat_password.label')} required';
                                          }
                                          if (val != newPasswordController.text) {
                                            return '${Language.getSettingsStrings('form.create_form.password.repeat_password.label')} doesn\'t match';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.text,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ) : Container(),
                          SaveBtn(
                            isUpdating: state.isUpdating,
                            color: Colors.black45,
                            isBottom: false,
                            title: 'Save',
                            onUpdate: () {
                              if (_formKey.currentState.validate() &&
                                  !state.isUpdating) {
                                widget.setScreenBloc.add(UpdatePasswordEvent(
                                  newPassword: newPasswordController.text,
                                  oldPassword: currentPasswordController.text,
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
}