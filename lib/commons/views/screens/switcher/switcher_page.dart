import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/models/fetchwallpaper.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';
import 'package:payever/commons/views/screens/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../../view_models/view_models.dart';
import '../../../models/models.dart';
import '../../../network/network.dart';
import '../../../utils/utils.dart';
import 'loader.dart';


import 'package:payever/commons/views/screens/dashboard/new_dashboard/dashboard_screen.dart';
//import '../dashboard/dashboard_screen_ref.dart';

const double _heightFactorTablet = 0.05;
const double _heightFactorPhone = 0.07;
//const double _widthFactorTablet = 2.0;
//const double _widthFactorPhone = 1.1;
//const double _paddingText = 16.0;

bool _isTablet = false;
bool _isPortrait = true;

class SwitcherScreen extends StatefulWidget {
  SwitcherScreen();

  @override
  createState() => _SwitcherScreenState();
}

class _SwitcherScreenState extends State<SwitcherScreen> {

  bool isSetLanguage = false;
  SwitcherScreenBloc screenBloc = SwitcherScreenBloc();

  @override
  void initState() {
    super.initState();
    screenBloc.add(SwitcherScreenInitialEvent());
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

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, SwitcherScreenState state) async {
        if (state is SwitcherScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is SwitcherScreenStateSuccess) {
//          Provider.of<GlobalStateModel>(context,listen: false)
//              .setCurrentBusiness(state.business);
//          Provider.of<GlobalStateModel>(context,listen: false)
//              .setCurrentWallpaper('$wallpaperBase${state.wallpaper.currentWallpaper.wallpaper}');
//          Navigator.pop(context, 'changed');
        }
      },
      child: BlocBuilder<SwitcherScreenBloc, SwitcherScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, SwitcherScreenState state) {
          if (!isSetLanguage && state.logUser != null) {
            Language.language = state.logUser.language;
            Language(context);
            Measurements.loadImages(context);
            isSetLanguage = true;
          }
          return _body(state);
        },
      ),
    );
  }

  Widget _body(SwitcherScreenState state) {
    return Stack(
      children: <Widget>[
        Positioned(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width + 200,
          left: -50,
          top: 0.0,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width + 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    '${Env.cdn}/images/commerceos-background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BlurEffectView(
              blur: 5,
              radius: 0,
              child: Container(
                color: Colors.black.withAlpha(50),
              ),
            ),
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          body: AnimatedOpacity(
            child: state.isLoading ? Wait() : Switcher(screenBloc: screenBloc,),
            duration: Duration(milliseconds: 500),
            opacity: 1.0,
          ),
        )
      ],
    );
  }
}

class GridItems extends StatefulWidget {
  final Business business;
  final Function onTap;
  final bool isLoading;
  GridItems({this.business, this.onTap, this.isLoading = false});

  @override
  createState() => _GridItemsState();
}

class _GridItemsState extends State<GridItems> {
  double itemsHeight = (Measurements.height * 0.08);

  bool haveImage;
  String imageURL;

  @override
  void initState() {
    super.initState();

    setState(() {
      haveImage = (widget.business.logo == null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: itemsHeight,
      child: InkWell(
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        vertical: Measurements.height * 0.01),
                    child: CustomCircleAvatar(
                        widget.business.logo != null
                            ? widget.business.logo
                            : 'business',
                        widget.business.name)),
                widget.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(),
              ],
            ),
            Container(
                alignment: Alignment.center,
                child: Text(
                  widget.business.name,
                  textAlign: TextAlign.center,
                ))
          ],
        ),
        onTap: widget.onTap,
      ),
    );
  }
}

class Wait extends StatefulWidget {
  @override
  _WaitState createState() => _WaitState();
}

class _WaitState extends State<Wait> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}

class Switcher extends StatefulWidget {
  final SwitcherScreenBloc screenBloc;
  Switcher({this.screenBloc});

  @override
  _SwitcherState createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  bool _moreSelected = false;

  @override
  Widget build(BuildContext context) {
    Business active;
    if (widget.screenBloc.state.businesses.length > 0) {
      active = widget.screenBloc.state.businesses.firstWhere((element) => element.active);
    }
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
              widget.screenBloc.state.businesses.length > 0
                  ? Container(
                  child: Column(
                    children: <Widget>[
                      Text('BUSINESS', style: TextStyle(
                          color: Colors.white.withAlpha(200)
                      ),),
                      Padding(
                        padding: EdgeInsets.only(
                            top: (Measurements.height *
                                (_isTablet
                                    ? _heightFactorTablet
                                    : _heightFactorPhone)) /
                                3),
                      ),
                      InkWell(
                        highlightColor: Colors.transparent,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            CustomCircleAvatar(
                                active.logo != null
                                    ? active.logo
                                    : 'business',
                                active.name),
                            widget.screenBloc.state.isLoading
                                ? Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  height: Measurements.height * 0.08,
                                  width: Measurements.height * 0.08,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black
                                          .withOpacity(0.2)),
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
                          print('onIconSelect - business');
                          widget.screenBloc.add(SwitcherSetBusinessEvent(business: active));
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
                      widget.screenBloc.state.businesses.length > 0
                          ? InkWell(
                        key: GlobalKeys.allButton,
                        highlightColor: Colors.transparent,
                        child: Chip(
                          backgroundColor:
                          Colors.black.withOpacity(0.4),
                          label: widget.screenBloc.state.businesses.length > 1
                              ? Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                    'All ${widget.screenBloc.state.businesses.length}'),
                                Icon(!_moreSelected
                                    ? IconData(
                                  58131,
                                  fontFamily:
                                  'MaterialIcons',
                                )
                                    : IconData(
                                  58134,
                                  fontFamily:
                                  'MaterialIcons',
                                ),
                                ),
                              ],
                            ),
                          )
                              : Container(
                            child: Row(
                              children: <Widget>[
                                Text(active.name),
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
                          print('onTextSelect - personal');
                          setState(
                                  () => _moreSelected = !_moreSelected);
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
            : Expanded(
          child: CustomGrid(
            screenBloc: widget.screenBloc,
          ),
        ),
      ],
    );
  }
}

class CustomCircleAvatar extends StatelessWidget {
  final String url;
  final String name;

  CustomCircleAvatar(this.url, this.name);

  @override
  Widget build(BuildContext context) {
    ImageProvider image;
    bool _haveImage;
    String displayName;

    if (url.contains('user') || url.contains('business')) {
      _haveImage = false;
      if (name.contains(' ')) {
        displayName = name.substring(0, 1);
        displayName = displayName + name.split(' ')[1].substring(0, 1);
      } else {
        displayName = name.substring(0, 1) + name.substring(name.length - 1);
        displayName = displayName.toUpperCase();
      }
    } else {
      _haveImage = true;
      image = CachedNetworkImageProvider(imageBase + url);
    }

    return Container(
      child: CircleAvatar(
        radius: Measurements.height * 0.04,
        backgroundColor:
        _haveImage ? Colors.transparent : Colors.grey.withOpacity(0.4),
        child: _haveImage
            ? CircleAvatar(
          radius: Measurements.height * 0.08,
          backgroundImage: image,
          backgroundColor: Colors.transparent,
        )
            : Text(displayName,
            style:
            _isTablet ? Styles.noAvatarTablet : Styles.noAvatarPhone),
      ),
    );
  }
}

class CustomGrid extends StatefulWidget {
  final SwitcherScreenBloc screenBloc;

  CustomGrid({this.screenBloc,});
  @override
  _CustomGridState createState() => _CustomGridState();
}

class _CustomGridState extends State<CustomGrid> {
  Business selected;
  @override
  Widget build(BuildContext context) {
    List<Widget> business = List();
    int index = 0;
    business.add(
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Container(
            child: Text('Business'),
            padding: EdgeInsets.symmetric(vertical: Measurements.height * 0.01),
          )
        ]));
    widget.screenBloc.state.businesses.forEach((f) {
      business.add(
        Container(
          key: Key('$index.switcher.icon'),
          child: GridItems(
            business: f,
            onTap: () {
              setState(() {
                selected = f;
              });
              widget.screenBloc.add(SwitcherSetBusinessEvent(business: f));
            },
            isLoading: f == selected,
          ),
        ),
      );
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