import 'package:flutter/material.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  final Future future;
  final Widget loadingWidget;
  final String errorMessage;
  final Function(T results) onDataLoaded;

  const CustomFutureBuilder(
      {Key key,
      @required this.future,
      this.loadingWidget,
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

          return loadingWidget != null ? loadingWidget : Center(child: Padding(
            padding: EdgeInsets.all(10),
            child: CircularProgressIndicator(),
          ));
        });
  }
}
