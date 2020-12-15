import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/sub_view/border_view.dart';

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
            padding: EdgeInsets.only(top: 18, bottom: 32),
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            gridView,
            SizedBox(height: 5,),
            annotationText,
            BorderView(
              styles: styles,
              type: widget.screenBloc.state.selectedChild.type,
              // onUpdateBorderRadius: (radius, updateApi) =>
              //     _updateBorderRadius(state, radius, updateApi: updateApi),
              // onUpdateBorderModel: (model, updateApi) {
              //   _updateImageBorderModel(state, model, updateApi: updateApi);
              // },
            ),
          ],
        ),
      ),
    );
  }

  Widget get gridView {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      crossAxisCount: isTablet ? 5 : (isPortrait ? 3 : 5),
      crossAxisSpacing: 1,
      mainAxisSpacing: 1,
      childAspectRatio: 1 / 0.3,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(9,
            (index) {
          return InkWell(
            onTap: () {
              Map<String, dynamic> sheets = widget.screenBloc.state.pageDetail.stylesheets[selectedChildId];
              // sheets['headerColumnColor'] = headerColumnColor;
              // sheets['headerRowColor'] = headerRowColor;
              // _updateStyles(sheets);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(46, 45, 50, 1),
                borderRadius: borderRadius(index),
              ),
              padding: EdgeInsets.all(8),
              child: SvgPicture.asset(
                  'assets/images/border-${borderAssets[index]}.svg',),
            ),
          );
        },
      ),
    );
  }

  BorderRadius borderRadius(int index) {
    switch(index) {
      case 0:
        return BorderRadius.only(topLeft: Radius.circular(8));
      case 2:
        return BorderRadius.only(topRight: Radius.circular(8));
      case 6:
        return BorderRadius.only(bottomLeft: Radius.circular(8));
      case 8:
        return BorderRadius.only(bottomRight: Radius.circular(8));
      default:
        return BorderRadius.zero;
    }
  }

  Widget get annotationText {
    return Text('Tap a border to edit it. Touch and hod to select an additional border.', style: TextStyle(fontSize: 13, color: Colors.grey),);
  }
}
