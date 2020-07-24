import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/connect/widgets/connect_item_image_view.dart';

class ConnectListItem extends StatelessWidget {
  final ConnectModel connectModel;
  final Function onTap;
  final Function onInstall;
  final bool isPortrait;
  final bool isTablet;

  ConnectListItem({
    this.connectModel,
    this.onTap,
    this.onInstall,
    this.isTablet = false,
    this.isPortrait = true,
  });

  @override
  Widget build(BuildContext context) {
    double margin = isTablet ? 24: 16;
    String iconType = connectModel.integration.displayOptions.icon ?? '';
    iconType = iconType.replaceAll('#icon-', '');
    return Container(
      height: 66,
      padding: EdgeInsets.only(left: margin, right: margin),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: SvgPicture.asset(Measurements.channelIcon(iconType), width: 32, height: 32, color: Colors.white70,),
                ),
                Expanded(
                  child: Text(
                    Language.getPosConnectStrings(connectModel.integration.displayOptions.title),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'HelveticaNeueMed',
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 6),
          ),
          isTablet || !isPortrait ? Container(
            width: Measurements.width * (isPortrait ? 0.1 : 0.2),
            child: Text(
              Language.getConnectStrings('categories.${connectModel.integration.category}.title'),
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'HelveticaNeueMed',
                fontSize: 14,
              ),
            ),
          ): Container(),
          isTablet || !isPortrait ? Padding(
            padding: EdgeInsets.only(left: 6),
          ): Container(),
          isTablet || !isPortrait ? Container(
            width: Measurements.width * (isPortrait ? 0.1 : 0.2),
            child: Text(
              Language.getPosConnectStrings(connectModel.integration.installationOptions.developer),
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'HelveticaNeueMed',
                fontSize: 14,
              ),
            ),
          ): Container(),
          isTablet || !isPortrait ? Padding(
            padding: EdgeInsets.only(left: 6),
          ): Container(),
          isTablet || !isPortrait ? Container(
            width: Measurements.width * (isPortrait ? 0.1 : 0.2),
            child: Text(
              Language.getPosConnectStrings(connectModel.integration.installationOptions.languages),
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'HelveticaNeueMed',
                fontSize: 14,
              ),
            ),
          ): Container(),
          isTablet || !isPortrait ? Padding(
            padding: EdgeInsets.only(left: 6),
          ): Container(),
          Container(
            width: !isTablet && isPortrait ? null : Measurements.width * (isTablet ? (isPortrait ? 0.15 : 0.2) : (isPortrait ? null: 0.35)),
            child: connectModel.installed ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(0),
                    child: MaterialButton(
                      onPressed: onTap,
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
                    padding: EdgeInsets.only(right: margin / 2),
                    child: MaterialButton(
                      onPressed: onInstall,
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
        ],
      ),
    );
  }
}