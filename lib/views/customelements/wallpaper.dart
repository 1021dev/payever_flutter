import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:provider/provider.dart';

class BackgroundBase extends StatefulWidget {
  bool _isBlur;
  Widget body, endDrawer,bottomNav;
  AppBar appBar;
  Key currentKey;
  BackgroundBase(this._isBlur,{this.body,this.endDrawer,this.bottomNav,this.appBar,this.currentKey});

  @override
  _BackgroundBaseState createState() => _BackgroundBaseState();
}

class _BackgroundBaseState extends State<BackgroundBase> {
  GlobalStateModel globalStateModel;
  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context);;
    return Stack(
      //overflow: Overflow.visible,
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          top: 0.0,
          child: Container(
            child: CachedNetworkImage(
              imageUrl: widget._isBlur?globalStateModel.currentWallpaperBlur:globalStateModel.currentWallpaper,
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: Measurements.height,
          width:  Measurements.width,
            child: Scaffold(
              key: widget.currentKey,
              backgroundColor: Colors.transparent,
              appBar: widget.appBar,
              endDrawer: widget.endDrawer,
              body: widget.body,
              bottomNavigationBar: widget.bottomNav,
            ),
          )
      ]);
  }
}