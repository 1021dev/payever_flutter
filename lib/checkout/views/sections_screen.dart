import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/checkout/widgets/section_item.dart';

class SectionsInitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionsScreen();
  }
}

class SectionsScreen extends StatefulWidget {
  @override
  _SectionsScreenState createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  int _selectedSectionIndex = -1;

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SectionItem(
                title: 'Step 1',
                detail: 'Shopping cart details',
                isExpanded: _selectedSectionIndex == 0,
                onTap: () {
                  setState(() {
                    _selectedSectionIndex = _selectedSectionIndex == 0 ? -1 : 0;
                  });
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
                isExpanded: _selectedSectionIndex == 1,
                onTap: () {
                  setState(() {
                    _selectedSectionIndex = _selectedSectionIndex == 0 ? -1 : 0;
                  });
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
                isExpanded: _selectedSectionIndex == 2,
                onTap: () {
                  setState(() {
                    _selectedSectionIndex = _selectedSectionIndex == 0 ? -1 : 0;
                  });
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
                        bottomRight: Radius.circular(10))),
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
    );
  }
}
