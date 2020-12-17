import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/widgets/main_app_bar.dart';

import '../../../../../theme.dart';

class ConditionalHighlightView extends StatefulWidget {
  @override
  _ConditionalHighlightViewState createState() => _ConditionalHighlightViewState();
}

class _ConditionalHighlightViewState extends State<ConditionalHighlightView> {

  int selectedItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppbar(title: 'Choose a Rule',),
        backgroundColor: Colors.grey[800],
        body: SafeArea(bottom: false, child: _body()));
  }

  Widget _body() {
    return Column(
      children: [
        _secondAppbar(),
        _gridViewBody(),
      ],
    );
  }

  Widget get mainBody {
    return SingleChildScrollView(
      child: ,
    )
  }

  Widget _secondAppbar() {
    return Container(
      height: 50,
      color: overlaySecondAppBar(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            SizedBox(width: 16),
            Row(
              children: ruleTitles.map((e) {
                int idx = ruleTitles.indexOf(e);
                return _secondAppBarItem(e, idx);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secondAppBarItem(String title, int index) {
    bool isSelected = selectedItemIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          selectedItemIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: isSelected
            ? BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        )
            : null,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.blue,
          ),
        ),
      ),
    );
  }
}
