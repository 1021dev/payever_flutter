import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';

class FontsView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Map<String, dynamic> stylesheets;
  final Function onUpdateFontFamily;
  const FontsView({this.screenBloc, this.stylesheets, @required this.onUpdateFontFamily});

  @override
  _FontsViewState createState() => _FontsViewState();
}

class _FontsViewState extends State<FontsView> {

  _FontsViewState();

  bool isPortrait;
  bool isTablet;
  String _fontFamily;

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
    TextStyles styles = TextStyles.fromJson(widget.stylesheets[state.selectedSectionId]);
    _fontFamily = styles.decodeHtmlTextFontFamily(widget.screenBloc.htmlText()) ?? 'Roboto';

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
                _toolBar,
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

  Widget get _toolBar {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blue,
                ),
                Text(
                  'Text',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                )
              ],
            ),
          ),
          Expanded(
              child: Text(
            'Fonts',
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          )),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(46, 45, 50, 1),
                ),
                child: Icon(Icons.close, color: Colors.grey),
              ),
            ),
          )
        ],
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
      onTap: ()=> widget.onUpdateFontFamily(fontFamily),
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
