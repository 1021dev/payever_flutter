import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';

bool _isPortrait;
bool _isTablet;

class ConnectCategoriesScreen extends StatefulWidget {
  final ConnectScreenBloc screenBloc;

  ConnectCategoriesScreen({
    this.screenBloc,
  });

  @override
  _ConnectCategoriesScreenState createState() => _ConnectCategoriesScreenState();

}

class _ConnectCategoriesScreenState extends State<ConnectCategoriesScreen> {

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

    Map<String, List<NotificationModel>> notifications = {};
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
                  padding: EdgeInsets.only(left: 24),
                  child: Text(
                    'Category',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String category = widget.screenBloc.state.categories[index];

                    return Container(
                      height: 44,
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: SvgPicture.asset(
                              Measurements.channelIcon(category),
                              height: 32,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                          ),
                          Text(
                            Language.getConnectStrings('categories.$category.title'),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container();
                  },
                  itemCount: widget.screenBloc.state.categories.length,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}