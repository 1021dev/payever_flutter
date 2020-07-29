import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';

bool _isPortrait;
bool _isTablet;

class ContactsFilterScreen extends StatefulWidget {
  final ContactScreenBloc screenBloc;
  ContactsFilterScreen({
    this.screenBloc,
  });

  @override
  _ContactsFilterScreenState createState() => _ContactsFilterScreenState();

}

class _ContactsFilterScreenState extends State<ContactsFilterScreen> {

  String selectedCategory = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    return Scaffold(
      backgroundColor: Color(0x80111111),
      resizeToAvoidBottomPadding: false,
      body: BlurEffectView(
        radius: 0,
        color: Colors.transparent,
        child: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 44,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Icon(Icons.close),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Text(
                            'Reset',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(24),
                  height: 44,
                  constraints: BoxConstraints.expand(height: 44),
                  child: SizedBox(
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Color(0xFF525151),
                      child: Text(
                        'Done',
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 24, bottom: 16),
                  child: Text(
                    'Category',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
//                          setState(() {
//                            selectedCategory = category;
//                          });
                        },
                        child: Container(
                          height: 44,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0x26FFFFFF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: <Widget>[
//                              Container(
//                                child: SvgPicture.asset(
//                                  Measurements.channelIcon(category),
//                                  height: 32,
//                                ),
//                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                              ),
                              Text(
                                Language.getConnectStrings('.title'),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container();
                    },
                    itemCount: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}