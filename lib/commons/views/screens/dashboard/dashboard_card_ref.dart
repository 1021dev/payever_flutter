import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../utils/utils.dart';
import '../../custom_elements/dashboard_card_content.dart';

/// ***
/// 
/// Ref means refactored but didnt change naming.
/// this will be the cavas for the dasboard cards 
/// it just contain the location for each component(header,body,...)
/// and bodies use the templates to mimic to a point the apple "widgets"(the cards on the search section)
/// 
/// TIP: AVOID at all cost the use of Backdrop filters. One element that consumes GPU usage in big ammounts.
///     therefore the more cards there are to render the more the cost on resources it will face.
///     (The overview is the screen that uses the most resources from them all).
///      
///  At the moment of implementation there was no other way to simulate the frosted glass effect. big compromise
///   on performance.
/// 
/// ***

class DashboardCardRef extends StatefulWidget {
  final String appName;
  final ImageProvider imageProvider;
  final Widget header;
  final Widget body;
  final bool defPad;

  DashboardCardRef(this.appName, this.imageProvider, this.header,
      {this.body, this.defPad = true});

  @override
  createState() => _DashboardCardRefState();
}

class _DashboardCardRefState extends State<DashboardCardRef>
    with TickerProviderStateMixin {
  Duration _duration = Duration(milliseconds: 300);

  _DashboardCardRefState();

  bool _open = false;
  dynamic handler;
  num pad = 0.02;
  bool isSingleActionButton;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    bool _isTablet = Measurements.width < 600 ? false : true;
    return Container(
      padding: EdgeInsets.symmetric(vertical: Measurements.width * (_isTablet ?0.003:0.01)),
      child: Column(
        children: <Widget>[
          AnimatedContainer(
            duration: _duration,
            width: Measurements.width * (_isTablet ? (Measurements.width < 850?0.6: 0.5): (_isPortrait ? 0.9 : 1.3)),
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 16),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(
                                    AppStyle.dashboardCardContentPadding()),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        height: AppStyle.iconDashboardCardSize(
                                            _isTablet),
                                        child: Image(
                                            image: widget.imageProvider,
                                            height:
                                                AppStyle.iconDashboardCardSize(
                                                    _isTablet))),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: Measurements.width *
                                              (_isTablet ? 0.01 : 0.02)),
                                    ),
                                    Text(
                                      Language.getWidgetStrings(
                                          "widgets.${widget.appName}.title"),
                                      style: TextStyle(
                                          fontSize: AppStyle
                                              .fontSizeDashboardTitle()),
                                    ),
                                  ],
                                ),
                              ),
                              widget.body != null
                                  ? InkWell(
                                      child: AnimatedContainer(
                                        padding: EdgeInsets.all(AppStyle
                                            .dashboardCardContentPadding()),
                                        duration: _duration,
                                        child: Text(Language.getWidgetStrings(!_open?"widgets.actions.more":"widgets.actions.less"),style: TextStyle(fontSize: AppStyle.fontSizeDashboardShow()),),
                                        
                                      ),
                                      onTap: () {
                                        listen();
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(minHeight: 75),
                          padding: widget.defPad
                              ? EdgeInsets.only(
                                  bottom:
                                      AppStyle.dashboardCardContentPadding(),
                                  left: AppStyle.dashboardCardContentPadding() *
                                      1.5,
                                  right:
                                      AppStyle.dashboardCardContentPadding() *
                                          1.5,
                                  top: AppStyle.dashboardCardContentPadding() /
                                      2)
                              : EdgeInsets.symmetric(
                                  vertical:
                                      AppStyle.dashboardCardContentPadding() /
                                          2),
                          child: DashboardCardPanel(
                            animationDuration: _duration,
                            child: ExpansionPanel(
                              body: widget.body ?? Container(),
                              isExpanded: _open,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) =>
                                      widget.header,
                            ),
                          ),
                        ),
                      ],
                    ),
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
      _open = !_open;
    });
  }
}
