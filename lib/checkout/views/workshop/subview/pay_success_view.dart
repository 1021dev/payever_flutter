import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';

import '../../../../theme.dart';

class PaySuccessView extends StatefulWidget {
  final ChannelSetFlow channelSetFlow;

  PaySuccessView({this.channelSetFlow});
  @override
  _PaySuccessViewState createState() => _PaySuccessViewState(payment:this.channelSetFlow.payment);
}

class _PaySuccessViewState extends State<PaySuccessView> {
  final Payment payment;
  PaymentDetails paymentDetails;

  _PaySuccessViewState({this.payment}){
    if (payment != null) {
      paymentDetails = payment.paymentDetails;
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (payment == null || paymentDetails == null)
    //   return Container();

    NumberFormat format = NumberFormat();
    String currency = format.simpleCurrencySymbol(widget.channelSetFlow.currency);
    DateTime paymentDate = DateTime.parse(payment.createdAt);
    String paymentDataStr = formatDate(paymentDate, [dd, '.', MM, '.', yyyy, hh, ':' , mm, ':', ss]);

    return Center(
      child: BlurEffectView(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              GestureDetector(
                onTap: (){Navigator.pop(context);},
                  child: Icon(Icons.check, size: 30,)),
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              Text(
                'Thank you! Your order has been placed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Text('Total', style: TextStyle(fontSize: 16),),
                        ),
                        Text('$currency${widget.channelSetFlow.total.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: _divider,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Text('Recipient', style: TextStyle(fontSize: 16),),
                        ),
                        Text(paymentDetails.merchantBankAccountHolder, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Text('Name of the bank', style: TextStyle(fontSize: 16),),
                        ),
                        Text(paymentDetails.merchantBankName, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Text('City of the bank', style: TextStyle(fontSize: 16),),
                        ),
                        Text(paymentDetails.merchantBankCity, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Text('IBAN', style: TextStyle(fontSize: 16),),
                        ),
                        Text(payment.bankAccount.iban, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Text('BIC', style: TextStyle(fontSize: 16),),
                        ),
                        Text(payment.bankAccount.bic, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: _divider,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Text(paymentDetails.merchantCompanyName, style: TextStyle(fontSize: 16),),
                  ),
                  Text(paymentDataStr, style: TextStyle(fontSize: 16)),
                ],
              ),
              Container(width: double.infinity, child: Text(widget.channelSetFlow.billingAddress.fullAddress, style: TextStyle(fontSize: 16))),
              SizedBox(height: 40,),
              Text('Reference', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text(widget.channelSetFlow.reference, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 30,),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 24,
                elevation: 0,
                minWidth: 0,
                color: overlayBackground(),
                child: Text(
                  Language.getSettingsStrings('actions.yes'),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  get _divider {
    return Divider(
      height: 0,
      thickness: 0.5,
      color: iconColor(),
    );
  }
}
