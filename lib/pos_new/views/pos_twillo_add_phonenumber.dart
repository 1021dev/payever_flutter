import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';
import 'package:payever/pos_new/models/models.dart';

bool _isPortrait;
bool _isTablet;

List<String> dropdownItems = [
  'Verify by code',
  'Verify by ID',
];
class PosTwilioAddPhoneNumber extends StatefulWidget {

  PosScreenBloc screenBloc;
  String businessId;
  String businessName;
  String id;

  PosTwilioAddPhoneNumber({
    this.screenBloc,
    this.businessId,
    this.businessName,
    this.id,
  });

  @override
  createState() => _PosTwilioAddPhoneNumberState();
}

class _PosTwilioAddPhoneNumberState extends State<PosTwilioAddPhoneNumber> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String wallpaper;
  String selectedState = '';

  @override
  void initState() {
    widget.screenBloc.add(
      AddPhoneNumberSettings(
        businessId: widget.businessId,
        action: 'add-number',
        id: widget.id,
      ),
    );
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
      listener: (BuildContext context, PosScreenState state) async {
        if (state is PosScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<PosScreenBloc, PosScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, PosScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _appBar(PosScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            Language.getPosTpmStrings('tpm.communications.twilio.adding_numbers'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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

  Widget _body(PosScreenState state) {
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
          ): Column(
            children: <Widget>[
              Expanded(
                child: _getBody(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody(PosScreenState state) {
    List<CountryDropdownItem> dropdownItems = state.dropdownItems;
    return Center(
      child: Wrap(
        runSpacing: 16,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: BlurEffectView(
                color: Color.fromRGBO(50, 50, 50, 0.2),
                blur: 15,
                radius: 12,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      color: Colors.black26,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      Language.getPosTpmStrings('tpm.communications.twilio.country'),
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    dropdownItems.length > 0 ? Expanded(
                                      child: DropdownButton<dynamic>(
                                        icon: Container(),
                                        underline: Container(),
                                        isExpanded: true,
                                        value: state.settingsModel.country != null ? state.settingsModel.country.label: dropdownItems.first.label,
                                        onChanged: (value) {
                                          setState(() {
                                            CountryDropdownItem item = dropdownItems.firstWhere((element) => element.label == value);
                                          });
                                        },
                                        items: dropdownItems.map((item) => DropdownMenuItem(
                                          child: Text(
                                            item.label,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          value: item.label,
                                        ),
                                        ).toList(),
                                      ),
                                    ): Container(),
                                  ],
                                ),
                                height: 64,
                              ),
                            ),
                            flex: 1,
                          ),
                          Container(
                            color: Color(0xFF888888),
                            width: 1,
                            height: 64,
                          ),
                          Flexible(
                            child: Container(
                                height: 64,
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 16),
                                    onChanged: (val) {

                                    },
                                    initialValue: '',
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 16, right: 16),
                                      labelText: Language.getPosTpmStrings('tpm.communications.twilio.phone_number_optional'),
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
                                )
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.check_box_outline_blank),
                      title: Text(
                        Language.getPosTpmStrings('tpm.communications.twilio.exclude_any'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.check_box_outline_blank),
                      title: Text(
                        Language.getPosTpmStrings('tpm.communications.twilio.exclude_local'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.check_box_outline_blank),
                      title: Text(
                        Language.getPosTpmStrings('tpm.communications.twilio.exclude_foreign'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      height: 56,
                      child: SizedBox.expand(
                        child: MaterialButton(
                          minWidth: 0,
                          onPressed: () {
                            widget.screenBloc.add(SearchPhoneNumberEvent(
                              businessId: widget.businessId,
                              id: widget.id,
                              action: 'search-numbers',
                              country: 'US',
                              excludeAny: false,
                              excludeForeign: false,
                              excludeLocal: false,
                              phoneNumber: '',
                            ));
                          },
                          color: Colors.black87,
                          child: Text(
                            Language.getPosTpmStrings('tpm.communications.twilio.search'),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]
      ),
    );
  }
}
