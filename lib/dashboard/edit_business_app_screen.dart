import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/theme.dart';

class EditBusinessAppScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final DashboardScreenBloc dashboardScreenBloc;

  EditBusinessAppScreen({
    this.globalStateModel,
    this.dashboardScreenBloc,
  });

  @override
  _EditBusinessAppScreenState createState() => _EditBusinessAppScreenState();
}

class _EditBusinessAppScreenState extends State<EditBusinessAppScreen> {
  Business activeBusiness;

  final _formKey = GlobalKey<FormState>();

  bool isApps = true;

  List<BusinessApps> businessApps = [];
  List<AppWidget> appWidgets = [];
  int selectedIndex = -1;
  List<Acl> acls = [];

  @override
  void initState() {
    activeBusiness = widget.globalStateModel.currentBusiness;
    if (widget.dashboardScreenBloc.state.businessWidgets != null) {
      appWidgets = widget.dashboardScreenBloc.state.currentWidgets;
      businessApps =
          widget.dashboardScreenBloc.state.businessWidgets.where((element) {
        return (element.dashboardInfo != null && element.dashboardInfo.title != null && element.dashboardInfo.title.isNotEmpty);
      }).toList();
      List<BusinessApps> businessAppsDefault = [];
      List<BusinessApps> businessAppsInstall = [];

      businessAppsDefault =
          businessApps.where((element) {
            if (element.code == "settings") {
              return element.setupStatus != "notStarted";
            }
            return (element.isDefault);
          }).toList();

      businessAppsInstall =
          businessApps.where((element) {
            return (!element.isDefault && element.installed);
          }).toList();
      List<BusinessApps> businessApps1 = [];
      businessApps1.addAll(businessAppsDefault);
      businessApps.forEach((element) {
        if (!businessAppsDefault.contains(element) ) {
          businessApps1.add(element);
        }
      });
      businessApps = [];
      businessApps.addAll(businessApps1);
    }
    print(
        'business apps length :${businessApps.length}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  get _body {
    return Scaffold(
      appBar: Appbar(
        'Edit Apps',
        onClose: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: _updateForm,
        ),
      ),
    );
  }

  get _updateForm {
    return BlocListener(
      bloc: widget.dashboardScreenBloc,
      listener: (BuildContext context, DashboardScreenState state) {
        if (state is SettingScreenUpdateSuccess) {
        } else if (state is SettingScreenStateFailure) {}
      },
      child: BlocBuilder<DashboardScreenBloc, DashboardScreenState>(
        bloc: widget.dashboardScreenBloc,
        builder: (context, state) {
          return Center(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(16),
                width: Measurements.width,
                child: BlurEffectView(
                  color: overlayBackground(),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          BlurEffectView(
                            color: overlayBackground(),
                            radius: 0,
                            child: Container(
                              height: 56,
                              color: overlayBackground(),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isApps = true;
                                          });
                                        },
                                        color: overlayButtonBackground()
                                            .withOpacity(isApps ? 1.0 : 0.6),
                                        height: 24,
                                        elevation: 0,
                                        child: AutoSizeText(
                                          'Apps',
                                          minFontSize: 8,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 2),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: MaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            isApps = false;
                                          });
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                        ),
                                        color: overlayButtonBackground()
                                            .withOpacity(isApps ? 0.6 : 1),
                                        elevation: 0,
                                        height: 24,
                                        child: AutoSizeText(
                                          'Widgets',
                                          maxLines: 1,
                                          minFontSize: 8,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          isApps
                              ? _appsBody()
                              : _widgetBody(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appsBody() {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        BusinessApps businessApp =
        businessApps[index];
        String icon =
        businessApp.dashboardInfo != null
            ? businessApp.dashboardInfo.icon
            : null;
        if (icon == null) {
          return Container();
        }
        icon = icon.replaceAll('32', '64');
        // int aclIndex = acls.indexWhere((element) =>
        // element.microService ==
        //     businessApp.code);
        // if (aclIndex > -1 && aclIndex < 100) {
        // } else {
        //   return Container();
        // }

        return BlurEffectView(
          color: Colors.transparent,
          radius: 0,
          child: Column(
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  setState(() {
                    if (selectedIndex == index) {
                      selectedIndex = -1;
                    } else {
                      selectedIndex = index;
                    }
                  });
                },
                child: Container(
                  height: 65,
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 30,
                              decoration:
                              BoxDecoration(
                                image:
                                DecorationImage(
                                  image:
                                  NetworkImage(
                                    '${Env.cdnIcon}$icon',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Flexible(
                              child: Text(
                                businessApp.code[0]
                                    .toUpperCase() +
                                    businessApp.code
                                        .substring(
                                        1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !businessApp.isDefault,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: overlayButtonBackground(),
                            ),
                            child: Text(businessApp.installed ? 'Uninstall' : 'Install',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 0,
          thickness: 0.5,
        );
      },
      itemCount: businessApps.length,
    );
  }

  Widget _widgetBody() {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        AppWidget appWidget =
        appWidgets[index];
        String icon =
        appWidget.icon != null
            ? appWidget.icon
            : null;
        if (icon == null) {
          return Container();
        }
        icon = icon.replaceAll('32', '64');

        return BlurEffectView(
          color: Colors.transparent,
          radius: 0,
          child: Column(
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  setState(() {
                    if (selectedIndex == index) {
                      selectedIndex = -1;
                    } else {
                      selectedIndex = index;
                    }
                  });
                },
                child: Container(
                  height: 65,
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 30,
                              decoration:
                              BoxDecoration(
                                image:
                                DecorationImage(
                                  image:
                                  NetworkImage(
                                    '${Env.cdnIcon}$icon',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Flexible(
                              child: Text(
                                appWidget.title,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: appWidget.install && !appWidget.defaultWid,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: overlayButtonBackground(),
                            ),
                            child: Text('Delete',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 0,
          thickness: 0.5,
        );
      },
      itemCount: appWidgets.length,
    );
  }

}
