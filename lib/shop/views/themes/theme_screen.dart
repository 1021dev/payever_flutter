import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/shop_filter_screen.dart';
import 'package:payever/shop/widgets/theme_cell.dart';

class ThemesScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final ShopModel activeShop;
  final DashboardScreenBloc dashboardScreenBloc;
  final ShopScreenBloc screenBloc;

  ThemesScreen({
    this.globalStateModel,
    this.screenBloc,
    this.activeShop,
    this.dashboardScreenBloc,
  });

  @override
  createState() => _ThemesScreenState();
}

class _ThemesScreenState extends State<ThemesScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isPortrait;
  bool _isTablet;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    return BlocListener(
      bloc: widget.screenBloc,
      listener: (BuildContext context, ShopScreenState state) async {
        if (state is ShopScreenStateFailure) {
          Fluttertoast.showToast(msg: state.error);
        }
      },
      child: BlocBuilder<ShopScreenBloc, ShopScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, ShopScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(ShopScreenState state) {
    List<ThemeModel> themes = _getThemes(state);
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 44,
            color: Color(0xFF222222),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16),
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () async {
                      await showGeneralDialog(
                        barrierColor: null,
                        transitionBuilder: (context, a1, a2, wg) {
                          final curvedValue =
                              1.0 - Curves.ease.transform(a1.value);
                          return Transform(
                            transform: Matrix4.translationValues(
                                -curvedValue * 200, 0.0, 0),
                            child: ShopFilterScreen(
                              screenBloc: widget.screenBloc,
                            ),
                          );
                        },
                        transitionDuration: Duration(milliseconds: 200),
                        barrierDismissible: true,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation1, animation2) {
                          return null;
                        },
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        Text(
                          'Filter',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                Text(
                  '${themes.length} Themes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: (themes.length > 0)
                ? GridView.count(
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 16),
                    children: themes.map((theme) {
                      return ThemeCell(
                        themeModel: theme,
                        onTapInstall: (theme) {
                          if (state.activeShop != null) {
                            widget.screenBloc.add(InstallTemplateEvent(
                              businessId:
                                  widget.globalStateModel.currentBusiness.id,
                              templateId: theme.id,
                              shopId: state.activeShop.id,
                            ));
                          }
                        },
                        onTapDelete: (theme) {
                          if (state.activeShop != null) {
                            widget.screenBloc.add(DeleteThemeEvent(
                              businessId:
                                  widget.globalStateModel.currentBusiness.id,
                              themeId: theme.id,
                              shopId: state.activeShop.id,
                            ));
                          }
                        },
                        onTapDuplicate: (theme) {
                          if (state.activeShop != null) {
                            widget.screenBloc.add(DuplicateThemeEvent(
                              businessId:
                                  widget.globalStateModel.currentBusiness.id,
                              themeId: theme.id,
                              shopId: state.activeShop.id,
                            ));
                          }
                        },
                        onTapEdit: (theme) {},
                      );
                    }).toList(),
                    crossAxisCount: (_isTablet || !_isPortrait) ? 3 : 2,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  List<ThemeModel> _getThemes(ShopScreenState state) {
    String selectedCategory = state.selectedCategory;
    print('selectedCategory : $selectedCategory');
    List<String> subCategories = state.subCategories;
    if (selectedCategory.isEmpty || selectedCategory == 'All')
      return state.themes;
    else if (selectedCategory == 'My Themes')
      return state.myThemes;
    else {
      if (subCategories.isEmpty)
        return state.themes;
      else {
        List<ThemeModel> themes = [];
        TemplateModel templateModel = state.templates
            .firstWhere((element) => element.code == selectedCategory);
        subCategories.forEach((subCategory) {
          templateModel.items
              .firstWhere((item) => item.code == subCategory)
              .themes
              .forEach((theme) {
            themes.add(theme);
          });
        });
        return themes;
      }
    }
  }
}
