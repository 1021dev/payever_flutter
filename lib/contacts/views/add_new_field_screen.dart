import 'dart:ui';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/contacts/models/model.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';

bool _isPortrait;
bool _isTablet;

class AddNewFieldScreen extends StatefulWidget {

  final ContactDetailScreenBloc screenBloc;
  final Field editField;
  final bool isEdit;

  AddNewFieldScreen({
    this.screenBloc,
    this.editField,
    this.isEdit = false,
  });

  @override
  createState() => _AddNewFieldScreenState();
}

class _AddNewFieldScreenState extends State<AddNewFieldScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController fieldNameController = TextEditingController();
  TextEditingController fieldLabelController = TextEditingController();

  bool isFilterable = false;
  bool isOnlyAdmin = false;
  bool isShowPerson = false;
  bool isShowCompany = false;
  String fieldLabel = '';
  String fieldType = '';
  String name = '';
  bool isSave = false;
  Map<String, String> filedTypes = {
    'Single line Text': 'text',
    'Paragraph Text': 'textarea',
    'Number': 'number',
    'Checkbox': 'checkbox',
    'Dropdown': 'select',
    'Multiselect': 'multiselect',
  };

  @override
  void initState() {
    if (widget.editField != null) {
      fieldLabel = widget.editField.name;
      fieldType = widget.editField.type;
    }
    fieldLabelController.text = fieldLabel;
    fieldNameController.text = name;
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
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    return BlocListener(
      bloc: widget.screenBloc,
      listener: (BuildContext context, ContactDetailScreenState state) async {
        if (state is ContactDetailScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<ContactDetailScreenBloc, ContactDetailScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, ContactDetailScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _appBar(ContactDetailScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Text(
        Language.getPosConnectStrings('Add Field'),
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
            if (isSave) {
              setState(() {
                isSave = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _body(ContactDetailScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(state),
      body: SafeArea(
        child: BackgroundBase(
          true,
          body: state.isLoading ?
          Center(
            child: CircularProgressIndicator(),
          ): Center(
            child: SingleChildScrollView(
              child: Container(
                width: Measurements.width,
                child: Column(
                  children: <Widget>[
                    _getBody(state),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBody(ContactDetailScreenState state) {

    List<Widget> widgets = [];
    Widget header = Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      height: 56,
      color: Colors.black54,
      child: SizedBox.expand(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Custom Field',
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
    );

    widgets.add(header);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget filedLabelField = Container(
      height: 64,
      child: Center(
        child: TextFormField(
          style: TextStyle(fontSize: 16),
          controller: fieldLabelController,
          onChanged: (val) {
            setState(() {
              fieldLabel = val;
            });
          },
          autovalidate: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            labelText: Language.getPosTpmStrings('Field Label'),
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
    );

    widgets.add(filedLabelField);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget fieldTypeField = Container(
      height: 64,
      padding: EdgeInsets.only(left: 4),
      child: Center(
        child: DropDownFormField(
          dataSource: filedTypes.keys.toList().map((element) {
            return {'display': element, 'value': filedTypes[element]};
          }).toList(),
          onChanged: (val) {
            setState(() {
              fieldType = val;
            });
          },
          autovalidate: true,
          filled: false,
          value: fieldType,
          titleText: null,
          hintText: 'Field Type',
          textField: 'display',
          valueField: 'value',
        ),
      ),
    );

    widgets.add(fieldTypeField);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget filterableSection = Container(
      height: 64,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              'Filterable',
            ),
          ),
          CupertinoSwitch(
            value: isFilterable,
            onChanged: (val) {
              setState(() {
                isFilterable = val;
              });
            },
            trackColor: Colors.black26,
          ),
        ],
      ),
    );

    widgets.add(filterableSection);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget valueEditable = Container(
      height: 64,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              'Value editable only by admin',
            ),
          ),
          CupertinoSwitch(
            value: isOnlyAdmin,
            onChanged: (val) {
              setState(() {
                isOnlyAdmin = val;
              });
            },
            trackColor: Colors.black26,
          ),
        ],
      ),
    );

    widgets.add(valueEditable);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget showOnPersonCards = Container(
      height: 64,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              'Show on person cards',
            ),
          ),
          CupertinoSwitch(
            value: isShowPerson,
            onChanged: (val) {
              setState(() {
                isShowPerson = val;
              });
            },
            trackColor: Colors.black26,
          ),
        ],
      ),
    );

    widgets.add(showOnPersonCards);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget showOnCompanyCards = Container(
      height: 64,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              'Show on company cards',
            ),
          ),
          CupertinoSwitch(
            value: isShowCompany,
            onChanged: (val) {
              setState(() {
                isShowCompany = val;
              });
            },
            trackColor: Colors.black26,
          ),
        ],
      ),
    );

    widgets.add(showOnCompanyCards);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget saveButton = Container(
      height: 56,
      child: SizedBox.expand(
        child: MaterialButton(
          onPressed: () {
            if (fieldLabel == '') {
              Fluttertoast.showToast(msg: 'Field Label required');
              return;
            }
            if (fieldType == '') {
              Fluttertoast.showToast(msg: 'FieldType required');
              return;
            }
            if (widget.isEdit) {
              Navigator.pop(context);
            } else {
              setState(() {
                isSave = true;
              });
            }
          },
          color: Colors.black87,
          child: Text(
            'Save field',
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
    widgets.add(saveButton);

    List<Widget> saveWidgets = [];

    Widget fieldNameField = Container(
      height: 64,
      child: Center(
        child: TextFormField(
          controller: fieldNameController,
          style: TextStyle(fontSize: 16),
          onChanged: (val) {
            setState(() {
              name = val;
            });
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            labelText: Language.getPosTpmStrings('Name'),
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
    );

    saveWidgets.add(fieldNameField);
    saveWidgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget saveButton1 = Container(
      height: 56,
      child: SizedBox.expand(
        child: MaterialButton(
          onPressed: () {
            if (name == '') {
              Fluttertoast.showToast(msg: 'Field Name required');
              return;
            }
            showConfirmDialog();
          },
          color: Colors.black87,
          child: Text(
            'Save',
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
    saveWidgets.add(saveButton1);

    return Center(
      child: Wrap(
        runSpacing: 16,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16),
            child: BlurEffectView(
              color: Color.fromRGBO(20, 20, 20, 0.2),
              blur: 15,
              radius: 12,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: (isSave ? saveWidgets: widgets).map((e) => e).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showConfirmDialog() {
    showCupertinoDialog(
      context: context,
      builder: (builder) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Wrap(
              children: <Widget>[
                BlurEffectView(
                  color: Color.fromRGBO(50, 50, 50, 0.4),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      SvgPicture.asset('assets/images/group_contact.svg'),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Text(
                        Language.getPosStrings('Are you sure?'),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.white
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Text(
                        Language.getPosStrings('This will save the info you entered over ${fieldNameController.text}'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 24,
                            elevation: 0,
                            minWidth: 0,
                            color: Colors.white10,
                            child: Text(
                              Language.getCommerceOSStrings('actions.cancel'),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              Field field = new Field();
                              field.name = name;
                              field.type = fieldType;
                              field.businessId = widget.screenBloc.state.business;
                              field.typename = 'Field';
                              widget.screenBloc.add(CreateNewFieldEvent(field: field));
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 24,
                            elevation: 0,
                            minWidth: 0,
                            color: Colors.white10,
                            child: Text(
                              Language.getCommerceOSStrings('actions.save'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]
            ),
          ),
        );
      },
    );
  }
}
