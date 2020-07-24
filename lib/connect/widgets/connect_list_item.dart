import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    String imageUrl = connectModel.integration.installationOptions.links.length > 0
        ? connectModel.integration.installationOptions.links.first.url ?? '': '';
    return Container(
      height: 66,
      child: Row(
        children: <Widget>[

        ],
      ),
    );
  }
}