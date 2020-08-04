import 'package:flutter/material.dart';

class SectionItem extends StatelessWidget {
  final String title;
  final String detail;
  final bool isExpanded;
  final Function onTap;

  const SectionItem({this.title, this.detail, this.isExpanded, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 16,
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Spacer(),
          Container(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 150),
            child: Text(
              detail,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {},
            child: Container(
              height: 28,
              width: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black54,
              ),
              child: Center(
                child: Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          IconButton(
              icon: Icon(
                isExpanded ? Icons.remove : Icons.add,
              ),
              onPressed: onTap),
        ],
      ),
    );
  }
}
