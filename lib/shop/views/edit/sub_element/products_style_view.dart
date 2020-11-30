import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

class ProductsStyleView extends StatefulWidget {
  final Function onChangeGridColumn;
  final Function onChangeGaps;
  final ShopProductsStyles styles;

  const ProductsStyleView({this.styles, this.onChangeGridColumn, this.onChangeGaps});

  @override
  _ProductsStyleViewState createState() => _ProductsStyleViewState();
}

class _ProductsStyleViewState extends State<ProductsStyleView> {

  double gapColumn = 15.0;
  double gapRow = 15.0;
  num column = 1;

  @override
  void initState() {
    gapColumn = widget.styles.columnGap.toDouble();
    gapRow = widget.styles.rowGap.toDouble();
    if (gapColumn > 15) gapColumn = 15;
    if (gapRow > 15) gapRow = 15;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return productsBody;
  }

  Widget get productsBody {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color.fromRGBO(46, 45, 50, 1),
                ),
                child: Text(
                  'Add product',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            SizedBox(height: 26,),
            Divider(
              height: 0,
              thickness: 0.5,
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
                  Expanded(
                    child: Slider(
                      value: column.toDouble(),
                      min: 0,
                      max: 3,
                      onChanged: (double value) => column,
                    ),
                  ),
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      '${column.toInt()}',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16,),
            Divider(
              height: 0,
              thickness: 0.5,
            ),
            SizedBox(height: 16,),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: Text(
                      'Products gaps',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16),
                    height: 60,
                    child: Row(
                      children: [
                        Text(
                          'Gaps',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Slider(
                            value: gapColumn.toDouble(),
                            min: 0,
                            max: 15,
                            onChanged: (double value) {
                              setState(() {
                                gapColumn = value;
                                _updateGaps(false);
                              });
                            },
                            onChangeEnd: (double value){
                              setState(() {
                                gapColumn = value;
                                _updateGaps(true);
                              });
                            }
                          ),
                        ),
                        Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(
                            '${gapColumn.toInt()}  px',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16),
                    height: 60,
                    child: Row(
                      children: [
                        Text(
                          'Row',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Slider(
                              value: gapRow.toDouble(),
                              min: 0,
                              max: 15,
                              onChanged: (double value) {
                                setState(() {
                                  gapRow = value;
                                  _updateGaps(false);
                                });
                              },
                              onChangeEnd: (double value){
                                setState(() {
                                  gapRow = value;
                                  _updateGaps(true);
                                });
                              }
                          ),
                        ),
                        Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(
                            '${gapRow.toInt()} px',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _updateGaps(bool updateApi) {
    widget.onChangeGaps({'columnGap': gapColumn.floor(), 'rowGap': gapRow.floor()}, updateApi);
  }

}
