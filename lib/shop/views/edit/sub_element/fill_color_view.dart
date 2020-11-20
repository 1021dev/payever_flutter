import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';

import 'background_view.dart';
import 'fill_view.dart';

class FillColorView extends StatefulWidget {
  final TextStyles styles;
  final ColorType colorType;
  final Color pickColor;
  final Function onUpdateColor;

  const FillColorView(
      {@required this.styles,
      @required this.colorType,
      @required this.pickColor,
      @required this.onUpdateColor});

  @override
  _FillColorViewState createState() => _FillColorViewState();
}

class _FillColorViewState extends State<FillColorView> {
  Color changedColor;

  @override
  Widget build(BuildContext context) {
    String title;

    switch(widget.colorType) {
      case ColorType.BackGround:
        title = 'Fill';
        break;
      case ColorType.Border:
        title = 'Color';
        break;
      case ColorType.Text:
        title = 'Text Color';
        break;
    }

    return Container(
      height: 60,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              if (widget.colorType == ColorType.BackGround) {
                // navigateSubView(FillView(widget.screenBloc,
                //   stylesheets: widget.stylesheets,
                //   onUpdateColor: (Color color) {
                //     setState(() {
                //       fillColor = color;
                //     });
                //     _updateFillColor(state);
                //   },
                //   onUpdateGradientFill: (GradientModel model, bool updateApi) =>
                //       _updateGradientFillColor(state, model, updateApi: updateApi),
                //   onUpdateImageFill: (BackGroundModel model) => _updateImageFill(state, model),
                // ));
                return;
              }

              showDialog(
                context: context,
                child: AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      paletteType: PaletteType.hsl,
                      pickerColor: widget.pickColor,
                      onColorChanged: (color) => changedColor = color,
                      showLabel: true,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('Got it'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onUpdateColor(changedColor);
                      },
                    ),
                  ],
                ),
              );
            },
            child: getFillContainer(),
          ),
        ],
      ),
    );
  }

  Widget getFillContainer() {
    if (widget.colorType == ColorType.BackGround)
      return Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          color: widget.pickColor,
        ),
        child: widget.styles.backgroundImage.isNotEmpty
            ? BackgroundView(styles: widget.styles)
            : widget.pickColor == Colors.transparent
            ? ClipPath(
          child: Container(
            color: Colors.red[900],
          ),
          clipper: NoBackGroundFillClipPath(),
        )
            : Container(),
      );

    return Container(
      width: 100,
      height: 40,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        color: widget.pickColor,
      ),
      child: widget.pickColor == Colors.transparent ? ClipPath(
        child: Container(
          color: Colors.red[900],
        ),
        clipper: NoBackGroundFillClipPath(),
      ) : Container(),
    );
  }
}
