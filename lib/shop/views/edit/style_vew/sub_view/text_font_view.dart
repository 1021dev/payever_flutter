import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/shop/models/models.dart';

import '../font_view.dart';

class TextFontView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Map<String, dynamic> stylesheets;

  const TextFontView({@required this.screenBloc, @required this.stylesheets,});

  @override
  _TextFontViewState createState() => _TextFontViewState();
}

class _TextFontViewState extends State<TextFontView> {
  TextStyles styles;
  String htmlText;
  String selectedChildId;

  @override
  void initState() {
    styles = TextStyles.fromJson(widget.stylesheets);
    ShopEditScreenState state = widget.screenBloc.state;
    selectedChildId = state.selectedChild.id;
    htmlText = widget.screenBloc.htmlText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    htmlText = widget.screenBloc.htmlText();

    return InkWell(
      onTap: () => navigateSubView(FontsView(
        screenBloc: widget.screenBloc,
        stylesheets: widget.stylesheets,
        onUpdateFontFamily: (fontFamily) {
          String htmlStr =
          styles.encodeHtmlString(htmlText, fontFamily: fontFamily);
          _updateTextProperty(widget.screenBloc.state, htmlStr);
        },
      )),
      child: Row(
        children: [
          Text(
            'Font',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Spacer(),
          Text(
            styles.decodeHtmlTextFontFamily(widget.screenBloc.htmlText()) ?? 'Roboto',
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
    );
  }

  void _updateTextProperty(ShopEditScreenState state, String newHtmlText) {
    Map<String, dynamic> sheets = widget.stylesheets;
    Map<String, dynamic> data = {'text': newHtmlText, 'sync': false};
    List<Map<String, dynamic>> effects = styles.getUpdateDataPayload(
        state.selectedSectionId,
        selectedChildId,
        sheets,
        data,
        'text',
        state.activeShopPage.templateId);
    print('payload: $effects');
    setState(() {
    });
    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }

  void navigateSubView(Widget subview) {
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.transparent,
        // isScrollControlled: true,
        builder: (builder) {
          return subview;
        });
  }
}
