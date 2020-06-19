import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/views/custom_elements/Dashboard/TransactionListCell.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/BlurEffectView.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/TopBarView.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/transactions/FilterContentView.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/transactions/SortContentView.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/transactions/model/Enums.dart';
import 'package:payever/settings/views/employees/expandable_component.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  SortType curSortType = SortType.date;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        top: true,
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://payever.azureedge.net/images/commerceos-background.jpg"),
                      fit: BoxFit.cover)),
              child: BlurEffectView(
                radius: 0,
              ),
            ),
            Column(
              children: [
                TopBarView(),
                Container(
                  height: 50,
                  color: Colors.black38,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.search,
                              size: 20,
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
                            onTap: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (builder) {
                                    return FilterContentView(
                                      onSelected: (val) {
                                        Navigator.pop(context);
                                      },
                                    );
                                  });
                            },
                            child: Icon(
                              Icons.filter_list,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (builder) {
                                    return SortContentView(
                                      selectedIndex: curSortType ,
                                      onSelected: (val) {
                                        Navigator.pop(context);
                                        setState(() {
                                          curSortType = val;
                                        });
                                      },
                                    );
                                  });
                            },
                            child: Icon(
                              Icons.sort,
                              size: 20,
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: 35,
                  color: Colors.black45,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Channel",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Type",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Customer name",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Total",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: _itemBuilder,
                    itemCount: 15,
                  ),
                ),
                Container(
                  height: 50,
                  color: Colors.black87,
                  alignment: Alignment.center,
                  child: Text(
                    "111 orders for \$88,946.75",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return TransactionListCell();
  }
}
