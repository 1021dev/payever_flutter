import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/connect/widgets/connect_item_image_view.dart';
import 'package:payever/theme.dart';

class ConnectGridItem extends StatelessWidget {
  final ConnectModel connectModel;
  final Function onTap;
  final Function onInstall;
  final Function onUninstall;
  final bool installingConnect;

  final formatter = new NumberFormat('###,###,###.00', 'en_US');

  ConnectGridItem({
    this.connectModel,
    this.onTap,
    this.onInstall,
    this.onUninstall,
    this.installingConnect = false,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl = connectModel.integration.installationOptions.links.length > 0
        ? connectModel.integration.installationOptions.links.first.url ?? '': '';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: overlayBackground(),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: ConnectItemImageView(
                    imageUrl,
                  ),
                ),
                Container(
                  height: 116,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 12,
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
                                      fontSize: 15,
                                      fontFamily: 'Roboto-Medium',
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  Language.getConnectStrings(connectModel.integration.installationOptions.price),
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 44,
                        color: overlayBackground(),
                        alignment: Alignment.center,
                        child: SizedBox.expand(
                          child: MaterialButton(
                            child: installingConnect ? Center(
                              child: Container(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ) : Text(
                              connectModel.installed ? Language.getConnectStrings('actions.uninstall'): Language.getConnectStrings('actions.install'),
                            ),
                            onPressed: () {
                              if (connectModel.installed) {
                                onUninstall(connectModel);
                              } else {
                                onInstall(connectModel);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            connectModel.installed ? Container(
              margin: EdgeInsets.all(10),
              height: 20,
              width: 75,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: overlayBackground(),
              ),
              child: Text(
                Language.getConnectStrings('installation.installed.title').toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Roboto-Medium',
                  fontSize: 11,
                ),
              ),
            ): Container(),
          ],
        ),
      ),
    );
  }
}