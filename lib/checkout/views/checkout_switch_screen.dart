import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';

bool _isPortrait;
bool _isTablet;

class CheckoutSwitchScreen extends StatefulWidget {

  final CheckoutScreenBloc screenBloc;
  final String businessId;

  CheckoutSwitchScreen({
    this.screenBloc,
    this.businessId,
  });

  @override
  createState() => _CheckoutSwitchScreenState();
}

class _CheckoutSwitchScreenState extends State<CheckoutSwitchScreen> {
  String imageBase = Env.storage + '/images/';

  CheckoutSwitchScreenBloc screenBloc;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Checkout selectedCheckout;
  String wallpaper;
  bool isLoading = false;

  @override
  void initState() {
    screenBloc = CheckoutSwitchScreenBloc(checkoutScreenBloc: widget.screenBloc);
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
      bloc: screenBloc,
      listener: (BuildContext context, CheckoutSwitchScreenState state) async {
      },
      child: BlocBuilder<CheckoutSwitchScreenBloc, CheckoutSwitchScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, CheckoutSwitchScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(CheckoutSwitchScreenState state) {
    return Container(
      child: state.isLoading ?
      Center(
        child: CircularProgressIndicator(),
      ): Container(
        alignment: Alignment.center,
        child: Container(
          width: Measurements.width,
          child: _getBody(state),
        ),
      ),
    );
  }

  Widget _getBody(CheckoutSwitchScreenState state) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _activeTerminalWidget(state) ,
          Text(
            'Further Terminals',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
          ),
          _furtherTerminals(state),
        ],
      ),
    );
  }

  Widget _activeTerminalWidget(CheckoutSwitchScreenState state) {
    String avatarName = '';
    if (state.defaultCheckout != null) {
      String name = state.defaultCheckout.name;
      if (name.contains(' ')) {
        avatarName = name.substring(0, 1);
        avatarName = avatarName + name.split(' ')[1].substring(0, 1);
      } else {
        avatarName = name.substring(0, 1) + name.substring(name.length - 1);
        avatarName = avatarName.toUpperCase();
      }
    }
    return Container(
      padding: EdgeInsets.only(top: 64, bottom: 64),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: state.defaultCheckout.logo != null ?
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueGrey.withOpacity(0.5),
                  image: DecorationImage(
                    image: NetworkImage('$imageBase${state.defaultCheckout.logo}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ):
              Container(
                width: 100,
                height: 100,
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey.withOpacity(0.5),
                  child: Text(
                    avatarName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            MaterialButton(
              onPressed: () {
              },
              height: 32,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.black26,
              child: Text(
                '+ Add Checkout',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _furtherTerminals(CheckoutSwitchScreenState state) {
    return GridView.count(
      crossAxisCount: _isTablet ? 5: 3,
      childAspectRatio: 0.7,
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 24),
      shrinkWrap: true,
      children: state.checkouts.map((cht) => CheckoutCell(
        onTap: (Checkout checkout){
          setState(() {
            selectedCheckout = checkout;
          });
        },
        selected: selectedCheckout,
        checkout: cht,
        onMore: (Checkout checkout) {
          showCupertinoModalPopup(
            context: context,
            builder: (builder) {
              bool isDefault = checkout.id == state.defaultCheckout.id;
              return Container(
                height: 64.0 * (isDefault ? 1.0 : 3.0) + MediaQuery.of(context).padding.bottom,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  children: popupButtons(context, checkout).sublist(0, isDefault ? 1 : 3),
                ),
              );
            },
          );
        },
        onOpen: (Checkout checkout) {
          screenBloc.add(SetDefaultCheckoutEvent(checkout: checkout));
          Navigator.pop(context);
        },
      )).toList(),
      physics: NeverScrollableScrollPhysics(),
    );
  }

  List<Widget> popupButtons(BuildContext context, Checkout checkout) {
    return [
      Container(
        height: 44,
        child: SizedBox.expand(
          child: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Edit'),
          ),
        ),
      ),
      Container(
        height: 44,
        child: SizedBox.expand(
          child: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              screenBloc.add(SetDefaultCheckoutEvent(checkout: checkout));
            },
            child: Text('Set as Default'),
          ),
        ),
      ),
      Container(
        height: 44,
        child: SizedBox.expand(
          child: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              showCupertinoDialog(
                context: context,
                builder: (builder) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Container(
                      height: 250,
                      child: BlurEffectView(
                        color: Color.fromRGBO(50, 50, 50, 0.4),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Icon(Icons.info),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Text(
                              Language.getPosStrings('delete_terminal_confirm.title'),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Text(
                              Language.getPosStrings('delete_terminal_confirm.description'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'No',
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Yes',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Text('Delete'),
          ),
        ),
      ),
    ];
  }
}

class CheckoutCell extends StatelessWidget {
  final Function onTap;
  final Checkout checkout;
  final Checkout selected;
  final Function onOpen;
  final Function onMore;

  CheckoutCell({
    this.onTap,
    this.checkout,
    this.selected,
    this.onOpen,
    this.onMore
  });

  @override
  Widget build(BuildContext context) {
    String avatarName = '';
    String name = checkout.name;
    if (name.contains(' ')) {
      avatarName = name.substring(0, 1);
      avatarName = avatarName.toUpperCase() + name.split(' ')[1].substring(0, 1).toUpperCase();
    } else {
      avatarName = name.substring(0, 1) + name.substring(name.length - 1).toUpperCase();
      avatarName = avatarName.toUpperCase();
    }
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      color: selected.id == checkout.id ? Colors.white24 : Colors.transparent.withOpacity(0),
      onPressed: () {
        onTap(checkout);
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: checkout.logo != null ?
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('$imageBase${checkout.logo}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ):
              Container(
                width: 80,
                height: 80,
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey.withOpacity(0.5),
                  child: Text(
                    avatarName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            Text(
              checkout.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              height: 36,
              child: selected.id == checkout.id ? Row(
                children: <Widget>[
                  MaterialButton(
                    minWidth: 0,
                    onPressed: () {
                      onOpen(checkout);
                    },
                    height: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.black26,
                    child: Text(
                      'Open',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Flexible(
                    child: MaterialButton(
                      onPressed: () {
                        onMore(checkout);
                      },
                      minWidth: 0,
                      height: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ): Container(),
            ),
          ],
        ),
      ),
    );
  }
}
