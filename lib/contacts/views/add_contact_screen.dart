import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/contacts/models/model.dart';
import 'package:payever/contacts/views/add_new_field_screen.dart';
import 'package:payever/contacts/widgets/contact_options_contentview.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';

bool _isPortrait;
bool _isTablet;

class AddContactScreen extends StatefulWidget {

  final ContactScreenBloc screenBloc;
  final Contact editContact;

  AddContactScreen({
    this.screenBloc,
    this.editContact,
  });

  @override
  createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ContactDetailScreenBloc screenBloc;
  String wallpaper;
  String selectedState = '';
  bool openGeneral = true;
  bool openAdditional = true;
  final String contactPlaceholder = 'https://payeverstage.azureedge.net/placeholders/contact-placeholder.png';

  var imageData;

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
    screenBloc = ContactDetailScreenBloc();
    if (widget.editContact != null) {
      screenBloc.add(GetContactDetail(contact: widget.editContact, business: widget.screenBloc.dashboardScreenBloc.state.activeBusiness.id));
    } else {
      screenBloc.add(ContactDetailScreenInitEvent(business: widget.screenBloc.dashboardScreenBloc.state.activeBusiness.id));
    }
  }

  @override
  void dispose() {
    screenBloc.close();
    print('dispose');
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
    String type = '';
    String firstName = '';
    String lastName = '';
    String mobilePhone = '';
    String email = '';
    String homePage = '';
    String street = '';
    String city = '';
    String stateString = '';
    String zip = '';
    String country = '';
    String image = '';

    if (state.contact != null) {
      type = state.contact.type;
      if (state.blobName != '') {
        image = state.blobName;
      } else {
        List<ContactField> imageFields = state.contact.contactFields.nodes.where((element) {
          return element.field.name == 'imageUrl';
        }).toList();
        if (imageFields.length > 0) {
          image = imageFields.first.value;
        }
      }
      print(image);
      List<ContactField> emailFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'email';
      }).toList();
      if (emailFields.length > 0) {
        email = emailFields.first.value;
      }

      List<ContactField> firstNameFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'firstName';
      }).toList();
      if (firstNameFields.length > 0) {
        firstName = firstNameFields.first.value;
      }

      List<ContactField> lastNameFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'lastName';
      }).toList();
      if (lastNameFields.length > 0) {
        lastName = lastNameFields.first.value;
      }

      List<ContactField> phoneFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'mobilePhone';
      }).toList();
      if (phoneFields.length > 0) {
        mobilePhone = phoneFields.first.value;
      }

      List<ContactField> homePageFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'homepage';
      }).toList();
      if (homePageFields.length > 0) {
        homePage = homePageFields.first.value;
      }

      List<ContactField> streetFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'street';
      }).toList();
      if (streetFields.length > 0) {
        street = streetFields.first.value;
      }

      List<ContactField> cityFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'city';
      }).toList();
      if (cityFields.length > 0) {
        city = cityFields.first.value;
      }

      List<ContactField> stateFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'state';
      }).toList();
      if (stateFields.length > 0) {
        stateString = stateFields.first.value;
      }

      List<ContactField> zipFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'zip';
      }).toList();
      if (zipFields.length > 0) {
        zip = zipFields.first.value;
      }

      List<ContactField> coungryFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'country';
      }).toList();
      if (coungryFields.length > 0) {
        country = coungryFields.first.value;
      }
    }

    List<Widget> widgets = [];
    Widget header = Container(
      height: 56,
      color: Colors.black54,
      child: SizedBox.expand(
        child: MaterialButton(
          onPressed: () {
            setState(() {
              openGeneral = !openGeneral;
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
                openGeneral ? Icons.add : Icons.remove,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );

    widgets.add(header);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    // Photo section;
    Widget photoSection = openGeneral ? Container(
        height: 200,
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: EdgeInsets.all(16),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: state.uploadPhoto ? Center(
                      child: Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                      ),
                    ) : (image == '' ? SvgPicture.asset('assets/images/add_contacts.svg')
                        : CachedNetworkImage(
                      alignment: Alignment.center,
                      imageUrl: image,
                      imageBuilder: (context, imageProvider) => Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xffededf4), Color(0xffaeb0b7)],
                          ),
                        ),
                        child: Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ) ,
                      placeholder: (context, url) => Container(
                        child: Center(
                          child: Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                    )),
                  ),
                ),
                Container(
                  width: 120,
                  child: MaterialButton(
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => CupertinoActionSheet(
                          title: const Text('Choose Photo'),
                          message: const Text('Your options are '),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: const Text('Take a Picture'),
                              onPressed: () {
                                Navigator.pop(context, 'Take a Picture');
                                getImage(0);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: const Text('Camera Roll'),
                              onPressed: () {
                                Navigator.pop(context, 'Camera Roll');
                                getImage(1);
                              },
                            )
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text('Cancel'),
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.pop(context, 'Cancel');
                            },
                          ),
                        ),
                      );
                    },
                    minWidth: 0,
                    padding: EdgeInsets.all(4),
                    height: 24,
                    color: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset('assets/images/add.svg'),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                          ),
                          Text(
                            'Add Media',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Helvetica Neue',
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
        )
    ) : Container();

    widgets.add(photoSection);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget typeField = openGeneral ? Container(
      height: 64,
      child: Center(
        child: TextFormField(
          style: TextStyle(fontSize: 16),
          onChanged: (val) {
            setState(() {

            });
          },
          initialValue: type,
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
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget nameSection = openGeneral ? Container(
      height: 64,
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: firstName,
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
          Container(
            width: 0.5,
            color: Colors.black,
          ),
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: lastName,
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
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget phoneSection = openGeneral ? Container(
      height: 64,
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: mobilePhone,
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
          Container(
            width: 0.5,
            color: Colors.black,
          ),
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: email,
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
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget homepageField = openGeneral ? Container(
      height: 64,
      child: Center(
        child: TextFormField(
          style: TextStyle(fontSize: 16),
          onChanged: (val) {
            setState(() {
            });
          },
          initialValue: homePage,
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
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget streetField = openGeneral ? Container(
      height: 64,
      child: Center(
        child: TextFormField(
          style: TextStyle(fontSize: 16),
          onChanged: (val) {
            setState(() {
            });
          },
          initialValue: street,
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
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget citySection = openGeneral ? Container(
      height: 64,
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: city,
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
          Container(
            width: 0.5,
            color: Colors.black,
          ),
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
              },
              initialValue: stateString,
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
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    Widget zipSection = openGeneral ? Container(
      height: 64,
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: zip,
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
          Container(
            width: 0.5,
            color: Colors.black,
          ),
          Flexible(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                });
              },
              initialValue: country,
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
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    // Additional Section
    Widget additionalSection = Container(
      height: 56,
      color: Colors.black54,
      child: SizedBox.expand(
        child: MaterialButton(
          onPressed: () {
            setState(() {
              openAdditional = !openAdditional;
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
                        'ADDITIONAL',
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
                openAdditional ? Icons.add : Icons.remove,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );

    widgets.add(additionalSection);
    widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);

    if (openAdditional) {
      state.additionalFields.forEach((element) {
        if (element.type == 'input') {
          Widget w = Container(
            height: 56,
            color: Colors.black38,
            child: SizedBox.expand(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      style: TextStyle(fontSize: 16),
                      onChanged: (val) {
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 16, right: 16),
                        labelText: Language.getPosTpmStrings(element.name),
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
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {

                        },
                        color: Colors.white60,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 24,
                        minWidth: 0,
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          screenBloc.add(RemoveAdditionalField(field: element));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.remove_circle),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
          widgets.add(w);
        } else if (element.type == 'select') {
          Widget w = Container(
            height: 56,
            color: Colors.black38,
            child: SizedBox.expand(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      style: TextStyle(fontSize: 16),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 16, right: 16),
                        labelText: Language.getPosTpmStrings(element.name),
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
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {

                        },
                        color: Colors.white60,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 24,
                        minWidth: 0,
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          screenBloc.add(RemoveAdditionalField(field: element));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.remove_circle),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
          widgets.add(w);
        } else if (element.type == 'checkbox') {
          Widget w = Container(
            height: 56,
            color: Colors.black38,
            child: SizedBox.expand(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                      ),
                      Icon(Icons.check_box_outline_blank),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                      ),
                      Text(
                        element.name,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {

                        },
                        color: Colors.white60,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 24,
                        minWidth: 0,
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          screenBloc.add(RemoveAdditionalField(field: element));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.remove_circle),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
          widgets.add(w);
        } else if (element.type == 'textarea') {
          Widget w = Container(
            height: 56,
            color: Colors.black38,
            child: SizedBox.expand(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      style: TextStyle(fontSize: 16),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 16, right: 16),
                        labelText: Language.getPosTpmStrings(element.name),
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
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {

                        },
                        color: Colors.white60,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 24,
                        minWidth: 0,
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          screenBloc.add(RemoveAdditionalField(field: element));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.remove_circle),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
          widgets.add(w);
        } else if (element.type == 'number') {
          Widget w = Container(
            height: 56,
            color: Colors.black38,
            child: SizedBox.expand(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      style: TextStyle(fontSize: 16),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 16, right: 16),
                        labelText: Language.getPosTpmStrings(element.name),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 0.5),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {

                        },
                        color: Colors.white60,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 24,
                        minWidth: 0,
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          screenBloc.add(RemoveAdditionalField(field: element));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.remove_circle),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
          widgets.add(w);
        } else if (element.type == 'multiselect') {
          Widget w = Container(
            height: 56,
            color: Colors.black38,
            child: SizedBox.expand(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      style: TextStyle(fontSize: 16),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 16, right: 16),
                        labelText: Language.getPosTpmStrings(element.name),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 0.5),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {

                        },
                        color: Colors.white60,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 24,
                        minWidth: 0,
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          screenBloc.add(RemoveAdditionalField(field: element));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.remove_circle),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
          widgets.add(w);
        }
        widgets.add(Divider(height: 0, thickness: 0.5, color: Colors.black),);
      });
    } else {

    }
    Widget optionsSection = openAdditional ? Container(
      height: 56,
      color: Colors.black38,
      child: SizedBox.expand(
        child: MaterialButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return ContactOptionContentView(
                  onAddNewField: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      PageTransition(
                        child: AddNewFieldScreen(
                          screenBloc: screenBloc,
                        ),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  onSelectPrevious: (val) {
                    Navigator.pop(context);
                    showLoadDialog(val);
                  },
                  fields: state.customFields,
                );
              },
            );
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
                        'Options',
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
                Icons.keyboard_arrow_down,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    ) : Container();

    widgets.add(optionsSection);

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
          Padding(
            padding: EdgeInsets.only(top: 16),
          ),
          Container(
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
          ),

        ],
      ),
    );
  }

  Future getImage(int type) async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.getImage(
      source: type == 1 ? ImageSource.gallery : ImageSource.camera,
    );
    if (image != null) {
      await _cropImage(File(image.path));
    }
  }

  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    if (croppedFile != null) {
      screenBloc.add(AddContactPhotoEvent(file: croppedFile));
    }

  }

  showLoadDialog(Field field) {
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
                          Language.getPosStrings('This will load the template from ${field.name}'),
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
                                screenBloc.add(LoadTemplateEvent(field: field));
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
                                Language.getCommerceOSStrings('Load'),
                              ),
                            ),
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
