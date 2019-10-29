
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchBar extends StatefulWidget {
  final Function onSubmit;
  final TextEditingController controller;
  const SearchBar({this.onSubmit, this.controller});
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        border: InputBorder.none,
        suffixIcon: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.close,
            size: 20,
            color: widget.controller.text.isNotEmpty
                ? Colors.white
                : Colors.transparent,
          ),
          onPressed: () {
            if (widget.controller.text.isNotEmpty) {
              widget.controller.clear();
              widget.onSubmit("");
            }
          },
        ),
        prefixIcon: IconButton(
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            "assets/images/searchicon.svg",
            color: Colors.white,
            height: 20,
          ),
          onPressed: () {},
        ),
      ),
      onChanged: (_) => setState(() {}),
      controller: widget.controller,
      onSubmitted: (doc) => widget.onSubmit(doc),
    );
  }
}
