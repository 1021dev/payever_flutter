import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddObjectAppbar extends StatelessWidget with PreferredSizeWidget {

  final Function onClose;
  final Function onSelected;

  AddObjectAppbar({this.onClose, this.onSelected});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AddObjectAppBarState(onSelected);
  }
}

class AddObjectAppBarState extends StatefulWidget {
  final Function onSelected;

  const AddObjectAppBarState(this.onSelected);

  @override
  _AddObjectAppBarStateState createState() => _AddObjectAppBarStateState();
}

class _AddObjectAppBarStateState extends State<AddObjectAppBarState> {
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return AppBar(
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color.fromRGBO(20, 19, 24, 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          child: Container(
                            padding: getPadding(),
                            decoration: getDecoration(0),
                            child: Icon(
                              Icons.table_rows_outlined,
                              color: Colors.white,
                            ),
                          ),
                          onTap:() =>_selectedCategory(0),
                        ),
                        InkWell(
                          child: Container(
                            padding: getPadding(),
                            decoration: getDecoration(1),
                            child: Icon(
                              Icons.cloud_circle,
                              color: Colors.white,
                            ),
                          ),
                          onTap:() =>_selectedCategory(1),
                        ),

                        InkWell(
                          child: Container(
                            padding: getPadding(),
                            decoration: getDecoration(2),
                            child: Icon(
                              Icons.format_shapes,
                              color: Colors.white,
                            ),
                          ),
                          onTap:() =>_selectedCategory(2),
                        ),

                        InkWell(
                          child: Container(
                            padding: getPadding(),
                            decoration: getDecoration(3),
                            child: Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                          ),
                          onTap:() =>_selectedCategory(3),
                        ),
                      ],),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: InkWell(
              child: Container(
                padding: EdgeInsets.all(4),
                alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(20, 19, 24, 1),
                  ),
                  child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),)
          ],

        ),
      ),
    );
  }

  EdgeInsets getPadding() {
    return EdgeInsets.symmetric(horizontal: 20, vertical: 4);
  }

  BoxDecoration getDecoration(int index) {
    if (index == selectedIndex)
      return BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color.fromRGBO(46, 45, 50, 1),
      );
    return null;
  }

  _selectedCategory(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onSelected(index);
  }
}
