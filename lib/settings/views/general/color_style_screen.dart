import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';

class ColorStyleScreen extends StatefulWidget {

  final SettingScreenBloc settingBloc;
  ColorStyleScreen({this.settingBloc,});

  _ColorStyleScreenState createState() => _ColorStyleScreenState();

}

class _ColorStyleScreenState extends State<ColorStyleScreen> {

  Business business;
  ThemeSetting setting;

  String primaryColor;
  String secondaryColor;

  bool selected = true;
  @override
  void initState() {
    business = widget.settingBloc.dashboardScreenBloc.state.activeBusiness;
    setting = business.themeSettings;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.settingBloc,
      listener: (BuildContext context, SettingScreenState state) async {
        if (state is SettingScreenStateSuccess) {
          Navigator.pop(context);
        } else if (state is SettingScreenStateFailure) {

        }
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.settingBloc,
        builder: (BuildContext context, SettingScreenState state) {
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomPadding: false,
            appBar: _appBar(state),
            body: SafeArea(
              child: BackgroundBase(
                true,
                backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
                body: state.isLoading ?
                Center(
                  child: CircularProgressIndicator(),
                ): Center(
                  child: _getBody(state),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(SettingScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Text(
        'Color and style',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody(SettingScreenState state) {
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          radius: 20,
          child: Wrap(
            children: <Widget>[
              BlurEffectView(
                color: Color.fromRGBO(100, 100, 100, 0.05),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Container(
                  height: 56,
                  color: Colors.black38,
                  child: SizedBox.expand(
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          selected = !selected;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                ),
                                SvgPicture.asset(
                                  'assets/images/grid.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                ),
                                Expanded(
                                  child: Text(
                                    'Theme',
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            selected ? Icons.remove : Icons.add,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              selected ? Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Colors',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Primary color',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  showDialog(
                                    context: context,
                                    child: AlertDialog(
                                      title: const Text('Pick a color!'),
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: colorConvert(primaryColor),
                                          onColorChanged: (val) {
                                            setState(() {
                                              primaryColor = '${val.value.toRadixString(16)}';
                                            });
                                          },
                                          showLabel: true,
                                          pickerAreaHeightPercent: 0.8,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: const Text('Got it'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 15),
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: colorConvert(primaryColor),
                                    border: Border.all(width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Secondary color',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  showDialog(
                                    context: context,
                                    child: AlertDialog(
                                      title: const Text('Pick a color!'),
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: colorConvert(secondaryColor),
                                          onColorChanged: (val) {
                                            setState(() {
                                              secondaryColor = '${val.value.toRadixString(16)}';
                                            });
                                          },
                                          showLabel: true,
                                          pickerAreaHeightPercent: 0.8,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: const Text('Got it'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 15),
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: colorConvert(secondaryColor),
                                    border: Border.all(width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ) : Container(),
              selected ? Container(
                height: 50,
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () {
                      if (!state.isUpdating) {
                        widget.settingBloc.add(
                            BusinessUpdateEvent({
                              'themeSettings': {
                                'primaryColor': primaryColor,
                                'secondaryColor': secondaryColor,
                                '_id': setting.id,
                              }
                            })
                        );
                      }
                    },
                    color: Colors.black,
                    child: state.isUpdating
                        ? CircularProgressIndicator(
                      strokeWidth: 2,
                    )
                        : Text(
                      Language.getCommerceOSStrings('actions.save'),
                    ),
                  ),
                ),
              ): Container(),
            ],
          ),
        ),
      ),
    );
  }

  Color colorConvert(String color) {
    if (color == null)
      return Colors.white;

    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF"+color));
    } else if (color.length == 8) {
      return Color(int.parse("0x"+color));
    } else {
      return Colors.white;
    }
  }
}