import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/views/custom_elements/DashboardOptionCell.dart';
import 'package:payever/commons/views/custom_elements/ProductCell.dart';

import 'BlurEffectView.dart';

class DashboardProductsView extends StatefulWidget {
  @override
  _DashboardProductsViewState createState() => _DashboardProductsViewState();
}

class _DashboardProductsViewState extends State<DashboardProductsView> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
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
                                  image: NetworkImage(Env.commerceOs +
                                      "/assets/ui-kit/icons-png/icon-commerceos-products-64.png"),
                                  fit: BoxFit.fitWidth)),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          "PRODUCTS",
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
                          onTap: () {

                          },
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
                        Container(
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
                                  child: Text("2",
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
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  height: 120,
                  child: ListView.builder(itemBuilder: _itemBuilder, itemCount: 3, scrollDirection: Axis.horizontal,),
                )
              ],
            ),
          ),
          if (isExpanded)
            Container(
              height: 50.0 * 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                  color: Colors.black38
              ),
              child: ListView.builder(itemBuilder: _itemBuilderDDetails, itemCount: 2,physics: NeverScrollableScrollPhysics(),),
            )
        ],
      ),
    );
  }
  Widget _itemBuilder(BuildContext context, int index) {
    return ProductCell();
  }
  Widget _itemBuilderDDetails(BuildContext context, int index) {
    return DashboardOptionCell();
  }

}