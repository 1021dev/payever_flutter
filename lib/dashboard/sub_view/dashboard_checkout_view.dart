import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/commons/models/business_apps.dart';
import 'package:payever/commons/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/dashboard_option_cell.dart';
import 'package:payever/theme.dart';

import 'dashboard_setup_buttons.dart';

class DashboardCheckoutView extends StatefulWidget {
  final VoidCallback onOpen;
  final BusinessApps businessApps;
  final AppWidget appWidget;
  final List<NotificationModel> notifications;
  final Function openNotification;
  final Function deleteNotification;
  final List<Checkout> checkouts;
  final Checkout defaultCheckout;
  final Function onTapGetStarted;
  final Function onTapContinueSetup;
  final Function onTapLearnMore;

  DashboardCheckoutView({
    this.onOpen,
    this.businessApps,
    this.appWidget,
    this.notifications = const [],
    this.openNotification,
    this.deleteNotification,
    this.checkouts = const [],
    this.defaultCheckout,
    this.onTapGetStarted,
    this.onTapContinueSetup,
    this.onTapLearnMore,
  });

  @override
  _DashboardCheckoutViewState createState() => _DashboardCheckoutViewState();
}

class _DashboardCheckoutViewState extends State<DashboardCheckoutView> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {

    if (widget.businessApps.setupStatus == 'completed') {
      return BlurEffectView(
        padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
        isDashboard: true,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
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
                                image: NetworkImage('${iconString()}${widget.appWidget.type}.png'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          SizedBox(width: 8,),
                          Text(
                            Language.getCommerceOSStrings('dashboard.apps.checkout').toUpperCase(),
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
                                color: overlayButtonBackground(),
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
                          widget.notifications.length > 0 ? SizedBox(width: 8): Container(),
                          widget.notifications.length > 0 ? Container(
                            height: 20,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: overlayBackground(),
                            ),
                            child:  Row(
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
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  widget.checkouts.length > 0
                      ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: InkWell(
                            onTap: () {

                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: overlayButtonBackground(),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/link.svg',
                                    width: 24,
                                    color: iconColor(),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Link',
                                    softWrap: true,
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: InkWell(
                            onTap: () {

                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: overlayButtonBackground(),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/edit_pen.svg',
                                    width: 24,
                                    color: iconColor(),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    Language.getCommerceOSStrings('menu.customer.manage'),
                                    softWrap: true,
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      : Container(
                    height: 72,
                    child: Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
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
        isDashboard: true,
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
                        image: NetworkImage('${Env.cdnIcon}icon-comerceos-${widget.appWidget.type}-not-installed.png'),
                        fit: BoxFit.fitWidth,
                      ),
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
                    Language.getWidgetStrings('widgets.checkout.actions.add-new'),
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
            SizedBox(height: 12),
            DashboardSetupButtons(
              businessApps: widget.businessApps,
              onTapContinueSetup: widget.onTapContinueSetup,
              onTapGetStarted: widget.onTapGetStarted,
              onTapLearnMore: widget.onTapLearnMore,
            ),
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
