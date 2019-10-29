import 'package:flutter/material.dart';
import 'package:payever/checkout_app/utils/utils.dart';
import 'package:payever/checkout_process/utils/checkout_process_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:provider/provider.dart';
import '../checkout_process.dart';
import '../views/custom_elements/custom_elements.dart';


class CheckoutAccountSectionStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CheckoutProcessStateModel checkoutProcessStateModel =
        Provider.of<CheckoutProcessStateModel>(context);
    return CheckoutAccountSection(checkoutProcessStateModel);
  }
}

class CheckoutAccountSection extends StatefulWidget {
  CheckoutProcessStateModel checkoutProcessStateModel;
  CheckoutAccountSection(this.checkoutProcessStateModel);
  @override
  _CheckoutAccountSectionState createState() => _CheckoutAccountSectionState();
}

class _CheckoutAccountSectionState extends State<CheckoutAccountSection> {
  EmailTextField emailTextField;
  ValueNotifier<ButtonStage> emailStatus = ValueNotifier(ButtonStage.empty);
  TextEditingController controller = TextEditingController();
  GoogleAutoComplete autoComplete;
  ValueNotifier check;
  listener() => setState(() {});

  @override
  void initState() {
    super.initState();
    emailTextField = EmailTextField(emailStatus, true);
    check = ValueNotifier(true)..addListener(listener);
    // emailStatus.addListener(listener);
  }

  var kGoogleApiKey = CheckoutProcessUtils.googleKey;

  @override
  Widget build(BuildContext context) {
    // print("_${widget.checkoutProcessStateModel.addressDescription}_");

    if (((widget.checkoutProcessStateModel.checkoutUser.email?.contains("@") ??
            false) &&
        (widget.checkoutProcessStateModel.checkoutUser.email?.contains(".") ??
            false))) {
      emailStatus.value = ButtonStage.ok;
      widget.checkoutProcessStateModel.email.value = false;
      widget.checkoutProcessStateModel.checkShipping();
    }
    controller = TextEditingController(
        text: widget.checkoutProcessStateModel.addressDescription ?? "");
    emailTextField.controller.text =
        widget.checkoutProcessStateModel.checkoutUser.email;
    return Container(
      child: Column(
        children: <Widget>[
          emailTextField,
          autoComplete = GoogleAutoComplete(
            CheckoutProcessUtils.googleKey,
            controller,
            check,
            widget.checkoutProcessStateModel,
          ),
          Button(
            widget.checkoutProcessStateModel,
            controller,
            emailStatus,
            emailTextField,
          ),
        ],
      ),
    );
  }
}

class Button extends StatefulWidget {
  CheckoutProcessStateModel checkoutProcessStateModel;
  TextEditingController controller;
  ValueNotifier<ButtonStage> emailStatus;
  EmailTextField emailTextField;
  Button(this.checkoutProcessStateModel, this.controller, this.emailStatus,
      this.emailTextField);
  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  void initState() {
    super.initState();
    widget.emailStatus.addListener(
      () => setState(
        () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCheckoutButton(
      false,
      () {
        if (itsReady()) {
          widget.checkoutProcessStateModel
              .getSectionOk("user", widget.checkoutProcessStateModel)
              .value = true;
          widget.checkoutProcessStateModel.notifyListeners();
        }
      },
      color: itsReady() ? Colors.black : Colors.black.withOpacity(0.3),
    );
  }

  bool itsReady() {
    if (widget.controller.text.isNotEmpty) {
      if (widget.controller.text.contains(
        Language.getCheckoutStrings("user.form.full_address.placeholder"),
      )) {
        return false;
      } else {
        return widget.emailStatus.value == ButtonStage.ok;
      }
    } else
      return false;
  }
}
