import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/checkout/widgets/checkout_top_button.dart';

class WorkShopInitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WorkshopScreen();
  }
}

class WorkshopScreen extends StatefulWidget {
  @override
  _WorkshopScreenState createState() => _WorkshopScreenState();
}

class _WorkshopScreenState extends State<WorkshopScreen> {
  bool openAdditional = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_topBar(), Expanded(child: _body())],
    );
  }

  Widget _topBar() {
    return Container(
      height: 50,
      color: Colors.black87,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Text(
            'Your checkout',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Spacer(),
          InkWell(
            onTap: () {},
            child: Container(
              height: 30,
              width: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: Center(
                child: Text(
                  'Open',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: PopupMenuButton<CheckOutPopupButton>(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.more_horiz,
                ),
              ),
              offset: Offset(0, 100),
              onSelected: (CheckOutPopupButton item) => item.onTap(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.black87,
              itemBuilder: (BuildContext context) {
                return _morePopup(context).map((CheckOutPopupButton item) {
                  return PopupMenuItem<CheckOutPopupButton>(
                    value: item,
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/images/payeverlogo.svg',
                      color: Colors.black,
                      height: 24,
                      width: 24,
                    ),
                    Text(
                      'Payever',
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                    Spacer(),
                    OutlineButton(
                      child: Text(
                        'Switch Checkout',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      onPressed: () {}, //callback when button is clicked
                      borderSide: BorderSide(
                        color: Colors.black54, //Color of the border
                        style: BorderStyle.solid, //Style of the border
                        width: 0.8, //width of the border
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 2,
                color: Colors.black26,
              ),
              Expanded(
                  child: Column(
                children: <Widget>[
                  Container(
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'BESTELLUNG',
                          style: TextStyle(color: Colors.black38, fontSize: 16),
                        ),
                        Spacer(),
                        IconButton(
                            icon: Icon(
                              openAdditional
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.black38,
                            ),
                            onPressed: () {
                              setState(() {
                                openAdditional = !openAdditional;
                              });
                            })
                      ],
                    ),
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  List<CheckOutPopupButton> _morePopup(BuildContext context) {
    return [
      CheckOutPopupButton(
        title: 'Copy pay link',
        onTap: () async {
          setState(() {});
        },
      ),
      CheckOutPopupButton(
        title: 'Copy prefilled link',
        onTap: () async {
          setState(() {});
        },
      ),
      CheckOutPopupButton(
        title: 'E-mail prefilled link',
        onTap: () async {
          setState(() {});
        },
      ),
      CheckOutPopupButton(
        title: 'Prefilled QR code',
        onTap: () async {
          setState(() {});
        },
      ),
    ];
  }
}
