import 'package:flutter/material.dart';
import 'package:payever/commons/utils/app_style.dart';
import 'package:payever/commons/utils/translations.dart';

class CustomCheckoutButton extends StatelessWidget {
  final VoidCallback _action;
  final VoidCallback secondAction;
  final bool _loading;
  final bool twoButtons;
  final Color color;

  const CustomCheckoutButton(this._loading, this._action,
      {this.color = Colors.black, this.twoButtons = false, this.secondAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: !twoButtons
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceAround,
      children: <Widget>[
        twoButtons
            ? Container(
                padding: EdgeInsets.only(top: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      Language.getCheckoutStrings("action.skip"),
                      style: TextStyle(
                        fontSize: AppStyle.fontSizeCheckoutButton(),
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onTap: secondAction,
                ),
              )
            : Container(),
        Container(
          padding: EdgeInsets.only(top: 10),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: !twoButtons ? 300 : 150,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: !_loading
                  ? Text(
                      Language.getCheckoutStrings("action.continue"),
                      style: TextStyle(
                        fontSize: AppStyle.fontSizeCheckoutButton(),
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    )
                  : Container(
                      width: 25,
                      height: 25,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ),
            onTap: _action,
          ),
        ),
      ],
    );
  }
}
