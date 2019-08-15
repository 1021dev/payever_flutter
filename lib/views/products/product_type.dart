

import 'package:flutter/material.dart';
import 'package:payever/utils/appStyle.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/views/products/new_product.dart';

class ButtomRow extends StatefulWidget {
  bool service = false;
  bool digital = false;
  bool physical = true;
  NewProductScreenParts parts;
  ValueNotifier openedRow;
  ButtomRow(this.openedRow, this.parts);

  @override
  _ButtomRowState createState() => _ButtomRowState();
}

class _ButtomRowState extends State<ButtomRow> {

  @override
  void initState() {
    super.initState();
    print(widget.parts.type);
    if(!widget.parts.editMode)
      widget.parts.type ="physical";
    else{
      widget.service  = (widget.parts.type == "service");
      widget.digital  = (widget.parts.type == "digital");
      widget.physical = (widget.parts.type == "physical");
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          elevation:0,// widget.service?0:0.1,
          highlightElevation: 0,
          color: !widget.service
              ? Colors.black.withOpacity(0.1)
              : Colors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20))
            ),
          child: Text(Language.getProductStrings("category.type.service"),style: TextStyle(fontSize: AppStyle.fontSizeButtonTabSelect()),),
          onPressed: () {
            setState(() {
              widget.parts.type = "service";
              widget.service = true;
              widget.digital = false;
              widget.physical = false;
            });
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 1),
        ),
        RaisedButton(
          elevation:0,// widget.digital?0:0.01,
          highlightElevation: 0,
          color: !widget.digital
              ? Colors.black.withOpacity(0.1)
              : Colors.white.withOpacity(0.2),
          child: Text(Language.getProductStrings("category.type.digital"),style: TextStyle(fontSize: AppStyle.fontSizeButtonTabSelect()),),
          onPressed: () {
            setState((){
              widget.parts.type = "digital";
              widget.service = false;
              widget.digital = true;
              widget.physical = false;
            });
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 1),
        ),
        RaisedButton(
          elevation:0,// widget.physical?0:0.1,
          highlightElevation: 0,
          color: !widget.physical
              ? Colors.black.withOpacity(0.1)
              : Colors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20))
                  ),
          child: Text(Language.getProductStrings("category.type.physical"),style: TextStyle(fontSize: AppStyle.fontSizeButtonTabSelect()),),
          onPressed: () {
            setState(() {
              widget.parts.type = "physical";
              widget.service = false;
              widget.digital = false;
              widget.physical = true;
            });
          },
        )
      ],
    );
  }
}
