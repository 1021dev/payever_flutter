
import 'package:flutter/material.dart';
import 'package:payever/utils/utils.dart';


class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget activeIcon,
    String title,
    Color color,
    TickerProvider vsync,
    bool tablet,
  }) : _icon = icon,
        _title = title,
       item = BottomNavigationBarItem(
         icon: icon,
         activeIcon: activeIcon,
         title:Container(padding: EdgeInsets.only(top: Measurements.width * (tablet?0.005:0.015)),child:Text(title,style: TextStyle(fontSize: 10),)),
         backgroundColor: color,
       ),
       controller = AnimationController(
         duration: kThemeAnimationDuration,
         vsync: vsync,
       ) {
    _animation = controller.drive(CurveTween(
      curve: const Interval(1.0, 1.0, curve: Curves.linear),
    ));
  }

  final Widget _icon;
  final String _title;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  Animation<double> _animation;

  FadeTransition transition(BottomNavigationBarType type, BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: _animation.drive(
          Tween<Offset>(
            begin: const Offset(0.0, 0.0), 
            end: Offset.zero,
          ),
        ),
        
      ),
    );
  }
}
