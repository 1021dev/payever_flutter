import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';

bool _isPortrait;
bool _isTablet;

class WallpaperCategoriesScreen extends StatefulWidget {
  final SettingScreenBloc screenBloc;
  WallpaperCategoriesScreen({
    this.screenBloc,
  });

  @override
  _WallpaperCategoriesScreenState createState() => _WallpaperCategoriesScreenState();

}

class _WallpaperCategoriesScreenState extends State<WallpaperCategoriesScreen> {

  String selectedCategory = '';
  @override
  void initState() {
    selectedCategory = widget.screenBloc.state.selectedCategory;
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

    return new OrientationBuilder(builder: (context, orientation) {
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
                          widget.screenBloc.add(WallpaperCategorySelected(category: selectedCategory));
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 24),
                              height: 44,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'My Wallpapers',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    height: 24,
                                    minWidth: 60,
                                    color: Colors.grey,
                                    child: Text(
                                      'Add',
                                    ),
                                  ),
                                  SizedBox(width: 10,)
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 24),
                              height: 44,
                              child: Text(
                                'All Wallpapers',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            itemBuilder: (context, index) {
                              String category = widget.screenBloc.state.wallpaperCategories[index].code;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = category;
                                  });
                                },
                                child: Container(
                                  height: 44,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: selectedCategory == category ? Color(0x26FFFFFF): Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
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
                                        getMainCategory(category),
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Container();
                            },
                            itemCount: widget.screenBloc.state.wallpaperCategories.length,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    );
  }
  
  String getMainCategory(String code) {
    code = code.replaceAll('BUSINESS_PRODUCT_', '');
    code = code.replaceAll('_', ' ');
    return code;
  }
}