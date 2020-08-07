
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';

class SectionItem extends StatelessWidget {
  final String title;
  final String detail;
  final bool isExpanded;
  final Function onTap;
  final List<Section> sections;
  final ReorderCallback onReorder;
  final Function onDelete;

  SectionItem({
    this.title,
    this.detail,
    this.isExpanded,
    this.onTap,
    this.sections = const [],
    this.onReorder,
    this.onDelete,
  });

  DraggingMode _draggingMode = DraggingMode.iOS;

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
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  width: 24,
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          detail,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 24,
                            minWidth: 0,
                            padding: EdgeInsets.only(left: 12, right: 12),
                            child: Text(
                              Language.getCheckoutStrings('checkout_sdk.action.edit'),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Icon(
                            isExpanded ? Icons.remove : Icons.add,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        isExpanded ? (title == 'Step 3' ?  Container(
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
        ): Container(
          height: sections.length * 50.0,
          child: ReorderableList(
          onReorder: this._reorderCallback,
            onReorderDone: this._reorderDone,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            Section section = sections[index];
                        return Item(
                          section: section,
                          // first and last attributes affect border drawn during dragging
                          isFirst: index == 0,
                          isLast: index == sections.length - 1,
                          draggingMode: _draggingMode,
                        );
                      },
                      childCount: sections.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        ): Container(),
      ],
    );
  }

  int _indexOfKey(Key key) {
    return sections.indexWhere((Section d) => Key(d.code) == key);
  }
  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);
    onReorder(draggingIndex, newPositionIndex);
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = sections[_indexOfKey(item)];
  }

}

class Item extends StatelessWidget {
  Item({
    this.section,
    this.isFirst,
    this.isLast,
    this.draggingMode,
  });

  final Section section;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;

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
                    child: !(section.fixed ?? false) ? Icon(Icons.remove): Container(),
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