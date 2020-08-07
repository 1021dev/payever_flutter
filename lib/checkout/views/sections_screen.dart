import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/widgets/section_detail_item.dart';
import 'package:payever/checkout/widgets/section_item.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';

class SectionsScreen extends StatefulWidget {
  final CheckoutScreenBloc checkoutScreenBloc;

  SectionsScreen({this.checkoutScreenBloc,});
  @override
  _SectionsScreenState createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  bool isExpandedSection1 = false;
  bool isExpandedSection2 = false;
  bool isExpandedSection3 = false;

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SectionItem(
                  title: 'Step 1',
                  detail: 'Shopping cart details',
                  isExpanded: isExpandedSection1,
                  onTap: () {
                    setState(() {
                      isExpandedSection1 = !isExpandedSection1;
                    });
                  },
                  sections: widget.checkoutScreenBloc.state.sections1,
                  onReorder: (oldIndex, newIndex) {
                    widget.checkoutScreenBloc.add(ReorderSection1Event(oldIndex: oldIndex, newIndex: newIndex));
                  },
                  onDelete: (Section section) {

                  },
                ),
                Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                SectionItem(
                  title: 'Step 2',
                  detail: 'Customer & payment details',
                  isExpanded: isExpandedSection2,
                  onTap: () {
                    setState(() {
                      isExpandedSection2 = !isExpandedSection2;
                    });
                  },
                  sections: widget.checkoutScreenBloc.state.sections2,
                  onReorder: (oldIndex, newIndex) {
                    widget.checkoutScreenBloc.add(ReorderSection1Event(oldIndex: oldIndex, newIndex: newIndex));
                  },
                  onDelete: (Section section) {

                  },
                ),
                Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                SectionItem(
                  title: 'Step 3',
                  detail: 'After sale details',
                  isExpanded: isExpandedSection3,
                  onTap: () {
                    setState(() {
                      isExpandedSection3 = isExpandedSection3;
                    });
                  },
                  sections: widget.checkoutScreenBloc.state.sections3,
                  onReorder: (oldIndex, newIndex) {
                    widget.checkoutScreenBloc.add(ReorderSection1Event(oldIndex: oldIndex, newIndex: newIndex));
                  },
                  onDelete: (Section section) {

                  },
                ),
                Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                Container(
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: MaterialButton(
                    onPressed: () {},
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
