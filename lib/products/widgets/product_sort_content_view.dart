import 'package:flutter/material.dart';
import 'package:payever/transactions/models/enums.dart';

class ProductSortContentView extends StatelessWidget {
  final String selectedIndex;
  final Function onSelected;

  ProductSortContentView({this.selectedIndex, this.onSelected});

  @override
  Widget build(BuildContext context) {
    print(selectedIndex);
    return Container(
      height: 380,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
          color: Color(0xFF222222),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              'Sort by:',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (){
                    onSelected(sortProducts.keys.toList()[index]);
                  },
                  title: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 8),
                        width: 24,
                        alignment: Alignment.center,
                        child: selectedIndex != sortProducts.keys.toList()[index] ? Container() : Icon(
                          Icons.check,
                          color: Color(0xFFAAAAAA),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                      ),
                      Text(
                        sortProducts[sortProducts.keys.toList()[index]],
                        style: TextStyle(
                          color: Color(0xFFAAAAAA),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Colors.transparent,
                );
              },
              itemCount: sortProducts.keys.toList().length,
            ),
          ),
        ],
      ),
    );
  }
}
