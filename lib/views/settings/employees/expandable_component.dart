import 'package:flutter/material.dart';
import 'package:payever/utils/utils.dart';

class ExpandableListView extends StatefulWidget {
  final IconData iconData;
  final String title;
  final bool isExpanded;
  final Widget widgetList;

  const ExpandableListView(
      {Key key, this.iconData, this.title, this.isExpanded, this.widgetList})
      : super(key: key);

  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      expandFlag = widget.isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Measurements.width - 2,
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        widget.iconData,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.title,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.05),
                ),
                IconButton(
                  icon: Icon(expandFlag ? Icons.remove : Icons.add),
                  onPressed: () {
                    setState(() {
                      expandFlag = !expandFlag;
                    });
                  },
                ),
              ],
            ),
          ),
          ExpandableContainer(expanded: expandFlag, child: widget.widgetList),
          Container(
              color: expandFlag
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.1),
              height: Measurements.height * 0.01,
              child: expandFlag
                  ? Divider(
                      color: Colors.white.withOpacity(0),
                    )
                  : Divider(
                      color: Colors.white,
                    )),
        ],
      ),
    );
  }
}

class ExpandableContainer extends StatefulWidget {
  final bool expanded;

  final Widget child;

  ExpandableContainer({
    @required this.child,
    this.expanded = true,
  });

  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      child: widget.expanded
          ? Container(
              color: Colors.white.withOpacity(0.05),
              child: AnimatedSize(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                vsync: this,
                child: widget.child,
              ),
            )
          : Container(width: 0, height: 0),
    );
  }
}
