import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/widgets/checkout_top_button.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';

class CheckoutLinkEditScreen extends StatefulWidget {

  final CheckoutScreenBloc screenBloc;
  final String title;
  Finance type;
  CheckoutLinkEditScreen(
      {this.screenBloc, this.title}){
    if (title == 'Text Link') {
      type = Finance.TEXT_LINK;
    } else if (title == 'Button') {
      type = Finance.BUBBLE;
    } else if (title == 'Calculator') {
      type = Finance.CALCULATOR;
    } else if (title == 'Bubble') {
      type = Finance.BUBBLE;
    }
  }

  _CheckoutLinkEditScreenState createState() => _CheckoutLinkEditScreenState();

}

class _CheckoutLinkEditScreenState extends State<CheckoutLinkEditScreen> {

  TextEditingController heightController = TextEditingController();
  Color pickerColor;
  String alignment = 'center';
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
            Fluttertoast.showToast(msg: state.error);
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
        alignment = widget.screenBloc.state.financeTextLink.alignment;
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
              child: MaterialButton(
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
                child: _alignmentImg(),
              ),
            ),
            Text(
              'Link Color',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: (){
                showDialog(
                  context: context,
                  child: AlertDialog(
                    title: const Text('Pick a color!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: pickerColor == null
                            ? colorConvert(widget
                                .screenBloc.state.financeTextLink.linkColor)
                            : pickerColor,
                        onColorChanged: changeColor,
                        showLabel: true,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text('Got it'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          var hex = '#${pickerColor.value.toRadixString(16)}';
                          state.financeTextLink.linkColor = hex;
                          widget.screenBloc.add(
                              UpdateFinanceExpressTypeEvent(Finance.TEXT_LINK));
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 30),
                width: 30,
                height: 30,
                color: pickerColor == null
                    ? colorConvert(widget
                    .screenBloc.state.financeTextLink.linkColor)
                    : pickerColor,
              ),
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
            Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                value: state.financeTextLink.visibility,
                onChanged: (val) {
                  state.financeTextLink.visibility = val;
                  widget.screenBloc.add(
                      UpdateFinanceExpressTypeEvent(Finance.TEXT_LINK));
                },
              ),
            ),
            SizedBox(width: 30,),
            Text(
              'Adaptive',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 30,),
            Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                value: state.financeTextLink.adaptiveDesign,
                onChanged: (val) {
                  state.financeTextLink.adaptiveDesign = val;
                  widget.screenBloc.add(
                      UpdateFinanceExpressTypeEvent(widget.type));
                },
              ),
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
            Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                value: state.financeTextLink.linkTo == 'finance_express',
                onChanged: (val) {
                  state.financeTextLink.adaptiveDesign = val;
                  widget.screenBloc.add(
                      UpdateFinanceExpressTypeEvent(widget.type));
                },
              ),
            ),
            SizedBox(width: 30,),
            Text(
              'Overlay',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 30,),
            Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                value: state.financeTextLink.linkTo == 'finance_calculator',
                onChanged: (val) {

                },
              ),
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
    } else {
      return Colors.transparent;
    }
  }

  SvgPicture _alignmentImg() {
    String asset;
    switch (alignment) {
      case 'center':
        asset = 'assets/images/alignment-center.svg';
        break;
      case 'left':
        asset = 'assets/images/alignment-left.svg';
        break;
      case 'right':
        asset = 'assets/images/alignment-right.svg';
        break;
      default:
        asset = 'assets/images/alignment-center.svg';
    }
    return SvgPicture.asset(asset, width: 16,
      height: 16,);
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  List<CheckOutPopupButton> _morePopup(BuildContext context) {
    return [
      CheckOutPopupButton(
        title: 'Copy pay link',
        icon: SvgPicture.asset(
          'assets/images/pay_link.svg',
          width: 16,
          height: 16,
        ),
        onTap: () async {

        },
      ),
      CheckOutPopupButton(
        title: 'Copy prefilled link',
        icon: SvgPicture.asset(
          'assets/images/prefilled_link.svg',
          width: 16,
          height: 16,
        ),
        onTap: () async {},
      ),
      CheckOutPopupButton(
        title: 'E-mail prefilled link',
        icon: SvgPicture.asset(
          'assets/images/email_link.svg',
          width: 16,
          height: 16,
        ),
        onTap: () async {

        },
      ),
      CheckOutPopupButton(
        title: 'Prefilled QR code',
        icon: SvgPicture.asset(
          'assets/images/prefilled_qr.svg',
          width: 16,
          height: 16,
        ),
        onTap: () async {
          setState(() {});
        },
      ),
    ];
  }
}