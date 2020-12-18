import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';

class StyleContainer extends StatefulWidget {
  final Widget child;

  const StyleContainer({Key key, this.child}) : super(key: key);

  @override
  _StyleContainerState createState() => _StyleContainerState();
}

class _StyleContainerState extends State<StyleContainer> {
  bool isPortrait;
  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);

    return Container(
      height: isPortrait? 350: 200,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          right: false,
          left: false,
          child: Container(
            color: Color.fromRGBO(23, 23, 25, 1),
            padding: padding,
            child: widget.child,
            ),
          ),
        ),
      );
  }
  EdgeInsets get padding {
    return isPortrait ? EdgeInsets.only(top: 18) : EdgeInsets.only(top: 18, left: 60, right: 60);
  }
}
