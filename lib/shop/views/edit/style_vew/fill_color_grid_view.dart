import 'package:flutter/material.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';

class FillColorGridView extends StatefulWidget {
  final Function onUpdateColor;
  final bool hasText;

  const FillColorGridView({this.onUpdateColor, this.hasText});

  @override
  _FillColorGridViewState createState() => _FillColorGridViewState();
}

class _FillColorGridViewState extends State<FillColorGridView> {
  bool isPortrait;
  bool isTablet;

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        crossAxisCount: isTablet ? 5 : (isPortrait ? 3 : 5),
        crossAxisSpacing: isTablet ? 40 : (isPortrait ? 40 : 40),
        mainAxisSpacing: isTablet ? 20 : (isPortrait ? 20 : 20),
        childAspectRatio: 1 / 0.7,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
          6,
              (index) {
            return _textBackgroundGridItem(index);
          },
        ),
      ),
    );
  }

  Widget _textBackgroundGridItem(int index) {
    Widget item = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: textBgColors[index],
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget.hasText
          ? Text(
        'Text',
        style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold),
      )
          : Container(),
    );

    return InkWell(
        onTap:()=> widget.onUpdateColor(textBgColors[index]),
        child: item);
  }
}
