import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iso_countries/iso_countries.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/settings/widgets/save_button.dart';

import 'add_email_screen.dart';

class ContactScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;
  final List<Country> countryList;
  ContactScreen({
    this.globalStateModel,
    this.setScreenBloc,
    this.countryList,
  });

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Business activeBusiness;
  ContactDetails contactDetails;

  String salutation;
  String firstName;
  String lastName;
  String phone;
  String fax;
  String additionalPhone;
  List<String> contactEmails = [];

  final _formKey = GlobalKey<FormState>();
  int selectedSection = 0;

  @override
  void initState() {
    widget.setScreenBloc.add(GetBusinessProductsEvent());
    activeBusiness =
        widget.globalStateModel.currentBusiness;
    contactDetails = activeBusiness.contactDetails;
    contactEmails = activeBusiness.contactEmails ?? [];
    if (contactDetails != null) {
      salutation = contactDetails.salutation;
      firstName = contactDetails.firstName;
      lastName = contactDetails.lastName;
      phone = contactDetails.phone;
      fax = contactDetails.fax;
      additionalPhone = contactDetails.additionalPhone;
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
      appBar: Appbar('Contact'),
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
                                            Expanded(
                                              child: Text(
                                                'Details',
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
                                        selectedSection == 0 ? Icons.remove : Icons.add,
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
                                      padding: EdgeInsets.only(left: 16, right: 8),
                                      child: DropdownButtonFormField(
                                        items: List.generate(2, (index) {
                                          return DropdownMenuItem(
                                            child: Text(
                                              Language.getConnectStrings(index == 0 ?
                                              'user_business_form.form.contactDetails.salutation.options.SALUTATION_MR':
                                              'user_business_form.form.contactDetails.salutation.options.SALUTATION_MRS'),
                                            ),
                                            value: index == 0 ? 'SALUTATION_MR': 'SALUTATION_MRS',
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            salutation = val;
                                          });
                                        },
                                        value: salutation != '' ? salutation : null,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.black54,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        hint: Text(
                                          Language.getSettingsStrings('form.create_form.company.product.label'),
                                        ),
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
                                            phone = val;
                                          });
                                        },
                                        initialValue: phone ?? '',
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 16, right: 16),
                                          labelText: Language.getPosTpmStrings('Phone (optional)'),
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
                                            fax = val;
                                          });
                                        },
                                        initialValue: fax ?? '',
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 16, right: 16),
                                          labelText: Language.getPosTpmStrings('Fax (optional)'),
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
                          selectedSection == 0 ? BlurEffectView(
                            color: Color.fromRGBO(100, 100, 100, 0.05),
                            radius: 0,
                            child: Container(
                              height: 64,
                              alignment: Alignment.center,
                              child: Center(
                                child: TextFormField(
                                  style: TextStyle(fontSize: 16),
                                  onChanged: (val) {
                                    setState(() {
                                      additionalPhone= val;
                                    });
                                  },
                                  initialValue: additionalPhone ?? '',
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                                    labelText: Language.getPosTpmStrings('Additional Phone number (optional)'),
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
                          ): Container(),
                          selectedSection == 0 ? SizedBox(height: 2,): Container(),
                          selectedSection == 0 ? SaveBtn(
                            isUpdating: state.isUpdating,
                            color: Colors.black45,
                            isBottom: false,
                            onUpdate: () {
                              if (_formKey.currentState.validate() &&
                                  !state.isUpdating) {
                                Map<String, dynamic> body = {};
                                body['salutation'] = salutation;
                                body['firstName'] = firstName;
                                body['lastName'] = lastName;
                                body['phone'] = phone;
                                body['fax'] = fax;
                                body['additionalPhone'] = additionalPhone;
                                print(body);
                                widget.setScreenBloc.add(BusinessUpdateEvent({
                                  'contactDetails': body,
                                }));
                              }
                            },
                          ): Container(),
                          Divider(height: 0, thickness: 0.5, color: Colors.grey,),
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
                                            Expanded(
                                              child: Text(
                                                'Emails',
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
                                        selectedSection == 1 ? Icons.remove : Icons.add,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          selectedSection == 1 ? (
                              contactEmails.length > 0 ?
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
                                                contactEmails[index],
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                MaterialButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        child: AddEmailScreen(
                                                          globalStateModel: widget.globalStateModel,
                                                          setScreenBloc: widget.setScreenBloc,
                                                          contactEmails: contactEmails,
                                                          editEmail: contactEmails[index],
                                                        ),
                                                        type: PageTransitionType.fade,
                                                        duration: Duration(milliseconds: 50),
                                                      ),
                                                    );
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
                                                                        SvgPicture.asset('assets/images/info.svg'),
                                                                        Padding(
                                                                          padding: EdgeInsets.only(top: 16),
                                                                        ),
                                                                        Text(
                                                                          Language.getSettingsStrings('form.create_form.contact_email.delete_email_title'),
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
                                                                          Language.getSettingsStrings('form.create_form.contact_email.delete_email_description'),
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
                                                                                Language.getSettingsStrings('actions.no'),
                                                                              ),
                                                                            ),
                                                                            MaterialButton(
                                                                              onPressed: () {
                                                                                contactEmails.remove(contactEmails[index]);
                                                                                widget.setScreenBloc.add(BusinessUpdateEvent({
                                                                                  'contactEmails': contactEmails,
                                                                                })
                                                                                );
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
                                                                                Language.getSettingsStrings('actions.yes'),
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
                                  itemCount: contactEmails.length
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
                          selectedSection == 1 ? Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                              ),
                            ),
                            child: SizedBox.expand(
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: AddEmailScreen(
                                        globalStateModel: widget.globalStateModel,
                                        setScreenBloc: widget.setScreenBloc,
                                        contactEmails: contactEmails,
                                      ),
                                      type: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 50),
                                    ),
                                  );
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Add +',),
                                ),
                              ),
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
