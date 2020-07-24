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

  final formatter = new NumberFormat('###,###,###.00', 'en_US');

  ConnectListItem({
    this.connectModel,
    this.onTap,
    this.onInstall,
  });

  @override
  Widget build(BuildContext context) {
    String iconType = connectModel.integration.displayOptions.icon ?? '';
    iconType = iconType.replaceAll('#icon-', '');
    print(iconType);
    return Container(
      height: 66,
      padding: EdgeInsets.only(left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 3,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: SvgPicture.asset(Measurements.channelIcon(iconType), width: 32, height: 32, color: Colors.white70,),
                ),
                Text(
                  Language.getPosConnectStrings(connectModel.integration.displayOptions.title),
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    fontFamily: 'HelveticaNeue',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              Language.getConnectStrings('categories.${connectModel.integration.category}.title'),
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.7),
                fontFamily: 'HelveticaNeue',
                fontSize: 14,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              Language.getPosConnectStrings(connectModel.integration.installationOptions.developer),
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.7),
                fontFamily: 'HelveticaNeue',
                fontSize: 14,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              Language.getPosConnectStrings(connectModel.integration.installationOptions.languages),
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.7),
                fontFamily: 'HelveticaNeue',
                fontSize: 14,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Text(
              'Price',
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.7),
                fontFamily: 'HelveticaNeue',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}