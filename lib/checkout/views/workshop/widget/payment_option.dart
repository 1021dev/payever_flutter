import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/workshop/subview/instant_payment_view.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/app_style.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/theme.dart';

class PaymentOptionCell extends StatefulWidget {
  final CheckoutPaymentOption payment;
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: iconColor()),
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
                    ),
                  ),
                ),
                paymentType(widget.payment.paymentMethod),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
          _expandedView,
        ],
      ),
    );
  }

  get _expandedView {
    BillingAddress billingAddress = widget.channelSetFlow.billingAddress;
    String name = '';
    if (billingAddress != null) {
      name =
      '${billingAddress.firstName ?? ''} ${billingAddress.lastName ?? ''}';
      if (name == ' ') name = '';
    }
    if (widget.payment.paymentMethod.contains('instant')) {
      return InstantPaymentView(
        isSelected: widget.isSelected,
        isSantander: false,
        name: name,
      );
    } else if (widget.payment.paymentMethod.contains('santander')) {
      return InstantPaymentView(
        isSelected: widget.isSelected,
        isSantander: true,
        name: name,
      );
    } else {
      return Container();
    }
  }

  Widget paymentType(String type) {
    double size = AppStyle.iconRowSize(false);
    return SvgPicture.asset(
      Measurements.paymentType(type),
      height: size,
      color: Colors.red,
    );
  }
}
