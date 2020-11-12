import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/theme.dart';

class ShopEditAppbar extends StatelessWidget with PreferredSizeWidget {

  final Function onClose;
  final Function onTapAdd;
  final Function onTapStyle;
  ShopEditAppbar({this.onClose, this.onTapAdd, this.onTapStyle});

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
              child: Text(
                'Done',
                style: TextStyle(
                  color: colorConvert('#0371E2'),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            InkWell(
              child: SvgPicture.asset('assets/images/back.svg'),
              onTap: null,
            ),
            InkWell(
              child: Icon(
                Icons.play_arrow,
                size: 40,
                color: colorConvert('#0371E2'),
              ),
              onTap: null,
            ),
            InkWell(
              child: SvgPicture.asset('assets/images/shop-brush.svg'),
              onTap: ()=> onTapStyle(),
            ),
            InkWell(
              child: SvgPicture.asset('assets/images/shop-add.svg'),
              onTap: () => onTapAdd(),
            ),
            InkWell(
                child: SvgPicture.asset('assets/images/add-contact.svg'),
                onTap: null),
            InkWell(
              child: SvgPicture.asset('assets/images/shop-more.svg'),
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }
}