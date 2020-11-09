import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopEditAppbar extends StatelessWidget with PreferredSizeWidget {

  final Function onClose;
  final Function onTapAdd;

  ShopEditAppbar({this.onClose, this.onTapAdd});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            InkWell(
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onTap: null,
            ),
            InkWell(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              onTap: null,
            ),
            InkWell(
              child: Icon(
                Icons.brush,
                color: Colors.white,
              ),
              onTap: null,
            ),
            InkWell(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onTap: () => onTapAdd(),
            ),
            InkWell(
                child: Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
                onTap: null),
            InkWell(
              child: Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
              onTap: null,
            ),
            InkWell(
              child: Icon(
                Icons.remove_red_eye,
                color: Colors.white,
              ),
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }
}