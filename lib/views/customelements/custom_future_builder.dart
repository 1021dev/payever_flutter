import 'package:flutter/material.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  final Future future;
  final String errorMessage;
  final Function(T results) onDataLoaded;

  const CustomFutureBuilder(
      {Key key,
      @required this.future,
      @required this.errorMessage,
      @required this.onDataLoaded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
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
