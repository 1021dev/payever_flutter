import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';

class ShadowView extends StatefulWidget {

  final TextStyles styles;
  final Function onUpdateShadow;

  const ShadowView({@required this.styles, @required this.onUpdateShadow});

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
                  onChanged: (value) {
                    setState(() {
                      shadowExpanded = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        if (shadowExpanded)
          Container(
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
          )
      ],
    );
  }

  Widget _shadowGridItem(int index) {
    double offsetX = 0;
    double offsetY = 0;
    double blurRadius = 5;
    switch (index) {
      case 0:
        offsetX = 0;
        offsetY = 5;
        break;
      case 1:
        offsetX = 5;
        offsetY = 5;
        break;
      case 2:
        offsetX = -5;
        offsetY = 5;
        break;
      case 3:
        offsetX = -5;
        offsetY = 0;
        break;
      case 4:
        offsetX = 0;
        offsetY = 0;
        blurRadius = 0;
        break;
      case 5:
        offsetX = -5;
        offsetY = -5;
        break;
    }

    Widget item = Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: blurRadius,
                offset: Offset(offsetX, offsetY), // changes position of shadow
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
        onTap: () {
          ShadowModel model = ShadowModel(blurRadius: blurRadius, offsetX: offsetX, offsetY: offsetY, color: Colors.black);
          widget.onUpdateShadow(model);
        },
        child: item);
  }

  ShadowType get shadowType {
    double blurRadius; double offsetX; double offsetY;

    if (shadowModel == null) return ShadowType.None;

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
