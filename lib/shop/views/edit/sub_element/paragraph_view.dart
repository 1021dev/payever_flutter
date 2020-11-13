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
  bool isEdit = false;

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
            'Paragraph Styles',
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          )),
          Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                  child: Text(
                    isEdit ? 'Done' : 'Edit',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  )),
              SizedBox(width: 16,),
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
              ),
            ],
          )
        ],
      ),
    );
  }

  // Style Body
  Widget get _styleBody {
    if (!isEdit)
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

    return ReorderableListView(
      onReorder: _onReorder,
      scrollDirection: Axis.vertical,
      children: List.generate(
        paragraphStyles.length,
            (index) {
          return paragraphItem(index);
        },
      ),
    );
  }

  Widget paragraphItem(int index) {
    TextStyle textStyle;
    String style = paragraphStyles[index];
    bool isCaptionRed = false;
    switch (style) {
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
        isCaptionRed = true;
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
    return InkWell(
      key: Key('$index'),
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: isCaptionRed ? 70 : 65,
        color: isCaptionRed ? Colors.transparent : Colors.white,
        child: Row(
          children: [
            if (isEdit)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: () => _onRemove(index),
                  child: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 24.0,
                  ),
                ),
              ),
            Text(
              paragraphStyles[index],
              style: textStyle,
            ),
            Spacer(),
            if (!isEdit && selectedIndex == index)
              Icon(
                Icons.check,
                color: Colors.blue,
              ),
            if (isEdit)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Icon(
                  Icons.reorder,
                  color: Colors.grey,
                  size: 24.0,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final String item = paragraphStyles.removeAt(oldIndex);
        paragraphStyles.insert(newIndex, item);
      },
    );
  }

  void _onRemove(int index) {
    setState(
          () {
        paragraphStyles.removeAt(index);
      },
    );
  }
}
