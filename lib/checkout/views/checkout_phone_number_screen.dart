import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';

class CheckoutPhoneNumberScreen extends StatefulWidget {

  final CheckoutScreenBloc checkoutScreenBloc;

  CheckoutPhoneNumberScreen({this.checkoutScreenBloc});

  _CheckoutPhoneNumberScreenState createState() => _CheckoutPhoneNumberScreenState();

}

class _CheckoutPhoneNumberScreenState extends State<CheckoutPhoneNumberScreen> {

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

  Widget _getBody(CheckoutScreenState state) {
    print(state.checkoutFlow.phoneNumber);
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
                  child: DropdownButtonFormField(
                    items: List.generate(state.phoneNumbers.length, (index) {
                      return DropdownMenuItem(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            state.phoneNumbers[index],
                          ),
                        ),
                        value: state.phoneNumbers[index],
                      );
                    }).toList(),
                    onChanged: (val) {
                    },
                    hint: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        'Phone number',
                      ),
                    ),
                  ),
                ),
              ),
              Container(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}