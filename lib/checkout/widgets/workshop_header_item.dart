import 'package:flutter/material.dart';

class WorkshopHeader extends StatelessWidget {

  final String title;
  final String subTitle;
  final bool isExpanded;
  final bool isApproved;
  final Function onTap;
  const WorkshopHeader({this.title, this.subTitle = '', this.isExpanded, this.isApproved = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 100,
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            subTitle,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Visibility(
            visible: isApproved,
            child: IconButton(
                icon: Icon(
                  this.isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black38,
                ),
                onPressed: () {
                  this.onTap();
                }),
          )
        ],
      ),
    );
  }
}
