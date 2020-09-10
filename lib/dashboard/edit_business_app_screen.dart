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
  int selectedSection = 0;

  List<BusinessApps> businessApps = [];
  int selectedIndex = -1;
  List<Acl> acls = [];

  @override
  void initState() {
    activeBusiness =
        widget.globalStateModel.currentBusiness;
    if (widget.dashboardScreenBloc.state.businessWidgets != null) {
      businessApps = widget.dashboardScreenBloc.state.businessWidgets.where((element) {
        if (element.installed) {
          Acl acl = element.allowedAcls;
          acl.setAll(false);
          acl.microService = element.code;
          acls.add(acl);
        }
        return element.installed;
      }).toList();
    }
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

        } else if (state is SettingScreenStateFailure) {

        }
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
                          selectedSection == 0 ? SizedBox(height: 2,): Container(),
                          selectedSection == 0 ? SizedBox(height: 2,): Container(),
                          selectedSection == 0 ? SizedBox(height: 2,): Container(),
                          BlurEffectView(
                            color: overlayBackground(),
                            radius: 0,
                            child: Container(
                              height: 56,
                              color: overlayBackground(),
                              child: SizedBox.expand(
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      if (selectedSection == 1) {
                                        selectedSection = -1;
                                      } else {
                                        selectedSection = 1;
                                      }
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
                                              'assets/images/icon-security.svg',
                                              width: 16,
                                              height: 16,
                                              color: iconColor(),),
                                            Padding(
                                              padding: EdgeInsets.only(left: 8),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Apps Access',
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        selectedSection == 1 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          selectedSection == 1 ? Container(
                            height: 300,
                            child: ListView.separated(
                              shrinkWrap: false,
                              itemBuilder: (context, index) {
                                BusinessApps businessApp = businessApps[index];
                                String icon = businessApp.dashboardInfo != null ? businessApp.dashboardInfo.icon: null;
                                if (icon == null) {
                                  return Container();
                                }
                                icon = icon.replaceAll('32', '64');
                                int aclIndex = acls.indexWhere((element) => element.microService == businessApp.code);
                                if (aclIndex > -1 && aclIndex < 100) {

                                } else {
                                  return Container();
                                }
                                Acl acl = acls[aclIndex];
                                String accessString = 'No Access';
                                if (acl.isFullAccess() == 1) {
                                  accessString = 'Custom Access';
                                } else if (acl.isFullAccess() == 2) {
                                  accessString = 'Full Access';
                                }
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
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Flexible(
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 44,
                                                      height: 44,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(22),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            '${Env.cdnIcon}$icon',
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 16,),
                                                    Flexible(
                                                      child: Text(
                                                        businessApp.code[0].toUpperCase() + businessApp.code.substring(1),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    accessString,
                                                  ),
                                                  SizedBox(width: 8,),
                                                  SvgPicture.asset(
                                                    selectedIndex == index
                                                        ? 'assets/images/ic_minus.svg':
                                                    'assets/images/ic_plus.svg',
                                                    width: 16,
                                                    height: 16,
                                                    color: iconColor(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        height: 0,
                                        thickness: 0.5,
                                      ),
                                      selectedIndex == index ? ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (ctx, idx) {
                                          String key = idx == 0
                                              ? 'Full Access'
                                              : businessApp.allowedAcls.toMap().keys.toList()[idx - 1];
                                          bool isChecked = false;
                                          if (idx == 0) {
                                            isChecked = acl.isFullAccess() == 2;
                                          } else {
                                            isChecked = acl.toMap()[key];
                                          }
                                          String permissionString = key[0].toUpperCase() + key.substring(1);
                                          return BlurEffectView(
                                            color: overlayRow(),
                                            radius: 0,
                                            child: MaterialButton(
                                              onPressed: () {
                                                isChecked = !isChecked;
                                                if (idx == 0) {
                                                  setState(() {
                                                    acl.setAll(isChecked);
                                                    acls[aclIndex] = acl;
                                                  });
                                                } else {
                                                  setState(() {
                                                    Map<String, bool> map = acl.toMap();
                                                    map[key] = isChecked;
                                                    acl.updateDict(map);
                                                    acls[aclIndex] = acl;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height: 60,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      permissionString,
                                                    ),
                                                    Transform.scale(
                                                      scale: 0.7,
                                                      child: CupertinoSwitch(
                                                        onChanged: (val) {
                                                          if (idx == 0) {
                                                            setState(() {
                                                              acl.setAll(val);
                                                              acls[aclIndex] = acl;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              Map<String, bool> map = acl.toMap();
                                                              map[key] = val;
                                                              acl.updateDict(map);
                                                              acls[aclIndex] = acl;
                                                            });
                                                          }
                                                        },
                                                        value: isChecked,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (ctx, idx) {
                                          return Divider(
                                            height: 0,
                                            thickness: 0.5,
                                          );
                                        },
                                        itemCount: businessApp.allowedAcls.toMap().keys.length + 1,
                                      ): Container(),
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
                            ),
                          ): Container(),
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

}

