import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payever/checkout_process/checkout_process.dart';


enum FieldStatus {
  ok,
  empty,
  error,
}
enum FieldType {
  all,
  numbers,
  sku,
}

class CustomFormField extends StatelessWidget {
  final int flex;

  /// Rounded corners
  /// default False
  final bool topRight;
  final bool topLeft;
  final bool bottomRight;
  final bool bottomLeft;

  final String text;
  final String sufix;
  final bool long;
  final bool error;
  final FieldType format;

  final bool mandatory;
  final TextEditingController controller;
  final Color color = Colors.white.withOpacity(0.1);

  dynamic onChange;
  dynamic validator;

  Map<FieldType, String> formaters = {
    FieldType.all: "[a-z A-Z 0-9 -- _ ]",
    FieldType.numbers: "[0-9 .]",
    FieldType.sku: "[a-z A-Z 0-9 -- _ ]",
  };

  CustomFormField({
    this.flex = 1,
    this.topRight = false,
    this.topLeft = false,
    this.bottomRight = false,
    this.bottomLeft = false,
    this.error = false,
    this.text = "",
    this.sufix = "",
    this.long = false,
    this.format = FieldType.all,
    this.mandatory = true,
    @required this.controller,
    @required this.onChange,
    @required this.validator,
  })  : assert(flex > 0),
        assert(controller != null);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.all(1.0),
        child: Container(
          padding: sufix.isEmpty
              ? EdgeInsets.symmetric(horizontal: 10)
              : EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(bottomLeft ? 8 : 0),
              bottomRight: Radius.circular(bottomRight ? 8 : 0),
              topLeft: Radius.circular(topLeft ? 8 : 0),
              topRight: Radius.circular(topRight ? 8 : 0),
            ),
          ),
          child: TextFormField(
            maxLines: long ? 5 : 1,
            inputFormatters: [
              WhitelistingTextInputFormatter(
                RegExp(
                  formaters[format],
                ),
              ),
              BlacklistingTextInputFormatter(
                RegExp("[,]"),
              ),
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: error?"${Language.getCommerceOSStrings("forms.error.validator.required")}":text,
              hintText: error?text:"",
              labelStyle: TextStyle(color: error ? Colors.red : null),
              suffixIcon: sufix.isNotEmpty
                  ? Container(
                      height: 59,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(bottomRight ? 8 : 0),
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(topRight ? 8 : 0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            sufix,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
            ),
            cursorColor: Colors.white,
            cursorWidth: 1,
            style: TextStyle(),
            controller: controller,
            onChanged: (text) => onChange(text),
            onSaved: (text) => validator(text),
            validator: (text)=> validator(text),
          ),
        ),
      ),
    );
  }
}

class CustomInventoryField extends StatelessWidget {
  final int flex;

  /// Rounded corners
  /// default False
  final bool topRight;
  final bool topLeft;
  final bool bottomRight;
  final bool bottomLeft;

  final String text;
  final String sufix;
  final bool long;
  final FieldType format;

  final bool mandatory;
  final TextEditingController controller;
  final Color color = Colors.white.withOpacity(0.1);

  dynamic onChange;
  dynamic validator;

  Map<FieldType, String> formaters = {
    FieldType.all: "[a-z A-Z 0-9 --  _ / ]",
    FieldType.numbers: "[0-9 .]",
    FieldType.sku: "[]",
  };

  CustomInventoryField({
    this.flex = 1,
    this.topRight = false,
    this.topLeft = false,
    this.bottomRight = false,
    this.bottomLeft = false,
    this.text = "",
    this.sufix = "",
    this.long = false,
    this.format = FieldType.all,
    this.mandatory = true,
    @required this.controller,
    @required this.onChange,
    @required this.validator,
  })  : assert(flex > 0),
        assert(controller != null);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.all(1.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(bottomLeft ? 8 : 0),
              bottomRight: Radius.circular(bottomRight ? 8 : 0),
              topLeft: Radius.circular(topLeft ? 8 : 0),
              topRight: Radius.circular(topRight ? 8 : 0),
            ),
          ),
          child: SizedBox(
            height: 59,
            child: TextFormField(
              showCursor: false,
              enableInteractiveSelection: false,
              maxLines: long ? 5 : 1,
              inputFormatters: [
                WhitelistingTextInputFormatter(
                  RegExp(
                    "[0-9]",
                  ),
                ),
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: text,
                labelStyle: TextStyle(),
                prefix: InkWell(
                  child: Container(
                    child: Icon(
                      Icons.remove_circle_outline,
                      size: 15,
                    ),
                  ),
                  onTap: () {
                    int stock = (int.parse(
                            controller.text.isEmpty ? "0" : controller.text) -
                        1);
                    controller.text = (stock >= 0 ? stock : 0).toString();
                    onChange(controller.text);
                  },
                ),
                suffix: InkWell(
                  child: Container(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.add_circle_outline,
                      size: 15,
                    ),
                  ),
                  onTap: () {
                    controller.text = (int.parse(controller.text.isEmpty
                                ? "0"
                                : controller.text) +
                            1)
                        .toString();
                    onChange(controller.text);
                  },
                ),
              ),
              textAlign: TextAlign.center,
              cursorColor: Colors.white,
              cursorWidth: 1,
              style: TextStyle(),
              controller: controller,
              onChanged: (text) => onChange(text),
              onSaved: (text) => validator(text),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSwitchField extends StatelessWidget {
  final int flex;

  /// Rounded corners
  /// default False
  final bool topRight;
  final bool topLeft;
  final bool bottomRight;
  final bool bottomLeft;
  final String text;
  final bool first;
  final bool value;
  final Color color = Colors.white.withOpacity(0.1);

  dynamic onChange;

  CustomSwitchField({
    this.flex = 1,
    this.topRight = false,
    this.topLeft = false,
    this.bottomRight = false,
    this.bottomLeft = false,
    this.text = "",
    this.first = false,
    this.value = false,
    @required this.onChange,
  }) : assert(flex > 0);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.all(1.0),
        child: InkWell(
          highlightColor: Colors.transparent,
          onTap: () => onChange(!value),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(bottomLeft ? 8 : 0),
                  bottomRight: Radius.circular(bottomRight ? 8 : 0),
                  topLeft: Radius.circular(topLeft ? 8 : 0),
                  topRight: Radius.circular(topRight ? 8 : 0),
                )),
            child: Container(
              height: 59,
              child: Row(
                children: <Widget>[
                  first
                      ? Switch(
                          onChanged: (value) => onChange(value),
                          value: value,
                          activeColor: Colors.blueAccent,
                        )
                      : Container(),
                  Expanded(
                    child: Text(
                      text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  !first
                      ? Switch(
                          onChanged: (value) => onChange(value),
                          value: value,
                          activeColor: Colors.blueAccent,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
