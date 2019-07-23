import 'package:flutter/material.dart';

class CustomFutureBuilder extends StatelessWidget {
  final Future future;
  final String errorMessage;
  final Function(dynamic results) onDataLoaded;

  const CustomFutureBuilder(
      {Key key,
      @required this.future,
      @required this.errorMessage,
      @required this.onDataLoaded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return onDataLoaded(snapshot.data);
          }
          if (snapshot.hasError) {
            return Center(child: Text(errorMessage));
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}
