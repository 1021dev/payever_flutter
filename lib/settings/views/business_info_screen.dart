import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/settings/widgets/save_button.dart';

class BusinessInfoScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;
  final bool fromDashboard;

  BusinessInfoScreen(
      {this.globalStateModel, this.setScreenBloc, this.fromDashboard = false});

  @override
  _BusinessInfoScreenState createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  bool isGridMode = true;
  bool _isPortrait;
  bool _isTablet;

  final TextEditingController myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.setScreenBloc.add(FetchWallpaperEvent());
    myController.text = widget.globalStateModel.currentBusiness.name;
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
            appBar: Appbar('Business Info'),
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

  Widget _getBody(SettingScreenState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.25),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            color: Colors.grey, shape: BoxShape.circle),
                        child: Icon(Icons.image),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: myController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter valid name.';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Business name',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 20),
                  child: GestureDetector(
                    onTap: null,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Text(
                        'Delete Business',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                SaveBtn(
                  isUpdating: state.isUpdating,
                  onUpdate: () {
                    if (!state.isUpdating) {
                      Map<String, dynamic> body = {
                        'logo': widget.globalStateModel.currentBusiness.logo,
                        'name': myController.text
                      };
                      widget.setScreenBloc.add(BusinessUpdateEvent(body));
                    }
                  },
                ),
              ],
            )),
      ),
    );
  }
}
