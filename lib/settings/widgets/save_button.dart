import 'package:flutter/material.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/theme.dart';

class SaveBtn extends StatelessWidget {
  final bool isUpdating;
  final Function onUpdate;
  final Color color;
  final bool isBottom;
  final String title;
  SaveBtn({
    this.isUpdating = false,
    this.onUpdate,
    this.color = Colors.black87,
    this.isBottom = true,
    this.title = 'Save',
  });

  @override
  Widget build(BuildContext context) {
    return saveButton();
  }

  Widget saveButton() {
    return BlurEffectView(
      borderRadius: isBottom ? BorderRadius.only(
        bottomLeft: Radius.circular(8.0),
        bottomRight: Radius.circular(8.0),
      ): BorderRadius.circular(0),
      child: Container(
        height: 55,
        child: SizedBox.expand(
          child: isUpdating
              ? Center(
            child: Container(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ) : MaterialButton(
            elevation: 0,
            onPressed: onUpdate,
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
