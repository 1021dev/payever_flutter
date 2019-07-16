import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/models/pos.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/pos/native_pos_screen.dart';
import 'package:payever/views/pos/webviewsection.dart';
import 'package:webview_flutter/webview_flutter.dart';


class Send2Device extends StatefulWidget {
  PosScreenParts parts;
  int index;
  String email;
  String phone;
  
  Send2Device({@required this.parts,this.index});
  NumberTextInputFormatter phoneFormatter = NumberTextInputFormatter();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  _Send2DeviceState createState() => _Send2DeviceState();
}

class _Send2DeviceState extends State<Send2Device> {
  
  String checkoutUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Form(
        key: widget.formKey,
        child: Container(
          child:Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                ),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8))),
                    focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8))),
                    hintText: "Phone number",
                  ),
                  autovalidate: true,
                  validator: (phone){
                    String patttern = r'(^([+0#])?[0-9]{12}$)';
                    RegExp regExp = new RegExp(patttern);
                    if (phone.length == 0) {
                          return null;
                    }
                    else if (!regExp.hasMatch(phone)) {
                          return 'Please enter valid mobile number';
                    }
                    return null;
                  },
                  onSaved: (phone){
                    widget.phone = phone;
                  },
                  inputFormatters: <TextInputFormatter> [
                      WhitelistingTextInputFormatter.digitsOnly,
                      widget.phoneFormatter,
                    ],
                ),
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "E-Mail Address",
                    border: OutlineInputBorder(borderRadius:         BorderRadius.only(bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8))),
                    focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8))),
                  ),
                  onSaved: (email){
                    widget.email = email;
                  },
                  validator: (email){
                    if(email.isNotEmpty)
                      if(!email.contains("@") || !email.contains(".")){
                        return 'Enter valid email address';
                      }
                  },
                ),
              ),
              Container(
                height: Measurements.height * 0.07,
                padding: EdgeInsets.symmetric(vertical: Measurements.height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        height: Measurements.height * 0.06,
                        width: Measurements.width * 0.4,
                        alignment: Alignment.center,
                        child: Text("skip",style: TextStyle(color: Colors.black),)
                        ),
                        onTap: (){
                          widget.parts.openSection.value = widget.index + 1;
                        },
                    ),
                    InkWell(
                      child:Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        width: Measurements.width * 0.4,
                        alignment: Alignment.center,
                        child: Text("Continue",style: TextStyle(),)
                        ),
                        onTap: (){
                          if(widget.formKey.currentState.validate()){
                          widget.formKey.currentState.save();
                          if(widget.email.isNotEmpty || widget.phone.isNotEmpty)
                            RestDatasource().postStorageSimple(GlobalUtils.ActiveToken.accessToken, Cart.items2MapSimple(widget.parts.shoppingCart.items),null,true,true,widget.phone.replaceAll(" ",""), DateTime.now().subtract(Duration(hours: 2)).add(Duration(minutes: 1)).toIso8601String(),widget.parts.currentTerminal.channelSet,true).then((obj){
                            print(obj);
                            //widget.parts.url = Env.Wrapper + "/pay/restore-flow-from-code/" + obj["id"];
                            Navigator.push(context,PageTransition(child:WebViewPayments(parts: widget.parts,),type:PageTransitionType.fade) );
                            }).catchError((onError){
                              print(onError);
                            });
                          }
                        },
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  
}

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('+');
      if (newValue.selection.end >= 1)
        selectionIndex++;
    }
    if ((newTextLength >= usedSubstringIndex))
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
