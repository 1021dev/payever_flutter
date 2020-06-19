import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TopBarView extends StatelessWidget {
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
              SvgPicture.asset("assets/images/payeverlogo.svg",
                  color: Colors.white, height: 15),
              SizedBox(width: 6,),
              Text("Business", style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),)
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: () {

                },
                child: Icon(
                  Icons.person_pin,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              SizedBox(width: 8,),
              InkWell(
                onTap: () {

                },
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              SizedBox(width: 8,),
              InkWell(
                onTap: () {

                },
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              SizedBox(width: 8,),
              InkWell(
                onTap: () {

                },
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              SizedBox(width: 8,),
              InkWell(
                onTap: () {

                },
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 15,
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
