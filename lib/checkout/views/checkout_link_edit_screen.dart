import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';

class CheckoutLinkEditScreen extends StatefulWidget {

  final CheckoutScreenBloc screenBloc;
  final String title;
  String type;
  CheckoutLinkEditScreen(
      {this.screenBloc, this.title}){
    if (title == 'Text Link') {
      type = 'text-link';
    } else if (title == 'Button') {
      type = 'button';
    } else if (title == 'Calculator') {
      type = 'banner-and-rate';
    } else if (title == 'Bubble') {
      type = 'bubble';
    }
  }

  _CheckoutLinkEditScreenState createState() => _CheckoutLinkEditScreenState();

}

class _CheckoutLinkEditScreenState extends State<CheckoutLinkEditScreen> {

  TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.screenBloc.add(FinanceExpressTypeEvent(widget.type));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: widget.screenBloc,
        listener: (BuildContext context, CheckoutScreenState state) async {
          if (state is CheckoutScreenStateFailure) {
          }
        },
      child: BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
        bloc: widget.screenBloc,
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
                ): Column(
                  children: <Widget>[
                    _getBody(state),
                  ],
                )
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
        widget.title,
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
    switch (widget.title) {
      case 'Text Link':
        return _getTextLinkWidget(state);
      case 'Button':
        return _getTextLinkWidget(state);
      case 'Bubble':
        return _getTextLinkWidget(state);
      case 'Calculator':
        return _getTextLinkWidget(state);
      default:
        return _getTextLinkWidget(state);
    }
    return Container();
  }

  Widget _getTextLinkWidget(CheckoutScreenState state) {
    return Container(
      height: 64,
      color: Colors.black45,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 30,),
            Text(
              'Height',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 15, right: 30),
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                color: Color.fromRGBO(100, 100, 100, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                onSaved: (val) {},
                onChanged: (val) {

                },
                initialValue: '${state.financeTextLink.height}',
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Height required';
                  } else {
                    return null;
                  }
                },
                textAlign: TextAlign.center,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 16),
                keyboardType: TextInputType.number,
              ),
            ),
            Text(
              'Text Size',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 15,),
            MaterialButton(
              onPressed: () {

              },
              color: Color.fromRGBO(100, 100, 100, 1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(8),
              ),
              height: 30,
              minWidth: 0,
              child: Text(
                state.financeTextLink.textSize,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'HelveticaNeueMed',
                ),
              ),
            ),
            SizedBox(width: 30,),
            Text(
              'Alignment',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 15, right: 30),
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                color: Color.fromRGBO(100, 100, 100, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                onSaved: (val) {},
                onChanged: (val) {

                },
                initialValue: '58',
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Height required';
                  } else {
                    return null;
                  }
                },
                textAlign: TextAlign.center,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 16),
                keyboardType: TextInputType.number,
              ),
            ),
            Text(
              'Link Color',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 30),
              width: 30,
              height: 30,
              color: colorConvert(state.financeTextLink.linkColor),
            ),
            Container(
              width: 2,
              height: 30,
              color: Colors.grey,
            ),
            SizedBox(width: 30,),
            Text(
              'Visibility',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 30,),
            CupertinoSwitch(
              value: state.financeTextLink.visibility,
              onChanged: (val) {

              },
            ),
            SizedBox(width: 30,),
            Text(
              'Adaptive',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 30,),
            CupertinoSwitch(
              value: state.financeTextLink.adaptiveDesign,
              onChanged: (val) {

              },
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              width: 2,
              height: 30,
              color: Colors.grey,
            ),
            Text(
              'Finance Express',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 30,),
            CupertinoSwitch(
              value: false,
              onChanged: (val) {

              },
            ),
            SizedBox(width: 30,),
            Text(
              'Overlay',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 30,),
            CupertinoSwitch(
              value: true,
              onChanged: (val) {

              },
            ),
            SizedBox(width: 30,),
          ],
        ),
      ),
    );
  }

  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF"+color));
    } else if (color.length == 8) {
      return Color(int.parse("0x"+color));
    }
  }
}