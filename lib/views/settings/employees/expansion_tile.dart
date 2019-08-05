import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:math';

//class ExpansionTileSample extends StatefulWidget {
//  @override
//  ExpansionTileSampleState createState() => new ExpansionTileSampleState();
//}
//
//class ExpansionTileSampleState extends State {
//  String foos = 'One';
//  int _key;
//
//  _collapse() {
//    int newKey;
//    do {
//      _key = new Random().nextInt(10000);
//    } while(newKey == _key);
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    _collapse();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      home: new Scaffold(
//        appBar: new AppBar(
//          title: const Text('ExpansionTile'),
//        ),
//        body: new ExpansionTile(
//            key: new Key(_key.toString()),
//            initiallyExpanded: false,
//            title: new Text(this.foos),
//            backgroundColor: Theme
//                .of(context)
//                .accentColor
//                .withOpacity(0.025),
//            children: [
//              new ListTile(
//                title: const Text('One'),
//                onTap: () {
//                  setState(() {
//                    this.foos = 'One';
//                    _collapse();
//                  });
//                },
//              ),
//              new ListTile(
//                title: const Text('Two'),
//                onTap: () {
//                  setState(() {
//                    this.foos = 'Two';
//                    _collapse();
//                  });
//                },
//              ),
//              new ListTile(
//                title: const Text('Three'),
//                onTap: () {
//                  setState(() {
//                    this.foos = 'Three';
//                    _collapse();
//                  });
//                },
//              ),
//            ]
//        ),
//      ),
//    );
//  }
//}


class ExpansionTileSample extends StatefulWidget {
  @override
  createState() => _ExpansionTileSampleState();
}

class _ExpansionTileSampleState extends State<ExpansionTileSample> {
  int _activeMeterIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView.builder(
          itemCount:  5,
          itemBuilder: (BuildContext context, int i) {
            return Card(
              margin:
              const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
              child: new ExpansionPanelList(
                expansionCallback: (int index, bool status) {
                  setState(() {
                    _activeMeterIndex = _activeMeterIndex == i ? null : i;
                  });
                },
                children: [
                  new ExpansionPanel(
                    isExpanded: _activeMeterIndex == i,
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context,
                        bool isExpanded) =>
                    new Container(
                        padding:
                        const EdgeInsets.only(left: 15.0),
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          'list-$i',
                        )),
                    body: new Container(child: new Text('content-$i'),),),
                ],
              ),
            );
          }),
    );
  }
}