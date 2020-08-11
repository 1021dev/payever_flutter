import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'checkout_top_button.dart';

class WorkshopTopBar extends StatefulWidget {

  final CheckoutScreenBloc checkoutScreenBloc;
  String url;
  final Function onOpenTap;
  WorkshopTopBar({this.checkoutScreenBloc, this.url, this.onOpenTap});
  @override
  _WorkshopTopBarState createState() => _WorkshopTopBarState();
}

class _WorkshopTopBarState extends State<WorkshopTopBar> {
  @override
  Widget build(BuildContext context) {
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                widget.onOpenTap();
              },
              child: Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
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
            SizedBox(width: 10,),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: PopupMenuButton<CheckOutPopupButton>(
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.black,
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
                      child: Row(
                        children: <Widget>[
                          item.icon,
                          SizedBox(width: 8,),
                          Text(
                            item.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            SizedBox(width: 10,),
          ],
        ),
      );
  }

  List<CheckOutPopupButton> _morePopup(BuildContext context) {
    return [
      CheckOutPopupButton(
        title: 'Copy pay link',
        icon: SvgPicture.asset(
          'assets/images/pay_link.svg',
          width: 16,
          height: 16,
        ),
        onTap: () async {
          Clipboard.setData(new ClipboardData(text: widget.url));
          Fluttertoast.showToast(msg: 'Link successfully copied');
        },
      ),
      CheckOutPopupButton(
        title: 'Copy prefilled link',
        icon: SvgPicture.asset(
          'assets/images/prefilled_link.svg',
          width: 16,
          height: 16,
        ),
        onTap: () async {
        },
      ),
      CheckOutPopupButton(
        title: 'E-mail prefilled link',
        icon: SvgPicture.asset(
          'assets/images/email_link.svg',
          width: 16,
          height: 16,
        ),
        onTap: () async {
          _sendMail('', 'Pay by payever Link', 'Dear customer, \\n'
              '${widget.checkoutScreenBloc.dashboardScreenBloc.state.activeBusiness.name} would like to invite you to pay online via payever. Please click the link below in order to pay for your purchase at ${widget.checkoutScreenBloc.dashboardScreenBloc.state.activeBusiness.name}.\\n'
              '${widget.url}\\n'
              ' For any questions to ${widget.checkoutScreenBloc.dashboardScreenBloc.state.activeBusiness.name} regarding the purchase itself, please reply to this email, for technical questions or questions regarding your payment, please email support@payever.de.');
        },
      ),
      CheckOutPopupButton(
        title: 'Prefilled QR code',
        icon: SvgPicture.asset(
          'assets/images/prefilled_qr.svg',
          width: 16,
          height: 16,
        ),
        onTap: () async {
          setState(() {});
        },
      ),
    ];
  }

  _sendMail(String toMailId, String subject, String body) async {
    var url = Uri.encodeFull('mailto:$toMailId?subject=$subject&body=$body');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
