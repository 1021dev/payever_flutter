import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';

class TableStyleView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Map<String, dynamic> stylesheets;

  const TableStyleView({@required this.screenBloc, @required this.stylesheets,});

  @override
  _TableStyleViewState createState() => _TableStyleViewState();
}

class _TableStyleViewState extends State<TableStyleView> {
  bool isPortrait;
  bool isTablet;
  TextEditingController rowController;
  TextEditingController columnController;
  TableStyles styles;

  @override
  void initState() {
    styles = TableStyles.fromJson(widget.stylesheets);
    rowController = TextEditingController(text: '${styles.rowCount}');
    columnController = TextEditingController(text: '${styles.columnCount}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          gridView,
          headerFooter,
          Divider(
            height: 0,
            thickness: 0.5,
          ),
          rowCount,
          columnCount,
          SizedBox(height: 32,)
        ],
      ),
    );
  }

  Widget get gridView {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      child: GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        crossAxisCount: isTablet ? 5 : (isPortrait ? 3 : 5),
        crossAxisSpacing: isTablet ? 40 : (isPortrait ? 40 : 40),
        mainAxisSpacing: isTablet ? 20 : (isPortrait ? 20 : 20),
        childAspectRatio: 1 / 0.7,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
          6,
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
                Map<String, dynamic> sheets = widget.stylesheets;
                sheets['headerColumnColor'] = headerColumnColor;
                sheets['headerRowColor'] = headerRowColor;
                _updateStyles(sheets);
              },
              child: Image.asset(
                  'assets/images/table-style-${index + 1}.png'),
            );
          },
        ),
      ),
    );
  }

  Widget get headerFooter {
    return Container(
      height: 50,
      child: Row(
        children: [
          Expanded(child: Text('Headers & Footer', style: TextStyle(fontSize: 15, color: Colors.white),)),
          Icon(Icons.arrow_forward_ios, color: Colors.grey,),
        ],
      ),
    );
  }

  Widget get rowCount {
    return Container(
      height: 60,
      child: Row(
        children: [
          Expanded(
              child: Text('Row',
                  style: TextStyle(fontSize: 15, color: Colors.white))),
          Container(
            width: 30,
            alignment: Alignment.centerRight,
            child: TextField(
              controller: rowController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                isDense: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              style: TextStyle(fontSize: 15, color: Colors.blue),
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              textAlign: TextAlign.center,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  Map<String, dynamic> sheets = widget.stylesheets;
                  sheets['rowCount'] = int.parse(value);
                  _updateStyles(sheets);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget get columnCount {
    return Row(
      children: [
        Expanded(
            child: Text('Column',
                style: TextStyle(fontSize: 15, color: Colors.white))),
        Container(
          width: 30,
          alignment: Alignment.centerRight,
          child: TextField(
            controller: columnController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            style: TextStyle(fontSize: 15, color: Colors.blue),
            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
            textAlign: TextAlign.center,
            onChanged: (value) {
              if (value.isNotEmpty) {
                Map<String, dynamic> sheets = widget.stylesheets;
                sheets['columnCount'] = int.parse(value);
                _updateStyles(sheets);
              }
            },
          ),
        ),
      ],
    );
  }

  _updateStyles(Map<String, dynamic> sheets) {
    ShopEditScreenState state = widget.screenBloc.state;
    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        state.selectedChild.id, sheets, state.activeShopPage.stylesheetIds);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }
}
