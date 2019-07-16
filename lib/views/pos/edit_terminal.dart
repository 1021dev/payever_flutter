import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/models/business.dart';
import 'package:payever/models/pos.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payever/views/login/login_page.dart';
import 'package:payever/views/pos/native_pos_screen.dart';
import 'package:payever/views/pos/pos_screen.dart';

class EditTerminal extends StatefulWidget {
  bool _isPortrait;
  bool _isTablet;
  String _name;
  String _logo;
  String _wallpaper;
  String _id;
  String _business;
  Terminal _currentTerm;
  Business business;
  EditTerminal(this._wallpaper,this._name,this._logo,this._id,this._business,this._currentTerm,this.business){
   
  }
  @override
  _EditTerminalState createState() => _EditTerminalState();
}

class _EditTerminalState extends State<EditTerminal> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        widget._isPortrait = Orientation.portrait == orientation;
        widget._isTablet = Measurements.width < 600 ? false : true; 
        return Stack(
        children: <Widget>[
          Positioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            top: 0.0,
            child: CachedNetworkImage(
              imageUrl: widget._wallpaper,
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          Scaffold(
            appBar: AppBar(elevation: 0,backgroundColor: Colors.transparent,leading: InkWell(radius: 20,child: Icon(IconData(58829, fontFamily: 'MaterialIcons')),onTap: (){Navigator.pop(context);},),),
            backgroundColor: Colors.black.withOpacity(0.2),
            body: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
              child:  EditForm(widget._name, widget._logo,widget._id,widget._business,widget._currentTerm,widget._wallpaper,widget._isTablet,widget.business),
            )
          )
        ]
      ); 
      },
       
    );
  }
}

class EditForm extends StatefulWidget {
  String _name;
  String _logo;
  String _newName;
  String _id;
  String _business;
  Business business;
  
  bool _isLoading = false;
  bool _isTablet = false;
  Terminal _currentTerm;
  String _wallpaper;
  
  EditForm(this._name,this._logo,this._id,this._business,this._currentTerm,this._wallpaper,this._isTablet,this.business){
    _newName = _name;
    
  }
  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  String IMAGE_BASE    = Env.Storage + '/images/';
  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      RestDatasource api = RestDatasource();
      api.postEditTerminal(widget._id, widget._newName, widget._logo,widget._business, GlobalUtils.ActiveToken.accessToken).then((res){
        print(res);
        widget._currentTerm.name = widget._newName;
        widget._currentTerm.logo = widget._logo;
        Navigator.pushReplacement(context, PageTransition(child:NativePosScreen(terminal:widget._currentTerm,business:widget.business),type:PageTransitionType.fade));        
      }
    ).catchError((onError){
      if(onError.toString().contains("401")){
        GlobalUtils.clearCredentials();
        Navigator.pushReplacement(context,PageTransition(child:LoginScreen() ,type: PageTransitionType.fade));
      }
    });
    }
  }
  static final formKey = new GlobalKey<FormState>();


  File _image;
   
  Future getImage() async {
    widget._isLoading = true;
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image.existsSync())
      setState(() {
        _image = image;
        RestDatasource api = RestDatasource();
          api.postTerminalImage(image, widget._business, GlobalUtils.ActiveToken.accessToken).then((dynamic res){
            widget._logo =  res["blobName"];
            api.postEditTerminal(widget._id, widget._newName, widget._logo,widget._business, GlobalUtils.ActiveToken.accessToken).then((res){
              print(res);
              setState(() {
              widget._isLoading= false;
              });
            });
        }).catchError((onError){
          setState(() {
            print(onError);
            widget._isLoading= false;
          });
          if(onError.toString().contains("401")){
            GlobalUtils.clearCredentials();
            Navigator.pushReplacement(context,PageTransition(child:LoginScreen() ,type: PageTransitionType.fade));
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(builder: (BuildContext context, Orientation orientation) {
      return Container(
      padding: EdgeInsets.symmetric(horizontal: (orientation == Orientation.portrait?Measurements.width:Measurements.height) *(widget._isTablet?  0.15:0.05)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: Measurements.height * (widget._isTablet? 0.07:0.08),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15),),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: InkWell(
                    child: Stack(
                      alignment: Alignment.topRight ,
                      children: <Widget>[
                        widget._logo!=null ? Center(child:CircleAvatar(backgroundColor: Colors.grey, backgroundImage: NetworkImage(IMAGE_BASE +widget._logo),)):Center(child:CircleAvatar(child:Center(child:SvgPicture.asset("images/newpicicon.svg") ),backgroundColor: Colors.grey,)),
                        widget._logo!=null ? Container(
                          decoration:BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.3),
                          ),
                          child: Icon(Icons.close,color: Colors.white.withOpacity(0.7),)
                        ,):Container(),
                        widget._isLoading?Center(child:CircularProgressIndicator()):Container(),
                      ],
                    ),
                    onTap: (){
                      if(widget._logo!=null){
                        setState(() {
                          widget._logo = null;
                        });
                      }else{
                          getImage();
                      }
                    },
                  ),
                ),

                Padding(padding: EdgeInsets.only(left: Measurements.width *0.03),),
                Container(
                  width: Measurements.width * 0.5,
                  child: Form(
                    key: formKey,
                    child: Center(
                      child: TextFormField(
                        onSaved: (val) => widget._newName = val,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Terminal name is required';
                          }
                        },
                        decoration: new InputDecoration(
                          labelText: "Terminal name",
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                        initialValue: widget._name
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15),),),
              height: Measurements.height * 0.07,
              child: Center(
                child:Text("Done"),
              ),
            ),
            onTap: (){
              print("done ${widget._id}");
              _submit();
            },
          ),
        ],
      ),
    );
    },);
  }
}