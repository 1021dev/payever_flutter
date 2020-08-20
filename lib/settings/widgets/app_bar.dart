import 'package:flutter/material.dart';

class Appbar extends StatelessWidget  with PreferredSizeWidget {
  final String title;
  final Function onClose;
  Appbar(this.title, {this.onClose});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32, maxWidth: 32, minHeight: 32, minWidth: 32),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: onClose != null ? onClose : () {
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }
}