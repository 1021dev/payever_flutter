import 'package:flutter/material.dart';
import 'package:payever/theme.dart';

class RowBuilder extends StatefulWidget {
  ///Builds row elements for the table
  /// its properties are not nullable
  const RowBuilder({
    Key key,
    @required this.tdAlignment,
    @required this.tdStyle,
    @required this.trWidth,
    @required this.trHeight,
    @required this.rowCount,
    @required this.headerColumnColor,
    @required this.headerRowColor,
    @required this.footerRowColor,
    @required Color borderColor,
    @required double borderWidth,
    @required this.cellData,
    @required this.column,
    @required this.index,
    @required this.col,
    @required this.tdPaddingLeft,
    @required this.tdPaddingTop,
    @required this.tdPaddingBottom,
    @required this.tdPaddingRight,
    @required this.onSubmitted,
    @required this.onChanged,
    @required this.widthRatio,
    @required this.stripeColor1,
    @required this.stripeColor2,
    @required this.zebraStripe,
    @required this.headerRows,
    @required this.headerColumns,
    @required this.footerRows,
    @required this.horizontalLines,
    @required this.headerColumnLines,
    @required this.verticalLines,
    @required this.headerRowLines,
  })  : _borderColor = borderColor,
        _borderWidth = borderWidth,
        super(key: key);

  /// Table row height
  final double trWidth;
  final double trHeight;
  final Color headerColumnColor;
  final Color headerRowColor;
  final Color footerRowColor;
  final Color _borderColor;
  final double _borderWidth;
  final cellData;
  final double widthRatio;
  final TextAlign tdAlignment;
  final TextStyle tdStyle;
  /// Table RowCount
  final int rowCount;
  final int index; /// row Index
  final int column;
  final col;
  final double tdPaddingLeft;
  final double tdPaddingTop;
  final double tdPaddingBottom;
  final double tdPaddingRight;
  final Color stripeColor1;
  final Color stripeColor2;
  final bool zebraStripe;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;
  /// Header & Footer
  final int headerRows;
  final int headerColumns;
  final int footerRows;
  /// Grid Options
  final bool horizontalLines;
  final bool headerColumnLines;
  final bool verticalLines;
  final bool headerRowLines;

  @override
  _RowBuilderState createState() => _RowBuilderState();
}

class _RowBuilderState extends State<RowBuilder> {
  @override
  Widget build(BuildContext context) {
    // print('row index: ${widget.index} column:${widget.column}');
    // print('headerRows: ${widget.headerRows} headerColumn:${widget.headerColumns}');
    return Flexible(
      fit: FlexFit.loose,
      flex: 6,
      child: Container(
        height: widget.trHeight,
        width: widget.trWidth,
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
                color: widget._borderColor, width: widget._borderWidth)),
        child: TextFormField(
          textAlign: widget.tdAlignment,
          style: widget.tdStyle,
          initialValue: widget.cellData.toString(),
          onFieldSubmitted: widget.onSubmitted,
          onChanged: widget.onChanged,
          textAlignVertical: TextAlignVertical.center,
          // enabled: false,
          decoration: InputDecoration(
              filled: widget.zebraStripe,
              fillColor: backgroundColor,
              // fillColor: widget.index % 2 == 1.0
              //     ? widget.stripeColor2
              //     : widget.stripeColor1,
              contentPadding: EdgeInsets.only(
                  left: widget.tdPaddingLeft,
                  right: widget.tdPaddingRight,
                  top: widget.tdPaddingTop,
                  bottom: widget.tdPaddingBottom),
              border: InputBorder.none),
        ),
      ),
    );
  }

  Color get backgroundColor {
    Color bgColor;
    if (widget.index < widget.headerRows) {
      bgColor = widget.headerRowColor;
    } else if (widget.index >= widget.rowCount - widget.footerRows) {
      bgColor = widget.footerRowColor;
    } else if (widget.column < widget.headerColumns) {
      bgColor = widget.headerColumnColor;
    } else {
      if (widget.zebraStripe) {
        bgColor = widget.index % 2 == 1.0
            ? widget.stripeColor2
            : widget.stripeColor1;
      } else {
        bgColor = widget.stripeColor1;
      }
    }
    if (widget.headerColumnColor == Colors.white && widget.headerRowColor == Colors.white)
      bgColor = widget.index % 2 == 1.0
          ? widget.stripeColor2
          : widget.stripeColor1;

    return bgColor;
  }
}
