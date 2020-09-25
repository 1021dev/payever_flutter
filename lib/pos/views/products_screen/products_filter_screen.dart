import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/theme.dart';

class ProductsFilterScreen extends StatefulWidget {
  final PosScreenBloc screenBloc;

  ProductsFilterScreen({
    this.screenBloc,
  });

  @override
  _ProductsFilterScreenState createState() =>
      _ProductsFilterScreenState();
}

class _ProductsFilterScreenState extends State<ProductsFilterScreen> {
  String selectedCategory = '';
  List<String> subCategories = [];
  bool _isPortrait;
  bool _isTablet;
  
  @override
  void initState() {
//    selectedCategory = widget.screenBloc.state.selectedCategory;
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
        // if (state is PosScreenStateFailure) {
        //   Fluttertoast.showToast(msg: state.error);
        // }
      },
      child: BlocBuilder<PosScreenBloc, PosScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, PosScreenState state) {
          return new OrientationBuilder(builder: (context, orientation) {
            return Scaffold(
              backgroundColor: overlayBackground(),
              resizeToAvoidBottomPadding: false,
              body: BlurEffectView(
                radius: 0,
                child: SafeArea(
                  bottom: false,
                  child: state.isUpdating
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _getBody(state),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _getBody(PosScreenState state) {
    return Container(
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
              child: MaterialButton(
                onPressed: () {
                  widget.screenBloc.add(ProductsFilterEvent(
                      category: selectedCategory,
                      subCategories: subCategories));
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                color: overlayFilterViewBackground(),
                child: Text(
                  'Done',
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = 'All';
                        subCategories = [];
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 24),
                      height: 44,
                      child: Text(
                        'All Products',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected('All')
                            ? overlayColor()
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _divider(),
                  ),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    itemBuilder: (context, index) {
                      String category = state.filterOptions[index].name;
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory =
                                    isSelected(category) ? '' : category;
                                if (selectedCategory.isEmpty) {
                                  subCategories = [];
                                }
                              });
                            },
                            child: Container(
                              height: 44,
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                  ),
                                  Text(
                                    getMainCategory(category),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    isSelected(category)
                                        ? Icons.clear
                                        : Icons.add,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _subCategories(state.filterOptions[index]),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => _divider(),
                    itemCount:state.filterOptions.length,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subCategories(ProductFilterOption filterOption) {
    return isSelected(filterOption.name)
        ? ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              String subCategory = filterOption.values[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isContainSubCategory(subCategory))
                      subCategories.remove(subCategory);
                    else
                      subCategories.add(subCategory);
                  });
                },
                child: Container(
                  height: 44,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isContainSubCategory(subCategory))
                        ? overlayColor()
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                      ),
                      Text(
                        getSubCategory(subCategory),
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return _divider();
            },
            itemCount: filterOption.values.length,
          )
        : Container();
  }

  bool isSelected(String category) {
    if (selectedCategory == null) return false;
    return selectedCategory == category;
  }

  bool isContainSubCategory(String subCategory) {
    return subCategories.contains(subCategory);
  }

  Widget _divider() {
    return Divider(
      height: 0,
      thickness: 0.5,
    );
  }

  String getMainCategory(String code) {
    code = code.replaceAll('BUSINESS_PRODUCT_', '');
    code = code.replaceAll('_', ' ');
    return code[0].toUpperCase() + code.substring(1).toLowerCase();
  }

  String getSubCategory(String code) {
    String title = code.split('_').first;
    code = code.replaceAll('${title}_', '');
    code = code.replaceAll('_', ' ');
    return code[0].toUpperCase() + code.substring(1).toLowerCase();
  }

}