import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BorderView extends StatefulWidget {
  @override
  _BorderViewState createState() => _BorderViewState();
}

class _BorderViewState extends State<BorderView> {
  bool borderExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          child: Row(
            children: [
              Text(
                'Border',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Spacer(),
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: borderExpanded,
                  onChanged: (value) {
                    setState(() {
                      borderExpanded = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        if (borderExpanded)
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              children: [
                Container(
                  height: 60,
                  child: Row(
                    children: [
                      Text(
                        'Style',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: 4,
                            color: Colors.white,
                          )),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
                // _fill(state, ColorType.Border),
                Container(
                  height: 60,
                  child: Row(
                    children: [
                      Text(
                        'Width',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: 4,
                            color: Colors.white,
                          )),
                      Text(
                        '1 pt',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
      ],
    );
  }
}
