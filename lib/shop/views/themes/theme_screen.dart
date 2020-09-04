import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/shop_filter_screen.dart';
import 'package:payever/shop/widgets/theme_cell.dart';
import 'package:payever/theme.dart';

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

  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  double iconSize;
  double margin;
  bool isGridMode = true;

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

    iconSize = _isTablet ? 120: 80;
    margin = _isTablet ? 24: 16;

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

  Widget _topBar(ShopScreenState state) {
    String itemsString = '';
    int selectedCount = 0;
    if (state.themeListModels.length > 0) {
      selectedCount = state.themeListModels.where((element) => element.isChecked).toList().length;
    }
    itemsString = '${state.themeListModels.length} items';
    return selectedCount == 0 ? Container(
      height: 64,
      color: Color(0xFF212122),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                onTap: () async {
                  await showGeneralDialog(
                    barrierColor: null,
                    transitionBuilder: (context, a1, a2, wg) {
                      final curvedValue = 1.0 - Curves.ease.transform(a1.value);
                      return Transform(
                        transform: Matrix4.translationValues(-curvedValue * 200, 0.0, 0),
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
                child: Container(
                  padding: EdgeInsets.all(margin),
                  child: SvgPicture.asset(
                    'assets/images/filter.svg',
                    width: 12,
                    height: 12,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: Container(
                  width: 1,
                  color: Color(0xFF888888),
                  height: 24,
                ),
              ),
              InkWell(
                onTap: () {

                },
                child: Text(
                  'Reset',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12),
              ),
              Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: Measurements.width / 2, maxHeight: 36, minHeight: 36),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFF111111),
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: SvgPicture.asset(
                        'assets/images/search_place_holder.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: searchFocus,
                        controller: searchTextController,
                        autofocus: false,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search in Themes',
                          isDense: true,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                        onSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      !_isTablet && _isPortrait ? '' : itemsString,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton<MenuItem>(
                    icon: SvgPicture.asset(isGridMode
                        ? 'assets/images/grid.svg'
                        : 'assets/images/list.svg', color: iconColor(),),
                    offset: Offset(0, 100),
                    onSelected: (MenuItem item) => item.onTap(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: overlayBackground().withOpacity(1),
                    itemBuilder: (BuildContext context) {
                      return appBarPopUpActions(context, state)
                          .map((MenuItem item) {
                        return PopupMenuItem<MenuItem>(
                          value: item,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              item.icon,
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ): Container(
      height: 64,
      color: Color(0xFF212122),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            onPressed: () {
              widget.screenBloc.add(SelectAllThemesEvent(isSelect: true));
            },
            child: Text(
              'Select all',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            height: 36,
            width: 0.5,
            color: Colors.white38,
          ),
          MaterialButton(
            onPressed: () {
              widget.screenBloc.add(SelectAllThemesEvent(isSelect: false));
            },
            child: Text(
              'Deselect all',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            height: 36,
            width: 0.5,
            color: Colors.white38,
          ),
          MaterialButton(
            onPressed: () {
              // screenBloc.add(DeleteSelectedContactsEvent());
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  List<MenuItem> appBarPopUpActions(
      BuildContext context, ShopScreenState state) {
    return [
      MenuItem(
        title: 'List',
        icon: SvgPicture.asset('assets/images/list.svg', color: iconColor(),),
        onTap: () {
          setState(() {
            isGridMode = false;
          });
        },
      ),
      MenuItem(
        title: 'Grid',
        icon: SvgPicture.asset('assets/images/grid.svg', color: iconColor(),),
        onTap: () {
          setState(() {
            isGridMode = true;
          });
        },
      ),
    ];
  }

  Widget _body(ShopScreenState state) {
    List<ThemeListModel> themes = _getThemes(state);
    return Container(
      child: Column(
        children: <Widget>[
          // Container(
          //   height: 44,
          //   color: Color(0xFF222222),
          //   child: Stack(
          //     alignment: Alignment.center,
          //     children: <Widget>[
          //       Container(
          //         padding: EdgeInsets.only(left: 16),
          //         alignment: Alignment.centerLeft,
          //         child: InkWell(
          //           onTap: () async {
          //             await showGeneralDialog(
          //               barrierColor: null,
          //               transitionBuilder: (context, a1, a2, wg) {
          //                 final curvedValue =
          //                     1.0 - Curves.ease.transform(a1.value);
          //                 return Transform(
          //                   transform: Matrix4.translationValues(
          //                       -curvedValue * 200, 0.0, 0),
          //                   child: ShopFilterScreen(
          //                     screenBloc: widget.screenBloc,
          //                   ),
          //                 );
          //               },
          //               transitionDuration: Duration(milliseconds: 200),
          //               barrierDismissible: true,
          //               barrierLabel: '',
          //               context: context,
          //               pageBuilder: (context, animation1, animation2) {
          //                 return null;
          //               },
          //             );
          //           },
          //           child: Row(
          //             children: <Widget>[
          //               Icon(
          //                 Icons.filter_list,
          //                 color: Colors.white,
          //               ),
          //               Padding(
          //                 padding: EdgeInsets.only(left: 8),
          //               ),
          //               Text(
          //                 'Filter',
          //                 style: TextStyle(color: Colors.white),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //       Text(
          //         '${themes.length} Themes',
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //           fontWeight: FontWeight.w400,
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          _topBar(state),
          Expanded(
            child: (themes.length > 0)
                ? GridView.count(
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 16),
                    children: themes.map((theme) {
                      return ThemeCell(
                        themeListModel: theme,
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
                        onCheck: (ThemeListModel model) {
                          widget.screenBloc.add(SelectThemeEvent(model: model));
                        },
                        onTapEdit: (theme) {},
                      );
                    }).toList(),
                    crossAxisCount: (_isTablet || !_isPortrait) ? 3 : 2,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 4/5,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  List<ThemeListModel> _getThemes(ShopScreenState state) {
    String selectedCategory = state.selectedCategory;
    print('selectedCategory : $selectedCategory');
    List<String> subCategories = state.subCategories;
    if (selectedCategory.isEmpty || selectedCategory == 'All')
      return state.themeListModels;
    else if (selectedCategory == 'My Themes') {
      List<ThemeListModel> themeListModels = [];
      state.myThemes.forEach((theme) => themeListModels
          .add(ThemeListModel(themeModel: theme, isChecked: false)));
      return themeListModels;
    } else {
      if (subCategories.isEmpty)
        return state.themeListModels;
      else {
        List<ThemeListModel> themeListModels = [];
        TemplateModel templateModel = state.templates
            .firstWhere((element) => element.code == selectedCategory);
        subCategories.forEach((subCategory) {
          templateModel.items
              .firstWhere((item) => item.code == subCategory)
              .themes
              .forEach((theme) {
            themeListModels.add(ThemeListModel(themeModel: theme, isChecked: false));
          });
        });
        return themeListModels;
      }
    }
  }
}
