import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';

class TextStyleView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;

  const TextStyleView({this.screenBloc});

  @override
  _TextStyleViewState createState() => _TextStyleViewState();
}

class _TextStyleViewState extends State<TextStyleView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      color: Colors.grey[800],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: CupertinoSegmentedControl(
                  children: const <int, Widget>{
                    0: Padding(
                        padding: EdgeInsets.all(8.0), child: Text('Style')),
                    1: Padding(
                        padding: EdgeInsets.all(8.0), child: Text('Text')),
                    2: Padding(
                        padding: EdgeInsets.all(8.0), child: Text('Arrange'))
                  },
                  onValueChanged: (value) {
                    setState(() {});
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
