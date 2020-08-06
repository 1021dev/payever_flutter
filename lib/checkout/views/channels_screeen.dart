import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/checkout/checkout_bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';

class ChannelsScreen extends StatefulWidget {
  final CheckoutScreenBloc checkoutScreenBloc;

  ChannelsScreen({this.checkoutScreenBloc});

  @override
  _ChannelsScreenState createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  List<String> subTitles = [
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

    List<ChannelItem> items = [];
    List<String> titles = [];
    List<ChannelSet> list = [];
    list.addAll(widget.checkoutScreenBloc.state.channelSets);
//    List<ChannelSet> filterList = list.where((element) => element.checkout == widget.checkoutScreenBloc.state.defaultCheckout.id).toList();
    for(ChannelSet channelSet in list) {
      if (!titles.contains(channelSet.type)) {
        titles.add(channelSet.type);
      }
    }
    
    if (titles.contains('link')) {
      ChannelItem item = new ChannelItem(
        title: 'Pay by Link',
        button: 'Open',
        checkValue: null,
        image: SvgPicture.asset('assets/images/linkicon.svg')
      );
      items.add(item);
    }
    if (titles.contains('finance_express')) {
      ChannelItem item = new ChannelItem(
          title: 'Pay by Link',
          button: 'Open',
          checkValue: null,
          image: SvgPicture.asset('assets/images/linkicon.svg')
      );
      items.add(item);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SingleChildScrollView(
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
      ),
    );
  }
}

class ChannelItem {
  String title;
  SvgPicture image;
  String button;
  bool checkValue;
  
  ChannelItem({this.title, this.image, this.button, this.checkValue,});
}