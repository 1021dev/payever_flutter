import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';

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
      color: Colors.black87,
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
          MaterialButton(
            onPressed: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            height: 24,
            minWidth: 0,
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Text(
              Language.getCheckoutStrings('checkout_sdk.action.edit'),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
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
