import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/products/widgets/reorderable_variant_item.dart';

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
  List<String> _children;

  @override
  void initState() {
    super.initState();
    _children = List<String>.generate(5, (index) => '$index', growable: true);
  }


  int _oldIndexOfKey(Key key) {
    return _children.indexWhere((String w) => Key(w) == key);
  }

  int _indexOfKey(Key key) {
    return _children.indexWhere((String w) => Key(w) == key);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(),
      body: SafeArea(
        child: BackgroundBase(
          true,
          body: Form(
            key: formKey,
            autovalidate: false,
            child: Container(
              color: Color(0x802c2c2c),
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
              Navigator.pop(context);
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
    return Column(
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
                Wrap(
                  children: <Widget>[
                    ReorderableList(
                      child: ListView.separated(
                        padding: EdgeInsets.all(4),
                        itemCount: 5,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return _buildReorderableItem(context, index);
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
                        int oldIndex = _oldIndexOfKey(draggedItem);
//                     if (_newIndex != null) widget.onReorder(oldIndex, _newIndex);
                        _newIndex = null;
                      },
                    ),
                  ],
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
                    onPressed: () {
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReorderableItem(BuildContext context, int index) {
    return ReorderableVariantItem(
      childrenAlreadyHaveListener: false,
      key: Key('$index'),
      innerItem: Container(
        height: 64,
        color: Colors.transparent,
        child: Row(
          children: <Widget>[

          ],
        ),
      ),
      handleIcon: Icon(Icons.drag_handle),
    );
  }


}