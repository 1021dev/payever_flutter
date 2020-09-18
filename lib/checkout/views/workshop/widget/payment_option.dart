import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/connect/models/connect.dart';

class PaymentOptionCell extends StatefulWidget {
  final Payment payment;
  final bool isSelected;

  const PaymentOptionCell({this.payment, this.isSelected});

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
          Icon(widget.isSelected ? Icons.check_circle : widget.isSelected, color: Colors.black54,),
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
          CachedNetworkImage(
            imageUrl: widget.payment.imagePrimaryFilename,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            color: Colors.white,
            placeholder: (context, url) => Container(
              child: Center(
                child: Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) =>  Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/no_image.svg',
                  color: Colors.black54,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
