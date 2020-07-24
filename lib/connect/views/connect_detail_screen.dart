import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:payever/connect/widgets/connect_item_image_view.dart';

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

  @override
  void initState() {
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
            Language.getConnectStrings('layout.title'),
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
              minWidth: 32
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
    String iconType = widget.connectModel.integration.displayOptions.icon ?? '';
    iconType = iconType.replaceAll('#icon-', '');
    String imageUrl = widget.connectModel.integration.installationOptions.links.length > 0
        ? widget.connectModel.integration.installationOptions.links.first.url ?? '': '';

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
                      height: iconSize,
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  Language.getPosConnectStrings(widget.connectModel.integration.displayOptions.title),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'HelveticaNeueMed',
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  Language.getPosConnectStrings(widget.connectModel.integration.installationOptions.price),
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 0.6),
                                    fontFamily: 'HelveticaNeueLight',
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  Language.getPosConnectStrings(widget.connectModel.integration.installationOptions.developer),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'HelveticaNeue',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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
                            widget.connectModel.integration.reviews.length > 0 ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${widget.connectModel.integration.reviews.length}',
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
                                  '${widget.connectModel.integration.timesInstalled ?? 0}',
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
                              '${widget.connectModel.integration.timesInstalled ?? 0}',
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
                      Language.getPosConnectStrings(widget.connectModel.integration.installationOptions.description),
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
                        Language.getPosConnectStrings(widget.connectModel.integration.installationOptions.developer),
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

          ],
        ),
      ),
    );
  }

  Widget _ratingView(ConnectScreenState state) {
    return Container(
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '4,5',
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
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '63 Ratings',
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
    return Container();
  }
}