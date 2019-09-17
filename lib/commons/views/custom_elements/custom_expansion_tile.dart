import 'package:flutter/material.dart';

import 'custom_expansion_panel.dart';

class CustomExpansionTile extends StatefulWidget {
//  final List<ExpandableHeader> widgetsTitleList;
  final List<Widget> widgetsTitleList;
  final List<Widget> widgetsBodyList;
  final bool isWithCustomIcon;
  final int listSize;
  final bool addBorderRadius;
  final bool scrollable;
  final bool customPadding;
  final Color headerColor;
  final Color bodyColor;
  final Color iconColor;

  const CustomExpansionTile(
      {Key key,
      @required this.widgetsTitleList,
      @required this.widgetsBodyList,
      @required this.isWithCustomIcon,
      this.listSize,
      this.addBorderRadius,
      this.bodyColor,
      this.headerColor,
      this.iconColor = Colors.white,
      this.scrollable = true, this.customPadding})
      : super(key: key);

  @override
  createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  int _activeIndex = 0;

  bool addBorderRadius = true;
  bool customPadding = false;

  @override
  void initState() {
    super.initState();

    if (widget.addBorderRadius != null) {
      setState(() {
        addBorderRadius = widget.addBorderRadius;
      });
    }

    if (widget.customPadding != null) {
      setState(() {
        customPadding = widget.customPadding;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: widget.scrollable
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
        itemCount: widget.listSize == 1
            ? widget.listSize
            : widget.widgetsTitleList.length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
//              margin: EdgeInsets.only(bottom: 60),
            decoration: i == 0 && addBorderRadius
                ? BoxDecoration(
                    color: widget.headerColor == null
                        ? Colors.white.withOpacity(0.1)
                        : widget.headerColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)))
                : BoxDecoration(
                    color: widget.headerColor == null
                        ? Colors.white.withOpacity(0.1)
                        : widget.headerColor,
                  ),
            child: CustomExpansionPanelList(
              iconColor: widget.iconColor,
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
                  body: widget.widgetsBodyList[i],
                ),
              ],
            ),
          );
        });
  }
}
