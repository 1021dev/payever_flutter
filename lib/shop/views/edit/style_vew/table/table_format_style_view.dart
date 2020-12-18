import 'package:flutter/material.dart';
import 'package:payever/shop/views/edit/style_vew/style_container.dart';

class TableFormatStyleView extends StatefulWidget {
  @override
  _TableFormatStyleViewState createState() => _TableFormatStyleViewState();
}

class _TableFormatStyleViewState extends State<TableFormatStyleView> {
  List<String>formats = ['Automatic', 'Number', 'Currency', 'Percentage', 'Date & Time', 'Duration', 'Text', ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return StyleContainer(
      child: ListView.separated(
          itemBuilder: (context, index) => _formatItem(index),
          separatorBuilder: (context, index) => Divider(
                height: 0,
                thickness: 0.5,
              ),
          itemCount: formats.length),
    );
  }

  Widget _formatItem(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        height: 50,
        child: Row(
          children: [
            Opacity(
                opacity: selectedIndex == index ? 1 : 0,
                child: Icon(
                  Icons.check,
                  color: Colors.blue,
                )),
            SizedBox(
              width: 16,
            ),
            Expanded(
                child: Text(
              formats[index],
              style: TextStyle(color: Colors.white, fontSize: 15),
            )),
            Opacity(
                opacity: (index == 0 || index == 6) ? 0 : 1,
                child: InkWell(child: Icon(Icons.info_outline, color: Colors.blue))),
          ],
        ),
      ),
    );
  }
}
