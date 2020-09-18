import 'package:flutter/material.dart';
import 'package:payever/checkout/views/workshop/widget/payment_option.dart';
import 'package:payever/checkout/widgets/workshop_header_item.dart';
import 'package:payever/connect/models/connect.dart';

class PaymentSelectView extends StatefulWidget {
  final bool enable;
  final bool approved;
  final bool expanded;
  final bool isUpdating;
  final Function onTapApprove;
  final Function onTapPay;
  final List<Payment> paymentOptions;
  final String paymentOptionId;

  const PaymentSelectView(
      {this.enable,
      this.approved,
      this.expanded,
      this.isUpdating,
      this.onTapApprove,
      this.onTapPay,
      this.paymentOptionId,
      this.paymentOptions});

  @override
  _PaymentSelectViewState createState() => _PaymentSelectViewState();
}

class _PaymentSelectViewState extends State<PaymentSelectView> {
  @override
  Widget build(BuildContext context) {
    if (!widget.enable ||
        widget.paymentOptions == null ||
        widget.paymentOptions.isEmpty) {
      return Container();
    }

    return Column(
      children: <Widget>[
        WorkshopHeader(
          title: 'SELECT PAYMENT',
          subTitle: 'Select a payment method',
          isExpanded: true /*widget.expanded*/,
          isApproved: widget.approved,
          onTap: () => widget.onTapApprove,
        ),
        Visibility(
          visible: true /*widget.expanded*/,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    Payment payment = widget.paymentOptions[index];
                    return PaymentOptionCell(
                      payment: payment,
                      isSelected: widget.paymentOptionId == '${payment.id}',
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 0,
                      height: 10,
                      color: Colors.transparent,
                    );
                  },
                  itemCount: widget.paymentOptions.length
              ),
              Container(
                height: 50,
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () => widget.onTapPay,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    color: Colors.black87,
                    child: widget.isUpdating
                        ? CircularProgressIndicator()
                        : Text(
                            'Next Step',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _paybuttonTitle() {
    
  }
}
