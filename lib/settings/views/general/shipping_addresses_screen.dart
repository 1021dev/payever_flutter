import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iso_countries/country.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/commons/models/user.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/settings/widgets/auto_complete_text_view.dart';

class ShippingAddressesScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;

  const ShippingAddressesScreen({Key key, this.globalStateModel, this.setScreenBloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShippingAddressesScreenState();
  }

}

class _ShippingAddressesScreenState extends State<ShippingAddressesScreen> {

  Business activeBusiness;
  User user;

  List<ShippingAddress> shippingAddresses = [];

  final _formKey = GlobalKey<FormState>();
  int selectedSection = 0;
  List<Country> countryList;

  @override
  void initState() {
    activeBusiness =
        widget.globalStateModel.currentBusiness;
    user = widget.setScreenBloc.state.user;
    shippingAddresses = user.shippingAddresses;

    if (shippingAddresses.length == 0) {
      shippingAddresses.add(ShippingAddress());
    }
    prepareDefaultCountries().then((value) {
      setState(() {
        countryList = value;
      });
    });
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
      appBar: Appbar('Shipping Address'),
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
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              ShippingAddress shippingAddress = shippingAddresses[index];
                              TextEditingController locationTextController = TextEditingController();
                              locationTextController.text = '';
                              return Column(
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
                                              if (selectedSection == index) {
                                                selectedSection = -1;
                                              } else {
                                                selectedSection = index;
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
                                                selectedSection == index ? Icons.remove : Icons.add,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  selectedSection == index ? Container(
                                    child: Column(
                                      children: <Widget>[
                                        BlurEffectView(
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
                                                    'assets/images/google-auto-complete.svg',
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                    controller: locationTextController,
                                                    textInputAction: TextInputAction.done,
                                                    keyboardType: TextInputType.url,
                                                    onChanged: (val) {

                                                    },
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      labelText: 'Google Autocomplete',
                                                      labelStyle: TextStyle(
                                                        color: Colors.white54,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        BlurEffectView(
                                          color: Color.fromRGBO(100, 100, 100, 0.05),
                                          radius: 0,
                                          child: Container(
                                            height: 65,
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
                                              value: shippingAddress.country ?? null,
                                              onChanged: (val) {
                                                shippingAddress.country = val;
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
                                        BlurEffectView(
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
                                                    shippingAddress.city= val;
                                                  });
                                                },
                                                initialValue: shippingAddress.city ?? '',
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
                                          ),
                                        ),
                                        BlurEffectView(
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
                                                    shippingAddress.street = val;
                                                  });
                                                },
                                                initialValue: shippingAddress.street ?? '',
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
                                          ),
                                        ),
                                        BlurEffectView(
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
                                                    shippingAddress.apartment = val;
                                                  });
                                                },
                                                initialValue: shippingAddress.apartment ?? '',
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 16, right: 16),
                                                  labelText: Language.getPosTpmStrings('Apartment, suite, etc (optional)'),
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
                                        BlurEffectView(
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
                                                    shippingAddress.zipCode = val;
                                                  });
                                                },
                                                initialValue: shippingAddress.zipCode ?? '',
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 16, right: 16),
                                                  labelText: Language.getPosTpmStrings('ZIP Code'),
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
                                  ) : Container(),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                height: 0,
                                color: Colors.grey,
                                thickness: 0.5,
                              );
                            },
                            itemCount: shippingAddresses.length,
                          ),
                          Container(
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
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Add +',),
                                ),
                              ),
                            ),
                          )                ],
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