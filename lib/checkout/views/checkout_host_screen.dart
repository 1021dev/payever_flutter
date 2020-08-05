import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';

class CheckoutCSPAllowedHostScreen extends StatefulWidget {

  final CheckoutScreenBloc checkoutScreenBloc;

  CheckoutCSPAllowedHostScreen({this.checkoutScreenBloc});

  _CheckoutCSPAllowedHostScreenState createState() => _CheckoutCSPAllowedHostScreenState();

}

class _CheckoutCSPAllowedHostScreenState extends State<CheckoutCSPAllowedHostScreen> {

  @override
  void initState() {
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
        Language.getConnectStrings('CSP allowed hosts'),
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
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          radius: 20,
          child: Wrap(
            children: List.generate(state.defaultCheckout.settings.cspAllowedHosts.length + 2, (index) {
              if (index == (state.defaultCheckout.settings.cspAllowedHosts.length + 1)) {
                return Container(
                  height: 50,
                  child: SizedBox.expand(
                    child: MaterialButton(
                      onPressed: () {

                      },
                      color: Colors.black,
                      child: Text(
                        Language.getCommerceOSStrings('actions.save'),
                      ),
                    ),
                  ),
                );
              } else if (index == state.defaultCheckout.settings.cspAllowedHosts.length) {
                return Container(
                  height: 50,
                  child: SizedBox.expand(
                    child: MaterialButton(
                      onPressed: () {

                      },
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        children: <Widget>[
                          Text(
                            Language.getConnectStrings('actions.addPlus'),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Container(
                height: 56,
                color: Colors.black38,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        onSaved: (val) {

                        },
                        onChanged: (val) {
                          setState(() {
                          });
                        },
                        validator: (value) {
                          return null;
                        },
                        decoration: new InputDecoration(
                          labelText: 'Host',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          contentPadding: EdgeInsets.only(left: 16, right: 16),
                        ),
                        style: TextStyle(fontSize: 16),
                        keyboardType: TextInputType.url,
                        initialValue: state.defaultCheckout.settings.cspAllowedHosts[index],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {

                      },
                      minWidth: 0,
                      child: SvgPicture.asset('assets/images/closeicon.svg'),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}