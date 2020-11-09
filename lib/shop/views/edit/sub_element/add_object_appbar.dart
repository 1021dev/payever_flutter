import 'package:flutter/material.dart';

class AddObjectAppbar extends StatelessWidget with PreferredSizeWidget {

  final Function onClose;
  final Function onTapAdd;

  AddObjectAppbar({this.onClose, this.onTapAdd});

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onTap: null,
            ),
            SizedBox(width: 30,),
            InkWell(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              onTap: null,
            ),
            SizedBox(width: 30,),
            InkWell(
              child: Icon(
                Icons.brush,
                color: Colors.white,
              ),
              onTap: null,
            ),
            SizedBox(width: 30,),
            InkWell(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onTap: () => onTapAdd(),
            ),
            SizedBox(width: 30,),
            InkWell(
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}