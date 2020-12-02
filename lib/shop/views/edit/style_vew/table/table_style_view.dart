import 'package:flutter/material.dart';
import 'package:payever/commons/utils/common_utils.dart';

class TableStyleView extends StatefulWidget {
  @override
  _TableStyleViewState createState() => _TableStyleViewState();
}

class _TableStyleViewState extends State<TableStyleView> {
  bool isPortrait;
  bool isTablet;

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          gridView,
        ],
      ),
    );
  }

  Widget get gridView {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      child: GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        crossAxisCount: isTablet ? 5 : (isPortrait ? 3 : 5),
        crossAxisSpacing: isTablet ? 40 : (isPortrait ? 40 : 40),
        mainAxisSpacing: isTablet ? 20 : (isPortrait ? 20 : 20),
        childAspectRatio: 1 / 0.7,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
          6,
              (index) {
            return Image.asset(
                'assets/images/table-style-${index + 1}.png');
          },
        ),
      ),
    );
  }
}
