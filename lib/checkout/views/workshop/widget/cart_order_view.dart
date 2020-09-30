import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import '../../../../theme.dart';

class CartOrderView extends StatefulWidget {
  final WorkshopScreenBloc workshopScreenBloc;
  final List<CartItem> cart;
  final String currency;
  final Function onTapQuality;
  const CartOrderView(this.cart, this.currency, this.workshopScreenBloc, this.onTapQuality);

  @override
  _CartOrderViewState createState() => _CartOrderViewState(cart);
}

class _CartOrderViewState extends State<CartOrderView> {
  final List<CartItem> cart;
  _CartOrderViewState(this.cart);
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkshopScreenBloc, WorkshopScreenState>(
      bloc: widget.workshopScreenBloc,
      builder: (BuildContext context, state) {
        return body(state);
      },
    );
  }

  Widget body(WorkshopScreenState state) {
    if (cart == null || cart.isEmpty) {
      Fluttertoast.showToast(msg: 'Cart is empty');
      return Container();
    }

    num totalPrice = 0;
    cart.forEach((element) {
      print('Cart: ${element.toJson().toString()}');
      totalPrice += element.price * element.quantity;
    });
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(child: Text('Total')),
                Text('Qty'),
                Text('Price'),
              ],
            ),
          ),
          _divider,
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                CartItem cartItem = cart[index];
                return Container(
                  height: 100,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      InkWell(
                        onTap: () {

                        },
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        width:80,
                        height:80,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          imageUrl: cartItem.image,
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
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0)),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/images/no_image.svg',
                                color: Colors.black54,
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text('${cartItem.name}'),
                      InkWell(
                        onTap: (){
                          widget.onTapQuality(cartItem);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${cartItem.quantity}'),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                      Text(
                        '${Measurements.currency(widget.currency)} ${formatter.format(cartItem.price)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 0,
                  height: 10,
                  color: Colors.transparent,
                );
              },
              itemCount: cart.length),
          _divider,
          Container(
            width: double.infinity,
            height: 60,
            child: Row(
              children: [
                Text('SUBTOTAL'),
                Text(
                  '${Measurements.currency(widget.currency)} ${formatter.format(totalPrice)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          _divider,
          Container(
            width: double.infinity,
            height: 60,
            child: Row(
              children: [
                Text('TOTAL'),
                Text(
                  '${Measurements.currency(widget.currency)} ${formatter.format(totalPrice)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
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
