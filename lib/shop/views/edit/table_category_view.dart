import 'package:flutter/material.dart';
import 'package:payever/commons/utils/common_utils.dart';

class TableCategoryView extends StatefulWidget {
  final Function onCreateTable;

  const TableCategoryView({this.onCreateTable});

  @override
  _TableCategoryViewState createState() => _TableCategoryViewState();
}

class _TableCategoryViewState extends State<TableCategoryView> {
  bool isPortrait;
  bool isTablet;
  final controller = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller,
              children: List.generate(6, (index) => tableCategoryPage(index)),
              onPageChanged: (page){
                currentPage = page;
                setState(() {});
              },
            ),
          ),
          Divider(height: 0, thickness: 0.5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) => indicator(index)),
          )
        ],
      ),
    );
  }

  Widget tableCategoryPage(int pageIndex) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        crossAxisCount: isTablet ? 3 : (isPortrait ? 2 : 3),
        crossAxisSpacing: isTablet ? 40 : (isPortrait ? 40 : 40),
        mainAxisSpacing: isTablet ? 60 : (isPortrait ? 60 : 20),
        childAspectRatio: 1 / 0.7,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
          4,
              (index) {
            return InkWell(
              onTap: ()=> widget.onCreateTable(index),
              child: Image.asset(
                  'assets/images/table${pageIndex + 1}-${index + 1}.png'),
            );
          },
        ),
      ),
    );
  }

  Widget indicator(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7, vertical: 20),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == currentPage ? Colors.blue : Colors.grey,
      ),
    );
  }
}
