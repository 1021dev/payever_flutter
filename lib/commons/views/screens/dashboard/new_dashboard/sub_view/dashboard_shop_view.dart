import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/DashboardOptionCell.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';

import '../../../../../../products/models/models.dart';

class DashboardShopView extends StatefulWidget {
  final VoidCallback onOpen;
  final BusinessApps businessApps;
  final AppWidget appWidget;

  DashboardShopView({this.onOpen, this.businessApps, this.appWidget});
  @override
  _DashboardShopViewState createState() => _DashboardShopViewState();
}

class _DashboardShopViewState extends State<DashboardShopView> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {

    if (widget.businessApps.setupStatus == 'completed') {
      return BlurEffectView(
        padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
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
                                    image: NetworkImage('${Env.cdnIcon}icons-apps-white/icon-apps-white-${widget.appWidget.type}.png'),
                                    fit: BoxFit.fitWidth)),
                          ),
                          SizedBox(width: 8,),
                          Text(
                            Language.getWidgetStrings(widget.appWidget.title).toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
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
                                  color: Colors.black.withAlpha(100)
                              ),
                              child: Center(
                                child: Text("Open",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          isExpanded ? Container(
                            height: 20,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white10
                            ),
                            child:  Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text("1",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white
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
                                          color: Colors.black45
                                      ),
                                      child: Center(
                                        child: Icon(
                                          isExpanded ? Icons.clear : Icons.add,
                                          color: Colors.white,
                                          size: 12,
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
                    padding: EdgeInsets.only(top: 64),
                  )
                ],
              ),
            ),
            if (isExpanded)
              Container(
                height: 50.0 * 1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                    color: Colors.black38
                ),
                child: ListView.builder(itemBuilder: _itemBuilderDDetails, itemCount: 1,physics: NeverScrollableScrollPhysics(),),
              )

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
                            image: NetworkImage('${Env.cdnIcon}icon-comerceos-${widget.appWidget.type}-not-installed.png'),
                            fit: BoxFit.fitWidth),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Language.getWidgetStrings(widget.appWidget.title),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    Language.getWidgetStrings("widgets.${widget.appWidget.type}.install-app"),
                    style: TextStyle(
                      color: Colors.white,
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
                  color: Colors.black38
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
                          !widget.appWidget.install ? "Get started" : "Continue setup process",
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  if (!widget.appWidget.install) Container(
                    width: 1,
                    color: Colors.white12,
                  ),
                  if (!widget.appWidget.install) Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {

                      },
                      child: Center(
                        child: Text(
                          "Learn more",
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.white, fontSize: 12),
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
    return DashboardOptionCell();
  }

}
