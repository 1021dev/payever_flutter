import 'package:flutter/material.dart';
import 'package:payever/theme.dart';

class SecondAppbar extends StatelessWidget {

  final Function onTapGetStarted;
  final Function onTapContinueSetup;
  final Function onTapLearnMore;

  SecondAppbar({
    this.onTapGetStarted,
    this.onTapContinueSetup,
    this.onTapLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      color: Colors.black87,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 12,
            ),
            MaterialButton(
              onPressed: () {

              },
              minWidth: 20,
              height: double.infinity,
              padding: EdgeInsets.zero,
              child: Text('Personal information', style: TextStyle(color: Colors.white),),
            ),
            SizedBox(
              width: 12,
            ),
            MaterialButton(
              onPressed: () {

              },
              minWidth: 20,
              padding: EdgeInsets.zero,
              child: Text('Language', style: TextStyle(color: Colors.white),),
            ),
            SizedBox(
              width: 16,
            ),
            MaterialButton(
              onPressed: () {

              },
              minWidth: 20,
              padding: EdgeInsets.zero,
              child: Text('Shipping address', style: TextStyle(color: Colors.white),),
            ),
            SizedBox(
              width: 12,
            ),
            MaterialButton(
              onPressed: () {

              },
              minWidth: 20,
              padding: EdgeInsets.zero,
              child: Text('Password', style: TextStyle(color: Colors.white),),
            ),
            SizedBox(
              width: 12,
            ),
            MaterialButton(
              onPressed: () {

              },
              minWidth: 20,
              padding: EdgeInsets.zero,
              child: Text('Email notifications', style: TextStyle(color: Colors.white),),
            ),
            SizedBox(
              width: 12,
            ),
            MaterialButton(
              onPressed: () {

              },
              minWidth: 20,
              padding: EdgeInsets.zero,
              child: Text('Wallpapers', style: TextStyle(color: Colors.white),),
            ),
            SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
    );
  }
}
