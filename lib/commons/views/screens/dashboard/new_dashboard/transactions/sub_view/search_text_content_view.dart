import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/transactions/model/Enums.dart';

class SearchTextContentView extends StatefulWidget {
  final InputEventCallback<String> onSelected;
  final String searchText;
  SearchTextContentView({this.searchText, this.onSelected});

  @override
  _SearchTextContentViewState createState() => _SearchTextContentViewState();
}

class _SearchTextContentViewState extends State<SearchTextContentView> {

  TextEditingController searchTextController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    searchTextController.text = widget.searchText;
    return Container(
        height: 120,
        child: Container(
          padding: EdgeInsets.fromLTRB(0 , 6, 0, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFF222222),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Column(
                  children: [
                    Container(
                      height: 65,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child:  TextField(
                        focusNode: searchFocus,
                        controller: searchTextController,
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: 'Search',
                        ),
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                        ),
                        onSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                          widget.onSelected(searchTextController.text);
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    widget.onSelected(searchTextController.text);
                  },
                  child: Container(
                    width: 60,
                    height: 36,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                        widget.searchText.length > 0 ? 'Update': 'Add'),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
