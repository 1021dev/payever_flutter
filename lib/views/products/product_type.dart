

import 'package:flutter/material.dart';
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
          color: widget.service
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20))
            ),
          child: Text(Language.getProductStrings("category.type.service")),
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
          color: widget.digital
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          child: Text(Language.getProductStrings("category.type.digital")),
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
          color: widget.physical
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20))
                  ),
          child: Text(Language.getProductStrings("category.type.physical")),
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
