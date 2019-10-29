import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/pos/view_models/view_models.dart';
import 'package:provider/provider.dart';
import '../variant_picker.dart';

class ColorPicker extends StatefulWidget {
  PickerValues pv;
  ColorPicker(
    this.pv,
  );
  @override
  _PicturePickerState createState() => _PicturePickerState();
}

class _PicturePickerState extends State<ColorPicker> {
  @override
  void initState() {
    super.initState();
    widget.pv.currentVariant.addListener(() {});
    // () => setState(
    //   () {
    //     print("setState on ColorPicker ");
    //   },
    // ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    List<Widget> _temp = List();
    for (var value in widget.pv.values) {
      _temp.add(
        ColorItem(
          index: i,
          value: value,
          name: widget.pv.name,
          onChangeSelection: widget.pv.onChangeSelection,
        ),
      );
      i++;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: "${widget.pv.name}: ",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: "${widget.pv.value}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Wrap(
            children: _temp,
          ),
        ),
      ],
    );
  }
}

class ColorItem extends StatelessWidget {
  final int index;
  Function(String, int, String) onChangeSelection;
  final String value;
  final String name;
  ColorItem({this.index, this.onChangeSelection, this.value, this.name});
  bool selected;
  bool justUnderLine = true;
  Color frameColor = Colors.blueAccent;
  double frameWidth = 1;
  @override
  Widget build(BuildContext context) {
    PosStateModel posProvider = Provider.of<PosStateModel>(context);
    selected = value == posProvider.selectedValue[name];
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Container(
          height: 40,
          width: 40,
          padding: EdgeInsets.all(0.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            border: Border(
              top: BorderSide(
                width: frameWidth,
                color: selected ? frameColor : Colors.white,
              ),
              bottom: BorderSide(
                width: frameWidth,
                color: selected ? frameColor : Colors.white,
              ),
              right: BorderSide(
                width: frameWidth,
                color: selected ? frameColor : Colors.white,
              ),
              left: BorderSide(
                width: frameWidth,
                color: selected ? frameColor : Colors.white,
              ),
            ),
          ),
          child: ColorCircle(
            color: customColors[value],
            size: 40.0,
          ),
        ),
      ),
      onTap: () => onChangeSelection(value, index, name),
    );
  }
}

Map<String, Color> customColors = {
  "Red": Color.fromRGBO(255, 59, 48, 1),
  "Blue": Color.fromRGBO(0, 122, 255, 1),
  "Green": Color.fromRGBO(52, 199, 89, 1),
  "Yellow": Color.fromRGBO(255, 204, 0, 1),
  "Pink": Color.fromRGBO(175, 82, 222, 1),
  "Orange": Color.fromRGBO(255, 149, 0, 1),
  "Silver": Color.fromRGBO(174, 174, 178, 1),
  "Black": Color.fromRGBO(28, 28, 30, 1),
};

class ColorCircle extends StatelessWidget {
  final Color color;
  final num size;

  ColorCircle({@required this.color, @required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Stack(
        children: <Widget>[
          Container(
            height: size + 2,
            width: size + 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          Container(
            height: size + 2,
            width: size + 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.25),
                  Colors.black12,
                ],
              ),
            ),
            padding: EdgeInsets.only(top: 2),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
                Container(
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[Colors.white12, Colors.transparent],
                    ),
                  ),
                ),
                Container(
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[Colors.white24, Colors.transparent],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
