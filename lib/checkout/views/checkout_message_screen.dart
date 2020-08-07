import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';

class CheckoutMessageScreen extends StatefulWidget {

  final CheckoutSettingScreenBloc settingBloc;
  final String businessId;
  final String checkoutId;
  final CheckoutSettings settings;

  CheckoutMessageScreen(
      {this.settingBloc, this.businessId, this.checkoutId, this.settings});

  _CheckoutMessageScreenState createState() => _CheckoutMessageScreenState();

}

class _CheckoutMessageScreenState extends State<CheckoutMessageScreen> {
  TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.settings.message);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: widget.settingBloc,
        listener: (BuildContext context, CheckoutSettingScreenState state) async {
          if (state is CheckoutSettingScreenStateSuccess) {
            Navigator.pop(context);
          } else if (state is CheckoutSettingScreenStateFailure) {
          }
        },
      child: BlocBuilder<CheckoutSettingScreenBloc, CheckoutSettingScreenState>(
        bloc: widget.settingBloc,
        builder: (BuildContext context, CheckoutSettingScreenState state) {
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomPadding: false,
            appBar: _appBar(state),
            body: SafeArea(
              child: BackgroundBase(
                true,
                backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
                body: state.isLoading ?
                Center(
                  child: CircularProgressIndicator(),
                ): Center(
                  child: _getBody(state),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(CheckoutSettingScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Text(
        Language.getConnectStrings('actions.edit'),
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

  Widget _getBody(CheckoutSettingScreenState state) {
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          radius: 20,
          child: Wrap(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12),
                child: BlurEffectView(
                  radius: 8,
                  child: TextFormField(
                    onSaved: (val) {

                    },
                    onChanged: (val) {
                      setState(() {
                      });
                    },
                    controller: controller,
                    validator: (value) {
                      return null;
                    },
                    decoration: new InputDecoration(
                      labelText: 'Message',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(left: 16, right: 16),
                    ),
                    style: TextStyle(fontSize: 16),
                    keyboardType: TextInputType.url,
                  ),
                ),
              ),
              Container(
                height: 50,
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () {
                      widget.settings.message = controller.text;
                      widget.settingBloc.add(UpdateCheckoutSettingsEvent(
                          widget.businessId,
                          widget.checkoutId,
                          widget.settings));
                    },
                    color: Colors.black,
                    child: state.isUpdating
                        ? CircularProgressIndicator(
                      strokeWidth: 2,
                    )
                        : Text(
                      Language.getCommerceOSStrings('actions.save'),
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
}