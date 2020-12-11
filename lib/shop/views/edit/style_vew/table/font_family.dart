import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';

import '../font_family_view.dart';

class FontFamily extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Function onClose;
  final String fontFamily;
  final Function onUpdateFontFamily;

  const FontFamily({this.screenBloc, this.onClose, this.fontFamily, this.onUpdateFontFamily});

  @override
  _FontFamilyState createState() => _FontFamilyState();
}

class _FontFamilyState extends State<FontFamily> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: InkWell(
        onTap: () {
          String selectedChildId =  widget.screenBloc.state.selectedChild.id;
          Widget subview = FontFamilyView(
            screenBloc: widget.screenBloc,
            stylesheets: widget.screenBloc.state.pageDetail.stylesheets[selectedChildId],
            onUpdateFontFamily: (_fontFamily) => widget.onUpdateFontFamily(_fontFamily),
            onClose: widget.onClose,
            fontFamily: widget.fontFamily,
          );
          navigateSubView(subview, context);
        } ,
        child: Row(
          children: [
            Text(
              'Font',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            Spacer(),
            Text(
              widget.fontFamily ?? 'Roboto',
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}
