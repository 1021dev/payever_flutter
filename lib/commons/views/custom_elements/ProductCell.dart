import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/utils/env.dart';

class ProductCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.fromLTRB(4, 0, 46, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.black38
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(Env.commerceOs +
                            "/assets/ui-kit/icons-png/icon-commerceos-ad-64.png"),
                        fit: BoxFit.fitWidth)),
              ),
            ],
          ),
          SizedBox(height: 2),
          Text(
            "Durable Iron Happy Continue",
            softWrap: true,
            maxLines: 2,
            style: TextStyle(
                fontSize: 10,
                color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 2),
          Text(
            "738,66 \$",
            softWrap: true,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 8,
                color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
