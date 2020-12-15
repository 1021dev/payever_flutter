import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/views/edit/style_vew/sub_view/toolbar.dart';

class FontFamilyView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Map<String, dynamic> stylesheets;
  final Function onUpdateFontFamily;
  final String fontFamily;
  final Function onClose;

  const FontFamilyView(
      {this.screenBloc, this.stylesheets, @required this.onUpdateFontFamily, @required this.fontFamily, @required this.onClose});

  @override
  _FontFamilyViewState createState() => _FontFamilyViewState();
}

class _FontFamilyViewState extends State<FontFamilyView> {

  _FontFamilyViewState();

  bool isPortrait;
  bool isTablet;
  String _fontFamily;

  @override
  void initState() {
    _fontFamily = widget.fontFamily ?? 'Roboto';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
    return BlocBuilder(
      bloc: widget.screenBloc,
      builder: (BuildContext context, state) {
        return body(state);
      },
    );
  }

  Widget body(ShopEditScreenState state) {
    if (state.selectedChild == null) return Container();
    return Container(
      height: 400,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Container(
            color: Color.fromRGBO(23, 23, 25, 1),
            padding: EdgeInsets.only(top: 18),
            child: Column(
              children: [
                Toolbar(backTitle: 'Text', title: 'Fonts', onClose: widget.onClose),
                SizedBox(
                  height: 10,
                ),
                Expanded(child: _styleBody),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Style Body
  Widget get _styleBody {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: fonts.length,
      itemBuilder: (context, index) {
        return fontItem(index);
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 0,
          indent: 20,
          endIndent: 20,
          thickness: 0.5,
          color: Colors.grey[800],
        );
      },
    );
  }

  Widget fontItem(int index) {
    String fontFamily = fonts[index];
    return InkWell(
      key: Key('$index'),
      onTap: () {
        setState(() {
          _fontFamily = fontFamily;
        });
        widget.onUpdateFontFamily(fontFamily);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 50,
        child: Row(
          children: [
            Opacity(
              opacity: fontFamily == _fontFamily ? 1 : 0,
              child: Icon(
                Icons.check,
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 16,),
            Text(
              fonts[index],
              // style: textStyle,
            ),
          ],
        ),
      ),
    );
  }

  TextStyle getTextStyle(String font) {
    TextStyle textStyle;
    switch (font) {
      case 'Title':
      case 'Title Small':
        textStyle = TextStyle(
            color: Colors.black, fontSize: 35, fontWeight: FontWeight.w600);
        break;
      case 'Subtitle':
      case 'Body':
        textStyle = TextStyle(color: Colors.black, fontSize: 30);
        break;
      case 'Body Small':
        textStyle = TextStyle(color: Colors.black, fontSize: 25);
        break;
      case 'Caption':
        textStyle = TextStyle(
            color: Colors.black, fontSize: 23, fontWeight: FontWeight.w700);
        break;
      case 'Caption Red':
        textStyle = TextStyle(
            color: Colors.red, fontSize: 30, fontWeight: FontWeight.w700);
        break;
      case 'Quote':
        textStyle = TextStyle(
            color: Colors.black, fontSize: 30, fontWeight: FontWeight.w600);
        break;
      case 'Attribution':
        textStyle = TextStyle(
            color: Colors.black, fontSize: 25, fontStyle: FontStyle.italic);
        break;
      default:
        textStyle = TextStyle(color: Colors.black, fontSize: 30);
    }
    return textStyle;
  }
}
