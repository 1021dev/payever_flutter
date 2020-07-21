import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';

import '../../../custom_elements/blur_effect_view.dart';

class DashboardAppPosView extends StatefulWidget {
  final BusinessApps businessApps;
  final AppWidget appWidget;
  final List<Terminal> terminals;
  final Terminal activeTerminal;
  final bool isLoading;
  final Function onTapOpen;
  final Function onTapEditTerminal;
  final List<NotificationModel> notifications;
  DashboardAppPosView({
    this.appWidget,
    this.businessApps,
    this.terminals = const [],
    this.isLoading,
    this.activeTerminal,
    this.onTapEditTerminal,
    this.onTapOpen,
    this.notifications = const [],
  });
  @override
  _DashboardAppPosViewState createState() => _DashboardAppPosViewState();
}

class _DashboardAppPosViewState extends State<DashboardAppPosView> {
  String uiKit = '${Env.cdnIcon}icons-apps-white/icon-apps-white-';
  String imageBase = Env.storage + '/images/';

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    List<Terminal> terminals = widget.terminals;
    String avatarName = '';
    if (widget.activeTerminal != null) {
      String name = widget.activeTerminal.name;
      if (name.contains(' ')) {
        avatarName = name.substring(0, 1);
        avatarName = avatarName + name.split(' ')[1].substring(0, 1);
      } else {
        avatarName = name.substring(0, 1) + name.substring(name.length - 1);
        avatarName = avatarName.toUpperCase();
      }
    }
    if (terminals.length == 0) {
      return BlurEffectView(
        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage('${Env.cdnIcon}icon-comerceos-pos-not-installed.png'),
                            fit: BoxFit.fitWidth)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Language.getCommerceOSStrings(widget.businessApps.dashboardInfo.title),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    Language.getWidgetStrings('widgets.${widget.businessApps.code}.install-app'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                  color: Colors.black38
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {

                      },
                      child: Center(
                        child: Text(
                          widget.businessApps.installed ? 'Get started' : 'Continue setup process',
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  if (widget.businessApps.installed) Container(
                    width: 1,
                    color: Colors.white12,
                  ),
                  if (widget.businessApps.installed) Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {

                      },
                      child: Center(
                        child: Text(
                          'Learn more',
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return BlurEffectView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage('${uiKit}point-of-sale.png'),
                              fit: BoxFit.fitWidth)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    Text(
                      'POINT OF SALE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: widget.onTapOpen,
                      child: Container(
                        height: 20,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withOpacity(0.4)
                        ),
                        child: Center(
                          child: Text('Open',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                    widget.notifications.length > 0 ?
                    SizedBox(width: 8) : Container(),
                    widget.notifications.length > 0 ? Container(
                      height: 20,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white10
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                '2',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Container(
                                width: 21,
                                height: 21,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.5),
                                    color: Colors.black45
                                ),
                                child: Center(
                                  child: Icon(
                                    isExpanded ? Icons.clear : Icons.add,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ): Container(),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
            ),
            widget.isLoading ? Container(
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ):
            Row(
              children: <Widget>[
                // Terminal View
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      widget.activeTerminal.logo != null ?
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage('$imageBase${widget.activeTerminal.logo}'),
                              fit: BoxFit.cover,
                            )
                        ),
                      ):
                      Container(
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blueGrey.withOpacity(0.5),
                          child: Text(
                            avatarName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          widget.activeTerminal.name,
                          maxLines: 2,
                          minFontSize: 16,
                          maxFontSize: 24,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12),
                ),
                // Edit Button
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    onPressed: widget.onTapEditTerminal,
                    color: Colors.black26,
                    height: 60,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text(
                            'Edit',
                            softWrap: true,
                            style: TextStyle(
                                color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
