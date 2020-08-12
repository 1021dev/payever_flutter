import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/widgets/checkout_top_button.dart';
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
      type = Finance.BUTTON;
    } else if (title == 'Calculator') {
      type = Finance.CALCULATOR;
    } else if (title == 'Bubble') {
      type = Finance.BUBBLE;
    }
  }

  _CheckoutLinkEditScreenState createState() => _CheckoutLinkEditScreenState();

}

class _CheckoutLinkEditScreenState extends State<CheckoutLinkEditScreen> {

  FinanceExpress financeExpress;
  TextEditingController heightController = TextEditingController();
  Color pickerColor;
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
              child: BackgroundBase(true,
                  backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
                  body: state.isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: <Widget>[
                            _getBody(state),
                            Expanded(
                              child: Container(
                                child: state.isUpdating
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Container(),
                              ),
                            ),
                          ],
                        )),
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
        financeExpress = state.financeTextLink;
        return _getTextLinkWidget(state);
      case 'Button':
        financeExpress = state.financeButton;
        return _getButtonWidget(state);
      case 'Bubble':
        financeExpress = state.financeBubble;
        return _getBubbleWidget(state);
      case 'Calculator':
        financeExpress = state.financeCalculator;
        return _getTextLinkWidget(state);
      default:
        financeExpress = state.financeTextLink;
        return _getTextLinkWidget(state);
    }
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
            _height(),
            _textSize(state),
            SizedBox(width: 30,),
            _alignment(state),
            _colorPad('Link Color'),
            SizedBox(width: 30,),
            _divider(),
            SizedBox(width: 30,),
            _visibilityAdaptive(true),
            SizedBox(width: 30,),
            _divider(),
            SizedBox(width: 30,),
            _financeExpressOverlay(),
            SizedBox(width: 30,),
          ],
        ),
      ),
    );
  }

  Widget _getButtonWidget(CheckoutScreenState state) {
    return Container(
      height: 64,
      color: Colors.black45,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 30,),
            _height(),
            _textSize(state),
//            _colorPad('Text color'),
//            _colorPad('Button color'),
            _alignment(state),
            _visibilityAdaptive(true),
            _financeExpressOverlay(),
            SizedBox(width: 30,),
          ],
        ),
      ),
    );
  }

  Widget _getBubbleWidget(CheckoutScreenState state) {
    return Container(
      height: 64,
      color: Colors.black45,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 30,),
            _visibilityAdaptive(false),
            SizedBox(width: 30,),
            _financeExpressOverlay(),
            SizedBox(width: 30,),
          ],
        ),
      ),
    );
  }

  Widget _height() {
    return Row(
      children: <Widget>[
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
              financeExpress.height = int.parse(val);
              widget.screenBloc.add(UpdateFinanceExpressTypeEvent(widget.type));
            },
            initialValue: '${financeExpress.height}',
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
      ],
    );
  }

  Widget _textSize(CheckoutScreenState state) {
    return Row(
      children: <Widget>[
        Text(
          'Text Size',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 15,),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.fromRGBO(100, 100, 100, 1),
            borderRadius: BorderRadius.circular(8),
          ),
          height: 30,
          width: 45,
          child: PopupMenuButton<CheckOutPopupButton>(
            child: Text(
              financeExpress.textSize,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'HelveticaNeueMed',
              ),
            ),
            offset: Offset(0, 100),
            onSelected: (CheckOutPopupButton item) => item.onTap(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.black87,
            itemBuilder: (BuildContext context) {
              return _textSizePopup(context, state).map((CheckOutPopupButton item) {
                return PopupMenuItem<CheckOutPopupButton>(
                  value: item,
                  child: Row(
                    children: <Widget>[
                      item.icon,
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        item.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ),
      ],
    );
  }

  Widget _alignment(CheckoutScreenState state) {
    return Row(
      children: <Widget>[
        Text(
          'Alignment',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 15, right: 30),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Color.fromRGBO(100, 100, 100, 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: PopupMenuButton<CheckOutPopupButton>(
            child: _alignmentImg(financeExpress.alignment),
            offset: Offset(0, 100),
            onSelected: (CheckOutPopupButton item) => item.onTap(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.black87,
            itemBuilder: (BuildContext context) {
              return _alignmentPopup(context, state).map((CheckOutPopupButton item) {
                return PopupMenuItem<CheckOutPopupButton>(
                  value: item,
                  child: Row(
                    children: <Widget>[
                      item.icon,
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        item.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ),
      ],
    );
  }

  Widget _colorPad(String title) {
    return Row(
      children: <Widget>[
        Text(
          title,
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
                        ? colorConvert(financeExpress.linkColor)
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
                      var hex = '${pickerColor.value.toRadixString(16)}';
                      financeExpress.linkColor = '#${hex.substring(2)}';
                      widget.screenBloc.add(
                          UpdateFinanceExpressTypeEvent(widget.type));
                    },
                  ),
                ],
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(left: 15),
            width: 30,
            height: 30,
            color: pickerColor == null
                ? colorConvert(financeExpress.linkColor)
                : pickerColor,
          ),
        ),
      ],
    );
  }

  Widget _visibilityAdaptive(bool showAdaptive) {
    return Row(
      children: <Widget>[
        Text(
          'Visibility',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 30,),
        Transform.scale(
          scale: 0.8,
          child: CupertinoSwitch(
            value: financeExpress.visibility,
            onChanged: (val) {
              financeExpress.visibility = val;
              widget.screenBloc.add(
                  UpdateFinanceExpressTypeEvent(widget.type));
            },
          ),
        ),
        showAdaptive ? Row(
          children: <Widget>[
            SizedBox(width: 30,),
            Text(
              'Adaptive',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 30,),
            Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                value: financeExpress.adaptiveDesign,
                onChanged: (val) {
                  financeExpress.adaptiveDesign = val;
                  widget.screenBloc.add(
                      UpdateFinanceExpressTypeEvent(widget.type));
                },
              ),
            ),
          ],
        ): Container(),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 2,
      height: 30,
      color: Colors.grey,
    );
  }

  Widget _financeExpressOverlay() {
    return Row(
      children: <Widget>[
        Text(
          'Finance Express',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 30,),
        Transform.scale(
          scale: 0.8,
          child: CupertinoSwitch(
            value: financeExpress.linkTo == 'finance_express',
            onChanged: (val) {
              financeExpress.linkTo = val ? 'finance_express' : '';
              widget.screenBloc.add(UpdateFinanceExpressTypeEvent(widget.type));
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
            value: financeExpress.linkTo == 'finance_calculator',
            onChanged: (val) {
              financeExpress.linkTo = val ? 'finance_calculator' : '';
              widget.screenBloc.add(UpdateFinanceExpressTypeEvent(widget.type));
            },
          ),
        ),
      ],
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

  SvgPicture _alignmentImg(String alignment) {
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

  List<CheckOutPopupButton> _alignmentPopup(BuildContext context, CheckoutScreenState state) {
    return [
      CheckOutPopupButton(
        title: '',
        icon:_alignmentImg('center'),
        onTap: () async {
          updateAlignment('center');
        },
      ),
      CheckOutPopupButton(
        title: '',
        icon: _alignmentImg('left'),
        onTap: () async {
          updateAlignment('left');
        },
      ),
      CheckOutPopupButton(
        title: '',
        icon: _alignmentImg('right'),
        onTap: () async {
          updateAlignment('right');
        },
      ),
    ];
  }

  List<CheckOutPopupButton> _textSizePopup(BuildContext context, CheckoutScreenState state) {
    return [
      CheckOutPopupButton(
        title: '12px',
        icon: Container(),
        onTap: () async {
          updateTextSize('12px');
        },
      ),
      CheckOutPopupButton(
        title: '14px',
        icon: Container(),
        onTap: () async {
          updateTextSize('14px');
        },
      ),
      CheckOutPopupButton(
        title: '16px',
        icon: Container(),
        onTap: () async {
          updateTextSize('16px');
        },
      ),
      CheckOutPopupButton(
        title: '18px',
        icon: Container(),
        onTap: () async {
          updateTextSize('18px');
        },
      ),
    ];
  }

  void updateAlignment(String alignment) {
    setState(() {
      financeExpress.alignment = alignment;
    });
    widget.screenBloc.add(UpdateFinanceExpressTypeEvent(widget.type));
  }

  void updateTextSize(String size) {
    setState(() {
      financeExpress.textSize = size;
    });
    widget.screenBloc.add(UpdateFinanceExpressTypeEvent(widget.type));
  }
}