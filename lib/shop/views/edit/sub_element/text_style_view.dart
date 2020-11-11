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

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
    List<Widget>textStyleWidgets = [];
    textStyleWidgets.add(_gridViewBody);
    textStyleWidgets.add(_fill);
    textStyleWidgets.add(_border);

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
        shrinkWrap: true,
        crossAxisCount: isTablet ? 5 : (isPortrait ? 3 : 5),
        crossAxisSpacing: isTablet ? 40 : (isPortrait ? 40 : 40),
        mainAxisSpacing: isTablet ? 20 : (isPortrait ? 20 : 20),
        childAspectRatio: 1 / 0.7,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
          6,
          (index) {
            return _objectGridItem(index);
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
                  value: false,
                  onChanged: (value) {

                  },
                ),
              ),
            ],
          ),
        ),
        if (borderExpanded)
          Container(
            
          )
      ],
    );
  }

  Widget _objectGridItem(int index) {
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
}
