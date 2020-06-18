import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardOptionCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.white12,
        ),
        Container(
          height: 50,
          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.white
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Get a quick tour around products",
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
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black.withAlpha(100)
                      ),
                      child: Center(
                        child: Text("Open",
                          style: TextStyle(
                              fontSize: 8,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  InkWell(
                    onTap: () {

                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.white10,
                      size: 21,
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
