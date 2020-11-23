import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';

class ShadowView extends StatefulWidget {

  final TextStyles styles;
  final String type;
  final Function onUpdateShadow;

  const ShadowView({@required this.styles, @required this.type, @required this.onUpdateShadow});

  @override
  _ShadowViewState createState() => _ShadowViewState();
}

class _ShadowViewState extends State<ShadowView> {
  bool shadowExpanded = false;
  bool isPortrait;
  bool isTablet;
  ShadowModel shadowModel;
  final ShadowModel defaultShadow = ShadowModel(blurRadius: 5, offsetX: 5, offsetY: 5, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
    shadowModel = widget.styles.parseShadowFromString(widget.styles.shadow);
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
                  onChanged: (value) => widget.onUpdateShadow(value ? defaultShadow : null),
                ),
              ),
            ],
          ),
        ),
        if (shadowExpanded)
          expandedView

      ],
    );
  }

  Widget get expandedView {
    if (widget.type == 'button')
      return buttonShadow;

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

  Widget get buttonShadow {
    return Container(
      padding: EdgeInsets.only(left: 16),
      height: 60,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Corners',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Slider(
                  value: shadowModel.blurRadius,
                  min: 0,
                  max: 100,
                  onChanged: (double value) => widget.onUpdateShadow(value, false),
                  onChangeEnd: (double value) => widget.onUpdateShadow(value, true),
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
              Text(
                'Corners',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Slider(
                  value: shadowModel.blurRadius,
                  min: 0,
                  max: 100,
                  onChanged: (double value) => widget.onUpdateShadow(value, false),
                  onChangeEnd: (double value) => widget.onUpdateShadow(value, true),
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
        ],
      ),
    );
  }

  Widget _shadowGridItem(int index) {
    ShadowModel model = widget.styles.getShadowModel(ShadowType.values[index], Colors.black);
    print('shadowType :${shadowType.index}');
    Widget item = Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: model.blurRadius,
                offset: Offset(model.offsetX, model.offsetY), // changes position of shadow
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

    return InkWell(
        onTap: () => widget.onUpdateShadow(model),
        child: item);
  }

  ShadowType get shadowType {
    if (shadowModel == null) return ShadowType.None;
    double blurRadius; double offsetX; double offsetY;

    blurRadius = shadowModel.blurRadius;
    offsetX = shadowModel.offsetX;
    offsetY = shadowModel.offsetY;

    if (blurRadius == 5 && offsetX == 0 && offsetY == 5)
      return ShadowType.Bottom;
    if (blurRadius == 5 && offsetX == 5 && offsetY == 5)
      return ShadowType.BottomRight;
    if (blurRadius == 5 && offsetX == -5 && offsetY == 5)
      return ShadowType.BottomLeft;
    if (blurRadius == 5 && offsetX == -5 && offsetY == 0)
      return ShadowType.Right;
    if (blurRadius == 0 && offsetX == 0 && offsetY == 0)
      return ShadowType.None;
    if (blurRadius == 5 && offsetX == -5 && offsetY == -5)
      return ShadowType.TopRight;

    return ShadowType.Unknown;
  }
}
