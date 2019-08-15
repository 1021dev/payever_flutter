import 'package:flutter/material.dart';
import 'package:payever/utils/utils.dart';

bool _isPortrait;
bool _isTablet;

class CustomToastNotification extends StatelessWidget {
  final IconData icon;
  final String toastText;

  const CustomToastNotification({Key key, this.icon, this.toastText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
<<<<<<< HEAD
    bool isTablet = MediaQuery.of(context).size.width>600;
=======

    _isTablet = MediaQuery.of(context).size.width > 600;

>>>>>>> 14f9a4311f9cd4671f366ee5424e080255ccab0f
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width:
              _isTablet ? Measurements.width * 0.40 : Measurements.width * 0.70,
          height: _isTablet
              ? Measurements.width * 0.06
              : Measurements.height * 0.07,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
<<<<<<< HEAD
              Container(
                width: Measurements.width * 0.10,
                height: Measurements.width * 0.10,
                child: Icon(
                  icon,
                  size: Measurements.width * (isTablet?0.04:0.07),
                  color: Color(0XFF0084ff),
                ),
=======
              Icon(
                icon,
                size: _isTablet
                    ? Measurements.width * 0.04
                    : Measurements.width * 0.07,
                color: Colors.blueAccent,
>>>>>>> 14f9a4311f9cd4671f366ee5424e080255ccab0f
              ),
              SizedBox(width: 7),
              Text(
                toastText,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
