import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChannelsInitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChannelsScreen();
  }
}

class ChannelsScreen extends StatefulWidget {
  @override
  _ChannelsScreenState createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  List<String> titles = [
    'Pay by Link',
    'Text Link',
    'Button',
    'Calculator',
    'Bubble',
    'Point of Sale',
    'Shop'
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
                        SvgPicture.asset('assets/images/grid.svg', width: 20, height: 20,),
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
                alignment: Alignment.centerLeft,
                height: 65,
                child: MaterialButton(
                  onPressed: () {},
                  child: Text(
                    '+ Add',
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