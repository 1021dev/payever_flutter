import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/utils/translations.dart';

import '../theme.dart';

class GoogleMapAddressTextField extends StatefulWidget {
  final String googleAutocomplete;
  final Function onChanged;
  const GoogleMapAddressTextField({this.googleAutocomplete, this.onChanged});
  @override
  _GoogleMapAddressTextFieldState createState() => _GoogleMapAddressTextFieldState();
}

class _GoogleMapAddressTextFieldState extends State<GoogleMapAddressTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/google-auto-complete.svg',
            color: iconColor(),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextFormField(
              style: TextStyle(
                fontSize: 16,
              ),
              initialValue: widget.googleAutocomplete ?? '',
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.url,
              onChanged: (val) {
                widget.onChanged(val);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: Language.getSettingsStrings('form.create_form.address.google_autocomplete.label'),
                labelStyle: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
