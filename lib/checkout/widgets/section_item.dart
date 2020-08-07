import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16,),
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
        isExpanded ? Container(
          height: title == 'Step 3' ? 1: sections.length * 50.0,
          child: ReorderableListView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: title == 'Step 3' ? List.generate(1, (index) {
              return Container(
                key: Key('$title$index'),
                height: 50,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 64,
                    ),
                    Flexible(
                      child: Text(
                        'Confirmation',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }): List.generate(sections.length, (index) {
              Section section = sections[index];
              print(section.code);
              return Container(
                padding: EdgeInsets.only(left: 16, right: 16,),
                key: Key('$title$index'),
                height: 50,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 64,
                      child: sections[index].fixed ? Container(): MaterialButton(
                        onPressed: onDelete(sections[index]),
                        child: Center(
                          child: Icon(Icons.remove),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        getTitleFromCode(sections[index].code),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            ),
            onReorder: onReorder,
          ),
        ): Container(),
      ],
    );
  }
}
