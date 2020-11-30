import 'package:flutter/material.dart';

class ProductsStyleView extends StatefulWidget {
  final Function onChangeGridColumn;
  final Function onChangeGaps;

  const ProductsStyleView({this.onChangeGridColumn, this.onChangeGaps});

  @override
  _ProductsStyleViewState createState() => _ProductsStyleViewState();
}

class _ProductsStyleViewState extends State<ProductsStyleView> {
  double gapColumn = 15.0; double gapRow = 15.0;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return productsBody;
  }

  Widget get productsBody {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            height: 60,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color.fromRGBO(46, 45, 50, 1),
            ),
            child: Text(
              'Add product',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16),
          height: 60,
          child: Row(
            children: [
              Text(
                'Products grid',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              SizedBox(
                width: 10,
              ),
              // Expanded(
              //   child: Slider(
              //     value: borderRadius,
              //     min: 0,
              //     max: 3,
              //     onChanged: (double value) =>
              //         widget.onUpdateBorderRadius(value, false),
              //     onChangeEnd: (double value) =>
              //         widget.onUpdateBorderRadius(value, true),
              //   ),
              // ),
              // Container(
              //   width: 50,
              //   alignment: Alignment.center,
              //   child: Text(
              //     '${borderRadius.toInt()} px',
              //     style: TextStyle(color: Colors.white, fontSize: 15),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );


  }

  _updateGaps() {
    widget.onChangeGaps({'columnGap': gapColumn, 'rowGap': gapRow});
  }

}
