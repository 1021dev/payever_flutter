library multiselect_formfield;

import 'package:flutter/material.dart';
import 'package:payever/products/views/add_variant_screen.dart';

import 'multi_select_dialog.dart';

class MultiSelectFormField extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function change;
  final Function open;
  final Function close;
  final Widget leading;
  final Widget trailing;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final Color fillColor;
  final InputBorder border;
  Map<String, Color> colorMaps;

  MultiSelectFormField(
      {FormFieldSetter<dynamic> onSaved,
        FormFieldValidator<dynamic> validator,
        dynamic initialValue,
        bool autovalidate = false,
        this.titleText = 'Title',
        this.hintText = 'Tap to select one or more',
        this.required = false,
        this.errorText = 'Please select one or more options',
        this.leading,
        this.dataSource,
        this.textField,
        this.valueField,
        this.change,
        this.open,
        this.close,
        this.okButtonLabel = 'OK',
        this.cancelButtonLabel = 'CANCEL',
        this.fillColor,
        this.border,
        this.trailing,
        this.colorMaps,
      })
      : super(
    onSaved: onSaved,
    validator: validator,
    initialValue: initialValue,
    autovalidate: autovalidate,
    builder: (FormFieldState<dynamic> state) {
      List<Widget> _buildSelectedOptions(state) {
        List<Widget> selectedOptions = [];

        if (state.value != null) {
          state.value.forEach((item) {
            var existingItem = dataSource.singleWhere((itm) => itm[valueField] == item, orElse: () => null);
            selectedOptions.add(Chip(
              label: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: colorMaps[existingItem[textField]],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    )
                ),
              ),
            ));
          });
        }

        return selectedOptions;
      }

      return InkWell(
        onTap: () async {
          List initialSelected = state.value;
          if (initialSelected == null) {
            initialSelected = List();
          }

          List selectedValues = await showDialog<List>(
            context: state.context,
            builder: (BuildContext context) {
              return MultiSelectDialog(
                title: titleText,
                okButtonLabel: okButtonLabel,
                cancelButtonLabel: cancelButtonLabel,
                initialSelectedValues: initialSelected,
                colorMaps: colorMaps,
                addButtonLabel: 'Add Color',
              );
            },
          );

          if (selectedValues != null) {
            state.didChange(selectedValues);
            state.save();
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            errorText: state.hasError ? state.errorText : null,
            errorMaxLines: 4,
            fillColor: fillColor ?? Theme.of(state.context).canvasColor,
            border: border ?? UnderlineInputBorder(),
          ),
          isEmpty: state.value == null || state.value == '',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          titleText,
                          style: TextStyle(fontSize: 13.0,),
                        )),
                    required
                        ? Padding(padding:EdgeInsets.only(top:5, right: 5), child: Text(
                      ' *',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 17.0,
                      ),
                    ),
                    )
                        : Container(),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                    ),
                  ],
                ),
              ),
              state.value != null && state.value.length > 0
                  ? Wrap(
                spacing: 8.0,
                runSpacing: 0.0,
                children: _buildSelectedOptions(state),
              )
                  : new Container(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  hintText,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
