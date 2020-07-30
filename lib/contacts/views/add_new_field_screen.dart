import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/contacts/models/model.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';

bool _isPortrait;
bool _isTablet;

class AddNewFieldScreen extends StatefulWidget {

  final ContactDetailScreenBloc screenBloc;
  final Contact editContact;

  AddNewFieldScreen({
    this.screenBloc,
    this.editContact,
  });

  @override
  createState() => _AddNewFieldScreenState();
}

class _AddNewFieldScreenState extends State<AddNewFieldScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String wallpaper;
  String selectedState = '';
  bool openGeneral = true;
  bool openAdditional = true;


  Business business;
  List<OverflowMenuItem> optionPopup(BuildContext context, ContactDetailScreenState state) {
    return [
      OverflowMenuItem(
        title: Language.getProductListStrings('Add Field'),
        onTap: () async {
          setState(() {
          });
        },
      ),
      OverflowMenuItem(
        title: Language.getProductListStrings('Choose previous fields'),
        onTap: () async {
          setState(() {
          });
        },
      ),
    ];
  }

  @override
  void initState() {
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
            Navigator.pop(context);
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

    Widget filedLabel = Container(
      height: 64,
      child: Center(
        child: TextFormField(
          style: TextStyle(fontSize: 16),
          onChanged: (val) {
            setState(() {

            });
          },
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

    widgets.add(filedLabel);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);


    Widget filterableSection = Container(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              'Filterable',
            ),
          ),
          CupertinoSwitch(
            value: false,
            onChanged: (val) {

            },
          )
        ],
      ),
    );

    widgets.add(filterableSection);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget valueEditable = Container(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              'Value editable only by admin',
            ),
          ),
          CupertinoSwitch(
            value: false,
            onChanged: (val) {

            },
          )
        ],
      ),
    );

    widgets.add(valueEditable);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget showOnPersonCards = Container(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              'Show on person cards',
            ),
          ),
          CupertinoSwitch(
            value: false,
            onChanged: (val) {

            },
          )
        ],
      ),
    );

    widgets.add(showOnPersonCards);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget showOnCompanyCards = Container(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              'Show on company cards',
            ),
          ),
          CupertinoSwitch(
            value: false,
            onChanged: (val) {

            },
          )
        ],
      ),
    );

    widgets.add(showOnCompanyCards);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget saveButton = Container(
      height: 56,
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: SizedBox.expand(
        child: MaterialButton(
          onPressed: () {
          },
          color: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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
    widgets.add(saveButton);

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
                children: widgets.map((e) => e).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
