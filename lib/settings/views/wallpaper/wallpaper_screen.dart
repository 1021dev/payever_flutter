import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/views/wallpaper/wallpaper_categories_screen.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/blocs/bloc.dart';

class WallpaperScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;
  final bool fromDashboard;

  WallpaperScreen(
      {this.globalStateModel, this.setScreenBloc, this.fromDashboard = false});

  @override
  _WallpaperScreenState createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  bool isGridMode = true;
  bool _isPortrait;
  bool _isTablet;

  @override
  void initState() {
    super.initState();
    widget.setScreenBloc.add(FetchWallpaperEvent());
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.fromDashboard) widget.setScreenBloc.close();
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
      bloc: widget.setScreenBloc,
      listener: (BuildContext context, SettingScreenState state) async {
        if (state is SettingScreenStateFailure) {
          Fluttertoast.showToast(msg: state.error);
        }
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (BuildContext context, SettingScreenState state) {
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomPadding: false,
            appBar: Appbar('Wallpapers'),
            body: SafeArea(
              child: BackgroundBase(
                true,
                backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
                body: state.isLoading ||
                        state.wallpapers == null ||
                        state.isUpdating
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _getBody(state),
              ),
            ),
          );
        },
      ),
    );
  }

  List<OverflowMenuItem> appBarPopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      OverflowMenuItem(
        title: 'List',
        iconData: 'assets/images/list.svg',
        onTap: () {
          setState(() {
            isGridMode = false;
          });
        },
      ),
      OverflowMenuItem(
        title: 'Grid',
        iconData: 'assets/images/grid.svg',
        onTap: () {
          setState(() {
            isGridMode = true;
          });
        },
      ),
    ];
  }

  Widget _getBody(SettingScreenState state) {
    List<Wallpaper> wallpapers = _getWallpapers(state);
    return Column(
      children: [
        _secondAppBar(state),
        Visibility(
          visible: isGridMode ? false : true,
          child: Container(
            height: 50,
            color: Colors.black45,
            child: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Text('Wallpaper'),
                Spacer(),
                Text('Industry'),
                Spacer(),
                SizedBox(
                  width: 60,
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: isGridMode
                ? GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        _gridItemBuilder(state, wallpapers[index]),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1 / 1, crossAxisCount: _isTablet || !_isPortrait ? 4: 2),
                    itemCount: wallpapers.length)
                : ListView.builder(
                    itemCount: wallpapers.length,
                    itemBuilder: (context, index) =>
                        _listItemBuilder(state, wallpapers[index])),
          ),
        ),
      ],
    );
  }

  Widget _secondAppBar(SettingScreenState state) {
    return Container(
      height: 50,
      color: Colors.black38,
      child: Row(
        children: [
          SizedBox(
            width: 8,
          ),
          IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () async {
                await showGeneralDialog(
                  barrierColor: null,
                  transitionBuilder: (context, a1, a2, wg) {
                    final curvedValue = 1.0 - Curves.ease.transform(a1.value);
                    return Transform(
                      transform:
                          Matrix4.translationValues(-curvedValue * 200, 0.0, 0),
                      child: WallpaperCategoriesScreen(
                        screenBloc: widget.setScreenBloc,
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
              }),
          FlatButton(
            onPressed: () {},
            child: Text(
              'Reset',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Row(
                children: [
                  IconButton(icon: Icon(Icons.search), onPressed: () => {}),
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(fontSize: 16),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Search wallpapers',
                        border: InputBorder.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          PopupMenuButton<OverflowMenuItem>(
            icon: SvgPicture.asset(isGridMode
                ? 'assets/images/grid.svg'
                : 'assets/images/list.svg'),
            offset: Offset(0, 100),
            onSelected: (OverflowMenuItem item) => item.onTap(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.black87,
            itemBuilder: (BuildContext context) {
              return appBarPopUpActions(context, state)
                  .map((OverflowMenuItem item) {
                return PopupMenuItem<OverflowMenuItem>(
                  value: item,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SvgPicture.asset(item.iconData),
                    ],
                  ),
                );
              }).toList();
            },
          ),
          SizedBox(
            width: 8,
          )
        ],
      ),
    );
  }

  Widget _gridItemBuilder(SettingScreenState state, Wallpaper wallpaper) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: CachedNetworkImage(
              imageUrl:
                  '${Env.storage}/wallpapers/${wallpaper.wallpaper}',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              placeholder: (context, url) =>
                  Container(child: Center(child: CircularProgressIndicator())),
            ),
          ),
          GestureDetector(
            onTap: () {
              updateWallpaper(wallpaper);
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              child: Text('Set'),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
            ),
          )
        ],
      ),
    );
  }

  Widget _listItemBuilder(SettingScreenState state, Wallpaper wallpaper) {
    return Column(
      children: <Widget>[
        Container(
          height: 70,
          child: Row(
            children: [
              SizedBox(
                width: 14,
              ),
              Container(
                height: 50,
                width: 50,
                child: CachedNetworkImage(
                  imageUrl:
                      '${Env.storage}/wallpapers/${wallpaper.wallpaper}',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                      child: Center(child: CircularProgressIndicator())),
                ),
              ),
              Spacer(),
              Text(wallpaper.industry.toString().toUpperCase()),
              Spacer(),
              InkWell(
                onTap: () {
                  updateWallpaper(wallpaper);
                },
                child: Container(
                  height: 20,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withAlpha(100)),
                  child: Center(
                    child: Text(
                      'Set',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ),
        Divider(height: 1, color: Colors.white.withOpacity(0.5)),
      ],
    );
  }

  List<Wallpaper> _getWallpapers(SettingScreenState state) {
    String selectedCategory = state.selectedCategory;
    List<String>subCategories = state.subCategories;
    if (selectedCategory.isEmpty || selectedCategory == 'All')
      return state.wallpapers;
    else if (selectedCategory == 'My Wallpapers')
      return state.myWallpapers;
    else {
      if (subCategories.isEmpty)
        return state.wallpapers;
      else {
        List<Wallpaper> wallpapers = [];
        WallpaperCategory wallpaperCategory = state.wallpaperCategories.where((element) => element.code == selectedCategory).toList().first;
        subCategories.forEach((subCategory) {
          wallpaperCategory.industries.where((industry) => industry.code == subCategory).toList().first.wallpapers.forEach((wallpaper) {
            wallpapers.add(wallpaper);
          });
        });
        return wallpapers;
      }
    }
  }

  void updateWallpaper(Wallpaper wallpaper) {
    widget.setScreenBloc.add(UpdateWallpaperEvent(body: wallpaper.toDictionary()));
  }
}

class OverflowMenuItem {
  final String title;
  final Color textColor;
  final String iconData;
  final Function onTap;

  OverflowMenuItem({
    this.title,
    this.iconData,
    this.textColor = Colors.black,
    this.onTap,
  });
}
