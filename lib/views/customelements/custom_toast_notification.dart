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
    bool isTablet = MediaQuery.of(context).size.width>600;
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
              Container(
                width: Measurements.width * 0.10,
                height: Measurements.width * 0.10,
                child: Icon(
                  icon,
                  size: Measurements.width * (isTablet?0.04:0.07),
                  color: Color(0XFF0084ff),
                ),
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
