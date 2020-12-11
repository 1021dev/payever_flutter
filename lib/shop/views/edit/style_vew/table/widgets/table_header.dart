import 'package:flutter/material.dart';

class THeader extends StatelessWidget {
  ///Builds elements for the table headers
  const THeader(
      {Key key,
      @required this.trWidth,
      @required List headers,
      @required FontWeight thWeight,
      @required double thSize,
      @required double widthRatio,
      @required int index})
      : _headers = headers,
        _thWeight = thWeight,
        _thSize = thSize,
        _index = index,
        super(key: key);

  final List _headers;
  final FontWeight _thWeight;
  final double trWidth;
  final double _thSize;
  final int _index;

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
        height: 20,
        width: trWidth,
        child: Text(
          _headers != null || _headers.isNotEmpty
              ? _headers[_index]['title']
              : '',
          style: TextStyle(fontWeight: _thWeight, fontSize: _thSize, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
