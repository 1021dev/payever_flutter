import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/screens/login/login_page.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/connect/views/connect_category_more_connections.dart';
import 'package:payever/connect/views/connect_version_history_screen.dart';
import 'package:payever/connect/widgets/connect_item_image_view.dart';
import 'package:payever/connect/widgets/connect_top_button.dart';

class ConnectDetailScreen extends StatefulWidget {
  final ConnectModel connectModel;
  final ConnectScreenBloc screenBloc;

  ConnectDetailScreen({
    this.connectModel,
    this.screenBloc,
  });

  @override
  State<StatefulWidget> createState() {
    return _ConnectDetailScreenState();
  }
}

class _ConnectDetailScreenState extends State<ConnectDetailScreen> {
  bool _isPortrait;
  bool _isTablet;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  double iconSize;
  double margin;
  List<ConnectPopupButton> uninstallPopUp(BuildContext context, ConnectScreenState state) {
    return [
      ConnectPopupButton(
        title: Language.getConnectStrings('actions.uninstall'),
        onTap: () async {
        },
      ),
    ];
  }

  @override
  void initState() {
    widget.screenBloc.add(ConnectDetailEvent(model: widget.connectModel));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
      bloc: widget.screenBloc,
      listener: (BuildContext context, ConnectScreenState state) async {
        if (state is ConnectScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<ConnectScreenBloc, ConnectScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, ConnectScreenState state) {
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomPadding: false,
            appBar: _appBar(state),
            body: SafeArea(
              child: BackgroundBase(
                true,
                backgroudColor: Color.fromRGBO(0, 0, 0, 0.75),
                body: state.isLoading ?
                Center(
                  child: CircularProgressIndicator(),
                ): Center(
                  child: _getBody(state),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(ConnectScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Text(
            Language.getPosConnectStrings(widget.connectModel.integration.displayOptions.title),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
            maxHeight: 32,
            maxWidth: 32,
            minHeight: 32,
            minWidth: 32,
          ),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody(ConnectScreenState state) {
    String iconType = state.editConnect.displayOptions.icon ?? '';
    iconType = iconType.replaceAll('#icon-', '');
    iconType = iconType.replaceAll('#', '');
    String imageUrl = state.editConnect.installationOptions.links.length > 0
        ? state.editConnect.installationOptions.links.first.url ?? '': '';

    iconSize = _isTablet ? 120: 80;
    margin = _isTablet ? 24: 16;
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(margin),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: margin),
                    child: SvgPicture.asset(
                      Measurements.channelIcon(iconType),
                      width: iconSize,
                      color: Color.fromRGBO(255, 255, 255, 0.75),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      Language.getPosConnectStrings(state.editConnect.displayOptions.title),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'HelveticaNeueMed',
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      Language.getPosConnectStrings(state.editConnect.installationOptions.price),
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.6),
                                        fontFamily: 'HelveticaNeueLight',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      Language.getPosConnectStrings(state.editConnect.installationOptions.developer),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'HelveticaNeue',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _isTablet || !_isPortrait ? Container(
                              child: widget.connectModel.installed ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(0),
                                    child: MaterialButton(
                                      onPressed: () {

                                      },
                                      color: Color.fromRGBO(255, 255, 255, 0.1),
                                      height: 26,
                                      minWidth: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      elevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      hoverElevation: 0,
                                      child: Text(
                                        Language.getPosConnectStrings('integrations.actions.open'),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'HelveticaNeueMed',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(0),
                                    child: PopupMenuButton<ConnectPopupButton>(
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: SvgPicture.asset('assets/images/more.svg'),
                                      ),
                                      offset: Offset(0, 100),
                                      onSelected: (ConnectPopupButton item) => item.onTap(),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      color: Colors.black87,
                                      itemBuilder: (BuildContext context) {
                                        return uninstallPopUp(context, state)
                                            .map((ConnectPopupButton item) {
                                          return PopupMenuItem<ConnectPopupButton>(
                                            value: item,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  item.title,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: item.icon,
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ),
                                ],
                              ) : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(right: 16),
                                    child: MaterialButton(
                                      onPressed: () {

                                      },
                                      color: Color.fromRGBO(255, 255, 255, 0.1),
                                      height: 26,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      minWidth: 0,
                                      elevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      hoverElevation: 0,
                                      child: Text(
                                        Language.getPosConnectStrings('integrations.actions.install'),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'HelveticaNeueMed',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ): Container(),
                          ],
                        ),
                        _isTablet || !_isPortrait
                            ? Container()
                            : Container(
                          child: widget.connectModel.installed ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(0),
                                child: MaterialButton(
                                  onPressed: () {

                                  },
                                  color: Color.fromRGBO(255, 255, 255, 0.1),
                                  height: 26,
                                  minWidth: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  elevation: 0,
                                  focusElevation: 0,
                                  highlightElevation: 0,
                                  hoverElevation: 0,
                                  child: Text(
                                    Language.getPosConnectStrings('integrations.actions.open'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'HelveticaNeueMed',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(0),
                                child: PopupMenuButton<ConnectPopupButton>(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: SvgPicture.asset('assets/images/more.svg'),
                                  ),
                                  offset: Offset(0, 100),
                                  onSelected: (ConnectPopupButton item) => item.onTap(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: Colors.black87,
                                  itemBuilder: (BuildContext context) {
                                    return uninstallPopUp(context, state)
                                        .map((ConnectPopupButton item) {
                                      return PopupMenuItem<ConnectPopupButton>(
                                        value: item,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              item.title,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8),
                                              child: item.icon,
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ],
                          ) : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 16),
                                child: MaterialButton(
                                  onPressed: () {

                                  },
                                  color: Color.fromRGBO(255, 255, 255, 0.1),
                                  height: 26,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  minWidth: 0,
                                  elevation: 0,
                                  focusElevation: 0,
                                  highlightElevation: 0,
                                  hoverElevation: 0,
                                  child: Text(
                                    Language.getPosConnectStrings('integrations.actions.install'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'HelveticaNeueMed',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 24,
                          thickness: 0.5,
                          color: Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            state.editConnect.reviews.length > 0 ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${state.editConnect.reviews.length}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'HelveticaNeueMed',
                                        fontSize: 21,
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(left: 4),
                                            child: SvgPicture.asset(
                                              'assets/images/star_fill.svg',
                                              width: 14,
                                              height: 14,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 4),
                                            child: SvgPicture.asset(
                                              'assets/images/star_fill.svg',
                                              width: 14,
                                              height: 14,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 4),
                                            child: SvgPicture.asset(
                                              'assets/images/star_fill.svg',
                                              width: 14,
                                              height: 14,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 4),
                                            child: SvgPicture.asset(
                                              'assets/images/star_fill.svg',
                                              width: 14,
                                              height: 14,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 4),
                                            child: SvgPicture.asset(
                                              'assets/images/star_fill.svg',
                                              width: 14,
                                              height: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  Language.getPosConnectStrings('25 Ratings'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'HelveticaNeueLight',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ) : Text(
                              'No rating',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'HelveticaNeueMed',
                                fontSize: 16,
                              ),
                            ),
                            _isTablet || !_isPortrait ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${state.editConnect.timesInstalled ?? 0}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'HelveticaNeueMed',
                                    fontSize: 21,
                                  ),
                                ),
                                Text(
                                  Language.getPosConnectStrings('Times Downloaded'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'HelveticaNeueLight',
                                    fontSize: 12,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 8),
                                ),
                              ],
                            ): Container(),
                          ],
                        ),
                        _isTablet || !_isPortrait ? Container()
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                            ),
                            Text(
                              '${state.editConnect.timesInstalled ?? 0}',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'HelveticaNeueMed',
                                fontSize: 21,
                              ),
                            ),
                            Text(
                              Language.getPosConnectStrings('Times Downloaded'),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'HelveticaNeueLight',
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 200,
              padding: EdgeInsets.all(margin),
              child: ConnectItemImageView(
                imageUrl,
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: margin, right: margin),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      Language.getPosConnectStrings(state.editConnect.installationOptions.description),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'HelveticaNeue',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(margin),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        Language.getPosConnectStrings(state.editConnect.installationOptions.developer),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'HelveticaNeue',
                          fontSize: 12,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                      ),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              Language.getConnectStrings('installation.labels.website'),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'HelveticaNeueLight',
                                fontSize: 12,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: SvgPicture.asset('assets/images/website.svg'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                      ),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              Language.getConnectStrings('Support'),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'HelveticaNeueLight',
                                fontSize: 12,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: SvgPicture.asset('assets/images/support.svg'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            Divider(
              height: margin,
              thickness: 0.5,
              color: Color.fromRGBO(255, 255, 255, 0.1),
              endIndent: margin,
              indent: margin,
            ),

            _ratingView(state),

            Divider(
              height: margin,
              thickness: 0.5,
              color: Color.fromRGBO(255, 255, 255, 0.1),
              endIndent: margin,
              indent: margin,
            ),

            _versions(state),

            Divider(
              height: margin,
              thickness: 0.5,
              color: Color.fromRGBO(255, 255, 255, 0.1),
              endIndent: margin,
              indent: margin,
            ),

            _informations(state),

            _information2(state),

            Divider(
              height: margin,
              thickness: 0.5,
              color: Color.fromRGBO(255, 255, 255, 0.1),
              endIndent: margin,
              indent: margin,
            ),

            _supported(state),

            Divider(
              height: margin,
              thickness: 0.5,
              color: Color.fromRGBO(255, 255, 255, 0.1),
              endIndent: margin,
              indent: margin,
            ),

            _morePayever(state),
          ],
        ),
      ),
    );
  }

  Widget _ratingView(ConnectScreenState state) {
    double rate = 0;
    List<ReviewModel> reviews = state.editConnect.reviews;
    if (reviews.length > 0) {
      double sum = 0;
      reviews.forEach((element) {
        sum = sum + element.rating;
      });
      rate = sum / reviews.length;
    }
    int count = 1;
    if (_isTablet) {
      if (_isPortrait) {
        count = 2;
      } else {
        count = 3;
      }
    } else {
      if (_isPortrait) {
        count = 1;
      } else {
        count = 2;
      }
    }
    int length = 2;
    if (_isTablet) {
      length = count;
    } else {
      length = 2;
    }   return Container(
      padding: EdgeInsets.only(left: margin, right: margin),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                Language.getConnectStrings('Ratings & Reviews'),
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.95),
                  fontFamily: 'HelveticaNeueMed',
                  fontSize: 18,
                ),
              ),
              GestureDetector(
                onTap: () {

                },
                child: Text(
                  Language.getConnectStrings('See All'),
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.95),
                    fontFamily: 'HelveticaNeue',
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: margin / 2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              rate > 0 ? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '$rate',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.95),
                      fontFamily: 'HelveticaNeueMed',
                      fontSize: 60,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 8),
                    child: Text(
                      'out of 5',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.95),
                        fontFamily: 'HelveticaNeueBold',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ): Container(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '${reviews.length} Ratings',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.95),
                      fontFamily: 'HelveticaNeue',
                      fontSize: 14,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 8),
                  ),
                ],
              ),
            ],
          ),
          Flexible(
            fit: FlexFit.loose,
            child: GridView.count(
              crossAxisCount: count,
              childAspectRatio: 3,
              children: reviews.map((review) {
                return Container(
                );
              }).toList().sublist(0, reviews.length > length ? length: reviews.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _versions(ConnectScreenState state) {
    return Container(
      padding: EdgeInsets.only(left: margin, right: margin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                Language.getConnectStrings('What\'s New'),
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.95),
                  fontFamily: 'HelveticaNeueMed',
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ConnectVersionHistoryScreen(
                        screenBloc: widget.screenBloc,
                        connectModel: widget.connectModel,
                      ),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                },
                child: Text(
                  Language.getConnectStrings('Version History'),
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.95),
                    fontFamily: 'HelveticaNeue',
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _informations(ConnectScreenState state) {
    List<InformationData> informations = [];

    if (state.editConnect.installationOptions.developer != null) {
      informations.add(InformationData(title: 'Provider', detail: Language.getPosConnectStrings(state.editConnect.installationOptions.developer)));
    }
    if (state.editConnect.installationOptions.category != null) {
      informations.add(InformationData(title: 'Category' , detail: Language.getConnectStrings('categories.${state.editConnect.category}.title')));
    }
    if (state.editConnect.installationOptions.languages != null) {
      informations.add(InformationData(title: 'Languages' , detail: Language.getPosConnectStrings(state.editConnect.installationOptions.languages)));
    }
    int count = 1;
    if (_isTablet) {
      if (_isPortrait) {
        count = 3;
      } else {
        count = 4;
      }
    } else {
      if (_isPortrait) {
        count = 2;
      } else {
        count = 3;
      }
    }
//    double width = (Measurements.width - margin * 2) / count - (count - 1) * margin / 2;
//    double ratio = width / (min(Measurements.width, Measurements.height) * 0.2);2
    return Container(
      padding: EdgeInsets.only(left: margin, right: margin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            Language.getConnectStrings('Informations'),
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.95),
              fontFamily: 'HelveticaNeueMed',
              fontSize: 18,
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: GridView.count(
              padding: EdgeInsets.only(top: 16,),
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: margin,
              shrinkWrap: true,
              childAspectRatio: 4,
              crossAxisCount: count,
              children: informations.map((info) {
                return Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        info.title,
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.475),
                          fontSize: 16,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                      Text(
                        info.detail,
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.95),
                          fontSize: 16,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _information2(ConnectScreenState state) {
    return Container(
      padding: EdgeInsets.only(left: margin, right: margin),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Column(
              children: <Widget>[
                Divider(
                  height: margin,
                  thickness: 0.5,
                  color: Color.fromRGBO(255, 255, 255, 0.1),
                ),
                Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/website.svg'),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                    ),
                    Expanded(
                      child: Text(
                        'Developer Website',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: margin),
          ),
          Flexible(
            child: Column(
              children: <Widget>[
                Divider(
                  height: margin,
                  thickness: 0.5,
                  color: Color.fromRGBO(255, 255, 255, 0.1),
                ),
                Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/privacy.svg'),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                    ),
                    Expanded(
                      child: Text(
                        'Privacy policy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: margin),
          ),
          Flexible(
            child: Column(
              children: <Widget>[
                Divider(
                  height: margin,
                  thickness: 0.5,
                  color: Color.fromRGBO(255, 255, 255, 0.1),
                ),
                Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/description.svg'),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                    ),
                    Expanded(
                      child: Text(
                        'Licence Agreement',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _supported(ConnectScreenState state) {
    return Container(
      padding: EdgeInsets.only(left: margin, right: margin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            Language.getConnectStrings('Supported'),
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.95),
              fontFamily: 'HelveticaNeueMed',
              fontSize: 18,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: margin / 2),
          ),
          Row(
            children: <Widget>[
              SvgPicture.asset('assets/images/account.svg'),
              Padding(
                padding: EdgeInsets.only(left: margin / 2),
              ),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Language.getConnectStrings('Title'),
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.95),
                        fontFamily: 'Helvetica Neue',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.6),
                        fontFamily: 'Helvetica Neue',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _morePayever(ConnectScreenState state) {
    int count = 1;
    if (_isTablet) {
      if (_isPortrait) {
        count = 2;
      } else {
        count = 3;
      }
    } else {
      if (_isPortrait) {
        count = 1;
      } else {
        count = 2;
      }
    }
//    double width = (Measurements.width - margin * 2) / count - (count - 1) * margin / 2;
//    double ratio = width / (min(Measurements.width, Measurements.height) * 0.2);
    int length = 6;
    if (_isTablet) {
      length = 6;
    } else {
      length = 4;
    }
    return Container(
      padding: EdgeInsets.only(left: margin, right: margin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                Language.getConnectStrings('More by payever'),
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.95),
                  fontFamily: 'HelveticaNeueMed',
                  fontSize: 18,
                ),
              ),
              state.categoryConnections.length > length ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ConnectCategoryMoreScreen(
                        screenBloc: widget.screenBloc,
                        connections: state.categoryConnections,
                      ),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                },
                child: Text(
                  Language.getConnectStrings('See All'),
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.95),
                    fontFamily: 'Helvetica Neue',
                    fontSize: 14,
                  ),
                ),
              ): Container(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: margin / 2),
          ),
          state.categoryConnections.length > 0 ? Flexible(
            fit: FlexFit.loose,
            child: GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: count,
              childAspectRatio: 3,
              mainAxisSpacing: margin / 2,
              crossAxisSpacing: margin / 2,
              children: state.categoryConnections.map((connect) {
                String iconType = connect.integration.displayOptions.icon ?? '';
                iconType = iconType.replaceAll('#icon-', '');
                iconType = iconType.replaceAll('#', '');
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: margin),
                        child: SvgPicture.asset(
                          Measurements.channelIcon(iconType),
                          width: iconSize,
                          color: Color.fromRGBO(255, 255, 255, 0.75),
                        ),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  Language.getPosConnectStrings(connect.integration.displayOptions.title),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'HelveticaNeueMed',
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  Language.getConnectStrings('categories.${connect.integration.category}.title'),
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 0.6),
                                    fontFamily: 'Helvetica Neue',
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  child: connect.installed ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(0),
                                        child: MaterialButton(
                                          onPressed: () {

                                          },
                                          color: Color.fromRGBO(255, 255, 255, 0.1),
                                          height: 26,
                                          minWidth: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(13),
                                          ),
                                          elevation: 0,
                                          focusElevation: 0,
                                          highlightElevation: 0,
                                          hoverElevation: 0,
                                          child: Text(
                                            Language.getPosConnectStrings('integrations.actions.open'),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'HelveticaNeueMed',
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(0),
                                        child: MaterialButton(
                                          onPressed: () {

                                          },
                                          color: Color.fromRGBO(255, 255, 255, 0.1),
                                          height: 26,
                                          minWidth: 0,
                                          shape: CircleBorder(),
                                          elevation: 0,
                                          focusElevation: 0,
                                          highlightElevation: 0,
                                          hoverElevation: 0,
                                          child: Icon(Icons.more_horiz),
                                        ),
                                      ),
                                    ],
                                  ) : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(right: 16),
                                        child: MaterialButton(
                                          onPressed: () {

                                          },
                                          color: Color.fromRGBO(255, 255, 255, 0.1),
                                          height: 26,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(13),
                                          ),
                                          minWidth: 0,
                                          elevation: 0,
                                          focusElevation: 0,
                                          highlightElevation: 0,
                                          hoverElevation: 0,
                                          child: Text(
                                            Language.getPosConnectStrings('integrations.actions.install'),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'HelveticaNeueMed',
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: margin,
                                  thickness: 0.5,
                                  color: Color.fromRGBO(255, 255, 255, 0.1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList().sublist(0, state.categoryConnections.length > length ? length: state.categoryConnections.length),
            ),
          ): Container(),
        ],
      ),
    );
  }
}