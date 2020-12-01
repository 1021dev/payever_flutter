import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/theme.dart';

class ShopEditAppbar extends StatelessWidget with PreferredSizeWidget {

  final Function onTapAdd;
  final Function onTapStyle;
  final Function onClose;

  ShopEditAppbar({this.onClose, this.onTapAdd, this.onTapStyle});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ShopEditAppBarState(onTapAdd, onTapStyle, onClose);
  }
}

class ShopEditAppBarState extends StatefulWidget {
  final Function onTapAdd;
  final Function onTapStyle;
  final Function onClose;

  const ShopEditAppBarState(this.onTapAdd, this.onTapStyle, this.onClose);

  @override
  _ShopEditAppBarStateState createState() => _ShopEditAppBarStateState();
}

class _ShopEditAppBarStateState extends State<ShopEditAppBarState> {
  @override
  Widget build(BuildContext context) {
    bool isPortrait = GlobalUtils.isPortrait(context);
    double padding = isPortrait ? 0 : 10;
    return AppBar(
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: isPortrait ? MainAxisAlignment.spaceBetween: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: InkWell(
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
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: InkWell(
                child: SvgPicture.asset('assets/images/back.svg'),
                onTap: null,
              ),
            ),
            if (!isPortrait)
              Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: InkWell(
                child: Icon(
                  Icons.play_arrow,
                  size: 40,
                  color: colorConvert('#0371E2'),
                ),
                onTap: null,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: InkWell(
                child: SvgPicture.asset('assets/images/shop-brush.svg'),
                onTap: ()=> widget.onTapStyle(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: InkWell(
                child: SvgPicture.asset('assets/images/shop-add.svg'),
                onTap: () => widget.onTapAdd(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: InkWell(
                  child: SvgPicture.asset('assets/images/add-contact.svg'),
                  onTap: null),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: InkWell(
                child: SvgPicture.asset('assets/images/shop-more.svg'),
                onTap: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
