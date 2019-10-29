import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payever/checkout_process/utils/checkout_process_utils.dart';
import 'package:payever/checkout_process/views/custom_elements/custom_elements.dart';
import 'package:payever/commons/views/views.dart';
import 'package:provider/provider.dart';

import '../checkout_process.dart';

class CheckoutShippingSectionStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CheckoutProcessStateModel checkoutProcessStateModel =
        Provider.of<CheckoutProcessStateModel>(context);
    return CheckoutShippingSection(checkoutProcessStateModel);
  }
}

class CheckoutShippingSection extends StatefulWidget {
  CheckoutProcessStateModel checkoutProcessStateModel;
  CheckoutShippingSection(this.checkoutProcessStateModel);

  @override
  _CheckoutShippingSectionState createState() =>
      _CheckoutShippingSectionState();
}

class _CheckoutShippingSectionState extends State<CheckoutShippingSection> {
  EmailTextField emailTextField;
  ValueNotifier<ButtonStage> emailStatus = ValueNotifier(ButtonStage.empty);
  ValueNotifier check;
  int _index = -1;
  CustomTextFieldForm streetField;
  CustomTextFieldForm countryField;
  CustomTextFieldForm cityField;
  CustomTextFieldForm firstNameField;
  CustomTextFieldForm lastNameField;
  CustomTextFieldForm postField;
  GoogleAutoComplete autoComplete;
  TextEditingController autoCompleteController;
  List<String> _countries = List();
  DropDownMenu a;
  fieldsInit() {
    emailTextField.controller.text =
        widget.checkoutProcessStateModel.checkoutUser.email;
    autoCompleteController = TextEditingController(
        text: widget.checkoutProcessStateModel.addressDescription ?? "");
  }

  @override
  void initState() {
    super.initState();
    _countries = Language.getCountryNameList();
    emailTextField = EmailTextField(emailStatus, true);
    check = ValueNotifier(true)
      ..addListener(
        () => setState(
          () {},
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    fieldsInit();
    return Container(
      child: Column(
        children: <Widget>[
          emailTextField,
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        // color: _index < 0
                        //     ? Colors.red
                        //     : Colors.black.withOpacity(0.3),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      bottom: BorderSide(
                        // color: _index < 0
                        //     ? Colors.red
                        //     : Colors.black.withOpacity(0.3),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      left: BorderSide(
                        // color: _index < 0
                        //     ? Colors.red
                        //     : Colors.black.withOpacity(0.3),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      right: BorderSide(
                        // color: _index < 0
                        //     ? Colors.red
                        //     : Colors.black.withOpacity(0.3),
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: _index < 0
                              ? Container()
                              : Text(
                                  Language.getCheckoutStrings(
                                    "address.form.label.salutation",
                                  ),
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                    fontSize: 10,
                                  ),
                                  maxLines: 1,
                                ),
                        ),
                        DropDownMenu(
                          iconSize: 15,
                          fontsize: 15,
                          noIcon: false,
                          autoCenter: false,
                          optionsList: <String>[
                            Language.getCheckoutStrings(
                                "options.salutation_mr"),
                            Language.getCheckoutStrings(
                                "options.salutation_mrs"),
                          ],
                          placeHolderText: Language.getCheckoutStrings(
                              "address.form.label.salutation"),
                          backgroundColor: Colors.white,
                          fontColor: Colors.black.withOpacity(0.6),
                          customColor: true,
                          hintColor: Colors.red,
                          onChangeSelection: (name, index) {
                            setState(
                              () {
                                _index = index;
                                widget.checkoutProcessStateModel.checkoutUser
                                    .setSalutation(index == 0
                                        ? "salutation_mr"
                                        : "salutation_mrs");
                                widget.checkoutProcessStateModel.salutation
                                    .value = false;
                                widget.checkoutProcessStateModel
                                    .checkShipping();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: firstNameField = CustomTextFieldForm(
                    Language.getCheckoutStrings(
                      "address.form.first_name.label",
                    ),
                    true,
                    widget.checkoutProcessStateModel.name,
                    widget.checkoutProcessStateModel,
                    init: widget.checkoutProcessStateModel.checkoutUser.name ??
                        "",
                    validator: (name) {
                      widget.checkoutProcessStateModel.checkoutUser
                          .setName(name);
                      return name.isEmpty;
                    },
                    borderTop: false,
                    borderBot: false,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: lastNameField = CustomTextFieldForm(
                    Language.getCheckoutStrings(
                      "address.form.last_name.label",
                    ),
                    true,
                    widget.checkoutProcessStateModel.lastname,
                    widget.checkoutProcessStateModel,
                    init: widget
                            .checkoutProcessStateModel.checkoutUser?.lastName ??
                        "",
                    validator: (name) {
                      widget.checkoutProcessStateModel.checkoutUser
                          .setLastName(name);
                      return name.isEmpty;
                    },
                    borderTop: false,
                    borderLeft: false,
                    borderBot: false,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 60,
            child: autoComplete = GoogleAutoComplete(
              CheckoutProcessUtils.googleKey,
              autoCompleteController,
              check,
              widget.checkoutProcessStateModel,
              isBottom: false,
            ),
          ),
          Row(
            children: <Widget>[
              // Expanded(
              //   flex: 2,
              //   child: Container(
              //     child: countryField = CustomTextFieldForm(
              //       Language.getCheckoutStrings(
              //         "address.form.label.country",
              //       ),
              //       true,
              //       widget.checkoutProcessStateModel.country,
              //       widget.checkoutProcessStateModel,
              //       init: widget
              //               .checkoutProcessStateModel.checkoutUser?.country ??
              //           "",
              //       validator: (name) {
              //         widget.checkoutProcessStateModel.checkoutUser
              //             .setCountry(name);
              //         return name.isEmpty;
              //       },
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 2,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        // color: widget.checkoutProcessStateModel.checkoutUser.country == null
                        //     ? Colors.red
                        //     : Colors.black.withOpacity(0.3),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      bottom: BorderSide(
                        // color: widget.checkoutProcessStateModel.checkoutUser.country == null
                        //     ? Colors.red
                        //     : Colors.black.withOpacity(0.3),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      left: BorderSide(
                        // color: widget.checkoutProcessStateModel.checkoutUser.country == null
                        //     ? Colors.red
                        //     : Colors.black.withOpacity(0.3),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      right: BorderSide(
                        // color: widget.checkoutProcessStateModel.checkoutUser.country == null
                        //     ? Colors.red
                        //     : Colors.black.withOpacity(0.3),
                        color: Colors.black.withOpacity(0.0),
                      ),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: (widget.checkoutProcessStateModel.checkoutUser
                                          ?.country ??
                                      null) ==
                                  null
                              ? Container()
                              : Text(
                                  Language.getCheckoutStrings(
                                    "address.form.label.country",
                                  ),
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                    fontSize: 10,
                                  ),
                                  maxLines: 1,
                                ),
                        ),
                        DropDownMenu(
                          defaultValue: widget
                              .checkoutProcessStateModel.checkoutUser.country,
                          iconSize: 15,
                          changeDef: true,
                          fontsize: 15,
                          noIcon: false,
                          autoCenter: false,
                          optionsList: _countries,
                          placeHolderText: Language.getCheckoutStrings(
                            "address.form.label.country",
                          ),
                          backgroundColor: Colors.white,
                          fontColor: Colors.black.withOpacity(0.6),
                          customColor: true,
                          hintColor: Colors.red,
                          onChangeSelection: (name, index) {
                            setState(
                              () {
                                widget.checkoutProcessStateModel.checkoutUser
                                    .setCountry(name);
                                widget.checkoutProcessStateModel.country.value =
                                    false;
                                widget.checkoutProcessStateModel
                                    .checkShipping();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: cityField = CustomTextFieldForm(
                    Language.getCheckoutStrings(
                      "address.form.label.city",
                    ),
                    true,
                    widget.checkoutProcessStateModel.city,
                    widget.checkoutProcessStateModel,
                    init: widget.checkoutProcessStateModel.checkoutUser?.city ??
                        "",
                    validator: (name) {
                      widget.checkoutProcessStateModel.checkoutUser
                          .setCity(name);
                      return name.isEmpty;
                    },
                    borderTop: false,
                    borderBot: false,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 9,
                child: Container(
                  child: streetField = CustomTextFieldForm(
                    Language.getCheckoutStrings("address.form.label.street"),
                    true,
                    widget.checkoutProcessStateModel.street,
                    widget.checkoutProcessStateModel,
                    init:
                        widget.checkoutProcessStateModel.checkoutUser?.street ??
                            "",
                    validator: (name) {
                      widget.checkoutProcessStateModel.checkoutUser
                          .setStreet(name);
                      return name.isEmpty;
                    },
                    borderRight: false,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: Container(
                    child: postField = CustomTextFieldForm(
                      Language.getCheckoutStrings(
                        "address.form.label.zip_code",
                      ),
                      true,
                      widget.checkoutProcessStateModel.post,
                      widget.checkoutProcessStateModel,
                      init: widget.checkoutProcessStateModel.checkoutUser
                              ?.zipCode ??
                          "",
                      validator: (text) {
                        widget.checkoutProcessStateModel.checkoutUser
                            .setZipCode(text);
                        return false;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: CustomTextFieldForm(
                    Language.getCheckoutStrings("labels.company_optional"),
                    false,
                    widget.checkoutProcessStateModel.company,
                    widget.checkoutProcessStateModel,
                    init:
                        widget.checkoutProcessStateModel.checkoutUser.company ??
                            "",
                    validator: (name) {
                      widget.checkoutProcessStateModel.checkoutUser
                          .setCompany(name);
                      return false;
                    },
                    borderTop: false,
                    borderBot: false,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: CustomTextFieldForm(
                    Language.getCheckoutStrings("address.form.label.phone") +
                        " " +
                        Language.getCheckoutStrings("labels.optional"),
                    false,
                    widget.checkoutProcessStateModel.phone,
                    widget.checkoutProcessStateModel,
                    isPhone: true,
                    init: widget.checkoutProcessStateModel.checkoutUser.phone ??
                        "",
                    validator: (phone) {
                      widget.checkoutProcessStateModel.checkoutUser
                          .setPhone(phone);
                      String patttern = r'(^([+0#])?[0-9]{12,}?$)';
                      RegExp regExp = new RegExp(patttern);
                      if (phone.length == 0) return false;
                      return !regExp.hasMatch(phone);
                    },
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
          ShippingButton(
            widget.checkoutProcessStateModel,
            widget.checkoutProcessStateModel.shippingValue,
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 10),
          //   child: ShippingButton(widget.checkoutProcessStateModel,true),
          // ),
        ],
      ),
    );
  }
}

class CustomTextFieldForm extends StatefulWidget {
  ValueNotifier<bool> error;
  bool bot;
  final String label;
  final bool mandatory;
  String errorLabel;
  String init;
  CheckoutProcessStateModel checkoutProcessStateModel;
  bool Function(String) validator;
  bool textValidation = false;
  final bool isPhone;
  bool borderTop;
  bool borderBot;
  bool borderRight;
  bool borderLeft;
  BorderRadius borderRadius;
  bool numeric;
  CustomTextFieldForm(
    this.label,
    this.mandatory,
    this.error,
    this.checkoutProcessStateModel, {
    this.init = "",
    this.errorLabel,
    this.validator,
    this.borderRadius,
    this.borderTop = true,
    this.borderBot = true,
    this.borderRight = true,
    this.borderLeft = true,
    this.isPhone = false,
    this.bot = true,
    this.numeric = false,
  }) {
    controller = TextEditingController(text: init);
  }

  TextEditingController controller;
  bool get getError => error.value;

  @override
  _CustomTextFieldFormState createState() => _CustomTextFieldFormState();
}

class _CustomTextFieldFormState extends State<CustomTextFieldForm> {
  Color colorOk = Colors.black.withOpacity(0.3);
  Color colorError = Colors.red;

  @override
  void initState() {
    super.initState();
    widget.error.addListener(
      () {
        setState(
          () {},
        );
        widget.checkoutProcessStateModel.checkShipping();
      },
    );
  }

  NumberTextInputFormatter phoneFormatter = NumberTextInputFormatter();
  @override
  Widget build(BuildContext context) {
    widget.error.value =
        ((widget.controller?.text?.isEmpty ?? true) && widget.mandatory) ||
            widget.textValidation;
    Color colorOK = Colors.black;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        border: Border(
          top: BorderSide(
            // color: !widget.error.value ? colorOk : colorError,
            color: widget.borderTop
                ? colorOK.withOpacity(0.3)
                : colorOK.withOpacity(0.1),
          ),
          bottom: BorderSide(
            // color: !widget.error.value ? colorOk : colorError,
            color: widget.borderBot
                ? colorOK.withOpacity(0.3)
                : colorOK.withOpacity(0.1),
          ),
          left: BorderSide(
            // color: !widget.error.value ? colorOk : colorError,
            color: widget.borderLeft
                ? colorOK.withOpacity(0.3)
                : colorOK.withOpacity(0.1),
          ),
          right: BorderSide(
            // color: !widget.error.value ? colorOk : colorError,
            color: widget.borderRight
                ? colorOK.withOpacity(0.3)
                : colorOK.withOpacity(0.1),
          ),
        ),
      ),
      child: TextField(
        inputFormatters: <TextInputFormatter>[
          widget.numeric
              ? WhitelistingTextInputFormatter(
                  RegExp(
                    r"^\d{1,12}\.?\d{0,2}",
                  ),
                )
              : widget.isPhone
                  ? WhitelistingTextInputFormatter.digitsOnly
                  : BlacklistingTextInputFormatter(
                  RegExp(
                    GlobalUtils.RX_emoji,
                  ),
                ),
          widget.isPhone
              ? phoneFormatter
              : BlacklistingTextInputFormatter(
                  RegExp(
                    GlobalUtils.RX_emoji,
                  ),
                ),
        ],
        controller: widget.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: !widget.error.value
              ? widget.label
              : widget.errorLabel ?? widget.label,
          labelStyle: TextStyle(
            fontSize: AppStyle.fontSizeCheckoutEditTextLabel(),
            color: !widget.error.value
                ? Colors.black.withOpacity(0.6)
                : Colors.red,
            fontWeight: AppStyle.fontWeightCheckoutEditTextLabel(),
          ),
        ),
        style: TextStyle(
          color: Colors.black,
        ),
        cursorColor: Colors.black,
        cursorWidth: 1,
        onChanged: (text) {
          setState(
            () {
              widget.textValidation = widget.validator(text);
            },
          );
        },
      ),
    );
  }
}

class ShippingButton extends StatefulWidget {
  CheckoutProcessStateModel checkoutProcessStateModel;
  ValueNotifier check;
  ShippingButton(this.checkoutProcessStateModel, this.check);

  @override
  _ShippingButtonState createState() => _ShippingButtonState();
}

class _ShippingButtonState extends State<ShippingButton> {
  @override
  void initState() {
    super.initState();
    widget.check
      ..addListener(
        () {
          Future.delayed(Duration(milliseconds: 10)).then((_) {
            setState(() {});
          });
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCheckoutButton(
      false,
      () {
        if (widget.check.value) {
          widget.checkoutProcessStateModel.setAddressDescriptionAuto();
          widget.checkoutProcessStateModel
              .getSectionOk("address", widget.checkoutProcessStateModel)
              .value = true;
        }
      },
      color: widget.check.value ? Colors.black : Colors.black.withOpacity(0.3),
    );
  }
}
