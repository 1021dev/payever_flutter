import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';

class FillView extends StatefulWidget {
  final List<Paragraph> paragraphs;
  final Paragraph selectedParagraph;
  final Function onUpdateParagraph;

  const FillView(
      {this.paragraphs,
      this.selectedParagraph,
      this.onUpdateParagraph});

  @override
  _FillViewState createState() => _FillViewState(selectedParagraph);
}

class _FillViewState extends State<FillView> {

  _FillViewState(this.selectedParagraph);

  bool isPortrait;
  bool isTablet;
  Paragraph selectedParagraph;
  int selectedItemIndex = 0;
  bool isEdit = false;
  List<String> fillTypes = [
    'Preset',
    'Color',
    'Gradient',
    'Image',
  ];

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
    return body();
  }

  Widget body() {
    return Container(
      height: 400,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Container(
            color: Color.fromRGBO(23, 23, 25, 1),
            padding: EdgeInsets.only(top: 18),
            child: Column(
              children: [
                _toolBar,
                _secondAppbar,
                SizedBox(
                  height: 10,
                ),
                Expanded(child: mainBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _toolBar {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blue,
                ),
                Text(
                  'Style',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                )
              ],
            ),
          ),
          Expanded(
              child: Text(
            'Fill',
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          )),
          Row(
            children: [
              SizedBox(width: 16,),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(46, 45, 50, 1),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.close, color: Colors.grey),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget get _secondAppbar {
    return Container(
      height: 50,
      child: Row(
        children: fillTypes.map((e) {
          int idx = fillTypes.indexOf(e);
          return _secondAppBarItem(e, idx);
        }).toList(),
      ),
    );
  }

  // Style Body
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

  Widget mainBody() {
    return Container(
      color: Colors.amber,
    );
  }
}
