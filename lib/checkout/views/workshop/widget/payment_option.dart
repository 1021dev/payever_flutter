import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/utils/app_style.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/connect/models/connect.dart';

class PaymentOptionCell extends StatefulWidget {
  final Payment payment;
  final bool isSelected;
  final Function onTapChangePayment;

  const PaymentOptionCell(
      {this.payment, this.isSelected = false, this.onTapChangePayment});

  @override
  _PaymentOptionCellState createState() => _PaymentOptionCellState();
}

class _PaymentOptionCellState extends State<PaymentOptionCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey),
      ),
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

}
