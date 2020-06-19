import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionListCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Container(
        height: 60,
        color: Colors.black45,
        child: Row(
          children: [
            SizedBox(width: 16,),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 30,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "stripe",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "Adrian R",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$ 410.00",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 4,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
