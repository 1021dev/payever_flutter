import 'package:flutter/material.dart';

class SectionsInitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionsScreen();
  }
}

class SectionsScreen extends StatefulWidget {
  @override
  _SectionsScreenState createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  List<String> titles = [
    'Step 1',
    'Step 2',
    'Step 3',
  ];
  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    height: 65,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 16,),
                        Text(
                          titles[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 28,
                            width: 65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black54,
                            ),
                            child: Center(
                              child: Text(
                                'Open',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  );
                },
                itemCount: titles.length,
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    color: Colors.grey,
                  );
                },
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              Container(
                height: 65,
                color: Colors.black87,
                child: MaterialButton(
                  onPressed: () {},
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

