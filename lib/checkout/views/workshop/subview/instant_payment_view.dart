import 'package:flutter/material.dart';
import 'package:super_rich_text/super_rich_text.dart';

class InstantPaymentView extends StatefulWidget {

  final bool isSelected;
  final String name;
  final String iban;
  final Function onChangedName;
  final Function onChangedIban;

  InstantPaymentView({this.isSelected, this.name, this.iban, this.onChangedName, this.onChangedIban});

  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;

  @override
  _InstantPaymentViewState createState() => _InstantPaymentViewState();
}

class _InstantPaymentViewState extends State<InstantPaymentView> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isSelected) {
      return Container();
    }
    return Form(
      key: widget._formKey,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 4, right: 4),
              alignment: Alignment.center,
              child: TextFormField(
                style: TextStyle(
                  fontSize: 16,
                  color:Colors.black,
                  fontWeight: FontWeight.w400,
                ),
                onChanged: (val) => widget.onChangedName(val),
                initialValue: widget.name,
                validator: (text) {
                  if (text.isEmpty){
                    return 'name required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Account holder',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 0.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Divider(height: 1,color: Colors.black54,),
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 4, right: 4),
              alignment: Alignment.center,
              child: TextFormField(
                style: TextStyle(
                  fontSize: 16,
                  color:Colors.black,
                  fontWeight: FontWeight.w400,
                ),
                onChanged: (val) => widget.onChangedIban(val),
                initialValue: widget.iban,
                validator: (text) {
                  if (text.isEmpty){
                    return 'IBAN required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'IBAN',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 0.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: (){
                      setState(() {
                        widget.isChecked = !widget.isChecked;
                      });
                    },
                    icon: Icon(widget.isChecked ? Icons.check_box : Icons.check_box_outline_blank),
                  ),
                  Expanded(
                    child: SuperRichText(
                      text:
                      'By clicking on the button below you initiate a transfer of your personal data to Santander Consumer Bank AG for the purpose of carrying out the payment. For more information, see the Santander &&data policy&& for Santander instant payments. With ticking this box, the customer agrees to receive&&marketing communication&& from Santander. This consent is voluntary and may be revoked at any time.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      othersMarkers: [
                        MarkerText.withUrl(
                            marker: '&&',
                            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                            urls: ['https://www.santander.de/static/datenschutzhinweise/direktueberweisung/',
                              'https://www.santander.de/static/datenschutzhinweise/rechnungskauf/werbehinweise.html']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
