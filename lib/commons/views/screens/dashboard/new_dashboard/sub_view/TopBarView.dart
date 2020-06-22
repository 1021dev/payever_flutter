import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TopBarView extends StatelessWidget {

  final String title;
  final String iconUrl;
  final Function onTapClose;
  final Function onTapMenu;
  final Function onTapAlert;
  final Function onTapSearch;
  final Function onTapProfile;

  const TopBarView({
    Key key,
    this.title = '',
    this.iconUrl,
    this.onTapClose,
    this.onTapMenu,
    this.onTapAlert,
    this.onTapSearch,
    this.onTapProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 8,),
              SvgPicture.asset("assets/images/transactions.svg",
                  color: Colors.white, height: 16, width: 24,),
              SizedBox(width: 6,),
              Text(this.title, style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),)
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: onTapProfile,
                child: Icon(
                  Icons.person_pin,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 6,),
              InkWell(
                onTap: onTapSearch,
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 6,),
              InkWell(
                onTap: onTapAlert,
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 6,),
              InkWell(
                onTap: onTapMenu,
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 6,),
              InkWell(
                onTap: onTapClose,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 6,),
            ],
          )
        ],
      ),
    );
  }
}
