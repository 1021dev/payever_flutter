import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/pos/view_models/view_models.dart';
import 'package:provider/provider.dart';

import '../variant_picker.dart';

class PatternPicker extends StatefulWidget {
  PickerValues pv;
  PatternPicker(
    this.pv,
  );
  @override
  _PicturePickerState createState() => _PicturePickerState();
}

class _PicturePickerState extends State<PatternPicker> {
  @override
  void initState() {
    super.initState();
    widget.pv.currentVariant.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    List<Widget> _temp = List();
    for (var value in widget.pv.values) {
      _temp.add(
        PatternItem(
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

class PatternItem extends StatelessWidget {
  final int index;
  Function(String, int, String) onChangeSelection;
  final String value;
  final String name;
  PatternItem({this.index, this.onChangeSelection, this.value, this.name});
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
          padding: EdgeInsets.all(2),
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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: DecorationImage(
                image: NetworkImage(
                  Env.storage +
                      "/products/" +
                      Provider.of<PosStateModel>(context)
                          .selectedProduct
                          .variants[index]
                          .images[0],
                ),
                fit: BoxFit.none,
              ),
            ),
          ),
        ),
      ),
      onTap: () => onChangeSelection(value, index, name),
    );
  }
}
