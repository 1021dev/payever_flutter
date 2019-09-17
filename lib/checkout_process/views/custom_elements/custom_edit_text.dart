import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../checkout_process.dart';

enum ButtonStage {
  error,
  ok,
  empty,
}

class EmailTextField extends StatefulWidget {
  ValueNotifier<ButtonStage> notifier;
  TextEditingController controller = TextEditingController();
  CheckoutProcessStateModel provider;
  bool top;
  EmailTextField(this.notifier, this.top);
  bool error = false;
  @override
  _EmailTextFieldState createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  Color colorOk = Colors.black.withOpacity(0.3);
  Color colorError = Colors.red;
  @override
  Widget build(BuildContext context) {
    CheckoutProcessStateModel checkoutProcessStateModel =
        Provider.of<CheckoutProcessStateModel>(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            // color: !widget.error ? colorOk : colorError,
            color: colorOk,
          ),
          bottom: BorderSide(
            // color: !widget.error ? colorOk : colorError,
            color: colorOk,
          ),
          left: BorderSide(
            // color: !widget.error ? colorOk : colorError,
            color: colorOk,
          ),
          right: BorderSide(
            // color: !widget.error ? colorOk : colorError,
            color: colorOk,
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.top ? 6 : 0),
          topRight: Radius.circular(widget.top ? 6 : 0),
          bottomLeft: Radius.circular(widget.top ? 0 : 6),
          bottomRight: Radius.circular(widget.top ? 0 : 6),
        ),
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: !widget.error
              ? Language.getCheckoutStrings("labels.email")
              : Language.getCheckoutStrings("errors.email_invalid"),
          labelStyle: TextStyle(
            fontSize: AppStyle.fontSizeCheckoutEditTextLabel(),
            color: !widget.error ? Colors.black.withOpacity(0.6) : Colors.red,
            fontWeight: AppStyle.fontWeightCheckoutEditTextLabel(),
          ),
        ),
        style: TextStyle(
          color: Colors.black,
        ),
        cursorColor: Colors.black,
        cursorWidth: 1,
        onChanged: (email) {
          checkoutProcessStateModel.checkoutUser.setEmail(email);
          if (email.length == 0) {
            setState(
              () {
                widget.notifier.value = ButtonStage.empty;
                checkoutProcessStateModel.email.value = true;
                checkoutProcessStateModel.checkShipping();
                widget.error = false;
              },
            );
            return null;
          } else if (!(email.contains("@") && email.contains("."))) {
            setState(
              () {
                widget.notifier.value = ButtonStage.error;
                checkoutProcessStateModel.email.value = true;
                checkoutProcessStateModel.checkShipping();
                widget.error = true;
              },
            );
            return null;
          }
          setState(
            () {
              widget.notifier.value = ButtonStage.ok;
              checkoutProcessStateModel.email.value = false;
              checkoutProcessStateModel.checkShipping();
              widget.error = false;
            },
          );
          return null;
        },
      ),
    );
  }
}
