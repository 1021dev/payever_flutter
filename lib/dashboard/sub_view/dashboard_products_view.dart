import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/dashboard_option_cell.dart';
import 'package:payever/commons/views/custom_elements/product_cell.dart';
import 'package:payever/products/models/models.dart';

class DashboardProductsView extends StatefulWidget {
  final AppWidget appWidget;
  final BusinessApps businessApps;
  final List<Products> lastSales;
  final Business business;
  final Function onOpen;
  final Function onSelect;
  final List<NotificationModel> notifications;
  final Function openNotification;
  final Function deleteNotification;

  DashboardProductsView({
    this.appWidget,
    this.businessApps,
    this.lastSales,
    this.business,
    this.onOpen,
    this.onSelect,
    this.notifications = const [],
    this.openNotification,
    this.deleteNotification,
  });
  @override
  _DashboardProductsViewState createState() => _DashboardProductsViewState();
}

class _DashboardProductsViewState extends State<DashboardProductsView> {
  String uiKit = '${Env.cdnIcon}icons-apps-white/icon-apps-white-';
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
                                    image: NetworkImage('${uiKit}product.png'),
                                    fit: BoxFit.fitWidth)),
                          ),
                          SizedBox(width: 8,),
                          Text(
                            Language.getCommerceOSStrings('dashboard.apps.products').toUpperCase(),
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
                                child: Text(
                                  Language.getCommerceOSStrings('actions.open'),
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                          widget.notifications.length > 0 ?
                          SizedBox(width: 8) : Container(),
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
                                        child: SvgPicture.asset(
                                          isExpanded ? 'assets/images/closeicon.svg' : 'assets/images/icon_plus.svg',
                                          width: 8,
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
                  SizedBox(height: 8),
                  widget.lastSales != null
                      ? Container(
                    height: 100,
                    child: GridView.count(
                      crossAxisCount: 3,
                      physics: NeverScrollableScrollPhysics(),
                      children: widget.lastSales.length > 3 ? List.generate(3, (index) => ProductCell(
                        product: widget.lastSales[index],
                        business: widget.business,
                        onTap: (Products product) {
                          widget.onSelect(product);
                        },
                      ),
                      ).toList() : widget.lastSales.map((e) => ProductCell(
                        product: e,
                        business: widget.business,
                        onTap: (Products product) {
                          widget.onSelect(product);
                        },
                      )).toList(),
                      childAspectRatio: (Measurements.width - 32) / 3.0 / 92.0,
                    )
                  ): Container(
                    height: 92,
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
                ],
              ),
            ),
            if (isExpanded)
              Container(
                height: 50.0 * widget.notifications.length,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                    color: Colors.black38
                ),
                child: ListView.builder(
                  itemBuilder: _itemBuilderDDetails,
                  itemCount: widget.notifications.length,
                  physics: NeverScrollableScrollPhysics(),
                ),
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
                          image: NetworkImage('${Env.cdnIcon}icon-comerceos-product-not-installed.png'),
                          fit: BoxFit.contain),
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
                    Language.getWidgetStrings('widgets.products.actions.add-new'),
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
                          !widget.businessApps.installed ? 'Get started' : 'Continue setup process',
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  if (!widget.businessApps.installed) Container(
                    width: 1,
                    color: Colors.white12,
                  ),
                  if (!widget.businessApps.installed) Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {

                      },
                      child: Center(
                        child: Text(
                          'Learn more',
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
  Widget _itemBuilder(BuildContext context, int index) {
    return ProductCell(
      product: widget.lastSales[index],
      business: widget.business,
      onTap: (Products product) {
        widget.onSelect(product);
      },
    );
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
