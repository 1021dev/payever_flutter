import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/theme.dart';

class ParagraphView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Map<String, dynamic> stylesheets;

  const ParagraphView({this.screenBloc, this.stylesheets});

  @override
  _ParagraphViewState createState() => _ParagraphViewState(screenBloc);
}

class _ParagraphViewState extends State<ParagraphView> {
  final ShopEditScreenBloc screenBloc;

  _ParagraphViewState(this.screenBloc);

  bool isPortrait;
  bool isTablet;
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
    return BlocBuilder(
      bloc: screenBloc,
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
                _segmentedControl,
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

  Widget get _segmentedControl {
    return Container(
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.blue,),
                Text('Text', style: TextStyle(color: Colors.blue, fontSize: 16),)
              ],
            ),
          ),
          Expanded(
            child: Text('Paragraph Styles', style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,)
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(46, 45, 50, 1),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.close, color: Colors.grey),
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
      itemCount: paragraphStyles.length,
      itemBuilder: (context, index) {
        return paragraphItem(index);
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 0,
          indent: 20,
          endIndent: 20,
          thickness: 0.5,
          color: Colors.grey,
        );
      },
    );
  }

  Widget paragraphItem(int index) {
    TextStyle textStyle;
    switch(index) {
      case 0:
      case 1:
        textStyle = TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.w600);
        break;
      case 2:
      case 3:
        textStyle = TextStyle(color: Colors.black, fontSize: 30);
        break;
      case 4:
        textStyle = TextStyle(color: Colors.black, fontSize: 25);
        break;
      case 5:
        textStyle = TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.w700);
        break;
      case 6:
        textStyle = TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.w700);
        break;
      case 7:
        textStyle = TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w600);
        break;
      case 8:
        textStyle = TextStyle(color: Colors.black, fontSize: 25, fontStyle: FontStyle.italic);
        break;
      default:
        textStyle = TextStyle(color: Colors.black, fontSize: 30);
    }
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: index == 6 ? 70 : 65,
        color: index != 6 ? Colors.white : Colors.transparent,
        child: Row(
          children: [
            Text(paragraphStyles[index], style: textStyle,),
            Spacer(),
            if (selectedIndex == index)
              Icon(Icons.check, color: Colors.blue,)
          ],
        ),
      ),
    );
  }
}
