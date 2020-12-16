import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StyleContainer extends StatefulWidget {
  final Widget child;

  const StyleContainer({Key key, this.child}) : super(key: key);

  @override
  _StyleContainerState createState() => _StyleContainerState();
}

class _StyleContainerState extends State<StyleContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
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
