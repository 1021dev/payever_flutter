import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/utils/translations.dart';

import '../theme.dart';

class GoogleMapAddressField extends StatefulWidget {
  final String googleAutocomplete;
  final Function onChanged;
  final double height;
  const GoogleMapAddressField({this.googleAutocomplete, this.onChanged, this.height = 65});
  @override
  _GoogleMapAddressFieldState createState() => _GoogleMapAddressFieldState();
}

class _GoogleMapAddressFieldState extends State<GoogleMapAddressField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
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
