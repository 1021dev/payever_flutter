import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/widget/background_view.dart';

class BlockView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  const BlockView(
      {this.child, this.stylesheets});

  @override
  _BlockViewState createState() => _BlockViewState();
}

class _BlockViewState extends State<BlockView> {

  SectionStyles blockStyles;
  final String TAG = 'BlockView : ';
  String selectChildId = '';

  _BlockViewState();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    blockStyles = getSectionStyleSheet();
    return body;
  }

  Widget get body {
    return Container(
        alignment: blockStyles.getBackgroundImageAlignment(),
        child: BackgroundView(styles: blockStyles));
  }


  SectionStyles getSectionStyleSheet() {
    try {
      Map<String, dynamic> json =
          widget.stylesheets;
      // print('$TAG Block ID ${block.id}');
      // print('$TAG Bloc style: $json');
      return SectionStyles.fromJson(json);
    } catch (e) {
      print('$TAG Error: ${e.toString()}');
      return null;
    }
  }
}
