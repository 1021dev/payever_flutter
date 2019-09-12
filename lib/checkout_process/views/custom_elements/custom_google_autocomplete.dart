import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import '../custom_elements/custom_google_places.dart';

import '../../checkout_process.dart';

class GoogleAutoComplete extends StatefulWidget {
  final String kGoogleApiKey;
  final TextEditingController controller;
  final bool isBottom;
  ValueNotifier check;
  CheckoutProcessStateModel checkoutProcessStateModel;
  GoogleAutoComplete(this.kGoogleApiKey, this.controller, this.check,
      this.checkoutProcessStateModel,
      {this.isBottom = true});

  @override
  _GoogleAutoCompleteState createState() => _GoogleAutoCompleteState();
}

class _GoogleAutoCompleteState extends State<GoogleAutoComplete> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Container(
        child: Container(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black.withOpacity(0.3),
                ),
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.3),
                ),
                left: BorderSide(
                  color: Colors.black.withOpacity(0.3),
                ),
                right: BorderSide(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.isBottom ? 0 : 0),
                topRight: Radius.circular(widget.isBottom ? 0 : 0),
                bottomLeft: Radius.circular(widget.isBottom ? 6 : 0),
                bottomRight: Radius.circular(widget.isBottom ? 6 : 0),
              ),
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: AppStyle.fontSizeCheckoutEditTextLabel(),
                color: Colors.black.withOpacity(0.6),
              ),
              child: CustomPlacesAutocompleteField(
                types: ["locality", "political", "geocode"],
                onChanged: (s) {
                  setState(
                    () {
                      //print
                      
                      //
                      List<String> address = s.description.split(",");
                      widget.checkoutProcessStateModel
                          .setAddressDescription(s.description);
                      widget.checkoutProcessStateModel.checkoutUser.setCountry(
                        address.last.replaceAll(" ", ""),
                      );
                      if (address.length > 2) {
                        widget.checkoutProcessStateModel.checkoutUser.setStreet(
                          address[0],
                        );
                        widget.checkoutProcessStateModel.checkoutUser.setCity(
                          address[1].replaceAll(" ", ""),
                        );
                      } else {
                        widget.checkoutProcessStateModel.checkoutUser.setCity(
                          address[0].replaceAll(" ", ""),
                        );
                        widget.checkoutProcessStateModel.checkoutUser
                            .setStreet("");
                      }
                    },
                  );
                },
                check: widget.check,
                leading: Icon(
                  Icons.location_on,
                  color: Colors.black.withOpacity(0.6),
                ),
                controller: widget.controller,
                apiKey: widget.kGoogleApiKey,
                mode: Mode.overlay,
                radius: 100,
                hint: Language.getCheckoutStrings(
                  "user.form.full_address.placeholder",
                ),
                language: "de",
                inputDecoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: widget.controller.text.isEmpty
                      ? ""
                      : Language.getCheckoutStrings(
                          "user.form.full_address.placeholder",
                        ),
                  labelStyle: TextStyle(
                    fontSize: AppStyle.fontSizeCheckoutEditTextLabel(),
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: AppStyle.fontWeightCheckoutEditTextLabel(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}