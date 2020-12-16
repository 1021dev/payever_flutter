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
  @override
  Widget build(BuildContext context) {
    bool isPortrait = GlobalUtils.isPortrait(context);

    return Container(
      height: isPortrait? 350: 200,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Container(
            color: Color.fromRGBO(23, 23, 25, 1),
            padding: EdgeInsets.only(top: 18),
            child: widget.child,
            ),
          ),
        ),
      );
  }
}
