
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/settings/widgets/save_button.dart';


class AddEmployeeScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;
  final Employee employee;
  AddEmployeeScreen({
    this.globalStateModel,
    this.setScreenBloc,
    this.employee,
  });

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  Business activeBusiness;

  final _formKey = GlobalKey<FormState>();
  int selectedSection = 0;
  Employee employee;
  String email;
  String firstName;
  String lastName;
  String positionType;
  List<Group> group = [];

  @override
  void initState() {
    activeBusiness =
        widget.globalStateModel.currentBusiness;
    if (widget.employee != null) {
      employee = widget.employee;
      email = employee.email;
      firstName = employee.firstName;
      lastName = employee.lastName;
      group = employee.groups;
      positionType = employee.positionType;
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
      backgroundColor: Colors.black,
      appBar: Appbar('Add Employee'),
      body: SafeArea(
        child: BackgroundBase(
          true,
          backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
          body: _updateForm,
        ),
      ),
    );
  }

  get _updateForm {
    return BlocListener(
      bloc: widget.setScreenBloc,
      listener: (BuildContext context, state) {
        if (state is SettingScreenUpdateSuccess) {
          Navigator.pop(context);
        } else if (state is SettingScreenStateFailure) {}
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (context, state) {

          List<GroupTag> tags = [];
          if (employee != null) {
            tags = employee.groups.map((element) {
          return GroupTag(
          name: element.name,
          position: state.employeeGroups.length,
          category: element,
          );
          }).toList();
          }

          return Center(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(16),
                width: Measurements.width,
                child: BlurEffectView(
                  color: Color.fromRGBO(20, 20, 20, 0.4),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
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
                                      if (selectedSection == 0) {
                                        selectedSection = -1;
                                      } else {
                                        selectedSection = 0;
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
                                            SvgPicture.asset('assets/images/account.svg'),
                                            Padding(
                                              padding: EdgeInsets.only(left: 8),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Info',
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
                                        selectedSection == 0 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          selectedSection == 0 ? SizedBox(height: 2,): Container(),
                          selectedSection == 0 ? Container(
                            height: 64,
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: BlurEffectView(
                                    color: Color.fromRGBO(100, 100, 100, 0.05),
                                    radius: 0,
                                    child: Container(
                                      height: 64,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16),
                                        onChanged: (val) {
                                          setState(() {
                                            firstName = val;
                                          });
                                        },
                                        initialValue: firstName ?? '',
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 16, right: 16),
                                          labelText: Language.getPosTpmStrings('First Name'),
                                          labelStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2),
                                ),
                                Flexible(
                                  child: BlurEffectView(
                                    color: Color.fromRGBO(100, 100, 100, 0.05),
                                    radius: 0,
                                    child: Container(
                                      height: 64,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16),
                                        onChanged: (val) {
                                          setState(() {
                                            lastName = val;
                                          });
                                        },
                                        initialValue: lastName ?? '',
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 16, right: 16),
                                          labelText: Language.getPosTpmStrings('Last Name'),
                                          labelStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ): Container(),
                          selectedSection == 0 ? SizedBox(height: 2,): Container(),
                          selectedSection == 0 ? Container(
                            height: 64,
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: BlurEffectView(
                                    color: Color.fromRGBO(100, 100, 100, 0.05),
                                    radius: 0,
                                    child: Container(
                                      height: 64,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16),
                                        onChanged: (val) {
                                          setState(() {
                                            email = val;
                                          });
                                        },
                                        initialValue: email ?? '',
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 16, right: 16),
                                          labelText: Language.getPosTpmStrings('Mail'),
                                          labelStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2),
                                ),
                                Flexible(
                                  child: BlurEffectView(
                                    color: Color.fromRGBO(100, 100, 100, 0.05),
                                    radius: 0,
                                    child: Container(
                                      height: 64,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 16, right: 8),
                                      child: DropdownButtonFormField(
                                        items: List.generate(GlobalUtils.positionsListOptions().length, (index) {
                                          return DropdownMenuItem(
                                            child: Text(
                                              GlobalUtils.positionsListOptions()[index],
                                            ),
                                            value: GlobalUtils.positionsListOptions()[index],
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            positionType = val;
                                          });
                                        },
                                        value: positionType != '' ? positionType : null,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.black54,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        hint: Text(
                                          'Position',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ): Container(),
                          selectedSection == 0 ? SizedBox(height: 2,): Container(),
                          selectedSection == 0 ? BlurEffectView(
                            color: Color.fromRGBO(100, 100, 100, 0.05),
                            radius: 0,
                            child: Container(
                              color: Color(0x80111111),
                              padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlutterTagging<GroupTag>(
                                      initialItems: tags,
                                      textFieldConfiguration: TextFieldConfiguration(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Search Category',
                                        ),
                                      ),
                                      findSuggestions: GroupSuggestService(
                                        categories: state.employeeGroups,
                                        addedCategories: group,
                                      ).getGroup,
                                      additionCallback: (value) {
                                        return GroupTag(
                                          name: value,
                                          position: state.employeeGroups.length,
                                        );
                                      },
                                      onAdded: (language) {
                                        // api calls here, triggered when add to tag button is pressed
                                        return GroupTag();
                                      },
                                      configureChip: (lang) {
                                        return ChipConfiguration(
                                          label: Text(lang.name),
                                          labelStyle: TextStyle(color: Colors.white),
                                          deleteIconColor: Colors.white,
                                        );
                                      },
                                      onChanged: () {
                                        List cates = tags.map((e) {
                                          return e.category;
                                        }).toList();
                                        group = cates;
                                      },
                                      configureSuggestion: (GroupTag tag ) {
                                        return SuggestionConfiguration(
                                          title: Text(tag.name),
                                          additionWidget: Chip(
                                            avatar: Icon(
                                              Icons.add_circle,
                                              color: Colors.white,
                                            ),
                                            label: Text('Add New Group'),
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ),
                            ),
                          ): Container(),
                          BlurEffectView(
                            color: Color.fromRGBO(100, 100, 100, 0.05),
                            radius: 0,
                            child: Container(
                              height: 56,
                              color: Colors.black38,
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
                                            SvgPicture.asset('assets/images/key.svg'),
                                            Padding(
                                              padding: EdgeInsets.only(left: 8),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Apps Access',
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
                                        selectedSection == 1 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          selectedSection == 1 ? (
                              group.length > 0 ?
                              ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return BlurEffectView(
                                      color: Color.fromRGBO(100, 100, 100, 0.05),
                                      radius: 0,
                                      child: Container(
                                        height: 50,
                                        padding: EdgeInsets.only(left: 16, right: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Flexible(
                                              child: Text(
                                                ''
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                MaterialButton(
                                                  onPressed: () {
                                                  },
                                                  color: Colors.black45,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  height: 24,
                                                  minWidth: 0,
                                                  padding: EdgeInsets.only(left: 8, right: 8),
                                                  elevation: 0,
                                                  child: Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                MaterialButton(
                                                  onPressed: () {
                                                  },
                                                  color: Colors.black45,
                                                  shape: CircleBorder(),
                                                  height: 24,
                                                  minWidth: 0,
                                                  elevation: 0,
                                                  child: SvgPicture.asset('assets/images/closeicon.svg', width: 8, height: 8),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      height: 0,
                                      thickness: 0.5,
                                      color: Colors.grey,
                                    );
                                  },
                                  itemCount: 0
                              ):
                              BlurEffectView(
                                color: Color.fromRGBO(100, 100, 100, 0.05),
                                radius: 0,
                                child: Container(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'You don\'t have additional emails',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ):
                          Container(),
                          SaveBtn(
                            isUpdating: state.isUpdating,
                            color: Colors.black45,
                            isBottom: false,
                            onUpdate: () {
                              if (_formKey.currentState.validate() &&
                                  !state.isUpdating) {
//                                Map<String, dynamic> body = {};
//                                print(body);
//                                widget.setScreenBloc.add(BusinessUpdateEvent({
//                                  'contactDetails': body,
//                                }));
                              }
                            },
                          )                        ],
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
class GroupSuggestService {
  final List<Group> categories;
  final List<Group> addedCategories;
  GroupSuggestService( {this.categories = const [], this.addedCategories = const [],});

  Future<List<GroupTag>> getGroup(String query) async {
    List list = categories.where((element) {
      bool isadded = false;
      addedCategories.forEach((e) {
        if (e.name == element.name) {
          isadded = true;
        }
      });
      return !isadded;
    }).toList();

    List<GroupTag> categoryTags = [];
    list.forEach((element) {
      categoryTags.add(GroupTag(
        name: element.name,
        position: categoryTags.length,
        category: element,
      ));
    });
    print(categoryTags.length);
    return categoryTags;
//    return categoryTags
//        .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
//        .toList();
  }
}
