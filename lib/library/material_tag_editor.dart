library material_tag_editor;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import './tag_editor_layout_delegate.dart';
import './tag_layout.dart';

/// A Wiget for editing tag similar to Google's Gmail
/// email address input widget in iOS app
/// TODO: Support remove while typing
class TagEditor<T> extends StatefulWidget {
  const TagEditor({
    @required this.length,
    @required this.tagBuilder,
    this.hasAddButton = true,
    this.delimeters = const [],
    this.icon,
    this.enabled = true,
    this.options = const [],
    this.selected = const [],
    @required this.onTap,
  });

  final int length;
  final Chip Function(BuildContext, int) tagBuilder;
  final bool hasAddButton;
  final List<String> delimeters;
  final IconData icon;
  final bool enabled;
  final List<T> options;
  final List<T> selected;
  final Function onTap;

  @override
  _TagEditorState createState() => _TagEditorState();
}

class _TagEditorState extends State<TagEditor> {

  List<TagPopupItem> popUpActions(BuildContext context){
    return widget.options.map((option) {
      bool checked = false;
      widget.selected.forEach((sel) {
        if (option == sel) {
          checked = true;
        }
      });
      return TagPopupItem(
          title: option,
          check: checked,
          value: option,
          onTap: (t) {
            widget.onTap(t.value);
          }      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
  }


  void _onTagChanged(String string) {
    if (string.isNotEmpty) {
    }
  }

  /// Shamelessly copied from [InputDecorator]
  Color _getDefaultIconColor(ThemeData themeData) {
    if (!widget.enabled) {
      return themeData.disabledColor;
    }

    switch (themeData.brightness) {
      case Brightness.dark:
        return Colors.white70;
      case Brightness.light:
        return Colors.black45;
      default:
        return themeData.iconTheme.color;
    }
  }

  /// Shamelessly copied from [InputDecorator]
  Color _getActiveColor(ThemeData themeData) {
    return themeData.hintColor;
  }

  Color _getIconColor(ThemeData themeData) {
    final themeData = Theme.of(context);
    final activeColor = _getActiveColor(themeData);
    return _getDefaultIconColor(themeData);
  }

  @override
  Widget build(BuildContext context) {
    final tagEditorArea = Container(
      child: TagLayout(
        delegate: TagEditorLayoutDelegate(length: widget.length),
        children: List<Widget>.generate(
              widget.length,
              (index) => LayoutId(
                id: TagEditorLayoutDelegate.getTagId(index),
                child: widget.tagBuilder(context, index),
              ),
            ) +
            <Widget>[
              LayoutId(
                id: TagEditorLayoutDelegate.textFieldId,
                child: PopupMenuButton<TagPopupItem>(
                  icon: Icon(Icons.add),
                  offset: Offset(0, 100),
                  onSelected: (TagPopupItem item) => item.onTap(item),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.black87,
                  itemBuilder: (BuildContext context) {
                    return popUpActions(context).map((item) {
                      return PopupMenuItem<TagPopupItem>(
                        value: item,
                        child: Row(
                          children: <Widget>[
                            item.check ? Icon(Icons.check_box): Icon(Icons.check_box_outline_blank),
                            Padding(
                              padding: EdgeInsets.only(left: 4),
                            ),
                            CircleAvatar(
                              child: Container(
                                width: 16,
                                height: 16,
                                color: Colors.red,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4),
                            ),
                            Text(
                              item.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
              )
            ],
      ),
    );

    return widget.icon == null
        ? tagEditorArea
        : Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.zero,
                  child: IconTheme.merge(
                    data: IconThemeData(
                      color: _getIconColor(Theme.of(context)),
                      size: 18.0,
                    ),
                    child: Icon(widget.icon),
                  ),
                ),
                Expanded(child: tagEditorArea),
              ],
            ),
          );
  }
}
class TagPopupItem {
  String title;
  bool check;
  String value;
  Function onTap;

  TagPopupItem({this.title = '', this.check = false, this.value = '', this.onTap});
}