import 'package:flutter/material.dart';

class SaveBtn extends StatelessWidget {
  final bool isUpdating;
  final Function onUpdate;
  SaveBtn({this.isUpdating = false, this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return saveButton();
  }

  Widget saveButton() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
        ),
      ),
      child: SizedBox.expand(
        child: isUpdating
            ? Center(
          child:  CircularProgressIndicator(),
        ) : MaterialButton(
          onPressed: onUpdate,
          child: Text('Save'),
        ),
      ),
    );
  }
}
