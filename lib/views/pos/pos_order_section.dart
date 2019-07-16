import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/models/pos.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/pos/native_pos_screen.dart';
import 'package:payever/views/pos/webviewsection.dart';


class OrderSection extends StatefulWidget {
  Color textColor  = Colors.black.withOpacity(0.7);
  PosScreenParts parts;
  int index;
  final List<DropdownMenuItem<int>> qtys = List();
  OrderSection({@required this.parts,this.index});
  @override
  _OrderSectionState createState() => _OrderSectionState();
}

class _OrderSectionState extends State<OrderSection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  
  @override
  Widget build(BuildContext context) {
    widget.qtys.clear();
    for(int i=1;i<100;i++){
        final number = new DropdownMenuItem(
        value: i,
        child: Text("$i"),
      );
      widget.qtys.add(number);
    }
    return Column(
      children: <Widget>[
        Container(
          height: Measurements.height * 0.05,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Text(Language.getCartStrings("checkout_cart_edit.form.label.product"),style: TextStyle(color:widget.textColor),)),
              Container(alignment: Alignment.center,width: Measurements.width * 0.15,child: Text(Language.getCartStrings("checkout_cart_edit.form.label.qty"),style: TextStyle(color: widget.textColor),)),
              Container(alignment: Alignment.center,width: Measurements.width * 0.2,child: Text(Language.getCartStrings("checkout_cart_edit.form.label.price"),style: TextStyle(color: widget.textColor),)),
            ],
          ),
        ),
        Divider(color: Colors.black.withOpacity(0.2),height: Measurements.height *0.01,),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.parts.shoppingCart.items.length,
          itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      width:  Measurements.width * 0.05,
                      height: Measurements.height * 0.1,
                      child: Center(
                        child: SvgPicture.asset("images/xsinacircle.svg",
                        width: Measurements.width * (widget.parts.isTablet?0.02:0.04),)
                      ),
                    ),
                    onTap: (){
                      print("click delete");
                      setState(() {
                        widget.parts.deleteProduct(index);
                      });
                    },
                  ),
                  Container(
                  height: Measurements.height * 0.09,
                  width:  Measurements.height * 0.09,
                  padding: EdgeInsets.all(Measurements.width * 0.01),
                    child: widget.parts.shoppingCart.items[index].image != null?CachedNetworkImage(
                      imageUrl: Env.Storage +"/products/"+ widget.parts.shoppingCart.items[index].image,
                      placeholder: (context, url) =>  Container(),
                      errorWidget: (context, url, error) => new Icon(Icons.error,color:Colors.black),
                      fit: BoxFit.contain,
                    ):Center(
                      child: SvgPicture.asset("images/noimage.svg",color: Colors.grey.withOpacity(0.7),height: Measurements.height * 0.05,),
                    ),
                  ),
                  Expanded(child: AutoSizeText(widget.parts.shoppingCart.items[index].name,style: TextStyle(color: widget.textColor),)),
                  Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child:Theme(
                          data: ThemeData.light(),
                          child: Container(
                            child: DropdownButton(
                              value: widget.parts.shoppingCart.items[index].quantity,
                              items: widget.qtys,
                              onChanged: (value) {
                                setState((){
                                  print(value);
                                  widget.parts.updateQty(index:index,quantity: value);
                                });
                              },)
                            ),
                        ),),
                      Container(alignment: Alignment.center,width: Measurements.width * 0.2,child: AutoSizeText("${Measurements.currency(widget.parts.business.currency)}${widget.parts.f.format(widget.parts.shoppingCart.items[index].price)}",maxLines: 1,style: TextStyle(color: widget.textColor),)),
                    ],
                  ),
                ],
              )
            ),
            Divider(color: Colors.black.withOpacity(0.2),height: Measurements.height *0.01,),
          ],
        );
          },
        ),
        widget.parts.shoppingCart.items.isNotEmpty?Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: Measurements.height * 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(padding: EdgeInsets.symmetric(horizontal:Measurements.width *0.01),child: Text(Language.getCartStrings("checkout_cart_edit.form.label.subtotal"),style: TextStyle(color: widget.textColor))),
                  Container(alignment: Alignment.center,width: Measurements.width * 0.2,child: AutoSizeText("${Measurements.currency(widget.parts.business.currency)}${widget.parts.f.format(widget.parts.shoppingCart.total)}",maxLines: 1,style: TextStyle(color:  widget.textColor),)),
                ],
              ),
            ),
          ],
        ):Container(
          height: Measurements.height * 0.1,
          alignment: Alignment.centerLeft,
          child:Container(
            child: Text(Language.getCartStrings("checkout_cart_edit.error.card_is_empty"),
              style: TextStyle(color: widget.textColor)
            )
          ),       
        ),
        Divider(color: Colors.black.withOpacity(0.2),height: Measurements.height *0.01,),
        widget.parts.shoppingCart.items.isNotEmpty?Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: Measurements.height * 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(padding: EdgeInsets.symmetric(horizontal:Measurements.width *0.01),child: Text(Language.getCartStrings("checkout_cart_edit.form.label.total"),style: TextStyle(color:widget.textColor,fontWeight: FontWeight.bold))),
                  Container(alignment: Alignment.center,width: Measurements.width * 0.2,child: AutoSizeText("${Measurements.currency(widget.parts.business.currency)}${widget.parts.f.format(widget.parts.shoppingCart.total)}",maxLines: 1,style: TextStyle(color:widget.textColor,fontWeight: FontWeight.bold),)),
                ],
              ),
            ),
          ],
        ):Container(),
        Container(
          height:Measurements.height * (widget.parts.isTablet?0.05:0.1),
          width: Measurements.width *(widget.parts.isTablet? 0.3: 0.9),
          padding: EdgeInsets.symmetric(vertical:Measurements.height * (widget.parts.isTablet?0.01:0.02)),
          child: InkWell(
            child:Container(
              decoration: BoxDecoration(
                color: widget.parts.shoppingCart.items.isNotEmpty?Colors.black:Colors.grey.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Center(
                child: Text(Language.getCartStrings("checkout_cart_edit.form.label.product"),style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold)),
              )
            ),
            onTap:(){
              widget.parts.shoppingCart.items.isEmpty?
              print("block")
              :nextStep();
            },
          ),
        ),
      ],
    );
  }

  nextStep() {
    print("next Step ");
    //widget.parts.openSection.notifyListeners();
    //widget.parts.openSection.value = widget.index +1;
      RestDatasource().postStorageSimple(GlobalUtils.ActiveToken.accessToken, Cart.items2MapSimple(widget.parts.shoppingCart.items),null,true,true,"widget.phone.replaceAll(" ","")",DateTime.now().subtract(Duration(hours: 2)).add(Duration(minutes: 1)).toIso8601String(),widget.parts.currentTerminal.channelSet,widget.parts.smsenabled).then((obj){
        //widget.checkUrl = widget.parts.url = Env.Wrapper + "/pay/restore-flow-from-code/" + obj["id"]+"?noHeaderOnLoading=true";
        widget.parts.shoppingCartID = obj["id"];    
        Navigator.push(context,PageTransition(child:WebViewPayments(parts: widget.parts,url: widget.parts.url = Env.Wrapper + "/pay/restore-flow-from-code/" + obj["id"]+"?noHeaderOnLoading=true",),type:PageTransitionType.fade) );            
      });             
  }
}