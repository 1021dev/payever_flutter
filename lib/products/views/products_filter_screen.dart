import 'package:date_format/date_format.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/contacts/models/model.dart';
import 'package:payever/products/widgets/product_filter_range_content_view.dart';
import 'package:payever/transactions/models/enums.dart';

import '../../theme.dart';

bool _isPortrait;
bool _isTablet;

class ProductsFilterScreen extends StatefulWidget {
  final ProductsScreenBloc screenBloc;

  ProductsFilterScreen({
    this.screenBloc,
  });

  @override
  _ProductsFilterScreenState createState() => _ProductsFilterScreenState();
}

class _ProductsFilterScreenState extends State<ProductsFilterScreen> {
  String selectedCategory = '';

  List<ContactFilterItem> filters = [
    ContactFilterItem(disPlayName: 'Name'),
    ContactFilterItem(disPlayName: 'Members count'),
    ContactFilterItem(disPlayName: 'Purchase date', type: 'Date'),
    ContactFilterItem(disPlayName: 'Orders count'),
    ContactFilterItem(disPlayName: 'Total spent'),
  ];

  DateTime startDate;
  DateTime endDate;

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

    Map<String, String> filterTypes = filterConditionsByFilterType('weight');
    return Scaffold(
      backgroundColor: overlayBackground(),
      resizeToAvoidBottomPadding: true,
      body: BlurEffectView(
        radius: 0,
        child: SafeArea(
          bottom: false,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 44,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Icon(Icons.close),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Text(
                            'Reset',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(24),
                  height: 44,
                  constraints: BoxConstraints.expand(height: 44),
                  child: SizedBox(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: overlayButtonBackground(),
                        ),
                        child: Text(
                          'Done',
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 24, bottom: 16),
                          child: Text(
                            'My products',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 24, bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                'Collections',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                             
                            ],
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            ContactFilterItem item = filters[index];
                            return Container(
                              child: Column(
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        item.isOpened = !item.isOpened;
                                        filters[index] = item;
                                      });
                                    },
                                    child: Container(
                                      height: 44,
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            item.disPlayName,
                                          ),
                                          Icon(
                                            item.isOpened
                                                ? Icons.close
                                                : Icons.add,
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  item.isOpened
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                              top: 8,
                                              bottom: 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  color: overlayBackground(),
                                                  child: item.condition != null
                                                      ? DropdownButtonFormField(
                                                          items: filterTypes
                                                              .keys
                                                              .toList()
                                                              .map((key) {
                                                            return DropdownMenuItem(
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            16),
                                                                child: Text(
                                                                  filterTypes[
                                                                      key],
                                                                ),
                                                              ),
                                                              value: key,
                                                            );
                                                          }).toList(),
                                                          onChanged: (val) {
                                                            setState(() {
                                                              item.condition =
                                                                  val;
                                                              filters[index] =
                                                                  item;
                                                            });
                                                          },
                                                          hint: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 16),
                                                            child: Text(
                                                              'Condition',
                                                            ),
                                                          ),
                                                          value: item.condition,
                                                        )
                                                      : DropdownButtonFormField(
                                                          items: filterTypes
                                                              .keys
                                                              .toList()
                                                              .map((key) {
                                                            return DropdownMenuItem(
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            16),
                                                                child: Text(
                                                                  filterTypes[
                                                                      key],
                                                                ),
                                                              ),
                                                              value: key,
                                                            );
                                                          }).toList(),
                                                          onChanged: (val) {
                                                            setState(() {
                                                              item.condition =
                                                                  val;
                                                              filters[index] =
                                                                  item;
                                                            });
                                                          },
                                                          hint: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 16),
                                                            child: Text(
                                                              'Condition',
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                                Container(
                                                  color: overlayRow(),
                                                  child: item.type == 'Date'
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            FlatButton(
                                                              onPressed:
                                                                  () async {
                                                                final DateTime picked = await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        startDate ??
                                                                            DateTime
                                                                                .now(),
                                                                    firstDate:
                                                                        DateTime(
                                                                            1990),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2030));
                                                                if (picked !=
                                                                        null &&
                                                                    picked !=
                                                                        startDate) {
                                                                  setState(() {
                                                                    startDate =
                                                                        picked;
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                startDate !=
                                                                        null
                                                                    ? formatDate(
                                                                        startDate,
                                                                        [
                                                                            mm,
                                                                            '/',
                                                                            dd,
                                                                            '/',
                                                                            yyyy
                                                                          ])
                                                                    : 'Start Date',
                                                              ),
                                                            ),
                                                            item.condition ==
                                                                    'between'
                                                                ? FlatButton(
                                                                    onPressed:
                                                                        () async {
                                                                      final DateTime picked = await showDatePicker(
                                                                          context:
                                                                              context,
                                                                          initialDate: endDate ??
                                                                              DateTime
                                                                                  .now(),
                                                                          firstDate: DateTime(
                                                                              1990),
                                                                          lastDate:
                                                                              DateTime(2030));
                                                                      if (picked !=
                                                                              null &&
                                                                          picked !=
                                                                              endDate)
                                                                        setState(
                                                                            () {
                                                                          endDate =
                                                                              picked;
                                                                        });
                                                                    },
                                                                    child: Text(
                                                                      endDate !=
                                                                              null
                                                                          ? formatDate(
                                                                              endDate, [
                                                                              mm,
                                                                              '/',
                                                                              dd,
                                                                              '/',
                                                                              yyyy
                                                                            ])
                                                                          : 'End Date',
                                                                    ),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        )
                                                      : TextFormField(
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                          onChanged: (val) {
                                                            setState(() {
                                                              item.value = val;
                                                              filters[index] =
                                                                  item;
                                                            });
                                                          },
                                                          readOnly: item.type ==
                                                              'Date',
                                                          initialValue:
                                                              item.value ?? '',
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    left: 16,
                                                                    right: 16),
                                                            labelText: Language
                                                                .getPosTpmStrings(
                                                                    'Search'),
                                                            labelStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            enabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          Colors
                                                                              .blue,
                                                                      width:
                                                                          0.5),
                                                            ),
                                                          ),
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                        ),
                                                ),
                                                Container(
                                                  height: 44,
                                                  child: SizedBox.expand(
                                                    child: MaterialButton(
                                                      onPressed: () {},
                                                      color: Colors.white38,
                                                      elevation: 0,
                                                      child: Text(
                                                        'Apply',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container();
                          },
                          itemCount: filters.length,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(8),
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 0,
                              thickness: 0,
                              color: Colors.transparent,
                            );
                          },
                          itemCount: filterProducts.keys.toList().length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                filterProducts[
                                    filterProducts.keys.toList()[index]],
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                showMeDialog(context,
                                    filterProducts.keys.toList()[index],
                                    (FilterItem val) {
                                  List<FilterItem> filterTypes = [];
                                  filterTypes.addAll(
                                      widget.screenBloc.state.filterTypes);
                                  if (val != null) {
                                    if (filterTypes.length > 0) {
                                      int isExist = filterTypes.indexWhere(
                                          (element) =>
                                              element.type == val.type);
                                      if (isExist > -1) {
                                        filterTypes[isExist] = val;
                                      } else {
                                        filterTypes.add(val);
                                      }
                                    } else {
                                      filterTypes.add(val);
                                    }
                                  } else {
                                    if (filterTypes.length > 0) {
                                      int isExist = filterTypes.indexWhere(
                                          (element) =>
                                              element.type == val.type);
                                      if (isExist != null) {
                                        filterTypes.removeAt(isExist);
                                      }
                                    }
                                  }
                                  widget.screenBloc.add(
                                      UpdateProductFilterTypes(
                                          filterTypes: filterTypes));
                                  Navigator.pop(context);
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showMeDialog(
      BuildContext context, String filterType, Function callback) {
    String filtername = filterProducts[filterType];
    debugPrint('FilterTypeName => $filterType');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Filter by: $filtername',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            content: ProductFilterRangeContentView(
                type: filterType,
                onSelected: (value) {
                  Navigator.pop(context);
                  callback(value);
                  // widget.onSelected(value);
                }),
          );
        });
  }
}
