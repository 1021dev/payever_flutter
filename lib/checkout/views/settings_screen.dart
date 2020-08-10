import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/checkout_host_screen.dart';
import 'package:payever/checkout/views/checkout_languages_screen.dart';
import 'package:payever/checkout/views/checkout_message_screen.dart';
import 'package:payever/checkout/views/checkout_phone_number_screen.dart';
import 'package:payever/commons/commons.dart';

class CheckoutSettingsScreen extends StatefulWidget {
  final CheckoutScreenBloc checkoutScreenBloc;
  final String businessId;
  final Checkout checkout;
  CheckoutSettingsScreen({this.checkoutScreenBloc, this.businessId, this.checkout});

  @override
  _CheckoutSettingsScreenState createState() => _CheckoutSettingsScreenState();
}

class _CheckoutSettingsScreenState extends State<CheckoutSettingsScreen> {
  CheckoutSettingScreenBloc screenBloc;

  @override
  void initState() {
    screenBloc = CheckoutSettingScreenBloc(checkoutScreenBloc: widget.checkoutScreenBloc);
    screenBloc.add(CheckoutSettingScreenInitEvent(businessId: widget.businessId, checkout: widget.checkout));
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, state) {
        if (state is CheckoutSettingScreenStateFailure) {
        }
      },
      child: BlocBuilder<CheckoutSettingScreenBloc, CheckoutSettingScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, state) {
          if (widget.checkout == null || widget.checkout.settings.styles == null ||state.isUpdating) {
            return Center(
              child: Container(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            );
          }
          String defaultLanguage = '';
          List<Lang> langs = widget.checkout.settings.languages.where((element) => element.active).toList();
          if (langs.length > 0) {
            defaultLanguage = langs.first.name;
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 16, right: 16,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Testing mode',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            CupertinoSwitch(
                              value: widget.checkout.settings.testingMode,
                              onChanged: (value) {
                                widget.checkout.settings.testingMode = value;
                                screenBloc.add(UpdateCheckoutSettingsEvent());
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 16, right: 16,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'CSP allowed hosts',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: CheckoutCSPAllowedHostScreen(
                                      settingBloc: screenBloc,
                                      checkout: widget.checkout,
                                    ),
                                    type: PageTransitionType.fade,
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Colors.black54,
                              elevation: 0,
                              height: 24,
                              minWidth: 0,
                              child: Text(
                                Language.getPosStrings('actions.edit'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 16, right: 16,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                'Color and style',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                CupertinoSwitch(
                                  value: widget.checkout.settings.styles.active ?? false,
                                  onChanged: (value) {
                                    widget.checkout.settings.styles.active = value;
                                    screenBloc.add(UpdateCheckoutSettingsEvent());
                                  },
                                ),
                                MaterialButton(
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.black54,
                                  elevation: 0,
                                  height: 24,
                                  minWidth: 0,
                                  child: Text(
                                    Language.getPosStrings('actions.edit'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 16, right: 16,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Language',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            Flexible(
                              child: Text(
                                '$defaultLanguage (default)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: CheckoutLanguagesScreen(
                                      settingBloc: screenBloc,
                                      checkout: widget.checkout,
                                    ),
                                    type: PageTransitionType.fade,
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Colors.black54,
                              elevation: 0,
                              height: 24,
                              minWidth: 0,
                              child: Text(
                                Language.getPosStrings('actions.edit'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 16, right: 16,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Phone number',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            Flexible(
                              child: Text(
                                widget.checkout.settings.phoneNumber ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: CheckoutPhoneNumberScreen(
                                      settingBloc: this.screenBloc,
                                      checkout: widget.checkout,
                                    ),
                                    type: PageTransitionType.fade,
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Colors.black54,
                              elevation: 0,
                              height: 24,
                              minWidth: 0,
                              child: Text(
                                Language.getPosStrings('actions.edit'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 16, right: 16,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Message',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            Flexible(
                              child: Text(
                                widget.checkout.settings.message ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: CheckoutMessageScreen(
                                      settingBloc: screenBloc,
                                      checkout: widget.checkout,
                                    ),
                                    type: PageTransitionType.fade,
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Colors.black54,
                              elevation: 0,
                              height: 24,
                              minWidth: 0,
                              child: Text(
                                Language.getPosStrings('actions.edit'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 16, right: 16,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                'Policies',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Colors.black54,
                              elevation: 0,
                              height: 24,
                              minWidth: 0,
                              child: Text(
                                Language.getPosStrings('actions.edit'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 16, right: 16,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Channel Set ID',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            Flexible(
                              child: Text(
                                widget.checkout.id,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Colors.black54,
                              elevation: 0,
                              height: 24,
                              minWidth: 0,
                              child: Text(
                                Language.getPosStrings('actions.copy'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
