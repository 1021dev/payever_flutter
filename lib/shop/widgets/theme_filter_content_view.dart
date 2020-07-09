import 'package:flutter/material.dart';

class ThemeFilterContentView extends StatelessWidget {
  final int selectedIndex;
  final Function onSelected;

  ThemeFilterContentView({this.selectedIndex, this.onSelected});

  @override
  Widget build(BuildContext context) {
    print(selectedIndex);
    return Container(
      height: 164,
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
              color: Color(0xFF222222),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 30,),
                  Text(
                    'Filter:',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: (){
                    onSelected(0);
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        alignment: Alignment.center,
                        child: selectedIndex == 0 ? Icon(
                          Icons.check,
                          color: Color(0xFFAAAAAA),
                        ) : Container(),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        height: 30,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'All themes',
                          style: TextStyle(
                            color: Color(0xFFAAAAAA),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: (){
                    onSelected(1);
                  },
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 24,
                        child: selectedIndex == 1 ? Icon(
                          Icons.check,
                          color: Color(0xFFAAAAAA),
                        ) : Container(),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        height: 30,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Own themes',
                          style: TextStyle(
                            color: Color(0xFFAAAAAA),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
