import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/connect/widgets/connect_item_image_view.dart';

class ConnectGridItem extends StatelessWidget {
  final ConnectModel connectModel;
  final Function onTap;
  final Function onInstall;

  final formatter = new NumberFormat('###,###,###.00', 'en_US');

  ConnectGridItem({
    this.connectModel,
    this.onTap,
    this.onInstall,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl = connectModel.integration.installationOptions.links.length > 0
        ? connectModel.integration.installationOptions.links.first.url ?? '': '';
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        color: Color.fromRGBO(0, 0, 0, 0.3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ConnectItemImageView(
              imageUrl,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: 8,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 25,
                  alignment: Alignment.topLeft,
                  child: Text(
                    Language.getConnectStrings(connectModel.integration.displayOptions.title),
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Roboto-Medium'
                    ),
                  ),
                ),
                Container(
                  height: 32,
                  alignment: Alignment.topLeft,
                  child: Text(
                    Language.getConnectStrings(connectModel.integration.installationOptions.description),
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                        fontFamily: 'Roboto'
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 44,
            color: Color.fromRGBO(0, 0, 0, 0.3),
            alignment: Alignment.center,
            child: SizedBox.expand(
              child: MaterialButton(
                child: Text(
                  Language.getConnectStrings('actions.install'),
                ),
                onPressed: () {

                },
              ),
            ),
          )
        ],
      ),
    );
  }
}