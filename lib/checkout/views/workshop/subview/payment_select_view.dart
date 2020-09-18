import 'package:flutter/material.dart';
import 'package:payever/checkout/widgets/workshop_header_item.dart';
import 'package:payever/commons/utils/translations.dart';

class PaymentSelectView extends StatefulWidget {
  final bool enable;
  final bool approved;
  final bool isUpdating;
  final Function onTapApprove;
  final Function onTapPay;

  const PaymentSelectView(
      {this.enable, this.approved, this.isUpdating, this.onTapApprove, this.onTapPay});

  @override
  _PaymentSelectViewState createState() => _PaymentSelectViewState();
}

class _PaymentSelectViewState extends State<PaymentSelectView> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.enable,
      child: Column(
        children: <Widget>[
          WorkshopHeader(
            title: 'SELECT PAYMENT',
            subTitle: 'Select a payment method',
            // isExpanded: _selectedSectionIndex == 3,
            isExpanded: true,
            isApproved: widget.approved,
            onTap: () => widget.onTapApprove,
          ),
          Visibility(
            // visible: _selectedSectionIndex == 3,
            visible: true,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 16,
                            color:Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                          onChanged: (val) {
                          },
                          initialValue: '',
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 16, right: 16),
                            labelText: 'Mobile number',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            enabledBorder: InputBorder.none,
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Divider(height: 1,color: Colors.black54,),
                      Container(
                        height: 50,
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 16,
                            color:Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                          onChanged: (val) {
                          },
                          initialValue: '',
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 16, right: 16),
                            labelText: 'E-Mail Address',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            enabledBorder: InputBorder.none,
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  child: SizedBox.expand(
                    child: MaterialButton(
                      onPressed: ()=> widget.onTapPay,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      color: Colors.black87,
                      child: widget.isUpdating ?
                      CircularProgressIndicator() :
                      Text(
                        Language.getCheckoutStrings('checkout_send_flow.action.continue'),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
