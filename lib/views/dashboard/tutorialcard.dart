import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/models/business.dart';
import 'package:payever/models/tutorial.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/appStyle.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/view_models/dashboard_state_model.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/views/customelements/dashboard_card_templates.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dashboardcard_ref.dart';

class SimplyTutorial extends StatefulWidget {
  String _appName;
  ImageProvider _imageProvider;
  bool firstTime = true;
  List<String> availableVideos = ["transactions","pos","products","tutorial",];
  SimplyTutorial(this._appName,this._imageProvider);
  @override
  _SimplyTutorialCardState createState() => _SimplyTutorialCardState();
}

class _SimplyTutorialCardState extends State<SimplyTutorial> {
  GlobalStateModel globalStateModel;
  DashboardStateModel dashboardStateModel;
  List<TutorialRow> tutorialrows = List(); 

  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context);
    dashboardStateModel = Provider.of<DashboardStateModel>(context);
    List<Tutorial> _tutorials = List();
    if(widget.firstTime){
      widget.firstTime  = false;
      RestDatasource().getTutorials(GlobalUtils.ActiveToken.accessToken,globalStateModel.currentBusiness.id).then((obj){
        obj.forEach((_tutorial){
          Tutorial temp = Tutorial.map(_tutorial);
          if(widget.availableVideos.contains(temp.type))
            _tutorials.add(temp);
        });
        _tutorials.sort((a,b)=> b.order.compareTo(a.order));
        dashboardStateModel.tutorials.clear();
        dashboardStateModel.setTutorials(_tutorials);
        setState((){});
      });
    }else{
      tutorialrows.clear();
      dashboardStateModel.tutorials.forEach((_tutorial){
        tutorialrows.add(TutorialRow(currentTutorial: _tutorial,business: globalStateModel.currentBusiness,));
      });
    }
    return DashboardCard_ref(
      widget._appName,
      widget._imageProvider,
      tutorialrows.isEmpty?Center(child:CircularProgressIndicator()):Head(tutorialrows),
      body:tutorialrows.isEmpty?null:Body(tutorialrows.sublist(2)),
      defPad: false,
    );
  }
}

class Head extends StatefulWidget {
  List<TutorialRow> _tutorials;
  Head(this._tutorials);
  @override
  _HeadState createState() => _HeadState();
}

class _HeadState extends State<Head> {
  @override
  Widget build(BuildContext context) {
    if(widget._tutorials.isEmpty)return null;
    if(widget._tutorials.length == 1 ) return widget._tutorials[0];
    return Container(
      child: Column(
        children: <Widget>[
          widget._tutorials[0],
          Divider(height: 1,color: Colors.white.withOpacity(0.5)),
          widget._tutorials[1]
        ],),
    );
  }
}

class Body extends StatefulWidget {
  List<TutorialRow> _tutorials;
  Body(this._tutorials);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    if(widget._tutorials.isEmpty ) return null;
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget._tutorials.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Divider(height: 1,color: Colors.white.withOpacity(0.5)),
              widget._tutorials[index],
            ],);
        },
      ),
    );
  }
}

class TutorialRow extends StatelessWidget {
  Tutorial currentTutorial;
  Business business;
  TutorialRow({this.currentTutorial,this.business});
  
  @override
  Widget build(BuildContext context) {
    bool _isTablet = Measurements.width > 600;
    return InkWell(
      child:Column(
        children: <Widget>[
          TitleAmountCardItem("",
            title: Row(
              children: <Widget>[
                SvgPicture.asset("images/playvideoicon.svg",height: AppStyle.iconDashboardCardSize(_isTablet),),
                Padding(padding: EdgeInsets.only(left: 10),),
                Text("${currentTutorial.title}",style:TextStyle(fontSize: AppStyle.fontSizeDashboardTitleAmount()),),
              ],
            ),
            amountWidget: currentTutorial.watched?SvgPicture.asset("images/watchedicon.svg"):Container(),
          ),
        ],
      ),
      onTap: (){
        RestDatasource().patchTutorials(GlobalUtils.ActiveToken.accesstoken,business.id,currentTutorial.id).then((_){});
        _launchURL(currentTutorial.url);
      },
    );
  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}