import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/commons/models/business_apps.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/notifications/widgets/notification_cell.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

bool _isPortrait;
bool _isTablet;

class NotificationsScreen extends StatefulWidget {
  final List<BusinessApps> businessApps;
  final Business business;
  final DashboardScreenBloc dashboardScreenBloc;

  NotificationsScreen({this.business, this.businessApps, this.dashboardScreenBloc,});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();

}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationsScreenBloc screenBloc;

  @override
  void initState() {
    screenBloc = NotificationsScreenBloc(dashboardScreenBloc: widget.dashboardScreenBloc);
    screenBloc.add(NotificationsScreenInitEvent(
      businessId: widget.business.id,));
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, NotificationsScreenState state) async {
      },
      child: BlocBuilder<NotificationsScreenBloc, NotificationsScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, NotificationsScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(NotificationsScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black54,
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(state),
      body: BlurEffectView(
        radius: 0,
        color: Colors.transparent,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            alignment: Alignment.center,
            child: ListView.separated(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              separatorBuilder: (context, index) {
                return Divider(color: Colors.transparent,);
              },
              itemBuilder: (context, index) {
                String key = widget.dashboardScreenBloc.state.notifications.keys.toList()[index];
                List<NotificationModel> notis = widget.dashboardScreenBloc.state.notifications.containsKey(key) ? widget.dashboardScreenBloc.state.notifications[key]: [];
                List<BusinessApps> bList = widget.businessApps.where((element) {
                  return element.code == getKind(key);
                }).toList();
                BusinessApps businessApps;
                if (bList.length > 0) {
                  print(bList.first.code);
                  businessApps = bList.first;
                }
                return NotificationCell(
                  notifications: notis,
                  businessApps: businessApps,
                  tapOpen: () {

                  },
                );
              },
              itemCount: widget.dashboardScreenBloc.state.notifications.keys.toList().length,
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar(NotificationsScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Text(
        Language.getWidgetStrings('Notifications'),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
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

}