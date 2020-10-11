import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/theme.dart';

class DashboardSettingsView extends StatefulWidget {
  final AppWidget appWidget;
  final BusinessApps businessApps;
  final List<NotificationModel> notifications;
  final Function openNotification;
  final Function deleteNotification;
  final Function onTapOpen;
  final Function onTapOpenWallpaper;
  final Function onTapOpenLanguage;

  DashboardSettingsView({
    this.appWidget,
    this.businessApps,
    this.notifications = const [],
    this.openNotification,
    this.deleteNotification,
    this.onTapOpen,
    this.onTapOpenWallpaper,
    this.onTapOpenLanguage,
  });
  @override
  _DashboardSettingsViewState createState() => _DashboardSettingsViewState();
}

class _DashboardSettingsViewState extends State<DashboardSettingsView> {
  @override
  Widget build(BuildContext context) {
    return BlurEffectView(
      padding: EdgeInsets.fromLTRB(14, 12, 14, 0),
      isDashboard: true,
      child: Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Language.getCommerceOSStrings('info_boxes.settings.heading').toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: InkWell(
                      onTap: widget.onTapOpenWallpaper,
                      child: Container(
                        height: 58,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: overlayDashboardButtonsBackground(),
                        ),
                        child: Text(
                          Language.getSettingsStrings('info_boxes.panels.wallpaper.title'),
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: InkWell(
                      onTap: widget.onTapOpenLanguage,
                      child: Container(
                        height: 58,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: overlayDashboardButtonsBackground(),
                        ),
                        child: Text(
                          Language.getSettingsStrings('form.create_form.language.label'),
                          softWrap: true,
                          style: TextStyle(fontSize: 16, color: Colors.white,),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
