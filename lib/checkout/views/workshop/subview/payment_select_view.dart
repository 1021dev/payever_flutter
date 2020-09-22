import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/workshop/widget/payment_option.dart';
import 'package:payever/checkout/widgets/workshop_header_item.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/theme.dart';

class PaymentSelectView extends StatefulWidget {
  final bool enable;
  final bool approved;
  final bool expanded;
  final bool isUpdating;
  final Function onTapApprove;
  final Function onTapChangePayment;
  final Function onTapPay;
  final ChannelSetFlow channelSetFlow;

  const PaymentSelectView(
      {this.enable,
      this.approved,
      this.expanded,
      this.isUpdating,
      this.onTapApprove,
      this.onTapPay,
      this.channelSetFlow,
      this.onTapChangePayment});

  @override
  _PaymentSelectViewState createState() => _PaymentSelectViewState();
}

class _PaymentSelectViewState extends State<PaymentSelectView> {
  // final ChannelSetFlow channelSetFlow;
  // List<CheckoutPaymentOption> paymentOptions;
  // num paymentOptionId;
  //
  // _PaymentSelectViewState({this.channelSetFlow}){
  //   paymentOptions = channelSetFlow.paymentOptions;
  //   paymentOptionId = channelSetFlow.paymentOptionId;
  // }

  @override
  Widget build(BuildContext context) {
    List<CheckoutPaymentOption> paymentOptions;
    num paymentOptionId;
    paymentOptions = widget.channelSetFlow.paymentOptions;
    paymentOptionId = widget.channelSetFlow.paymentOptionId;
    if (!widget.enable || paymentOptions == null || paymentOptions.isEmpty) {
      return Container();
    }
    String payBtnTitle, paymentMethod;
    List<CheckoutPaymentOption>payments = paymentOptions.where((element) => element.id == paymentOptionId).toList();

    if (payments == null || payments.isEmpty) {
      payBtnTitle = 'Continue';
    } else {
      paymentMethod = payments.first.paymentMethod;
      if (paymentMethod == null) {
        payBtnTitle = 'Continue';
      } else if (paymentMethod.contains('santander')) {
        payBtnTitle =
        'Buy now for ${Measurements.currency(widget.channelSetFlow.currency)}${widget.channelSetFlow.amount}';
      } else if (paymentMethod.contains('cash')) {
        payBtnTitle = 'Pay now';
      } else if (paymentMethod.contains('instant')) {
        payBtnTitle = 'Pay';
      }
    }

    return Column(
      children: <Widget>[
        WorkshopHeader(
          title: 'SELECT PAYMENT',
          subTitle: 'Select a payment method',
          isExpanded: widget.expanded,
          isApproved: widget.approved,
          onTap: () => widget.onTapApprove,
        ),
        Visibility(
          visible: widget.expanded,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    CheckoutPaymentOption payment = paymentOptions[index];
                    return PaymentOptionCell(
                      channelSetFlow: widget.channelSetFlow,
                      payment: payment,
                      isSelected: paymentOptionId == payment.id,
                      onTapChangePayment: (id) => widget.onTapChangePayment(id),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 0,
                      height: 10,
                      color: Colors.transparent,
                    );
                  },
                  itemCount: paymentOptions.length),
              Container(
                height: 50,
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () {
                      if (paymentMethod == null || paymentMethod.isEmpty) return;
                      Map<String, dynamic>body = {};
                      if (paymentMethod.contains('instant')) {
                        Map<String, dynamic>payment = {};
                        Map<String, dynamic>paymentDetails = {};
                        List<dynamic>paymentItems = [];

                        paymentDetails['adsAgreement'] = false;
                        paymentDetails['recipientHolder'] = false;
                        body['paymentItems'] = paymentItems;
                      }
                      widget.onTapPay(body);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    color: overlayBackground(),
                    child: widget.isUpdating
                        ? CircularProgressIndicator()
                        : Text(
                            payBtnTitle,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 10,)
            ],
          ),
        ),
      ],
    );
  }
}
