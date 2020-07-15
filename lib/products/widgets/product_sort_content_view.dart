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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Sort by:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: (){
                      onSelected(sortProducts.keys.toList()[index]);
                    },
                    title: Row(
                      children: <Widget>[
                        Container(
                          width: 24,
                          alignment: Alignment.center,
                          child: selectedIndex != sortProducts.keys.toList()[index] ? Container() : Icon(
                            Icons.check,
                            color: Color(0xFFAAAAAA),
                          ),
                        ),
                        Container(
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            sortProducts[sortProducts.keys.toList()[index]],
                            style: TextStyle(
                                color: Color(0xFFAAAAAA)
                            ),
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
                    color: Color(0x80888888),
                  );
                },
                itemCount: sortProducts.keys.toList().length,
              ),
            ],
          ),
    );
  }
}
