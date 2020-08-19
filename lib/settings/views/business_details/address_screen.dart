import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iso_countries/iso_countries.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/settings/widgets/save_button.dart';

class AddressScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;

  AddressScreen({
    this.globalStateModel,
    this.setScreenBloc,
  });

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  Business activeBusiness;
  CompanyAddress companyAddress;
  List<Country> countryList;
  String city;
  String countryName;
  String countryCode;
  String street;
  String zipCode;
  String googleAutocomplete;

  final _formKey = GlobalKey<FormState>();
  TextEditingController autoCompleteController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController zipController = TextEditingController();

  @override
  Future<void> initState() {
    widget.setScreenBloc.add(GetBusinessProductsEvent());
    activeBusiness =
        widget.setScreenBloc.dashboardScreenBloc.state.activeBusiness;
    companyAddress = activeBusiness.companyAddress;
    prepareDefaultCountries();
    if (companyAddress != null) {
      city = companyAddress.city;
      countryCode = companyAddress.country;
      if (countryCode != null)
        getCountryForCodeWithIdentifier(countryCode, 'en-en');
      street = companyAddress.street;
      zipCode = companyAddress.zipCode;
      googleAutocomplete = companyAddress.googleAutocomplete;

      autoCompleteController.text = googleAutocomplete ?? '';
      cityController.text = city ?? '';
      streetController.text = street ?? '';
      zipController.text = zipCode ?? '';
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
      appBar: Appbar('Address'),
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
                            Container(
                              padding:
                                  EdgeInsets.only(left: 8, top: 8, right: 8),
                              height: 65,
                              child: BlurEffectView(
                                color: Color.fromRGBO(100, 100, 100, 0.05),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(left: 12, right: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SvgPicture.asset(
                                          'assets/images/google-auto-complete.svg'),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                          controller: autoCompleteController,
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.url,
                                          onChanged: (val) {
                                            googleAutocomplete = val;
                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: 'Google Autocomplete',
                                              labelStyle: TextStyle(
                                                color: Colors.white54,
                                                fontSize: 12,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  EdgeInsets.only(left: 8, top: 2, right: 8),
                              child: BlurEffectView(
                                color: Color.fromRGBO(100, 100, 100, 0.05),
                                radius: 0,
                                child: Container(
                                  padding: EdgeInsets.only(left: 12, right: 12),
                                  child: DropdownButtonFormField(
                                    items: List.generate(countryList.length,
                                        (index) {
                                      return DropdownMenuItem(
                                        child: Text(
                                          countryList[index].name,
                                        ),
                                        value: countryList[index].name,
                                      );
                                    }).toList(),
                                    value: countryName ?? null,
                                    onChanged: (val) {
                                      countryName = val;
                                    },
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black54,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    hint: Text(
                                      'Country',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: 8,
                                top: 2,
                                right: 8,
                              ),
                              height: 65,
                              child: BlurEffectView(
                                color: Color.fromRGBO(100, 100, 100, 0.05),
                                radius: 0,
                                child: Container(
                                  padding: EdgeInsets.only(left: 12, right: 12),
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    controller: cityController,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.url,
                                    onChanged: (val) {
                                      city = val;
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'City is required.';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'City',
                                        labelStyle: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: 8,
                                top: 2,
                                right: 8,
                              ),
                              height: 65,
                              child: BlurEffectView(
                                color: Color.fromRGBO(100, 100, 100, 0.05),
                                radius: 0,
                                child: Container(
                                  padding: EdgeInsets.only(left: 12, right: 12),
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    controller: streetController,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.url,
                                    onChanged: (val) {
                                      street = val;
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Street is required.';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Street',
                                        labelStyle: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 8, top: 2, right: 8, bottom: 8),
                              height: 65,
                              child: BlurEffectView(
                                color: Color.fromRGBO(100, 100, 100, 0.05),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(left: 12, right: 12),
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    controller: zipController,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.url,
                                    onChanged: (val) {
                                      zipCode = val;
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'ZIP Code is required.';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'ZIP Code',
                                        labelStyle: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            SaveBtn(
                              isUpdating: state.isUpdating,
                              onUpdate: () {
                                if (_formKey.currentState.validate() &&
                                    !state.isUpdating) {
                                  Map<String, dynamic> body = {};
                                  body['city'] = city;
                                  String code = getCountryCode(countryName);
                                  if (code == null) {
                                    Fluttertoast.showToast(msg: 'Can not find country Code');
                                    return;
                                  }
                                  body['country'] = code.toUpperCase();
                                  body['street'] = street;
                                  body['zipCode'] = zipCode;
                                  if (googleAutocomplete != null) {
                                    body['googleAutocomplete'] =
                                        googleAutocomplete;
                                  }
                                  print(body);
                                  widget.setScreenBloc.add(BusinessUpdateEvent({
                                    'companyAddress': body,
                                  }));
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }

  Future<void> prepareDefaultCountries() async {
    List<Country> countries;
    try {
      countries = await IsoCountries.iso_countries;
    } on PlatformException {
      countries = null;
    }
    if (!mounted) return;
    setState(() {
      countryList = countries;
    });
  }

  Future<void> getCountryForCodeWithIdentifier(
      String code, String localeIdentifier) async {
    Country _country;
    try {
      _country = await IsoCountries.iso_country_for_code_for_locale(code,
          locale_identifier: localeIdentifier);
    } on PlatformException {
      _country = null;
    }
    if (!mounted) return;

    setState(() {
      countryName = _country.name;
    });
  }
  
  String getCountryCode(String countryName) {
    return countryList.where((element) => element.name == countryName).toList().first.countryCode;
  }  
}
