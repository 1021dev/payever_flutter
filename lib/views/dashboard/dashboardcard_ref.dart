import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_svg/svg.dart';
import 'package:payever/models/business.dart';
import 'package:payever/utils/appStyle.dart';
import 'package:payever/utils/global_keys.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/customelements/dashboardcard_content.dart';
import 'dart:ui';

import 'package:url_launcher/url_launcher.dart';



class DashboardCard_ref extends StatefulWidget {

  String appName;
  ImageProvider imageProvider;
  Business _business;
  Widget header;
  Widget body;
  bool _boolbusiness = false;
  bool _open = false;
  dynamic handler;
  bool _active;
  bool defPad;
  num pad = 0.02;
  bool isSingleActionButton;
  
  DashboardCard_ref(this.appName,this.imageProvider,this.header,{this.body,this.defPad = true});

  @override
  _DashboardCard_refState createState() => _DashboardCard_refState();
}

class _DashboardCard_refState extends State<DashboardCard_ref> with  TickerProviderStateMixin{
  Duration _duration = Duration(milliseconds: 300);
  _DashboardCard_refState();
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
  }



  @override
  Widget build(BuildContext context) {
    bool _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width);
    Measurements.width  = (_isPortrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height);
    bool _isTablet = Measurements.width < 600 ? false : true;
      return Container(
        padding: EdgeInsets.symmetric(vertical:Measurements.width * 0.01),
        child: Column(
          children: <Widget>[
            AnimatedContainer(
              duration: _duration,
              width: Measurements.width * (_isTablet? 0.7 : (_isPortrait? 0.9:1.3)),
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8,sigmaY: 16),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                      child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding:EdgeInsets.all(AppStyle.dashboardCardContentPadding()),
                                child: Row(
                                  children: <Widget>[
                                    Container(height: AppStyle.iconDashboardCardSize(_isTablet),child: Image(image:widget.imageProvider,height: AppStyle.iconDashboardCardSize(_isTablet))),
                                    Padding(padding: EdgeInsets.only(right: Measurements.width * (_isTablet? 0.01:0.02)),),
                                    Text(Language.getWidgetStrings("widgets.${widget.appName}.title"),style: TextStyle(fontSize: AppStyle.fontSizeDashboardTitle()),),
                                  ],
                                ),
                              ),
                              widget.body != null?
                              InkWell(
                                child: AnimatedContainer(
                                  padding: EdgeInsets.all(AppStyle.dashboardCardContentPadding()),
                                  duration: _duration,
                                  child: Text(!widget._open?"Show More":"Show Less",style: TextStyle(fontSize: AppStyle.fontSizeDashboardShow()),),
                                ),
                                onTap:(){
                                  listen();
                                },
                              ):Container(),
                            ],
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(minHeight: 75),
                          padding: widget.defPad?EdgeInsets.symmetric(vertical:AppStyle.dashboardCardContentPadding()/(_isTablet?2:2),horizontal: AppStyle.dashboardCardContentPadding()*1.5):EdgeInsets.symmetric(vertical:AppStyle.dashboardCardContentPadding()/2),
                          child: DashboardCardPanel(
                            animationDuration: _duration,
                            child: ExpansionPanel(
                              body: widget.body??Container(),
                              isExpanded: widget._open,
                              headerBuilder: (BuildContext context, bool isExpanded) => widget.header,
                            ),
                          ),
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
      }
      void listen() {
        setState(() {
          widget._open = !widget._open;
        });
      }
  // Widget singleActionButtonWidget(BuildContext context, bool _isTablet) {
  //   return InkWell(
  //     radius:
  //     _isTablet ? Measurements.height * 0.02 : Measurements.width * 0.07,
  //     child: Container(
  //         padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.02),
  //         decoration: BoxDecoration(
  //           shape: BoxShape.rectangle,
  //           color: Colors.grey.withOpacity(0.3),
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         height: _isTablet
  //             ? Measurements.height * 0.02
  //             : Measurements.width * 0.07,
  //         child: Center(
  //           child:
  //               Container(
  //             alignment: Alignment.center,
  //                  child:Text(Language.getConnectStrings("actions.open"))
  //           ),
  //         )),
  //     onTap: () {
  //       setState(() {
  //         widget.handler.loadScreen(context, _isloading);
  //       });
  //     },
  //   );
  // }

  // Widget actionButtonsWidget(BuildContext context, bool _isTablet, bool isActive) {
  //   return isActive
  //       ? InkWell(
  //         key: Key("${widget.appName}.card.open"),
  //     radius: _isTablet
  //         ? Measurements.height * 0.02
  //         : Measurements.width * 0.07,
  //     child: Container(
  //         padding:
  //         EdgeInsets.symmetric(horizontal: Measurements.width * 0.02),
  //         decoration: BoxDecoration(
  //           shape: BoxShape.rectangle,
  //           color: Colors.grey.withOpacity(0.3),
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         height: _isTablet
  //             ? Measurements.height * 0.02
  //             : Measurements.width * 0.07,
  //         child: Center(
  //           child: 
  //           // _isloading.value
  //           //     ? Container(
  //           //     constraints: BoxConstraints(
  //           //       maxWidth: _isTablet
  //           //           ? Measurements.height * 0.01
  //           //           : Measurements.width * 0.04,
  //           //       maxHeight: _isTablet
  //           //           ? Measurements.height * 0.01
  //           //           : Measurements.width * 0.04,
  //           //     ),
  //           //     child: CircularProgressIndicator(
  //           //       strokeWidth: 2,
  //           //     ))
  //           //     :
  //                Container(
  //             alignment: Alignment.center,
  //             child:Text(Language.getConnectStrings("actions.open"))
              
  //           ),
  //         )),
  //     onTap: () {
  //       setState(() {
          
  //         // _isloading.value = true;
  //         widget.handler.loadScreen(context, _isloading);
  //       });
  //     },
  //   )
  //       : Container(
  //       child: InkWell(
  //         child: Container(
  //             height: _isTablet
  //                 ? Measurements.height * 0.02
  //                 : Measurements.width * 0.07,
  //             child: Container(
  //                 width: 100,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.rectangle,
  //                   color: Colors.grey.withOpacity(0.3),
  //                   borderRadius: BorderRadius.circular(15),
  //                 ),
  //                 child: Row(
  //                   mainAxisSize: MainAxisSize.max,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: <Widget>[
  //                     SvgPicture.asset(
  //                       "images/launchicon.svg",
  //                       height:
  //                       Measurements.width * (_isTablet ? 0.015 : 0.03),
  //                       color: Colors.white.withOpacity(0.7),
  //                     ),
  //                     Padding(
  //                       padding:
  //                       EdgeInsets.only(left: Measurements.width * 0.008),
  //                     ),
  //                     Text(
  //                       "Learn more",
  //                       style: TextStyle(
  //                           color: Colors.white.withOpacity(0.7)
  //                           ),
  //                     ),
  //                   ],
  //                 ))),
  //         onTap: () {
  //           setState(() {
  //             isActive
  //                 ? widget.handler.loadScreen(context, _isloading)
  //                 : _launchURL(widget.handler.learnMore());
  //           });
  //         },
  //       ));
  // }
}

// abstract class CardContract{
//   void loadScreen(BuildContext context,ValueNotifier state);
//   String learnMore();
// }
