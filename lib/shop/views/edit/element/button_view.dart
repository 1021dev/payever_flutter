import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

import '../../../../theme.dart';

class ButtonView extends StatefulWidget {
  final Child child;

  const ButtonView(this.child);
  @override
  _ButtonViewState createState() => _ButtonViewState(child);
}

class _ButtonViewState extends State<ButtonView> {
  final Child child;

  _ButtonViewState(this.child);

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    if (child.styles == null || child.styles.isEmpty) {
      return Container();
    }
    ButtonStyles styles = ButtonStyles.fromJson(child.styles);
    return Container(
      width: styles.width,
      height: styles.height,
      decoration: BoxDecoration(
        color: colorConvert(styles.backgroundColor),
        borderRadius: BorderRadius.circular(styles.buttonBorderRadius()),
      ),
      margin: EdgeInsets.only(
          left: styles.marginLeft,
          right: styles.marginRight,
          top: styles.marginTop,
          bottom: styles.marginBottom),
      alignment: Alignment.center,
      child: Text(Data.fromJson(child.data).text,
          style: TextStyle(
              color: colorConvert(styles.color),
              fontSize: styles.fontSize
          )),
    );
  }

}
