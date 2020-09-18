import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/workshop/subview/instant_payment_view.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/app_style.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/connect/models/connect.dart';

class PaymentOptionCell extends StatefulWidget {
  final Payment payment;
  final bool isSelected;
  final ChannelSetFlow channelSetFlow;
  final Function onTapChangePayment;

  const PaymentOptionCell(
      {this.payment, this.isSelected = false, this.onTapChangePayment, this.channelSetFlow});

  @override
  _PaymentOptionCellState createState() => _PaymentOptionCellState();
}

class _PaymentOptionCellState extends State<PaymentOptionCell> {
  @override
  Widget build(BuildContext context) {
    BillingAddress billingAddress = widget.channelSetFlow.billingAddress;
    String name = '';
    if (billingAddress != null) {
      name = '${billingAddress.firstName ?? ''} ${billingAddress.lastName ?? ''}';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            child: Row(
              children: [
                IconButton(
                    onPressed: () => widget.onTapChangePayment(widget.payment.id),
                    icon: Icon(
                      widget.isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: Colors.black54,
                    )),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    widget.payment.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                paymentType(widget.payment.paymentMethod)
              ],
            ),
          ),
          InstantPaymentView(
            isSelected: true,
            name: name,
          ),
        ],
      ),
    );
  }

  Widget paymentType(String type) {
    double size = AppStyle.iconRowSize(false);
    return SvgPicture.asset(
      Measurements.paymentType(type),
      height: size,
      color: Colors.red,
    );
  }

// <span>By clicking on the button below you initiate a transfer of your personal data to Santander Consumer Bank AG for the purpose of carrying out the payment.
// For more information, see the Santander <a target="_blank" href="https://www.santander.de/static/datenschutzhinweise/direktueberweisung/">data policy</a> for Santander instant payments. With ticking this box, the customer agrees to receive
// <a target="_blank" href="https://www.santander.de/static/datenschutzhinweise/rechnungskauf/werbehinweise.html">marketing communication</a> from Santander. This consent is voluntary and may be revoked at any time.</span>

// <span>By clicking on the button below, personal data will be transmitted to Santander Consumer Bank AG for the purpose of reviewing creditworthiness - more information about this can be found in the <a target="_blank" href="https://www.santander.de/static/datenschutzhinweise/rechnungskauf/datenschutzhinweise.html"><u>data protection policy</u></a>. The customer agrees to receive <a href="communication"><u>marketing communication</u></a> by Santander. This voluntary consent can be revoked at any time.</span>
}
