import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/settings/employees/employees_screen.dart';

bool _isTablet = false;
bool _isPortrait = true;
double _cardSize;

class SettingCardsData extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    _isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;
    _cardSize = Measurements.height * (_isTablet ? 0.03 : 0.05);

    return InkWell(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        height: _cardSize * (_isTablet ? 2.5 : 2),
        padding: EdgeInsets.only(
            bottom: Measurements.width * (_isTablet ? 0.01 : 0.015)),
        child: Row(
          children: <Widget>[
//              SizedBox(
//                width: _isTablet
//                    ? Measurements.width * 0.15
//                    : Measurements.width * 0.18,
//                height: _isTablet
//                    ? Measurements.width * 0.15
//                    : Measurements.width * 0.18,
//                child: CircleAvatar(
//                  backgroundColor: Colors.blue,
//                  child: SvgPicture.asset(
//                    "images/mailicon.svg",
////                    fit: BoxFit.fill,
//                    color: Colors.white,
//                  ),
//                ),
//              ),

            SizedBox(
              width: _isTablet
                  ? Measurements.width * 0.15
                  : Measurements.width * 0.18,
              height: _isTablet
                  ? Measurements.width * 0.15
                  : Measurements.width * 0.18,
              child: CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.3),
//                  child: Icon(Icons.settings, color: Colors.white,size: 40,),
                child: Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),

            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: AutoSizeText(
                          "Employees",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: AutoSizeText(
                          "View employees and groups.",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
//                  child: SettingsScreen(),
              child: EmployeesScreen(),
              type: PageTransitionType.fade,
            ));
      },
    );
  }
}
