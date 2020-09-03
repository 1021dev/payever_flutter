import 'package:flutter/material.dart';
import 'package:payever/theme.dart';

class SecondAppbar extends StatefulWidget {
  final Function onTap;

  int selectedIndex;

  SecondAppbar({
    this.onTap,
    this.selectedIndex = 0,
  });

  @override
  _SecondAppbarState createState() => _SecondAppbarState();
}

class _SecondAppbarState extends State<SecondAppbar> {
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
            InkWell(
              onTap: () {
                widget.onTap(0);
                setState(() {
                  widget.selectedIndex = 0;
                });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  height: double.infinity,
                  alignment: Alignment.center,
                  color: widget.selectedIndex == 0
                      ? Colors.white12
                      : Colors.transparent,
                  child: Text(
                    'Personal information',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            InkWell(
              onTap: () {
                widget.onTap(1);
                setState(() {
                  widget.selectedIndex = 1;
                });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  height: double.infinity,
                  alignment: Alignment.center,
                  color: widget.selectedIndex == 1
                      ? Colors.white12
                      : Colors.transparent,
                  child: Text(
                    'Language',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            InkWell(
              onTap: () {
                widget.onTap(2);
                setState(() {
                  widget.selectedIndex = 2;
                });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  height: double.infinity,
                  alignment: Alignment.center,
                  color: widget.selectedIndex == 2
                      ? Colors.white12
                      : Colors.transparent,
                  child: Text(
                    'Shipping address',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            InkWell(
              onTap: () {
                widget.onTap(3);
                setState(() {
                  widget.selectedIndex = 3;
                });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  height: double.infinity,
                  alignment: Alignment.center,
                  color: widget.selectedIndex == 3
                      ? Colors.white12
                      : Colors.transparent,
                  child: Text(
                    'Password',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            InkWell(
              onTap: () {
                widget.onTap(4);
                setState(() {
                  widget.selectedIndex = 4;
                });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  height: double.infinity,
                  alignment: Alignment.center,
                  color: widget.selectedIndex == 4
                      ? Colors.white12
                      : Colors.transparent,
                  child: Text(
                    'Email notifications',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            InkWell(
              onTap: () {
                widget.onTap(5);
                setState(() {
                  widget.selectedIndex = 5;
                });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  height: double.infinity,
                  alignment: Alignment.center,
                  color: widget.selectedIndex == 5
                      ? Colors.white12
                      : Colors.transparent,
                  child: Text(
                    'Wallpapers',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
