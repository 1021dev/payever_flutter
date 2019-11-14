import 'package:flutter/material.dart';
import 'package:payever/checkout_process/view_models/checkout_process_state_model.dart';
import 'package:payever/commons/view_models/pos_cart_state_model.dart';
import 'package:payever/pos/utils/utils.dart';
import 'package:payever/pos/view_models/pos_state_model.dart';
import 'package:provider/provider.dart';

class CustomCheckoutPopUp extends StatelessWidget {
  final Widget icon;
  final String title;
  final String message;
  final VoidCallback action;
  CustomCheckoutPopUp({this.icon, this.title = "", this.message = "",this.action});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: icon),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: AppStyle.fontSizeCheckoutSuccessTitle(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: AppStyle.fontSizeCheckoutSuccessMessage(),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.black.withOpacity(0.4),
                          ),
                          bottom: BorderSide(
                            color: Colors.black.withOpacity(0.4),
                          ),
                          left: BorderSide(
                            color: Colors.black.withOpacity(0.4),
                          ),
                          right: BorderSide(
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        Language.getWidgetStrings("widgets.actions.close"),
                        style: TextStyle(color: Colors.black.withOpacity(0.4)),
                      ),
                    ),
                    onTap: () {
                        Provider.of<PosStateModel>(context).trashCart();
                        action();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
