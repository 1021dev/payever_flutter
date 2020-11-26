import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/sub_element/fill_color_view.dart';

class ShadowView extends StatefulWidget {
  final Map<String, dynamic>stylesheets;
  final TextStyles styles;
  final String type;
  final Function onUpdateShadow;

  const ShadowView(
      {@required this.stylesheets,
      @required this.styles,
      @required this.type,
      @required this.onUpdateShadow});

  @override
  _ShadowViewState createState() => _ShadowViewState();
}

class _ShadowViewState extends State<ShadowView> {

  bool shadowExpanded = false;
  bool isPortrait;
  bool isTablet;

  ShadowModel shadowModel;

  @override
  Widget build(BuildContext context) {

    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
    shadowModel = null;

    if (widget.type == 'button' || widget.type == 'shop-cart') {
      shadowModel = widget.styles
          .parseShadowFromString(widget.styles.boxShadow, widget.type);
    } else if (widget.type == 'image') {
      ImageStyles styles = ImageStyles.fromJson(widget.stylesheets);
      if (styles.boxShadow != null && styles.boxShadow != false)
        shadowModel = ShadowModel(
          type: 'image',
          shadowAngle: styles.shadowAngle,
          shadowBlur: styles.shadowBlur,
          shadowFormColor: styles.shadowFormColor,
          shadowOffset: styles.shadowOffset,
          shadowOpacity: styles.shadowOpacity,
        );
    } else if (widget.type == 'shape') {
      shadowModel = widget.styles
          .parseShadowFromString(widget.styles.shadow, widget.type);
    } else if (widget.type == 'social-icon') {
      shadowModel = widget.styles
          .parseShadowFromString(widget.styles.filter, widget.type);
    } else {

    }
    shadowModel?.type = widget.type;
    shadowExpanded = shadowModel != null;

    return Column(
      children: [
        Container(
          height: 60,
          child: Row(
            children: [
              Text(
                'Shadow',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Spacer(),
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: shadowExpanded,
                  onChanged: (value) {
                    if (widget.type == 'button') {
                      widget.onUpdateShadow(
                          value ? ButtonShadowModel() : null, true);
                    } else if (widget.type == 'image') {
                      widget.onUpdateShadow(
                          value ? ImageShadowModel() : null, true);
                    } else if (widget.type == 'shape') {
                      widget.onUpdateShadow(
                          value ? ShapeShadowModel() : null, true);
                    } else if (widget.type == 'shop-cart') {
                      widget.onUpdateShadow(
                          value ? CartShadowModel() : null, true);
                    } else if (widget.type == 'social-icon') {
                      widget.onUpdateShadow(
                          value ? SocialIconShadowModel() : null, true);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        if (shadowExpanded) expandedView
      ],
    );
  }

  Widget get expandedView {
    if (widget.type == 'button') return buttonShadow;
    if (widget.type == 'shape' || widget.type == 'image') return shapeShadow;
    if (widget.type == 'shop-cart' || widget.type == 'social-icon') return cartShadow;
    return Container();
  }

  Widget get buttonShadow {
    return Container(
      padding: EdgeInsets.only(left: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                child: Text(
                  'Blur',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Slider(
                  value: shadowModel.blurRadius,
                  min: 0,
                  max: 100,
                  onChanged: (double value) => _onUpdateBoxShadow(blur: value, updateApi: false),
                  onChangeEnd: (double value) => _onUpdateBoxShadow(blur: value, updateApi: true),
                ),
              ),
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  '${shadowModel.blurRadius.toInt()} px',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 50,
                child: Text(
                  'Spread',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Slider(
                  value: shadowModel.spread,
                  min: 0,
                  max: 100,
                  onChanged: (double value) => _onUpdateBoxShadow(spread: value, updateApi: false),
                  onChangeEnd: (double value) => _onUpdateBoxShadow(spread: value, updateApi: true),
                ),
              ),
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  '${shadowModel.spread.toInt()} px',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget get shapeShadow {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: GridView.count(
        padding: EdgeInsets.all(10),
        shrinkWrap: true,
        crossAxisCount: isTablet ? 5 : (isPortrait ? 3 : 5),
        crossAxisSpacing: isTablet ? 40 : (isPortrait ? 40 : 40),
        mainAxisSpacing: isTablet ? 20 : (isPortrait ? 20 : 20),
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
          6,
              (index) {
            return _shadowGridItem(index);
          },
        ),
      ),
    );
  }

  Widget get cartShadow {
    return Container(
      padding: EdgeInsets.only(left: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                child: Text(
                  'Blur',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Slider(
                  value: shadowModel.blurRadius,
                  min: 0,
                  max: 100,
                  onChanged: (double value) => _onUpdateBoxShadow(blur: value, updateApi: false),
                  onChangeEnd: (double value) => _onUpdateBoxShadow(blur: value, updateApi: true),
                ),
              ),
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  '${shadowModel.blurRadius.floor()} pt',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 50,
                child: Text(
                  'Offset',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Slider(
                  value: shadowModel.shadowOffset,
                  min: 0,
                  max: 100,
                  onChanged: (double value) => _onUpdateBoxShadow(shadowOffset: value, updateApi: false),
                  onChangeEnd: (double value) => _onUpdateBoxShadow(shadowOffset: value, updateApi: true),
                ),
              ),
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  '${shadowModel.shadowOffset.floor()} px',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 53,
                child: Text(
                  'Opacity',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Slider(
                  value: shadowModel.shadowOpacity,
                  min: 0,
                  max: 1,
                  onChanged: (double value) => _onUpdateBoxShadow(shadowOpacity: value, updateApi: false),
                  onChangeEnd: (double value) => _onUpdateBoxShadow(shadowOpacity: value, updateApi: true),
                ),
              ),
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  '${shadowModel.shadowOpacity} px',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 53,
                child: Text(
                  'Angle',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Slider(
                  value: shadowModel.shadowAngle,
                  min: 0,
                  max: 360,
                  onChanged: (double value) => _onUpdateBoxShadow(shadowAngle: value, updateApi: false),
                  onChangeEnd: (double value) => _onUpdateBoxShadow(shadowAngle: value, updateApi: true),
                ),
              ),
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  '${shadowModel.shadowAngle.floor()}\u00B0',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
          FillColorView(
              styles: widget.styles,
              colorType: ColorType.shadow,
              pickColor: shadowModel.color,
              onUpdateColor: (color)=>_onUpdateBoxShadow(color: color, updateApi: true))
        ],
      ),
    );
  }

  _onUpdateBoxShadow(
      {double blur,
      double spread,
      Color color,
      double shadowBlur,
      double shadowOffset,
      double shadowAngle,
      double shadowOpacity,
      double shadowFormColor,
      bool updateApi}) {
    shadowModel.blurRadius = blur ?? shadowModel.blurRadius;
    shadowModel.color = color ?? shadowModel.color;
    shadowModel.spread = spread ?? shadowModel.spread;
    shadowModel.shadowBlur = shadowBlur ?? shadowModel.shadowBlur;
    shadowModel.shadowOffset = shadowOffset ?? shadowModel.shadowOffset;
    shadowModel.shadowAngle = shadowAngle ?? shadowModel.shadowAngle;
    shadowModel.shadowOpacity = shadowOpacity ?? shadowModel.shadowOpacity;
    shadowModel.shadowFormColor = shadowFormColor ?? shadowModel.shadowFormColor;
    widget.onUpdateShadow(shadowModel, updateApi);
  }

  Widget _shadowGridItem(int index) {
    ShadowModel model =
        widget.styles.getShadowModel(ShadowType.values[index], Colors.black, widget.type);
    model?.type = widget.type;

    Widget item = Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: model == null ? null : [
              BoxShadow(
                color: Colors.black,
                blurRadius: model.getBlur,
                offset: Offset(
                    model.getOffSetX, model.getOffSetY), // changes position of shadow
              ),
            ],
          ),
          alignment: Alignment.center,
        ),
        if (shadowType.index == index)
          Positioned(
              bottom: 10,
              right: 10,
              child: Icon(
                Icons.check_circle,
                color: Colors.blue,
              ))
      ],
    );

    return InkWell(onTap: () => widget.onUpdateShadow(model, true), child: item);
  }

  ShadowType get shadowType {
    if (shadowModel == null) return ShadowType.none;
    double blurRadius;
    double offsetX;
    double offsetY;
    if (widget.type == 'shape') {
      blurRadius = shadowModel.blurRadius;
      offsetX = shadowModel.offsetX;
      offsetY = shadowModel.offsetY;
    } else if (widget.type == 'image') {
      blurRadius = shadowModel.shadowBlur;
      offsetX = shadowModel.getOffSetX.floor().toDouble();
      offsetY = shadowModel.getOffSetY.floor().toDouble();
    }

    if (blurRadius == 5 && offsetX == 0 && offsetY == 5)
      return ShadowType.bottom;
    if (blurRadius == 5 && offsetX == 5 && offsetY == 5)
      return ShadowType.bottomRight;
    if (blurRadius == 5 && offsetX == -5 && offsetY == 5)
      return ShadowType.bottomLeft;
    if (blurRadius == 5 && offsetX == -5 && offsetY == 0)
      return ShadowType.right;
    if (blurRadius == 0 && offsetX == 0 && offsetY == 0) return ShadowType.none;
    if (blurRadius == 5 && offsetX == -5 && offsetY == -5)
      return ShadowType.topRight;

    return ShadowType.unknown;
  }
}
