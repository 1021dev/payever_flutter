import 'package:flutter/material.dart';

class SaveBtn extends StatelessWidget {
  final bool isSaving;
  SaveBtn(this.isSaving);

  @override
  Widget build(BuildContext context) {
    return saveButton();
  }

  Widget saveButton() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.4),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0))),
      child: Center(
          child: isSaving
              ? CircularProgressIndicator()
              : Text('Save')),
    );
  }
}
