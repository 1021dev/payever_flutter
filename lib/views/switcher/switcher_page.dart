import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/models/appwidgets.dart';
import 'package:payever/models/business.dart';
import 'package:payever/models/user.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/auth.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/global_keys.dart';
import 'package:payever/utils/local_storage.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/dashboard/dashboard_screen.dart';
import 'package:payever/views/switcher/loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

const double _heightFactorTablet = 0.05;
const double _heightFactorPhone = 0.07;
const double _widthFactorTablet = 2.0;
const double _widthFactorPhone = 1.1;
const double _paddingText = 16.0;

bool _isTablet = false;
bool _isPortrait = true;

SwitchParts parts = new SwitchParts();

String IMAGE_BASE      = Env.Storage + '/images/';
String WALLPAPER_BASE  = Env.Storage + '/wallpapers/'; 

class SwitcherScreen extends StatefulWidget {
  SwitcherScreen(){
    
  }
  
  @override
  _SwitcherScreenState createState() => _SwitcherScreenState();
}


class _SwitcherScreenState extends State<SwitcherScreen>
    implements LoadStateListener, AuthStateListener {
  String _userLogo = "";
  bool _moreSelected = false;
  bool _loadPersonal = false;
  bool _loadBusiness = false;
  bool _businessActiveImage = false;
  bool _isLoad = false;
  _SwitcherScreenState() {
    print("Switcher");
    var auth = AuthStateProvider();
    auth.subscribe(this);
    var load = LoadStateProvider();
    load.subscribe(this);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    parts = new SwitchParts();
  }
  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    
  return Stack(
        children: <Widget>[
          Positioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            top: 0.0,
            child: _isTablet
                ? Image.asset(
                    _isPortrait
                        ? "images/loginverticaltablet.png"
                        : "images/loginhorizontaltablet.png",
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    _isPortrait
                        ? "images/loginverticalphone.png"
                        : "images/loginhorizontalphone.png",
                    fit: BoxFit.fill),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: AnimatedOpacity(
              child: _isLoad ? Switcher() : Wait(),
              duration: Duration(milliseconds: 500), 
              opacity: 1.0,
            ),
          )
        ],
      );
  }
  @override
  void onLoadStateChanged(LoadState state) {
    // TODO: implement onLoadStateChanged
    setState(() => _isLoad = true);
  }

  @override
  void onAuthStateChanged(AuthState state) {
    // TODO: implement onAuthStateChanged
  }

  Future getBusiness(){
    SharedPreferences.getInstance().then((prefs){
        String token = prefs.getString(GlobalUtils.TOKEN);
        if (token.length > 0) {
        return RestDatasource().getUser(token,context).then((dynamic result) {
          parts._logUser = User.map(result);
          prefs.setString(GlobalUtils.LANGUAGE, parts._logUser.language);
          Language.LANGUAGE = parts._logUser.language;
          Language(context);
          Measurements.loadImages(context);
          return RestDatasource().getBusinesses(token,context).then((dynamic result) {
            result.forEach((item) {
              parts.businesses.add(Business.map(item));
            });
            return true;
          }).catchError((e){
            
          });
        }).catchError((e) {
          print('handle error on getMenuProfileData $e');
          
        });
      }else{
        return false;
      }
      });
  }

}

class GridItems extends StatefulWidget {
  Business business;
  bool haveImage;
  bool _isLoading= false;
  String imageURL;
  GridItems({this.business}){
    haveImage = (this.business.logo == null);
  } 
  @override
  _GridItemsState createState() => _GridItemsState();
}
class _GridItemsState extends State<GridItems> {

  double itemsHeight = (Measurements.height * 0.08);
  @override
  Widget build(BuildContext context) {
    return Container(
      width:itemsHeight,
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: Measurements.height * 0.01),
                  child: CustomCircleAvatar(widget.business.logo != null ? widget.business.logo : "business",widget.business.name)
                ),
                widget._isLoading?Center(child: CircularProgressIndicator()):Container(),
              ],
            ),
            Container(alignment: Alignment.center,child: Text(widget.business.name,textAlign: TextAlign.center,))
          ],
        ),
        onTap: (){
          setState(() {
            widget._isLoading = true;
          });
          parts.fetchWallpaper(widget.business.id,context).then((img){
            parts.getWidgets(widget.business.id,context).then((onValue){
            Navigator.pushReplacement(
              context,
              PageTransition(
                child:DashboardScreen(GlobalUtils.ActiveToken,img,widget.business,parts._wids,null),
                type: PageTransitionType.fade)
              );
            });
          });
        },
      ),
    );
  }
}


class Wait extends StatefulWidget {
  @override
  _WaitState createState() => _WaitState();
}

class _WaitState extends State<Wait> implements LoadStateListener {
  _WaitState() {
    RestDatasource api = new RestDatasource();
    Future<NetworkImage> getImage(String url) async {
      return NetworkImage(url);
    }
      SharedPreferences.getInstance().then((prefs){
        String token = prefs.getString(GlobalUtils.TOKEN);
        if (token.length > 0) {
        api.getUser(token,context).then((dynamic result) {
          parts._logUser = User.map(result);
          prefs.setString(GlobalUtils.LANGUAGE, parts._logUser.language);
          Language.LANGUAGE = parts._logUser.language;
          Language(context);
          Measurements.loadImages(context);
          api.getBusinesses(token,context).then((dynamic result) {
            result.forEach((item) {
              parts.businesses.add(Business.map(item));
            });
            if (parts.businesses != null) {
              parts.businesses.forEach((b) {
                if (b.active) {
                  parts._active = b;
                }
                parts._busWids.add(GridItems(business:b));
              });
            }
            parts.grid = new CustomGrid();
            var authStateProvider = LoadStateProvider();
            authStateProvider.notify(LoadState.LOADED).then((bool r) {
              var authStateProvider = LoadStateProvider();
              authStateProvider.dispose(this);
            });
          });
        }).catchError((e) {
          print('handle error on getMenuProfileData $e');
        });
      }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(""),
        )
      ],
    );
  }

  @override
  void onLoadStateChanged(LoadState state) {
    print("Loaded");
  }
}

class Switcher extends StatefulWidget {
  Switcher();
  @override
  _SwitcherState createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {

  bool _moreSelected = false;
  bool _loadPersonal = false;
  bool _loadBusiness = false;
  bool _businessActiveImage = false;

  void goPersonalDashDummy(){
    Future.delayed(Duration(milliseconds: 500)).then((_)=> setState(()=> _loadPersonal = false) );
  }
  void goPersonalDash(){
    String wallpaperid;
    RestDatasource api = RestDatasource();
      api.getWallpaperPersonal(GlobalUtils.ActiveToken.accesstoken,context).then((dynamic obj){
        wallpaperid= obj[GlobalUtils.CURRENT_WALLPAPER];

        api.getWidgetsPersonal(GlobalUtils.ActiveToken.accesstoken,context).then((dynamic obj){
          obj.forEach((item) {
            parts._wids.add(AppWidget.map(item));
          });
        Navigator.pushReplacement(
          context,
          PageTransition(
            child:DashboardScreen(
              GlobalUtils.ActiveToken,
              wallpaperid.isEmpty? NetworkImage(WALLPAPER_BASE + wallpaperid):AssetImage("images/loginhorizontaltablet.png"),
              null,
              parts._wids,
              parts._logUser),
            type: PageTransitionType.fade)
          );
        }).catchError((onError){
          print("wigets $onError");
        });
    }).catchError((onError){
      print("wallpaper $onError");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(milliseconds: 700),
          padding: EdgeInsets.only(
              top: (Measurements.height *
                  (!_moreSelected
                      ? (_isTablet ? 0.3 : _isPortrait ? 0.3 : 0.1)
                      : (_isTablet ? 0.1 : _isPortrait ? 0.1 : 0.05)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                    Text("Personal"),
                    Padding(
                      padding: EdgeInsets.only(
                          top: (Measurements.height *
                                  (_isTablet
                                      ? _heightFactorTablet
                                      : _heightFactorPhone)) /
                              3),
                    ),
                    InkWell(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          CustomCircleAvatar(parts._logUser.logo != null
                              ? parts._logUser.logo
                              : "user",parts._logUser.firstName),
                          _loadPersonal
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: Measurements.height * 0.08,
                                      width: Measurements.height * 0.08,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black.withOpacity(0.2)),
                                    ),
                                    Container(
                                      child: CircularProgressIndicator(),
                                    )
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                      onTap: () {
                        print("onIconSelect - personal");
                        setState(() => _loadPersonal = true);
                        goPersonalDashDummy();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: (Measurements.height *
                                  (_isTablet
                                      ? _heightFactorTablet
                                      : _heightFactorPhone)) /
                              3),
                    ),
                    InkWell(
                      child:Container(height:48,alignment: Alignment.center ,child: Text(parts._logUser.firstName),),
                      onTap: () {
                        print("onTextSelect - personal");
                        setState(() => _loadPersonal = true);
                        goPersonalDashDummy();
                      },
                    ),
                ],
              ),
                  ),
              parts.businesses != null
                  ? Container(
                      padding: EdgeInsets.only(
                          left:
                              (Measurements.width * (_isTablet ? 0.2 : 0.2))),
                      child: Column(
                        children: <Widget>[
                          Text("Business"),
                          Padding(
                            padding: EdgeInsets.only(
                                top: (Measurements.height *
                                        (_isTablet
                                            ? _heightFactorTablet
                                            : _heightFactorPhone)) /
                                    3),
                          ),
                          InkWell(
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                CustomCircleAvatar(parts._active.logo != null
                                    ? parts._active.logo
                                    : "business",parts._active.name),
                                _loadBusiness
                                    ? Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          Container(
                                            height:
                                                Measurements.height * 0.08,
                                            width: Measurements.height * 0.08,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black
                                                    .withOpacity(0.2)),
                                          ),
                                          Container(
                                            child:
                                                CircularProgressIndicator(),
                                          )
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                            onTap: () {
                              print("onIconSelect - business");
                              setState(() => _loadBusiness = true);

                              parts.fetchWallpaper(parts._active.id,context).then((img){
                                parts.getWidgets(parts._active.id,context).then((onValue){
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      child: DashboardScreen(
                                        GlobalUtils.ActiveToken,
                                        img,
                                        parts._active,
                                        parts._wids,null),
                                      type: PageTransitionType.fade)
                                  );
                                });
                                
                              });
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: (Measurements.height *
                                        (_isTablet
                                            ? _heightFactorTablet
                                            : _heightFactorPhone)) /
                                    3),
                          ),
                          (parts.businesses != null)
                              ? InkWell(
                                key:GlobalKeys.allButtom,
                                  child: Chip(
                                    backgroundColor:
                                        Colors.black.withOpacity(0.4),
                                    label: parts.businesses.length > 1
                                        ? Container(
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                    "All ${parts.businesses.length}"),
                                                Icon(!_moreSelected
                                                    ? IconData(58131,
                                                        fontFamily:
                                                            'MaterialIcons')
                                                    : IconData(58134,
                                                        fontFamily:
                                                            'MaterialIcons'))
                                              ],
                                            ),
                                          )
                                        : Container(
                                            child: Row(
                                              children: <Widget>[
                                                Text(parts._active.name),
                                                Icon(!_moreSelected
                                                    ? IconData(58131,
                                                        fontFamily:
                                                            'MaterialIcons')
                                                    : IconData(58134,
                                                        fontFamily:
                                                            'MaterialIcons'))
                                              ],
                                            ),
                                          ),
                                  ),
                                  onTap: () {
                                    print("onTextSelect - personal");
                                    setState(() => _moreSelected = !_moreSelected);
                                  },
                                )
                              : Container(),
                        ],
                      ))
                  : Container(),
            ],
          ),
          
        ),
        !_moreSelected
            ? Container()
            :Expanded(child:CustomGrid())
      ],
    );
  }
 
}

class SwitchParts {

  User _logUser;
  List<Business> businesses = new List();
  Business _active;
  Widget grid;
  List<GridItems> _busWids = new List();
  List<AppWidget> _wids       = new List();
  Future<String> fetchWallpaper(String id,BuildContext context) async{
    String wallpaperid;
    SharedPreferences prefs;
    RestDatasource api = new RestDatasource();
      await api.getWallpaper(id,GlobalUtils.ActiveToken.accesstoken,context).then((obj){
        wallpaperid = obj[GlobalUtils.CURRENT_WALLPAPER];
        SharedPreferences.getInstance().then((p){
          prefs = p; 
          prefs.setString(GlobalUtils.WALLPAPER, WALLPAPER_BASE + wallpaperid);
          prefs.setString(GlobalUtils.BUSINESS, id);
          print(id);
        });   
    }).catchError((onError){
      print("ERROR ---- $onError");
    });
    return   WALLPAPER_BASE + wallpaperid;
  }

  Future<AppWidget> getWidgets(String id,BuildContext context) async {
    RestDatasource api = new RestDatasource();
    await api.getWidgets(id,GlobalUtils.ActiveToken.accesstoken,context).then((dynamic obj){
      parts._wids = List();
      obj.forEach((item) {
        parts._wids.add(AppWidget.map(item));
      });
    }).catchError((onError){
      print("ERROR ---- $onError");
    });
  }
}

class  CustomCircleAvatar extends StatelessWidget {

  String url;
  ImageProvider image;
  bool _haveImage;
  String name;
  String displayName;
  String initials(){
    if(name.contains(" ")){
      displayName = name.substring(0,1);
      displayName = displayName + name.split(" ")[1].substring(0,1);
    }else{
      displayName = name.substring(0,1) + name.substring(name.length-1);
    }
    displayName = displayName.toUpperCase();
  }

  CustomCircleAvatar(this.url,this.name) {
    switch (url) {
      case "user":
        this._haveImage = false;
        initials();
        break;
      case "business":
        this._haveImage = false;
        initials();
        break;
      default:
        this._haveImage = true;
        this.image = CachedNetworkImageProvider(IMAGE_BASE + url);
        break;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        radius: Measurements.height * 0.04,
        backgroundColor: _haveImage ? Colors.transparent : Colors.grey.withOpacity(0.4),
        child: _haveImage? CircleAvatar(
          radius: Measurements.height * 0.08,
          backgroundImage: image,
          backgroundColor: Colors.transparent,
          ):Text(this.displayName,style: _isTablet ? Styles.noAvatarTablet:Styles.noAvatarPhone),
      ),
    );
  }
}

class CustomGrid extends StatefulWidget {
  @override
  _CustomGridState createState() => _CustomGridState();
}

class _CustomGridState extends State<CustomGrid> {
  @override
  Widget build(BuildContext context) {

    List<Widget> business = List();
    int index = 0;
    business.add(Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[Container(child: Text("Business"),padding: EdgeInsets.symmetric(vertical: Measurements.height * 0.01),)]));
    parts.businesses.forEach((f){
      business.add(Container(key:Key("${index}.switcher.icon"),child: GridItems(business: f,)));
      index++;
    });
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Wrap(  
          spacing: Measurements.width * 0.075,
          runSpacing: Measurements.width * 0.01,
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: business,
        ),
      ],
    );
  }
}

//___
