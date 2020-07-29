import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/connect/models/connect.dart';

bool _isPortrait;
bool _isTablet;

class AddContactScreen extends StatefulWidget {

  final ContactScreenBloc screenBloc;

  AddContactScreen({
    this.screenBloc,
  });

  @override
  createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ContactDetailScreenBloc screenBloc;
  String wallpaper;
  String selectedState = '';
  int isOpened = 0;
  int accountSection = -1;

  var imageData;

  Business business;

  @override
  void initState() {
    screenBloc = ContactDetailScreenBloc(contactScreenBloc: widget.screenBloc);
    business = widget.screenBloc.dashboardScreenBloc.state.activeBusiness;

    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
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
      bloc: screenBloc,
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
        bloc: screenBloc,
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
        Language.getPosConnectStrings('Add Contact'),
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
        child: MaterialButton(
          onPressed: () {
            setState(() {
              if (isOpened == 0) {
                isOpened = -1;
              } else {
                isOpened = 0;
              }
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'GENERAL',
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
                isOpened == 0 ? Icons.add : Icons
                    .remove,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );

    widgets.add(header);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        // Photo section;
        Widget photoSection = isOpened == 0 ? Container(
          height: Measurements.width * 0.8,
          child: Center(
            child: Column(
              children: <Widget>[

              ],
            )
          )
        ) : Container();

        widgets.add(photoSection);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget typeField = isOpened == 0 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Type'),
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
        ): Container();

        widgets.add(typeField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

    Widget nameSection = isOpened == 0 ? Container(
      height: 64,
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
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
          Padding(
            padding: EdgeInsets.only(left: 2),
          ),
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
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
        ],
      ),
    ): Container();

    widgets.add(nameSection);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

    Widget phoneSection = isOpened == 0 ? Container(
      height: 64,
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Mobile Phone'),
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
          Padding(
            padding: EdgeInsets.only(left: 2),
          ),
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Email'),
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
        ],
      ),
    ): Container();

    widgets.add(phoneSection);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

    Widget homepageField = isOpened == 0 ? Container(
      height: 64,
      child: Center(
        child: TextFormField(
          style: TextStyle(fontSize: 16),
          onTap: () {

          },
          onChanged: (val) {
            setState(() {
            });
          },
          initialValue: '',
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            labelText: Language.getPosTpmStrings('Homepage'),
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
    ): Container();

    widgets.add(homepageField);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

    Widget streetField = isOpened == 0 ? Container(
      height: 64,
      child: Center(
        child: TextFormField(
          style: TextStyle(fontSize: 16),
          onTap: () {

          },
          onChanged: (val) {
            setState(() {
            });
          },
          initialValue: '',
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            labelText: Language.getPosTpmStrings('Street'),
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
    ): Container();

    widgets.add(streetField);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

    Widget citySection = isOpened == 0 ? Container(
      height: 64,
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('City'),
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
          Padding(
            padding: EdgeInsets.only(left: 2),
          ),
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('State'),
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
        ],
      ),
    ): Container();

    widgets.add(citySection);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

    Widget zipSection = isOpened == 0 ? Container(
      height: 64,
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Zip'),
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
          Padding(
            padding: EdgeInsets.only(left: 2),
          ),
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Country'),
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
        ],
      ),
    ): Container();

    widgets.add(zipSection);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

    return Center(
      child: Wrap(
        runSpacing: 16,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
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

//DropDownFormField(
//filled: false,
//titleText: Language.getProductStrings('Product must match'),
//hintText: Language.getProductStrings('Product must match'),
//value: conditionOption,
//onChanged: (value) {
//setState(() {
//conditionOption = value;
//if (conditionOption != 'No Conditions') {
//CollectionModel collection = state.collectionDetail;
//FillCondition fillCondition = collection
//    .automaticFillConditions;
//fillCondition.strict =
//conditionOption == 'All Conditions';
//collection.automaticFillConditions = fillCondition;
//widget.screenBloc.add(
//UpdateCollectionDetail(collectionModel: collection));
//}
//});
//},
//dataSource: productConditionOptions.map((e) {
//return {
//'display': e,
//'value': e,
//};
//}).toList(),
//textField: 'display',
//valueField: 'value',
//)