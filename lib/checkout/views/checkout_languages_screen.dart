import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';

class CheckoutLanguagesScreen extends StatefulWidget {

  final CheckoutScreenBloc checkoutScreenBloc;

  CheckoutLanguagesScreen({this.checkoutScreenBloc});

  _CheckoutLanguagesScreenState createState() => _CheckoutLanguagesScreenState();

}

class _CheckoutLanguagesScreenState extends State<CheckoutLanguagesScreen> {

  @override
  void initState() {
    widget.checkoutScreenBloc.add(GetPhoneNumbers());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: widget.checkoutScreenBloc,
        listener: (BuildContext context, CheckoutScreenState state) async {
          if (state is CheckoutScreenStateFailure) {
            Navigator.pushReplacement(
              context,
              PageTransition(
                child: LoginScreen(),
                type: PageTransitionType.fade,
              ),
            );
          }
        },
      child: BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
        bloc: widget.checkoutScreenBloc,
        builder: (BuildContext context, CheckoutScreenState state) {
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

  Widget _appBar(CheckoutScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Text(
        Language.getConnectStrings('Add Language'),
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

  Widget _getBody(CheckoutScreenState state) {
    if (state.defaultCheckout == null) {
      return Container();
    }
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          child: Wrap(
            children: <Widget>[
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Lang lang = state.defaultCheckout.settings.languages[index];
                  return Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            lang.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Helvetica Neue',
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: <Widget>[
                            lang.isDefault ? Text(
                              Language.getPosStrings('edit_locales.default'),
                            ): (lang.active ? MaterialButton(
                              onPressed: () {

                              },
                              color: Colors.black54,
                              elevation: 0,
                              height: 24,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minWidth: 0,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                Language.getPosStrings('actions.set_as_default'),
                              ),
                            ): Container()),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            CupertinoSwitch(
                              value: lang.active,
                              onChanged: (val) {

                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 0,
                    thickness: 0.5,
                    color: Colors.grey,
                  );
                },
                itemCount: state.defaultCheckout.settings.languages.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}