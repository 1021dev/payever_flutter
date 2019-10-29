import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/pos/view_models/view_models.dart';
import 'package:provider/provider.dart';

import '../variant_picker.dart';

class PicturePicker extends StatefulWidget {
  PickerValues pv;
  PicturePicker(
    this.pv,
  );
  @override
  _PicturePickerState createState() => _PicturePickerState();
}

class _PicturePickerState extends State<PicturePicker> {
  @override
  void initState() {
    super.initState();
    widget.pv.currentVariant.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
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
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: widget.pv.values.length,
            itemBuilder: (BuildContext context, int index) {
              return PictureItem(
                index: index,
                value: widget.pv.values[index],
                name: widget.pv.name,
                onChangeSelection: widget.pv.onChangeSelection,
              );
            },
          ),
        ),
      ],
    );
  }
}

class PictureItem extends StatelessWidget {
  final int index;
  Function(String, int, String) onChangeSelection;
  final String value;
  final String name;
  PictureItem({this.index, this.onChangeSelection, this.value, this.name});
  bool selected;
  bool justUnderLine = true;
  Color frameColor = Colors.black;
  double frameWidth = 1;
  @override
  Widget build(BuildContext context) {
    PosStateModel posProvider = Provider.of<PosStateModel>(context);
    selected = value == posProvider.selectedValue[name];
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 90,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            border: justUnderLine?Border(
                top: BorderSide(
                  width: 0,
                  color: Colors.white,
                ),
                bottom: BorderSide(
                  width: 2,
                  color: selected?frameColor:Colors.white,
                ),
                right: BorderSide(
                  width: 0,
                  color: Colors.white,
                ),
                left: BorderSide(
                  width: 0,
                  color: Colors.white,
                ),
              ):Border(
                top: BorderSide(
                  width: frameWidth,
                  color: selected?frameColor:Colors.white,
                ),
                bottom: BorderSide(
                  width: frameWidth,
                  color: selected?frameColor:Colors.white,
                ),
                right: BorderSide(
                  width: frameWidth,
                  color: selected?frameColor:Colors.white,
                ),
                left: BorderSide(
                  width: frameWidth,
                  color: selected?frameColor:Colors.white,
                ),
              ),
            image: DecorationImage(
              image: NetworkImage(Env.storage +
                  "/products/" +
                  Provider.of<PosStateModel>(context)
                      .selectedProduct
                      .variants[index]
                      .images[0]),
            ),
          ),
        ),
      ),
      onTap: () => onChangeSelection(value, index, name),
    );
  }
}
