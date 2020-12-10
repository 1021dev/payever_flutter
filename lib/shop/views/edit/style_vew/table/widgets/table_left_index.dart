import 'package:flutter/material.dart';

class TLeftIndex extends StatelessWidget {
  ///Builds elements for the table headers
  const TLeftIndex(
      {Key key,
      @required this.trHeight,
      @required this.index,}) :
        super(key: key);

  final double trHeight;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
                    color: Colors.grey,
                    width: 0.5))),
        height: trHeight,
        width: 20,
        child: Text('${index + 1}',
          style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
