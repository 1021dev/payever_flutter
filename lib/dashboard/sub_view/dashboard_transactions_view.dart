import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/dashboard_option_cell.dart';
import 'package:payever/theme.dart';

import 'dashboard_setup_buttons.dart';

class DashboardTransactionsView extends StatefulWidget {
  final VoidCallback onOpen;
  final BusinessApps businessApps;
  final AppWidget appWidget;
  final bool isLoading;
  final List<Day> lastMonth;
  final List<Month> lastYear;
  final List<double> monthlySum;
  final double total;
  final Function onTapGetStarted;
  final Function onTapContinueSetup;
  final Function onTapLearnMore;
  final List<NotificationModel> notifications;
  final Function openNotification;
  final Function deleteNotification;
  DashboardTransactionsView({
    this.onOpen,
    this.businessApps,
    this.appWidget,
    this.total = 0,
    this.isLoading = true,
    this.lastMonth = const [],
    this.lastYear = const [],
    this.monthlySum = const [],
    this.onTapGetStarted,
    this.onTapContinueSetup,
    this.onTapLearnMore,
    this.notifications = const [],
    this.openNotification,
    this.deleteNotification,
  });
  @override
  _DashboardTransactionsViewState createState() => _DashboardTransactionsViewState();
}

class _DashboardTransactionsViewState extends State<DashboardTransactionsView> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    String currency = '';
    if (widget.lastYear.length > 0) {
      NumberFormat format = NumberFormat();
      currency = format.simpleCurrencySymbol(widget.lastYear.last.currency);
    }
    if (widget.businessApps != null && widget.businessApps.setupStatus == 'completed') {
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
                                    fit: BoxFit.fitWidth)),
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
                                  color: overlayButtonBackground(),
                              ),
                              child: Center(
                                child: Text(
                                  'Open',
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
                      )
                    ],
                  ),
                  widget.isLoading ? Container(
                    height: 64,
                    child: Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ):
                  SizedBox(height: 8),
                  !widget.isLoading ?  Row(
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        size: 10,
                      ),
                      SizedBox(width: 4),
                      Text(
                        Language.getWidgetStrings('widgets.transactions.this-month'),
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ): Container(),
                  !widget.isLoading ?  SizedBox(height: 8): Container(),
                  widget.lastYear.length > 0 ?  Row(
                    children: [
                      Text(
                        '${widget.lastYear.last.amount} $currency',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ): Container(),
                  !widget.isLoading ? SizedBox(height: 20): Container(),
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
                ],
              ),
            ),
            SizedBox(height: 12),
            DashboardSetupButtons(
              businessApps: widget.businessApps,
              appWidget: widget.appWidget,
              onTapContinueSetup: widget.onTapContinueSetup,
              onTapGetStarted: widget.onTapGetStarted,
              onTapLearnMore: widget.onTapLearnMore,
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
