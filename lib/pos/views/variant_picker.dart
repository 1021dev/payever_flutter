import 'package:flutter/material.dart';
import 'package:payever/pos/view_models/view_models.dart';
import 'package:payever/settings/models/models.dart';
import 'package:provider/provider.dart';

import 'custom_elements/color_picker.dart';
import 'custom_elements/custom_elements.dart';

class VariantSection extends StatefulWidget {
  ValueNotifier<int> currentVariant;
  VariantSection(this.currentVariant);

  @override
  _VariantSectionState createState() => _VariantSectionState();
}

class _VariantSectionState extends State<VariantSection> {
  int extra = 0;
  refresh(int i) {
    extra = i;
  }

  @override
  Widget build(BuildContext context) {
    PosStateModel posProvider = Provider.of<PosStateModel>(context);
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: posProvider.optionName.length + extra,
      itemBuilder: (BuildContext context, int index) {
        return VariantPicker(
          posProvider: posProvider,
          index: index,
          currentVariant: widget.currentVariant,
          callback: (_int) => refresh(_int),
        );
      },
    );
  }
}

class VariantPicker extends StatefulWidget {
  PosStateModel posProvider;
  int index;
  final dynamic Function(int) callback;
  final ValueNotifier<int> currentVariant;
  VariantPicker({
    @required this.posProvider,
    @required this.index,
    @required this.currentVariant,
    this.callback,
  });

  @override
  _VariantPickerState createState() => _VariantPickerState();
}

class _VariantPickerState extends State<VariantPicker> {
  @override
  Widget build(BuildContext context) {
    widget.posProvider = Provider.of<PosStateModel>(context);
    String name;
    List<String> values = List();
    String value;

    if (widget.index < widget.posProvider.optionName.length) {
      name = widget.posProvider.optionName[widget.index];
      values = widget.posProvider.values[name];
      value = widget.posProvider.selectedValue[name];
    } else {
      //
      widget.posProvider.getVariantValues();
      //
      name = widget.posProvider.selectedProduct
          .variants[widget.currentVariant.value].options[widget.index].name;
      value = widget.posProvider.selectedProduct
          .variants[widget.currentVariant.value].options[widget.index].value;
      values = widget.posProvider.getValues(
        widget.posProvider.selectedProduct.variants
            .where(
              (variant) => variant.options
                  .where(
                    (option) => option.name == name,
                  )
                  .isNotEmpty,
            )
            .toList(),
        name,
        "",
      );
    }
    PickerValues currentValues = PickerValues(
      currentVariant: widget.currentVariant,
      name: name,
      values: values,
      value: value,
      onChangeSelection: (value, _index, name) {
        if (widget.posProvider.optionName.contains(name)) {
          widget.currentVariant.value =
              widget.posProvider.setValue(name, value);
        } else {
          widget.posProvider.getVariantValues();
          List a = widget.posProvider.selectedProduct.variants
              .where(
                (variant) => variant.options
                    .where(
                      (option) => option.name == name,
                    )
                    .isNotEmpty,
              )
              .toList()
              .where(
                (_var) => _var.optionMap[name] == value,
              )
              .toList();
          widget.currentVariant.value =
              widget.posProvider.selectedProduct.variants.indexWhere(
            (_variant) => _variant == a[0],
          );
        }
        widget.callback(
          widget.posProvider.check4Options(widget.currentVariant.value),
        );
      },
    );

    /// ***
    ///
    /// The different types of pickers were implemented taking into consideration the way that different
    /// shop Systems manage the selection of the options for specific fields
    ///
    /// eg.
    ///
    ///   PickturePicker -> Zalando. Vertical rectangular pictures.
    ///   ColorPicker    -> Apple accesories. Circular dots.
    ///   PatternPicker  -> __ . Circular dots with a picture. thought for some texture or pattern.
    ///   SquarePicker   -> Apple hardware. Square with rounded corners
    ///   OptionDropDown -> just a normal dropdown
    ///
    /// ***

    switch (name) {
      case "Color":
        // return PicturePicker(
        // return ColorPicker(
        return SquarePicker(
          // return PatternPicker(
          currentValues,
        );
        break;
      case "color":
        // return PicturePicker(
        // return ColorPicker(
        return SquarePicker(
          // return PatternPicker(
          currentValues,
        );
        break;
      case "Size":
        // return PicturePicker(
        // return ColorPicker(
        return SquarePicker(
          // return PatternPicker(
          currentValues,
        );
        break;
      case "Detail":
        // return PicturePicker(
        // return ColorPicker(
        return SquarePicker(
          // return PatternPicker(
          currentValues,
        );
        break;
      default:
        return SquarePicker(
          // return OptionDropDown(
          currentValues,
        );
        break;
    }
  }
}

class PickerValues {
  List<String> values = List();
  String name;
  String value;
  Function(String, int, String) onChangeSelection;
  final ValueNotifier<int> currentVariant;

  PickerValues({
    this.currentVariant,
    this.value,
    this.values,
    this.name,
    this.onChangeSelection,
  });
}
