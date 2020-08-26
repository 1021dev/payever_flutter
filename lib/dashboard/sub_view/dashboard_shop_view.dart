import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/commons/models/business_apps.dart';
import 'package:payever/commons/models/models.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/dashboard_option_cell.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/theme.dart';

class DashboardShopView extends StatefulWidget {
  final VoidCallback onOpen;
  final BusinessApps businessApps;
  final AppWidget appWidget;
  final List<ShopModel> shops;
  final ShopModel shopModel;
  final bool isLoading;
  final Function onTapEditShop;
  final List<NotificationModel> notifications;
  final Function openNotification;
  final Function deleteNotification;

  DashboardShopView({
    this.onOpen,
    this.businessApps,
    this.appWidget,
    this.shopModel,
    this.shops = const [],
    this.isLoading = false,
    this.onTapEditShop,
    this.notifications = const [],
    this.openNotification,
    this.deleteNotification,
  });
  @override
  _DashboardShopViewState createState() => _DashboardShopViewState();
}

class _DashboardShopViewState extends State<DashboardShopView> {
  String imageBase = Env.storage + '/images/';
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    List<ShopModel> shops = widget.shops;
    String avatarName = '';
    if (widget.shopModel != null) {
      String name = widget.shopModel.name;
      if (name.contains(' ')) {
        avatarName = name.substring(0, 1);
        avatarName = avatarName + name.split(' ')[1].substring(0, 1);
      } else {
        avatarName = name.substring(0, 1) + name.substring(name.length - 1);
        avatarName = avatarName.toUpperCase();
      }
    }

    if (widget.businessApps.setupStatus == 'completed') {
      return BlurEffectView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage('${iconString()}shop.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(width: 8,),
                          Text(
                            Language.getWidgetStrings(widget.appWidget.title).toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: widget.onOpen,
                            child: Container(
                              height: 20,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: overlayBackground(),
                              ),
                              child: Center(
                                child: Text(
                                  Language.getCommerceOSStrings('actions.open'),
                                  style: TextStyle(
                                      fontSize: 10,
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
                                      '${widget.notifications.length}',
                                      style: TextStyle(
                                          fontSize: 10,
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
                                          color: overlayBackground(),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          isExpanded ? 'assets/images/closeicon.svg' : 'assets/images/icon_plus.svg',
                                          width: 8,
                                          color: iconColor(),
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
                  widget.shopModel != null
                      ? (
                      Row(
                        children: <Widget>[
                          // Shop View
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: <Widget>[
                                widget.shopModel.logo != null ?
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage('$imageBase${widget.shopModel.logo}'),
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
                                        color: iconColor(),
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
                                    widget.shopModel.name,
                                    maxLines: 2,
                                    minFontSize: 16,
                                    maxFontSize: 24,
                                    style: TextStyle(
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
                              onPressed: widget.onTapEditShop,
                              color: overlayBackground(),
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
                                    SvgPicture.asset('assets/images/edit_pen.svg', width: 24, color: iconColor(),),
                                    SizedBox(width: 8),
                                    Text(
                                      'Edit',
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  ) : Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    child: Text(
                      'You have no shops',
                    ),
                  ),
                ],
              ),
            ),
            if (isExpanded)
              Container(
                height: 50.0 * widget.notifications.length,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                    color: overlayBackground(),
                ),
                child: ListView.builder(
                  itemBuilder: _itemBuilderDDetails,
                  itemCount: widget.notifications.length,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
          ],
        ),
      );
    } else {
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
                            image: NetworkImage('${Env.cdnIcon}icon-comerceos-shop-not-installed.png'),
                            fit: BoxFit.contain),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Language.getWidgetStrings(widget.appWidget.title),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    Language.getWidgetStrings('widgets.store.install-app'),
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                  color: overlayBackground(),
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
                          !widget.businessApps.installed ? 'Get started' : 'Continue setup process',
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  if (!widget.businessApps.installed) Container(
                    width: 1,
                    color: Colors.white12,
                  ),
                  if (!widget.businessApps.installed) Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {

                      },
                      child: Center(
                        child: Text(
                          'Learn more',
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 12),
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
    }
  }

  Widget _itemBuilderDDetails(BuildContext context, int index) {
    return DashboardOptionCell(
      notificationModel: widget.notifications[index],
      onTapDelete: (NotificationModel model) {
        widget.deleteNotification(model);
      },
      onTapOpen: (NotificationModel model) {
        widget.openNotification(model);
      },
    );
  }

}
