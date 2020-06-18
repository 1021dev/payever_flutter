import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/BlurEffectView.dart';

import '../../../../../../products/models/models.dart';

class DashboardTransactionsView extends StatefulWidget {
  @override
  _DashboardTransactionsViewState createState() => _DashboardTransactionsViewState();
}

class _DashboardTransactionsViewState extends State<DashboardTransactionsView> {
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
                                        "/assets/ui-kit/icons-png/icon-commerceos-transactions-64.png"),
                                    fit: BoxFit.fitWidth)),
                          ),
                          SizedBox(width: 8,),
                          Text(
                            "TRANSACTIONS",
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
                                      fontSize: 8,
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
                                color: Colors.white.withAlpha(30)
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text("1",
                                      style: TextStyle(
                                          fontSize: 8,
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
                                    child: Icon(
                                      isExpanded ? Icons.cancel : Icons.add_circle,
                                      color: Colors.black.withAlpha(80),
                                      size: 21,
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
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 10,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "This month",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withAlpha(150)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "0 \$",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withAlpha(150),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            if (isExpanded) Container(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                  color: Colors.black38
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.white
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Get a quick tour around transactions",
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                      SizedBox(width: 12),
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
                                  fontSize: 8,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      InkWell(
                        onTap: () {

                        },
                        child: Icon(
                          Icons.cancel,
                          color: Colors.white10,
                          size: 21,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
    );
  }
}
