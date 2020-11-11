import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';

class TextStyleView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;

  const TextStyleView({this.screenBloc});

  @override
  _TextStyleViewState createState() => _TextStyleViewState();
}

class _TextStyleViewState extends State<TextStyleView> {
  bool isPortrait;
  bool isTablet;
  Color bgColor = Colors.transparent;
  bool borderExpanded = false;
  bool shadowExpanded = false;
  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
    List<Widget>textStyleWidgets = [];
    textStyleWidgets.add(_gridViewBody);
    textStyleWidgets.add(_fill);
    textStyleWidgets.add(_border);
    textStyleWidgets.add(_shadow);
    return Container(
      height: 350,
      color: Colors.grey[800],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 34),
          child: Column(
            children: [
              _segmentedControl,
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: textStyleWidgets.length,
                  itemBuilder: (context, index) {
                    return textStyleWidgets[index];
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 0,
                      thickness: 0.5,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  get _segmentedControl {
    return Container(
      alignment: Alignment.center,
      child: CupertinoSegmentedControl(
        children: const <int, Widget>{
          0: Padding(
              padding: EdgeInsets.all(8.0), child: Text('Style')),
          1: Padding(
              padding: EdgeInsets.all(8.0), child: Text('Text')),
          2: Padding(
              padding: EdgeInsets.all(8.0), child: Text('Arrange'))
        },
        onValueChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  get _gridViewBody {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
            return _textBackgroundGridItem(index);
          },
        ),
      ),
    );
  }

  get _fill {
    return Container(
      height: 60,
      child: Row(
       children: [
         Text('Fill', style: TextStyle(color: Colors.white, fontSize: 18),),
         Spacer(),
         Container(
           width: 100,
           height: 40,
           decoration: BoxDecoration(
             border: Border.all(color: Colors.grey, width: 1),
             color: bgColor,
             borderRadius: BorderRadius.circular(8),
           ),
         ),
         SizedBox(width: 15),
         Icon(Icons.arrow_forward_ios),
       ],
      ),
    );
  }

  get _border {
    return Column(
      children: [
        Container(
          height: 60,
          child: Row(
            children: [
              Text('Border', style: TextStyle(color: Colors.white, fontSize: 18),),
              Spacer(),
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: borderExpanded,
                  onChanged: (value) {
                    setState(() {
                      borderExpanded = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        if (borderExpanded)
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              children: [
                Container(
                  height: 60,
                  child: Row(
                    children: [
                      Text('Style', style: TextStyle(color: Colors.white, fontSize: 18),),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 4,
                        color: Colors.white,
                      )),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  child: Row(
                    children: [
                      Text('Color', style: TextStyle(color: Colors.white, fontSize: 18),),
                      Spacer(),
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  child: Row(
                    children: [
                      Text('Width', style: TextStyle(color: Colors.white, fontSize: 18),),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: 4,
                            color: Colors.white,
                          )),
                      Text('1 pt', style: TextStyle(color: Colors.white, fontSize: 16),),
                    ],
                  ),
                )
              ],
            ),
          )
      ],
    );
  }

  get _shadow {
    return Column(
      children: [
        Container(
          height: 60,
          child: Row(
            children: [
              Text('Shadow', style: TextStyle(color: Colors.white, fontSize: 18),),
              Spacer(),
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: shadowExpanded,
                  onChanged: (value) {
                    setState(() {
                      shadowExpanded = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        if (shadowExpanded)
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.count(
              padding: EdgeInsets.all(10),
              shrinkWrap: true,
              crossAxisCount: isTablet ? 5 : (isPortrait ? 3 : 5),
              crossAxisSpacing: isTablet ? 40 : (isPortrait ? 40 : 40),
              mainAxisSpacing: isTablet ? 20 : (isPortrait ? 20 : 20),
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(
                6,
                    (index) {
                  return _shadowGridItem(index);
                },
              ),
            ),
          )
      ],
    );
  }

  Widget _textBackgroundGridItem(int index) {
    Color color;
    switch (index) {
      case 0:
        color = Color.fromRGBO(0, 168, 255, 1);
        break;
      case 1:
        color = Color.fromRGBO(96, 234, 50, 1);
        break;
      case 2:
        color = Color.fromRGBO(255, 22, 1, 1);
        break;
      case 3:
        color = Color.fromRGBO(255, 200, 0, 1);
        break;
      case 4:
        color = Color.fromRGBO(255, 91, 175, 1);
        break;
      case 5:
        color = Color.fromRGBO(0, 0, 0, 1);
        break;
    }

    Widget item = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('Text', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
    );

    return InkWell(
        onTap: () {
          Navigator.pop(context, index);
        },
        child: item);
  }

  Widget _shadowGridItem(int index) {
    double offsetX = 0;
    double offsetY = 0;
    double blurRadius = 5;
    switch (index) {
      case 0:
        offsetX = 0;
        offsetY = 5;
        break;
      case 1:
        offsetX = 5;
        offsetY = 5;
        break;
      case 2:
        offsetX = -5;
        offsetY = 5;
        break;
      case 3:
        offsetX = -5;
        offsetY = 0;
        break;
      case 4:
        offsetX = 0;
        offsetY = 0;
        blurRadius = 0;
        break;
      case 5:
        offsetX = -5;
        offsetY = -5;
        break;
    }

    Widget item = Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: blurRadius,
                offset: Offset(offsetX, offsetY), // changes position of shadow
              ),
            ],
          ),
//      color: colorConvert(styles.backgroundColor),
          alignment: Alignment.center,
        ),
        Positioned(
            bottom: 10,
            right: 10,
            child: Icon(
              Icons.check_circle,
              color: Colors.blue,
            ))
      ],
    );

    return InkWell(
        onTap: () {
          Navigator.pop(context, index);
        },
        child: item);
  }


}
