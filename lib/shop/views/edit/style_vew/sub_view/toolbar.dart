import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Toolbar extends StatefulWidget {

  final String backTitle;
  final String title;
  final Function onClose;

  const Toolbar({@required this.backTitle, @required this.title, @required this.onClose});

  @override
  _ToolbarState createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.blue,
                  ),
                  Flexible(
                    child: Text(
                      widget.backTitle,
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
              child: Text(
                widget.title,
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              )),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                SizedBox(width: 16,),
                Spacer(),
                InkWell(
                  onTap: () {
                    widget.onClose();
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
            ),
          )
        ],
      ),
    );
  }
}
