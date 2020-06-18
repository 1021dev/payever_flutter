import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class DashboardMenuView extends StatelessWidget {
  final Widget scaffold;
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  DashboardMenuView({this.scaffold, this.innerDrawerKey});

  @override
  Widget build(BuildContext context) {
    return InnerDrawer(
      key: innerDrawerKey,
      rightAnimationType: InnerDrawerAnimation.quadratic,
      onTapClose: true,
      rightOffset: 0,
      swipe: false,
      colorTransitionChild: Colors.transparent,
      colorTransitionScaffold: Colors.black.withAlpha(50),
      rightChild: SafeArea(
        top: true,
        child: Container(
          color: Colors.black,
        ),
      ),
      scaffold: scaffold,
    );
  }
}
