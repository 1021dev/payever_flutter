import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TutorialCell extends StatelessWidget {
  final String title;
  final bool showUnderline;

  TutorialCell({this.title, this.showUnderline = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 39,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.videocam,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Text(
                    title,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(width: 12),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {

                    },
                    child: Container(
                      height: 20,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black.withAlpha(100)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text("Open",
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.white
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        if (showUnderline) Container(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
          height: 1,
          color: Colors.white12,
        ),
      ],
    );
  }
}
