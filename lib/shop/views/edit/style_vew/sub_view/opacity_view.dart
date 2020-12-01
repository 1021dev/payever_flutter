import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

class OpacityView extends StatefulWidget {
  final TextStyles styles;
  final Function onUpdateOpacity;

  const OpacityView({@required this.styles, @required this.onUpdateOpacity});

  @override
  _OpacityViewState createState() => _OpacityViewState();
}

class _OpacityViewState extends State<OpacityView> {
  double opacityValue = 1.0;

  @override
  Widget build(BuildContext context) {
    opacityValue = widget.styles.opacity;

    return Container(
      height: 60,
      child: Row(
        children: [
          Text(
            'Opacity',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Slider(
              value: opacityValue,
              min: 0,
              max: 1,
              onChanged: (double value) => widget.onUpdateOpacity(value, false),
              onChangeEnd: (double value) => widget.onUpdateOpacity(value, true),
            ),
          ),
          Container(
            width: 30,
            alignment: Alignment.center,
            child: Text(
              '${opacityValue.toStringAsFixed(1)}',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
