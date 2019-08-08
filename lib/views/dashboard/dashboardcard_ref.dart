import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart' as prefix1;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_svg/svg.dart';
import 'package:payever/models/business.dart';
import 'package:payever/utils/appStyle.dart';
import 'package:payever/utils/global_keys.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'dart:ui';

import 'package:url_launcher/url_launcher.dart';



class DashboardCard extends StatefulWidget {

  String _appName;
  ImageProvider _imageProvider;
  Business _business;
  Widget mainCard;
  Widget secondCard;
  bool _boolbusiness = false;
  dynamic handler;
  bool _active;
  num pad;
  bool isSingleActionButton;


  DashboardCard(this._appName,this._imageProvider,this.mainCard,this.secondCard,this.handler,this._active, this.isSingleActionButton);

  @override
  _DashboardCardState createState() => _DashboardCardState(_appName,_imageProvider,mainCard,secondCard);
}

class _DashboardCardState extends State<DashboardCard> with  TickerProviderStateMixin{
  
  bool _open = false;
  var _isloading = ValueNotifier(false);
  String _appName;
  Widget mainCard;
  Widget secondCard;

  
  ImageProvider _imageProvider;
  
  _DashboardCardState(this._appName,this._imageProvider,this.mainCard,this.secondCard);


  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  void initState() {
    super.initState();
     _isloading.addListener(listen);
  }

  @override
  Widget build(BuildContext context) {
    bool _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width);
    Measurements.width  = (_isPortrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height);
    bool _isTablet = Measurements.width < 600 ? false : true; 
    double _cardSize = Measurements.height * (_isTablet?0.04:0.065);
    widget.pad = _isTablet?0.02:0.04 ;
   
    if(!widget._active)_open = false;
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return Container(
              padding: EdgeInsets.all(Measurements.width * 0.02),
              child: Column(
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(milliseconds: 50),
                    width: Measurements.width * (_isTablet? 0.7 : (_isPortrait? 0.9:1.3)),
                    child: Container(
                      child: ClipRRect(
                        borderRadius: !_open ?  BorderRadius.circular(12) :BorderRadius.only(topRight: Radius.circular(12),topLeft: Radius.circular(12)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8,sigmaY: 16),
                          child: Container(
                            color: Colors.black.withOpacity(0.2),
                            child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left:Measurements.width * widget.pad,top:Measurements.width * widget.pad,right:Measurements.width * widget.pad,bottom:Measurements.width * widget.pad/2,),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Container(height: AppStyle.iconDashboardCardSize(_isTablet),child: Image(image:_imageProvider)),
                                      Padding(padding: EdgeInsets.only(right: Measurements.width * (_isTablet? 0.01:0.02)),),
                                      Text(Language.getWidgetStrings("widgets.${widget._appName}.title")),
                                    ],),
                                    Row(
                                      children: <Widget>[
                                        // Container(
                                        //   child: ClipRect(
                                        //     child: Column(
                                        //       mainAxisAlignment: MainAxisAlignment.center,
                                        //       children: <Widget>[
                                        //       widget.isSingleActionButton
                                        //           ? singleActionButtonWidget(
                                        //               context, _isTablet)
                                        //           : actionButtonsWidget(
                                        //               context, _isTablet, widget._active),
                                        //       ],),
                                        //   ),
                                        // ),
                                        Padding(padding: EdgeInsets.only(right: Measurements.width * 0.02),),
                                        widget._active ? InkWell(
                                          radius: _isTablet ? Measurements.height * 0.02: Measurements.width * 0.07,
                                          splashColor: Colors.transparent,
                                          child: widget.isSingleActionButton
                                              ? Container() :  Container(height: _isTablet ? Measurements.height * 0.02: Measurements.width * 0.06,padding:EdgeInsets.symmetric(vertical: _isTablet?3:4) ,child: Text(_open?Language.getWidgetStrings("widgets.actions.less"):Language.getWidgetStrings("widgets.actions.more"))),onTap: (){setState(() =>_open=!_open);},):Container(),
                                       ],
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 100),
                                padding: EdgeInsets.only(bottom:Measurements.width * widget.pad,left: Measurements.width * widget.pad,right: Measurements.width * widget.pad),
                                child: mainCard
                              ),
                            ],),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
        },);
      }
      void listen() {
        setState(() {
        });
      }

  Widget singleActionButtonWidget(BuildContext context, bool _isTablet) {
    return InkWell(
      radius:
      _isTablet ? Measurements.height * 0.02 : Measurements.width * 0.07,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.02),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
          ),
          height: _isTablet
              ? Measurements.height * 0.02
              : Measurements.width * 0.07,
          child: Center(
            child:
                Container(
              alignment: Alignment.center,
                   child:Text(Language.getConnectStrings("actions.open"))
            ),
          )),
      onTap: () {
        setState(() {
          widget.handler.loadScreen(context, _isloading);
        });
      },
    );
  }

  Widget actionButtonsWidget(BuildContext context, bool _isTablet, bool isActive) {
    //print("${widget._appName}.card.open");
    return isActive
        ? InkWell(
          key: Key("${widget._appName}.card.open"),
      radius: _isTablet
          ? Measurements.height * 0.02
          : Measurements.width * 0.07,
      child: Container(
          padding:
          EdgeInsets.symmetric(horizontal: Measurements.width * 0.02),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
          ),
          height: _isTablet
              ? Measurements.height * 0.02
              : Measurements.width * 0.07,
          child: Center(
            child: 
            // _isloading.value
            //     ? Container(
            //     constraints: BoxConstraints(
            //       maxWidth: _isTablet
            //           ? Measurements.height * 0.01
            //           : Measurements.width * 0.04,
            //       maxHeight: _isTablet
            //           ? Measurements.height * 0.01
            //           : Measurements.width * 0.04,
            //     ),
            //     child: CircularProgressIndicator(
            //       strokeWidth: 2,
            //     ))
            //     :
                 Container(
              alignment: Alignment.center,
              child:Text(Language.getConnectStrings("actions.open"))
              
            ),
          )),
      onTap: () {
        setState(() {
          
          // _isloading.value = true;
          widget.handler.loadScreen(context, _isloading);
        });
      },
    )
        : Container(
        child: InkWell(
          child: Container(
              height: _isTablet
                  ? Measurements.height * 0.02
                  : Measurements.width * 0.07,
              child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        "images/launchicon.svg",
                        height:
                        Measurements.width * (_isTablet ? 0.015 : 0.03),
                        color: Colors.white.withOpacity(0.7),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.only(left: Measurements.width * 0.008),
                      ),
                      Text(
                        "Learn more",
                        style: prefix0.TextStyle(
                            color: Colors.white.withOpacity(0.7)
                            ),
                      ),
                    ],
                  ))),
          onTap: () {
            setState(() {
              isActive
                  ? widget.handler.loadScreen(context, _isloading)
                  : _launchURL(widget.handler.learnMore());
            });
          },
        ));
  }
}

abstract class CardContract{

  void loadScreen(BuildContext context,ValueNotifier state);
  String learnMore();

}
