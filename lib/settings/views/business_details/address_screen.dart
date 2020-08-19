import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  AddressScreen({this.globalStateModel, this.setScreenBloc});
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {

  TextEditingController autoCompleteController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  Business activeBusiness;
  CompanyAddress companyAddress;

  String city;
  String country;
  String street;
  String zipCode;
  String googleAutocomplete;

  List<Country> countries;

  @override
  Future<void> initState() {
    widget.setScreenBloc.add(GetBusinessProductsEvent());
    activeBusiness = widget.setScreenBloc.dashboardScreenBloc.state.activeBusiness;
    companyAddress = activeBusiness.companyAddress;
    prepareDefaultCountries();
    if (companyAddress != null) {
      city = companyAddress.city;
      country = companyAddress.country;
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

  Future<void> prepareDefaultCountries() async {
    try {
      countries = await IsoCountries.iso_countries;
    } on PlatformException {
      countries = null;
    }
    if (!mounted) return;
  }

  get _body {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: Appbar('Company'),
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
                          padding: EdgeInsets.only(left: 8, top: 8, right: 8),
                          child: BlurEffectView(
                            color: Color.fromRGBO(100, 100, 100, 0.05),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: 12, right: 12),
                              child: DropdownButtonFormField(
                                items: List.generate(countries.length, (index) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      countries[index].name,
                                    ),
                                    value: countries[index].countryCode,
                                  );
                                }).toList(),
                                value: country != '' ? country : null,
                                onChanged: (val) {
                                  country = val;
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black54,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                hint: Text(
                                  Language.getSettingsStrings('form.create_form.company.legal_form.label'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8, top: 2, right: 8, bottom: 8),
                          height: 65,
                          child: BlurEffectView(
                            color: Color.fromRGBO(100, 100, 100, 0.05),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: 12, right: 12),
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
                                  labelText: Language.getSettingsStrings('form.create_form.company.url_web.label'),
                                  labelStyle: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  )
                                ),
                              ),
                            ),
                          ),
                        ),
                        SaveBtn(
                          isUpdating: state.isUpdating,
                          onUpdate: () {

                            Map<String, dynamic> body = {};
                            if (city != null) {
                              body['city'] = city;
                            }
                            if (country != country) {
                              body['country'] = country;
                            }
                            if (street != null) {
                              body['street'] = street;
                            }
                            if (zipCode != null) {
                              body['zipCode'] = zipCode;
                            }
                            if (googleAutocomplete != null) {
                              body['googleAutocomplete'] = googleAutocomplete;
                            }

                            widget.setScreenBloc.add(BusinessUpdateEvent(
                              {
                                'companyDetails': body,
                              }
                            ));
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ),
          );
        },
      ),
    );
  }
}

