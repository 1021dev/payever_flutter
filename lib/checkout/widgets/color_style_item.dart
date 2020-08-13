
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';

class ColorStyleItem extends StatelessWidget {
  final String title;
  final String icon;
  final bool isExpanded;
  final Function onTap;

  ColorStyleItem({
    this.title,
    this.icon,
    this.isExpanded,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            height: 65,
            color: Colors.black54,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SvgPicture.asset(icon, width: 16,
                  height: 16,),
                SizedBox(width: 10,),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
        ),
        isExpanded ? (
            title == 'Step 3' ?
            Container(
          decoration: BoxDecoration(color: Colors.transparent),
          child: SafeArea(
            top: false,
            bottom: false,
            child: Opacity(
              opacity: 1,
              child: Container(
                height: 50.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                        child: Text(
                            'Confirmation',
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle1),
                      ),
                    ),
                    // Triggers the reordering
                    Container(
                      padding: EdgeInsets.only(right: 18.0, left: 18.0),
                      color: Colors.transparent,
                      child: Center(
                        child: Icon(Icons.reorder, color: Color(0xFF888888)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ):
            Container(
          height: 3 * 50.0,
          child: Container(),
        )
        ): Container(),
      ],
    );
  }


}

class Item extends StatelessWidget {
  Item({
    this.section,
    this.isFirst,
    this.isLast,
    this.draggingMode,
    this.onDelete,
  });

  final Section section;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;
  final Function onDelete;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;
    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = BoxDecoration(color: Colors.transparent);
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Colors.black12);
    }

    // For iOS dragging mode, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = !(section.fixed ?? false) ? (draggingMode == DraggingMode.iOS
        ? ReorderableListener(
      child: Container(
        padding: EdgeInsets.only(right: 18.0, left: 18.0),
        color: Colors.transparent,
        child: Center(
          child: Icon(Icons.reorder, color: Color(0xFF888888)),
        ),
      ),
    )
        : Container()): Container();

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Opacity(
            // hide content for placeholder
            opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: Container(
              height: 50.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    width: 50,
                    child: !(section.fixed ?? false) ? MaterialButton(
                      child: Icon(Icons.remove),
                      onPressed: () {
                        onDelete(section);
                      },
                    ): Container(),
                  ),
                  Expanded(
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                        child: Text(
                            getTitleFromCode(section.code),
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle1),
                      )),
                  // Triggers the reordering
                  dragHandle,
                ],
              ),
            ),
          )),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.Android) {
      content = DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
      key: Key(section.code),
      childBuilder: _buildChild,
    );
  }
}

enum DraggingMode {
  iOS,
  Android,
}