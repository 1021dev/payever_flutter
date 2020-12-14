import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';

class CellBorder extends StatefulWidget {

  final ShopEditScreenBloc screenBloc;
  final Function onUpdateColor;
  final Function onClose;
  final Map<String, dynamic> stylesheets;

  const CellBorder(
      this.screenBloc,
      {this.onUpdateColor,
        this.onClose,
        this.stylesheets});

  @override
  _CellBorderState createState() => _CellBorderState();
}

class _CellBorderState extends State<CellBorder> {
  bool isPortrait;
  bool isTablet;

  TableStyles styles;
  String selectedChildId;
  List<String>borderAssets = ['outside', 'inside', 'all', 'left', 'vertical', 'right', 'top', 'horizontal', 'bottom'];
  @override
  void initState() {
    ShopEditScreenState state = widget.screenBloc.state;
    selectedChildId = state.selectedChild.id;
    styles = TableStyles.fromJson(state.pageDetail.stylesheets[selectedChildId]);

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
    styles = TableStyles.fromJson(state.pageDetail.stylesheets[selectedChildId]);
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
                Expanded(child: mainBody()),
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
                  'Cell',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                )
              ],
            ),
          ),
          Expanded(
              child: Text(
                'Cell Border',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              )),
          Row(
            children: [
              SizedBox(width: 16,),
              InkWell(
                onTap: () {
                  widget.onClose();
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

  Widget mainBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          gridView,
        ],
      ),
    );
  }

  Widget get gridView {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      decoration: BoxDecoration(
        color: Color.fromRGBO(46, 45, 50, 1),
      ),
      child: GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        crossAxisCount: isTablet ? 5 : (isPortrait ? 3 : 5),
        crossAxisSpacing: isTablet ? 40 : (isPortrait ? 40 : 40),
        mainAxisSpacing: isTablet ? 20 : (isPortrait ? 20 : 20),
        childAspectRatio: 1 / 0.3,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
          9,
              (index) {

            return InkWell(
              onTap: (){
                String headerColumnColor, headerRowColor;
                switch(index) {
                  case 0:
                    headerColumnColor = '#38719F';
                    headerRowColor = '#428CC8';
                    break;
                  case 1:
                    headerColumnColor = '#459138';
                    headerRowColor = '#61C348';
                    break;
                  case 2:
                    headerColumnColor = '#F7B950';
                    headerRowColor = '#F9CD54';
                    break;
                  case 3:
                    headerColumnColor = '#D576A8';
                    headerRowColor = '#AA3E7A';
                    break;
                  case 4:
                    headerColumnColor = '#9EA2AC';
                    headerRowColor = '#73767E';
                    break;
                  default:
                    headerColumnColor = '#ffffff';
                    headerRowColor = '#ffffff';
                }
                Map<String, dynamic> sheets = widget.screenBloc.state.pageDetail.stylesheets[selectedChildId];
                sheets['headerColumnColor'] = headerColumnColor;
                sheets['headerRowColor'] = headerRowColor;
                // _updateStyles(sheets);
              },
              child: SvgPicture.asset(
                  'assets/images/border-${borderAssets[index]}.svg',),
            );
          },
        ),
      ),
    );
  }

}
