import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payever/products/utils/utils.dart';
import 'package:provider/provider.dart';

import '../checkout_process.dart';
import '../views/custom_elements/custom_elements.dart';
import 'custom_elements/custom_checkout_button.dart';
import 'custom_elements/custom_checkout_popup.dart';

class CheckoutS2DeviceSection extends StatefulWidget {
  @override
  _CheckoutS2DeviceSectionState createState() =>
      _CheckoutS2DeviceSectionState();
}

class _CheckoutS2DeviceSectionState extends State<CheckoutS2DeviceSection> {
  NumberTextInputFormatter phoneFormatter = NumberTextInputFormatter();
  Color colorOk = Colors.black.withOpacity(0.3);
  Color colorError = Colors.red;

  ValueNotifier<ButtonStage> phoneStatus = ValueNotifier(ButtonStage.empty);
  ValueNotifier<ButtonStage> emailStatus = ValueNotifier(ButtonStage.empty);

  final formKey = new GlobalKey<FormState>();
  PhoneTextField phoneTextField;
  EmailTextField emailTextField;

  @override
  void initState() {
    super.initState();
    phoneTextField = PhoneTextField(phoneStatus);
    emailTextField = EmailTextField(emailStatus, false);
    phoneStatus.addListener(listener);
    emailStatus.addListener(listener);
  }

  listener() {
    setState(() {});
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    CheckoutProcessStateModel checkoutProcessStateModel =
        Provider.of<CheckoutProcessStateModel>(context);
    return Form(
      key: formKey,
      child: Container(
        child: Column(
          children: <Widget>[
            phoneSetUp(checkoutProcessStateModel) ? PhoneError() : Container(),
            phoneTextField,
            emailTextField,
            CustomCheckoutButton(
              loading,
              () {
                if (continueStatus() &&
                    !loading &&
                    !phoneSetUp(checkoutProcessStateModel)) {
                  setState(() => loading = true);
                  CheckoutProcessApi()
                      .postCheckout(checkoutProcessStateModel.flowObj["id"],
                          checkoutProcessStateModel.getchannelSet)
                      .then(
                    (message) {
                      CheckoutProcessApi()
                          .postStorageSimple(
                        checkoutProcessStateModel.flowObj,
                        true,
                        true,
                        phoneTextField.controller.text,
                        phoneTextField.controller.text.isEmpty
                            ? "email"
                            : "sms",
                        DateTime.now()
                            .subtract(
                              Duration(
                                hours: 2,
                              ),
                            )
                            .add(Duration(minutes: 1))
                            .toIso8601String(),
                        false,
                      )
                          .then(
                        (a) {
                          String url = Env.wrapper +
                              "/pay/restore-flow-from-code/" +
                              a["id"];
                          CheckoutProcessApi()
                              .postSendToDev(
                            urlGetter(url, checkoutProcessStateModel),
                            emailTextField.controller.text ?? "",
                            "${checkoutProcessStateModel.checkoutStructure.name}",
                            checkoutProcessStateModel.flowObj["id"],
                            phoneTextField.controller.text.isNotEmpty
                                ? checkoutProcessStateModel
                                        .checkoutStructure.phoneNumber ??
                                    ""
                                : "",
                            phoneTextField.controller.text ?? "",
                          )
                              .then((_) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: CustomCheckoutPopUp(
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.black,
                                        size: 65,
                                      ),
                                      title: Language.getCheckoutSMSStrings(
                                          "checkout_send_flow.finish.header"),
                                      message: Language.getCheckoutSMSStrings(
                                          "checkout_send_flow.finish.caption"),
                                    ));
                              },
                            );
                            print("sended");
                            print("clear cart");
                            print("pop context");
                            print("load successful pop");
                          }).catchError((onError) {
                            print(onError.toString());
                          });
                        },
                      );
                    },
                  ).catchError(
                    (onError) {
                      print(onError.toString());
                    },
                  );
                } else {
                  print("not good");
                }
              },
              color: continueStatus()
                  ? phoneSetUp(checkoutProcessStateModel)
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black
                  : Colors.black.withOpacity(0.3),
              twoButtons: true,
              secondAction: () {
                checkoutProcessStateModel.getSectionOk("send_to_device",checkoutProcessStateModel).value =
                    true;
              },
            ),
          ],
        ),
      ),
    );
  }

  String urlGetter(
      String url, CheckoutProcessStateModel checkoutProcessStateModel) {
    return checkoutProcessStateModel.checkoutStructure.message
            ?.replaceFirst("{{terminal_url}}", url) ??
        "${checkoutProcessStateModel.checkoutStructure.name} : $url";
  }

  bool continueStatus() {
    bool phoneOk = phoneStatus.value == ButtonStage.ok;
    bool emailOk = emailStatus.value == ButtonStage.ok;
    bool error = (phoneStatus.value == ButtonStage.error) ||
        (emailStatus.value == ButtonStage.error);

    return (phoneOk || emailOk) && !error;
  }

  bool phoneSetUp(CheckoutProcessStateModel checkoutProcessStateModel) {
    return phoneTextField.controller.text.isNotEmpty &&
        (checkoutProcessStateModel.checkoutStructure.phoneNumber == null);
  }
}

class PhoneError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
          border: Border(
            top: BorderSide(
              color: Colors.red,
              width: 0.5,
            ),
            bottom: BorderSide(
              color: Colors.red,
              width: 0.5,
            ),
            left: BorderSide(
              color: Colors.red,
              width: 0.5,
            ),
            right: BorderSide(
              color: Colors.red,
              width: 0.5,
            ),
          ),
        ),
        child: Text(
          Language.getCheckoutSMSStrings(
              "checkout_send_flow.errors.from_phone_not_configured"),
          style: TextStyle(
              color: Colors.red.withAlpha(255), fontWeight: FontWeight.w300),
        ),
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
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if ((newTextLength >= usedSubstringIndex))
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class PhoneTextField extends StatefulWidget {
  bool error = false;
  ValueNotifier<ButtonStage> notifier;
  TextEditingController controller = TextEditingController(text: "");
  PhoneTextField(this.notifier);
  @override
  _PhoneTextFieldState createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  NumberTextInputFormatter phoneFormatter = NumberTextInputFormatter();
  Color colorOk = Colors.black.withOpacity(0.3);
  Color colorError = Colors.red;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: !widget.error ? colorOk : colorError,
          ),
          bottom: BorderSide(
            color: !widget.error ? colorOk : colorError,
          ),
          left: BorderSide(
            color: !widget.error ? colorOk : colorError,
          ),
          right: BorderSide(
            color: !widget.error ? colorOk : colorError,
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
      child: TextField(
        controller: widget.controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: !widget.error
              ? Language.getCheckoutStrings("labels.phone_number")
              : Language.getCheckoutStrings("errors.phone_number_invalid"),
          labelStyle: TextStyle(
            color: !widget.error ? Colors.black.withOpacity(0.6) : Colors.red,
            fontWeight: FontWeight.w300,
          ),
        ),
        style: TextStyle(
          color: Colors.black,
        ),
        cursorColor: Colors.black,
        cursorWidth: 1,
        onChanged: (phone) {
          String patttern = r'(^([+0#])?[0-9]{13,}?$)';
          RegExp regExp = new RegExp(patttern);
          if (phone.length == 0) {
            setState(
              () {
                widget.notifier.value = ButtonStage.empty;
                widget.error = false;
              },
            );
            return null;
          } else if (regExp.hasMatch(phone)) {
            setState(
              () {
                widget.notifier.value = ButtonStage.error;
                widget.error = true;
              },
            );
            return null;
          }
          setState(
            () {
              widget.notifier.value = ButtonStage.ok;
              widget.error = false;
            },
          );
          return null;
        },
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
          phoneFormatter,
        ],
      ),
    );
  }
}
