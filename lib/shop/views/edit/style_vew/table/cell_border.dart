import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/sub_view/border_style_view.dart';
import 'package:payever/shop/views/edit/style_vew/sub_view/toolbar.dart';
import 'package:payever/theme.dart';
import '../fill_color_view.dart';
import 'cell_border_style_view.dart';

class CellBorder extends StatefulWidget {

  final ShopEditScreenBloc screenBloc;
  final Function onUpdateStyles;
  final Function onClose;
  final Map<String, dynamic> stylesheets;

  const CellBorder(
      {@required this.screenBloc,
      @required this.onUpdateStyles,
      @required this.onClose,
      @required this.stylesheets});

  @override
  _CellBorderState createState() => _CellBorderState();
}

class _CellBorderState extends State<CellBorder> {
  bool isPortrait;
  bool isTablet;

  TableStyles styles;
  String selectedChildId;
  List<String>borderAssets = ['outside', 'inside', 'all', 'left', 'vertical', 'right', 'top', 'horizontal', 'bottom'];
  String borderStyle;
  double borderWidth;
  Color borderColor;

  @override
  void initState() {
    ShopEditScreenState state = widget.screenBloc.state;
    selectedChildId = state.selectedChild.id;
    styles = TableStyles.fromJson(state.pageDetail.stylesheets[selectedChildId]);
    borderWidth = styles.borderWidth;
    borderColor = colorConvert(styles.borderColor);
    borderStyle = borderWidth == 0 ? null : styles.borderStyle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
    return body();
  }

  Widget body() {
    styles = TableStyles.fromJson(widget.screenBloc.state.pageDetail.stylesheets[selectedChildId]);
    return Container(
      height: 400,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Container(
            color: Color.fromRGBO(23, 23, 25, 1),
            padding: EdgeInsets.only(top: 18, bottom: 32),
            child: Column(
              children: [
                Toolbar(backTitle: 'Cell', title: 'Cell Border', onClose: widget.onClose),
                SizedBox(
                  height: 10,
                ),
                Expanded(child: mainBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mainBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _gridView,
            SizedBox(height: 5,),
            _annotationText,
            _borderStyle,
            _lineType,
          ],
        ),
      ),
    );
  }

  Widget get _gridView {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      crossAxisCount: isTablet ? 5 : (isPortrait ? 3 : 5),
      crossAxisSpacing: 1,
      mainAxisSpacing: 1,
      childAspectRatio: 1 / 0.3,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(9,
            (index) {
          return InkWell(
            onTap: () {
              Map<String, dynamic> sheets = widget.screenBloc.state.pageDetail.stylesheets[selectedChildId];
              // sheets['headerColumnColor'] = headerColumnColor;
              // sheets['headerRowColor'] = headerRowColor;
              // _updateStyles(sheets);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(46, 45, 50, 1),
                borderRadius: _borderRadius(index),
              ),
              padding: EdgeInsets.all(8),
              child: SvgPicture.asset(
                  'assets/images/border-${borderAssets[index]}.svg',),
            ),
          );
        },
      ),
    );
  }

  BorderRadius _borderRadius(int index) {
    switch(index) {
      case 0:
        return BorderRadius.only(topLeft: Radius.circular(8));
      case 2:
        return BorderRadius.only(topRight: Radius.circular(8));
      case 6:
        return BorderRadius.only(bottomLeft: Radius.circular(8));
      case 8:
        return BorderRadius.only(bottomRight: Radius.circular(8));
      default:
        return BorderRadius.zero;
    }
  }

  Widget get _annotationText {
    return Text('Tap a border to edit it. Touch and hod to select an additional border.', style: TextStyle(fontSize: 13, color: Colors.grey),);
  }

  Widget get _borderStyle {
    return InkWell(
      onTap: () {
        navigateSubView(CellBorderStyleView(
          borderStyle: borderStyle,
          onClose: widget.onClose,
          hasNone: true,
          onChangeBorderStyle: (style) {
            // borderModel.borderStyle = style;
            // _updateBorderModel(true);
          },
        ), context);
      },
      child: Container(
        height: 60,
        child: Row(
          children: [
            Text(
              'Border',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
                child: borderStyle != null
                    ? borderStyleWidget(borderStyle)
                    : Text(
                        'No Border',
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                        textAlign: TextAlign.end,
                      )),
            SizedBox(
              width: 16,
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  Widget get _lineType {
    return Column(
      children: [
        InkWell(
          onTap: () {
            navigateSubView(BorderStyleView(
              borderStyle: borderStyle,
              title: 'Cell Border',
              backTitle: 'Line Type',
              onClose: widget.onClose,
              hasNone: true,
              onChangeBorderStyle: (style) {
                Map<String, dynamic>sheets = widget.stylesheets;
                sheets['borderStyle'] = style;
                if (style == null) {
                  sheets['borderWidth'] = 0;
                } else {
                  if (borderWidth == 0) {
                    sheets['borderWidth'] = 1;
                    sheets['borderColor'] = encodeColor(Colors.grey);
                  }
                }
                _updateSheets(sheets);
              },
            ), context);
          },
          child: Container(
            height: 50,
            child:  Row(
              children: [
                Text(
                  'Line',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: borderStyle != null
                        ? borderStyleWidget(borderStyle)
                        : Text(
                      'None',
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                      textAlign: TextAlign.end,
                    )),
                SizedBox(
                  width: 16,
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
        if (borderStyle != null)
        Column(
          children: [
            Container(
              height: 50,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    child: Text(
                      'Width',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: borderWidth > 10 ? 10 : borderWidth,
                      min: 0,
                      max: 10,
                      onChanged: (double value) {
                        borderWidth = value;
                        _updateBorderModel();
                      },
                      onChangeEnd: (double value) {
                        borderWidth = value;
                        _updateBorderModel();
                      },
                    ),
                  ),
                  Text(
                    '${borderWidth.round()} px',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            FillColorView(
              pickColor: borderColor,
              styles: styles,
              colorType: ColorType.border,
              onUpdateColor: (Color color) {
                String hexColor = encodeColor(color);
                Map<String, dynamic>sheets = widget.stylesheets;
                sheets['borderColor'] = hexColor;
                _updateSheets(sheets);
              },
            ),
          ],
        ),
      ],
    );
  }

  _updateBorderModel() {
    // widget.onUpdateBorderModel(borderModel,);
  }

  _updateSheets(Map<String, dynamic>sheets) {
    widget.onUpdateStyles(sheets);
  }
}
