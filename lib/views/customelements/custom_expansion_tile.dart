import 'package:flutter/material.dart';

import 'package:payever/models/expandable_header.dart';
import 'package:payever/utils/utils.dart';
import 'custom_expansion_panel.dart';

class CustomExpansionTile extends StatefulWidget {
//  final List<ExpandableHeader> widgetsTitleList;
  final List<Widget> widgetsTitleList;
  final List<Widget> widgetsBodyList;
  final bool isWithCustomIcon;
  final int listSize;

  const CustomExpansionTile(
      {Key key,
      @required this.widgetsTitleList,
      @required this.widgetsBodyList,
      @required this.isWithCustomIcon,
      this.listSize})
      : super(key: key);

  @override
  createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.listSize == 1 ? widget.listSize : widget.widgetsTitleList.length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
//              margin: EdgeInsets.only(bottom: 60),
            decoration: i == 0
                ? BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)))
                : BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                  ),
            child: CustomExpansionPanelList(
              isWithCustomIcon: widget.isWithCustomIcon,
              expansionCallback: (int index, bool status) {
                setState(() {
                  _activeIndex = _activeIndex == i ? null : i;
                });
              },
              children: [
                ExpansionPanel(
                  isExpanded: _activeIndex == i,
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool isExpanded) =>
                      widget.widgetsTitleList[i],
//                        Container(
//                      decoration: BoxDecoration(
////                          color: Colors.white.withOpacity(0.8),
//                          ),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Container(
//                            child: Row(
//                              children: <Widget>[
//                                widget.widgetsTitleList[i].icon ?? Container(),
//                                SizedBox(width: 10),
//                                Text(
//                                  widget.widgetsTitleList[i].title,
//                                  style: TextStyle(fontSize: 18),
//                                ),
//                              ],
//                            ),
//                            padding: EdgeInsets.symmetric(
//                                horizontal: Measurements.width * 0.05),
//                          ),
//                        ],
//                      ),
//                    ),
                  body: widget.widgetsBodyList[i],
                ),
              ],
            ),
          );
        });
  }
}
