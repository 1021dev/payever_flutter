import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:provider/provider.dart';

class PayeverAppBar extends StatefulWidget implements PreferredSizeWidget {
  final DashboardScreenBloc dashboardScreenBloc;
  final Function onTapToggle;
  final Function onTapBusiness;
  final Function onTapNotification;
  final Function onTapClose;
  final Function onTapSearch;
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  PayeverAppBar({
    this.dashboardScreenBloc,
    this.onTapBusiness,
    this.onTapNotification,
    this.onTapClose,
    this.onTapToggle,
    this.onTapSearch,
    this.innerDrawerKey,
  });
  @override
  createState() => _PayeverAppBarState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _PayeverAppBarState extends State<PayeverAppBar> {

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
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Container(
            child: Center(
              child: Container(
                  child: SvgPicture.asset(
                    'assets/images/payeverlogo.svg',
                    color: Colors.white,
                    height: 16,
                    width: 24,
                  )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Text(
            'Business',
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
            Icons.person_pin,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {

          },
        ),
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.search,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {

          },
        ),
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () async {
            Provider.of<GlobalStateModel>(context,listen: false)
                .setCurrentBusiness(widget.dashboardScreenBloc.state.activeBusiness);
            Provider.of<GlobalStateModel>(context,listen: false)
                .setCurrentWallpaper(widget.dashboardScreenBloc.state.curWall);

            await showGeneralDialog(
                barrierColor: null,
                transitionBuilder: (context, a1, a2, ww) {
                  final curvedValue = Curves.ease.transform(a1.value) -   1.0;
                  return Transform(
                    transform: Matrix4.translationValues(-curvedValue * 200, 0.0, 0),
                    child: NotificationsScreen(
                      business: widget.dashboardScreenBloc.state.activeBusiness,
                      businessApps: widget.dashboardScreenBloc.state.businessWidgets,
                      dashboardScreenBloc: widget.dashboardScreenBloc,
                    ),
                  );
                },
                transitionDuration: Duration(milliseconds: 200),
                barrierDismissible: true,
                barrierLabel: '',
                context: context,
                pageBuilder: (context, animation1, animation2) {});
          },
        ),
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.menu,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            widget.innerDrawerKey.currentState.toggle();
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

}