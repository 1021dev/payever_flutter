import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:payever/models/transaction.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/utils.dart';

class SearchParts{
  bool _isPortrait;
  bool _isTablet;
}

class SearchCard extends StatefulWidget {
  String oldString ="";
  SearchParts _parts;
  ValueNotifier<String> search;
  String id;
  Stopwatch watch = Stopwatch();
  Timer t;
  
  SearchCard(this.search,this.id){
    _parts = SearchParts();
    
  }

  @override
  _SearchCardState createState() => _SearchCardState();

}

class _SearchCardState extends State<SearchCard> {
  List<Transaction> _list = List();
  @override
  void initState() {
    super.initState();
    widget.search.addListener(listener);
    widget.watch.start();
    }
    @override
    Widget build(BuildContext context) {
      widget._parts._isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
      Measurements.height = (widget._parts._isPortrait ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width);
      Measurements.width  = (widget._parts._isPortrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height);
      widget._parts._isTablet = Measurements.width < 600 ? false : true;
      return Container(
        margin: EdgeInsets.symmetric(horizontal: Measurements.width * 0.05),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            
          ),
        );
    }
    void listener(){
      if(widget.watch.elapsedMilliseconds<2500){
        print("send");
        send();
      }else{
        widget.watch.reset();
        delete();
      }
    }
    void send(){
      RestDatasource api= RestDatasource();
        api.getTransactionList(widget.id, GlobalUtils.ActiveToken.accessToken, "?limit=8&query=${widget.search.value}&orderBy=created_at&direction=desc",context).then((result){
          print(result);
          _list=List();
          widget.oldString = widget.search.value;
        });
    }
    void delete(){
      RestDatasource api= RestDatasource();
        api.deleteTransactionList(widget.id, GlobalUtils.ActiveToken.accessToken, "?limit=8&query=${widget.oldString}&orderBy=created_at&direction=desc").then((result){
          print(result);
          send();
        });
    }
}