import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/widget/background_view.dart';
import 'package:payever/shop/views/edit/element/widget/dashed_decoration_view.dart';
import 'package:payever/theme.dart';

class RowBuilder extends StatefulWidget {
  ///Builds row elements for the table
  /// its properties are not nullable
  const RowBuilder({
    Key key,
    @required this.baseStyles,
    @required this.enableEdit,
    @required this.tdAlignment,
    @required this.tdVerticalAlignment,
    @required this.textWrap,
    @required this.tdStyle,

    @required this.trWidth,
    @required this.trHeight,

    @required this.columnCount,
    @required this.rowCount,

    @required this.fillColor,
    @required this.headerColumnColor,
    @required this.headerRowColor,
    @required this.footerRowColor,

    @required this.cellData,
    @required this.column,

    @required this.rowIndex,
    @required this.col,
    @required this.onSubmitted,
    @required this.onChanged,

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
    @required this.footerRowLines,

    @required this.outline,
    this.tableBorder,
    this.borderModel
  })  : super(key: key);

  final BaseStyles baseStyles;
  /// Table row height
  final double trWidth;
  final double trHeight;
  final String fillColor;
  final Color headerColumnColor;
  final Color headerRowColor;
  final Color footerRowColor;
  final cellData;
  /// Text Style
  final bool enableEdit;
  final TextAlign tdAlignment;
  final Alignment tdVerticalAlignment;
  final TextStyle tdStyle;
  final bool textWrap;
  /// Table RowCount
  final int rowCount;
  final int columnCount;
  final int rowIndex; /// row Index
  final int column;
  final col;
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
  final bool footerRowLines;
  /// Out Lines
  final bool outline;
  /// Borders
  final TableBorder tableBorder;
  final BorderModel borderModel;

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
      child: DashedDecorationView(
        borderModel: widget.borderModel,
        child: Container(
          height: widget.trHeight,
          width: widget.trWidth,
          alignment: widget.tdVerticalAlignment,
          decoration: BoxDecoration(
              color: backgroundColor,
              border: border),
          child: Stack(
            children: [
              if (hasBackground)
                BackgroundView(styles: widget.baseStyles,),
              TextFormField(
                textAlign: widget.tdAlignment,
                style: widget.tdStyle,
                initialValue: widget.cellData.toString(),
                onFieldSubmitted: widget.onSubmitted,
                onChanged: widget.onChanged,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: widget.textWrap ? TextInputType.multiline : null,
                maxLines: widget.textWrap ? null : 1,
                enabled: widget.enableEdit,
                decoration: InputDecoration(
                    isDense: true,
                    filled: widget.zebraStripe,
                    fillColor: backgroundColor,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get hasBackground {
    BaseStyles styles = widget.baseStyles;
    return (styles.backgroundColor != null && styles.backgroundColor.isNotEmpty) || (styles.backgroundImage != null && styles.backgroundImage.isNotEmpty);
  }

  Color get backgroundColor {
    if (widget.fillColor != null && widget.fillColor.isNotEmpty)
      return colorConvert(widget.fillColor);

    Color bgColor;
    if (isHeader) {
      bgColor = widget.headerRowColor;
    } else if (isFooter) {
      bgColor = widget.footerRowColor;
    } else if (isHeaderLeft) {
      bgColor = widget.headerColumnColor;
    } else {
      if (widget.zebraStripe) {
        bgColor = widget.rowIndex % 2 == 1.0
            ? widget.stripeColor2
            : widget.stripeColor1;
      } else {
        bgColor = widget.stripeColor1;
      }
    }
    if (widget.headerColumnColor == Colors.white && widget.headerRowColor == Colors.white)
      bgColor = widget.rowIndex % 2 == 1.0
          ? widget.stripeColor2
          : widget.stripeColor1;

    return bgColor;
  }

  Border get border {
    if (widget.borderModel == null || widget.borderModel.borderStyle != 'solid') return null;
    BorderSide borderSide = BorderSide(
        color: colorConvert(widget.borderModel.borderColor), width: widget.borderModel.borderWidth);
    BorderSide top = BorderSide.none;
    BorderSide bottom = BorderSide.none;
    BorderSide right = BorderSide.none;
    BorderSide left = BorderSide.none;

    if (isTop && widget.outline) top = borderSide;
    if (isLeft && widget.outline) left = borderSide;
    if (isRight && widget.outline) right = borderSide;
    if (isBottom && widget.outline) bottom = borderSide;

    if (isHeader) {
      if (widget.headerRowLines) right = borderSide;
      // if (widget.headerColumnLines) bottom = borderSide;
      if (widget.headerRowLines && widget.rowIndex == widget.headerRows -1 )
        bottom = borderSide;
    } else if (isFooter) {
      if (widget.footerRowLines) right = borderSide;
      // if (widget.headerColumnLines) bottom = borderSide;
    } else if (isHeaderLeft) {
      if (widget.headerColumnLines) bottom = borderSide;
      // if (widget.headerRowLines) right = borderSide;
      if (widget.headerColumnLines && widget.column == widget.headerColumns -1)
        right = borderSide;
    } else {
      if (widget.verticalLines) right = borderSide;
      if (widget.horizontalLines) bottom = borderSide;
      if (widget.footerRowLines && widget.rowIndex == widget.rowCount - widget.footerRows -1)
        bottom = borderSide;
    }
    return Border(bottom: bottom, right: right, top: top, left: left);
  }

  bool get isHeader {
    return widget.rowIndex < widget.headerRows;
  }

  bool get isHeaderLeft {
    return widget.column < widget.headerColumns;
  }

  bool get isFooter {
    return widget.rowIndex >= widget.rowCount - widget.footerRows;
  }

  bool get isTop {
    return widget.rowIndex == 0;
  }

  bool get isLeft {
    return widget.column == 0;
  }

  bool get isBottom {
    return widget.rowIndex == widget.rowCount - 1;
  }

  bool get isRight {
    return widget.column == widget.columnCount -1;
  }

}
