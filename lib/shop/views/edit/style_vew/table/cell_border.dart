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
import '../style_container.dart';
import 'cell_border_style_view.dart';
import 'font_size.dart';

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
  BorderModel borderModel;

  @override
  void initState() {
    ShopEditScreenState state = widget.screenBloc.state;
    selectedChildId = state.selectedChild.id;
    styles = TableStyles.fromJson(widget.screenBloc.state.pageDetail.stylesheets[selectedChildId]);
    borderModel = styles.borderWidth == 0
        ? null
        : BorderModel(
        borderColor: styles.borderColor,
        borderStyle: styles.borderStyle,
        borderWidth: styles.borderWidth);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
    return body();
  }

  Widget body() {
    return StyleContainer(
      child: Column(
        children: [
          Toolbar(backTitle: 'Cell', title: 'Cell Border', onClose: widget.onClose),
          SizedBox(
            height: 10,
          ),
          Expanded(child: mainBody()),
        ],
      ),
    );
  }

  Widget mainBody() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _gridView,
            SizedBox(height: 5,),
            _annotationText,
            _borderStyle,
            _lineType,
            _addConditionalHighlight,
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
              Map<String, dynamic> sheets = widget.stylesheets[selectedChildId];
              sheets['cellBorder'] = borderAssets[index];
              _updateSheets(sheets);
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
        navigateSubView(
            CellBorderStyleView(
              borderModel: borderModel,
              onClose: widget.onClose,
              onChangeBorderModel: _updateBorderModel,
            ),
            context);
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
                child: borderModel != null
                    ? borderStyleWidget(borderModel)
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
            Widget subview = BorderStyleView(
              borderStyle: borderModel?.borderStyle,
              title: 'Line Type',
              backTitle: 'Cell Border',
              onClose: widget.onClose,
              hasNone: true,
              onChangeBorderStyle: (style) {
                borderModel?.borderStyle = style;
                if (style == null) {
                  borderModel = null;
                } else {
                  if (borderModel == null) {
                    borderModel = BorderModel(
                        borderWidth: 1,
                        borderColor: encodeColor(Colors.grey),
                        borderStyle: style);
                  }
                }
                _updateBorderModel(borderModel);
              },
            );
            navigateSubView(subview, context);
          },
          child: Container(
            height: 50,
            child:  Row(
              children: [
                Text(
                  'Line Type',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: borderModel != null
                        ? borderStyleWidget(BorderModel(borderWidth: 3, borderStyle: borderModel.borderStyle, borderColor: '#FFFFFF'))
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
        if (borderModel != null)
        Column(
          children: [
              FillColorView(
              pickColor: colorConvert(borderModel.borderColor),
              styles: styles,
              colorType: ColorType.border,
              onUpdateColor: (Color color) {
                borderModel.borderColor = encodeColor(color);
                _updateBorderModel(borderModel);
              },
            ),
            FontSize(
              screenBloc: widget.screenBloc,
              fontSize: borderModel.borderWidth,
              hasFontFactor: false,
              title: 'Width',
              onUpdateFontSize: (double value) {
                borderModel.borderWidth = value;
                _updateBorderModel(borderModel);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget get _addConditionalHighlight {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            Widget subview;
            navigateSubView(subview, context);
          },
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromRGBO(51, 48, 53, 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Add Conditional Highlighting',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Automatically highlight cells that match rules you specify.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  _updateBorderModel(BorderModel model) {
    borderModel = model;
    Map<String, dynamic>sheets = widget.stylesheets;
    if (model == null || model.borderStyle == null) {
      sheets['borderStyle'] = null;
      sheets['borderWidth'] = 0;
      sheets['cellBorder'] = null;
    } else {
      sheets['borderWidth'] = model.borderWidth;
      sheets['borderColor'] = model.borderColor;
      sheets['borderStyle'] = model.borderStyle;
    }
    _updateSheets(sheets);
  }

  _updateSheets(Map<String, dynamic>sheets) {
    setState(() {

    });
    widget.onUpdateStyles(sheets);
  }
}
