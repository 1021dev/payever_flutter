import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';

class ContactGridItem extends StatelessWidget {
  final Function onTap;
  final Function onInstall;
  final Function onUninstall;

  final formatter = new NumberFormat('###,###,###.00', 'en_US');

  ContactGridItem({
    this.onTap,
    this.onInstall,
    this.onUninstall,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: Color.fromRGBO(0, 0, 0, 0.3),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 200,
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
                                  Language.getConnectStrings('connectModel.integration.displayOptions.title'),
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Roboto-Medium'
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  Language.getConnectStrings('connectModel.integration.installationOptions.price'),
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
                      ),
                      Container(
                        height: 44,
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        alignment: Alignment.center,
                        child: SizedBox.expand(
                          child: MaterialButton(
                            child: Text(
                              'Open',
                            ),
                            onPressed: () {
                                onInstall();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(10),
              height: 20,
              width: 75,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(0, 0, 0, 0.3),
              ),
              child: Text(
                Language.getConnectStrings('installation.installed.title').toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto-Medium',
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}