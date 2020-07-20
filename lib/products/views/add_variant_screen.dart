import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/library/material_tag_editor.dart';
import 'package:payever/products/widgets/multi_select_formfield.dart';
import 'package:payever/products/widgets/reorderable_variant_item.dart';

import 'add_variant_option_screen.dart';

class AddVariantScreen extends StatefulWidget {

  AddVariantScreen();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddVariantScreenState();
  }
}

class _AddVariantScreenState extends State<AddVariantScreen> {

  bool isLoading = false;
  int _newIndex;
  List<TagVariantItem> _children = [];
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  bool isShownColorPicker = false;
  Map<String, Color> colorsMap = {
    'Blue': Color(0xff0084ff),
    'Green': Color(0xff81d552),
    'Yellow': Color(0xffeebd40),
    'Pink': Color(0xffde68a5),
    'Brown': Color(0xff594139),
    'Black': Color(0xff000000),
    'White': Color(0xffffffff),
    'Grey': Color(0xff434243),
  };

  @override
  void initState() {
    super.initState();
    _children.add(TagVariantItem(name: 'Default', type: 'string', values: [], key: '${_children.length}'));
  }

  int _oldIndexOfKey(Key key) {
    return _children.indexWhere((TagVariantItem w) => Key(w.key) == key);
  }

  int _indexOfKey(Key key) {
    return _children.indexWhere((TagVariantItem w) => Key(w.key) == key);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: SafeArea(
        child: BackgroundBase(
          true,
          body: Form(
            key: formKey,
            autovalidate: false,
            child: Container(
              child: _getBody(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            '+ Add Variant',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            height: 32,
            elevation: 0,
            minWidth: 0,
            color: Colors.black,
            child: Text(
              Language.getProductStrings('cancel'),
            ),
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (builder) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Container(
                      height: 250,
                      child: BlurEffectView(
                        color: Color.fromRGBO(50, 50, 50, 0.4),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Icon(Icons.info),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Text(
                              Language.getPosStrings('Editing Variants'),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Text(
                              Language.getPosStrings('Do you really want to close editing a Variant? Because all data will be lost when unsaved and you will not be able to restore it?'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  height: 24,
                                  elevation: 0,
                                  minWidth: 0,
                                  color: Colors.white10,
                                  child: Text(
                                    Language.getPosStrings('actions.no'),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  height: 24,
                                  elevation: 0,
                                  minWidth: 0,
                                  color: Colors.white10,
                                  child: Text(
                                    Language.getPosStrings('actions.yes'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 8),
        ),
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 0,
            minWidth: 0,
            color: Colors.white24,
            child: isLoading ? Center(
              child: Container(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ) : Text(
              Language.getProductStrings('save'),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: BlurEffectView(
              color: Color.fromRGBO(20, 20, 20, 0.4),
              padding: EdgeInsets.only(top: 12),
              blur: 12,
              radius: 16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ReorderableList(
                    child: ListView.separated(
                      padding: EdgeInsets.all(4),
                      itemCount: _children.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildOptionItems(context, index);
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 0,
                          color: Colors.transparent,
                        );
                      },
                    ),
                    onReorder: (Key draggedItem, Key newPosition) {
                      int draggingIndex = _indexOfKey(draggedItem);
                      int newPositionIndex = _indexOfKey(newPosition);

                      final item = _children[draggingIndex];
                      setState(() {
                        _newIndex = newPositionIndex;
                        _children.removeAt(draggingIndex);
                        _children.insert(newPositionIndex, item);
                      });

                      return true;
                    },
                    onReorderDone: (Key draggedItem) {
                      int draggingIndex = _indexOfKey(draggedItem);
                      int oldIndex = _oldIndexOfKey(draggedItem);
                     if (_newIndex != null) {
                       final item = _children[oldIndex];
                       setState(() {
                         _newIndex = oldIndex;
                         _children.removeAt(draggingIndex);
                         _children.insert(oldIndex, item);
                       });
                     }
                    },
                  ),
                  Divider(
                    height: 0,
                    thickness: 0.5,
                    color: Color(0x80888888),
                  ),
                  Container(
                    height: 64,
                    padding: EdgeInsets.only(bottom: 8, right: 8),
                    alignment: Alignment.centerRight,
                    child: MaterialButton(
                      child: Text(
                        Language.getProductStrings('+ Add option'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          PageTransition(
                            child: AddVariantOptionScreen(),
                            type: PageTransitionType.fade,
                            duration: Duration(milliseconds: 500),
                          ),
                        );

                        if (result != null) {
                          if (result == 'color') {
                            setState(() {
                              _children.add(TagVariantItem(name: 'Color', type: 'color', values: [], key: '${_children.length}'));
                            });
                          } else if (result == 'other') {
                            setState(() {
                              _children.add(TagVariantItem(name: 'Default', type: 'string', values: [], key: '${_children.length}'));
                            });
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItems(BuildContext context, int index) {
    return IntrinsicHeight(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 8, top: 4, bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Container(
                padding: EdgeInsets.only(left: 8, right: 8),
                margin: EdgeInsets.all(1),
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  color: Color(0x80222222),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                ),
                alignment: Alignment.center,
                child: TextFormField(
                  onTap: () {
                    if (isShownColorPicker)
                      Navigator.pop(context);
                    setState(() {
                      isShownColorPicker = false;
                    });
                  },
                  onChanged: (val) {

                  },
                  initialValue: _children[index].name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                      labelText: Language.getProductStrings('Option name'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      border: InputBorder.none
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Color(0x80222222),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                child: _children[index].type == 'string'
                    ? Tags(
                  itemCount: _children[index].values.length,
                  alignment: WrapAlignment.start,
                  spacing: 4,
                  runSpacing: 8,
                  itemBuilder: (int i) {
                    return ItemTags(
                      key: Key('filterItem$i'),
                      index: i,
                      title: _children[index].values[i],
                      color: Colors.white12,
                      activeColor: Colors.white12,
                      textActiveColor: Colors.white,
                      textColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.only(
                        left: 8, top: 4, bottom: 4, right: 8,
                      ),
                      removeButton: ItemTagsRemoveButton(
                          backgroundColor: Colors.transparent,
                          onRemoved: () {
                            return true;
                          }
                      ),
                    );
                  },
                  textField: TagsTextField(
                    hintText: '',
                    autofocus: false,
                    onChanged: (val) {
                      if (isShownColorPicker)
                        Navigator.pop(context);
                      setState(() {
                        isShownColorPicker = false;
                      });
                    },
                    textStyle: TextStyle(
                      fontSize: 14,
                      //height: 1
                    ),
                    enabled: true,
                    inputDecoration: InputDecoration(
                      hintText: '',
                      labelText: 'Option value',
                      border: InputBorder.none,
                    ),
                    constraintSuggestion: false,
                    suggestions: null,
                    onSubmitted: (String str) {
                      setState(() {
                        List<String> values = _children[index].values;
                        values.add(str);
                        _children[index].values = values;
                      });
                    },
                  ),
                ): Container(
                  child: MultiSelectFormField(
                    autovalidate: false,
                    titleText: 'Color options',
                    okButtonLabel: 'OK',
                    cancelButtonLabel: 'CANCEL',
                    // required: true,
                    hintText: 'Please choose one or more',
                    initialValue: [_children[index].values, colorsMap],
                    onSaved: (value) {
                      if (value == null) return;
                      setState(() {
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: MaterialButton(
                onPressed: () {

                },
                minWidth: 0,
                child: SvgPicture.asset(
                  'assets/images/xsinacircle.svg',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReorderableItem(BuildContext context, int index) {
    return ReorderableVariantItem(
      childrenAlreadyHaveListener: false,
      key: Key('$index'),
      innerItem: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 8,
          top: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0x80111111),
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextFormField(
                onTap: () {
                  if (isShownColorPicker)
                    Navigator.pop(context);
                  setState(() {
                    isShownColorPicker = false;
                  });
                },
                onChanged: (val) {

                },
                initialValue: _children[index].name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  fillColor: Color(0x80111111),
                  labelText: Language.getProductStrings('Option name'),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w200,
                  ),
                  border: InputBorder.none
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(
                  left: 4, right: 4, top: 8, bottom: 8,
                ),
                child: _children[index].type == 'string'
                    ? Tags(
                  itemCount: _children[index].values.length,
                  alignment: WrapAlignment.start,
                  spacing: 4,
                  runSpacing: 8,
                  itemBuilder: (int i) {
                    return ItemTags(
                      key: Key('filterItem$i'),
                      index: i,
                      title: _children[index].values[i],
                      color: Colors.white12,
                      activeColor: Colors.white12,
                      textActiveColor: Colors.white,
                      textColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.only(
                        left: 8, top: 4, bottom: 4, right: 8,
                      ),
                      removeButton: ItemTagsRemoveButton(
                          backgroundColor: Colors.transparent,
                          onRemoved: () {
                            return true;
                          }
                      ),
                    );
                  },
                  textField: TagsTextField(
                    hintText: '',
                    autofocus: false,
                    onChanged: (val) {
                      if (isShownColorPicker)
                        Navigator.pop(context);
                      setState(() {
                        isShownColorPicker = false;
                      });

                    },
                    textStyle: TextStyle(
                      fontSize: 14,
                      //height: 1
                    ),
                    enabled: true,
                    inputDecoration: InputDecoration(
                      hintText: '',
                      labelText: 'Option value',
                      border: InputBorder.none,
                    ),
                    constraintSuggestion: false,
                    suggestions: null,
                    onSubmitted: (String str) {
                      setState(() {
                        List<String> values = _children[index].values;
                        values.add(str);
                        _children[index].values = values;
                      });
                    },
                  ),
                ): Container(
                  child: MultiSelectFormField(
                    autovalidate: false,
                    titleText: 'Color options',
                    okButtonLabel: 'OK',
                    cancelButtonLabel: 'CANCEL',
                    // required: true,
                    hintText: 'Please choose one or more',
                    initialValue: [_children[index].values, colorsMap],
                    onSaved: (value) {
                      if (value == null) return;
                      setState(() {
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      handleIcon: Icon(Icons.drag_handle),
    );
  }
}

class TagVariantItem {
  TagVariantItem({
    this.name,
    this.type,
    this.values = const [],
    this.key,
  });
  final String key;
  final String name;
  final String type;
  List<String> values;
}

class VariantColorOption {
  final String title;
  final Color color;
  final bool checked;
  
  VariantColorOption({
    this.title,
    this.color,
    this.checked,
  });
}