import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/widgets/product_item_image_view.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';

import '../../../theme.dart';

class AddProductsScreen extends StatefulWidget {

  final ShopEditScreenBloc screenBloc;
  AddProductsScreen(this.screenBloc);

  @override
  createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  
  bool _isPortrait;
  bool _isTablet;

  InAppWebViewController webView;
  double progress = 0;
  String url = '';

  String wallpaper;
  int selectedIndex = 0;
  List<FilterItem> filterTypes = [];
  int selectedTypes = 0;

  @override
  void initState() {
    widget.screenBloc.add(FetchProductsInitEvent());
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

    return BlocBuilder<ShopEditScreenBloc, ShopEditScreenState>(
      bloc: widget.screenBloc,
      builder: (BuildContext context, ShopEditScreenState state) {
        return _body(state);
      },
    );
  }

  Widget _body(ShopEditScreenState state) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: state.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Column(
                    children: <Widget>[
                      // _toolBar(state),
                      // _tagsBar(state),
                      Expanded(
                        child: _getBody(state),
                      ),
                      // _bottomBar(state),
                    ],
                  ),
                ),
        ),
      ),
    );
  }


  Widget _getBody(ShopEditScreenState state) {
    if (state.isLoading) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return gridBody(state);
  }

  Widget gridBody(ShopEditScreenState state) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, top: 16),
      child: GridView.count(
        crossAxisCount: _isTablet ? 3 : (_isPortrait ? 2 : 3),
        crossAxisSpacing: _isTablet ? 12 : (_isPortrait ? 6 : 12),
        mainAxisSpacing: 12,
        children: List.generate(
          state.products.length,
              (index) {
                ProductsModel productsModel = state.products[index];
                return Container(
                  margin: EdgeInsets.only(left: 3, right: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    color: overlayBackground(),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            ProductItemImage(
                              productsModel.images.isEmpty ? null : productsModel.images.first,
                            ),
                          ],
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 6/1.7,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8, right: 8, bottom: 3, top: 4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                AutoSizeText(
                                  productsModel.title,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500
                                  ),
                                  maxLines: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3, bottom: 1),
                                  child: Text(
                                    '${formatter.format(productsModel.price)} ${Measurements.currency(productsModel.currency)}',
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                // Text(
                                //   productsModel.onSales
                                //       ? Language.getProductListStrings('filters.quantity.options.outStock')
                                //       : Language.getProductListStrings('filters.quantity.options.inStock'),
                                //   style: TextStyle(
                                //     fontSize: 8,
                                //     fontWeight: FontWeight.w300,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 0,
                        thickness: 0.5,
                        color: Colors.white54,
                      ),
                      AspectRatio(
                        aspectRatio: 6/1,
                        child: Container(
                          child: InkWell(
                            onTap: (){
                              // onTap(product);
                            },
                            child: Center(child: Text('Open', style: TextStyle(fontSize: 12),)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
          },
        ),
      ),
    );

  }

  // Widget _toolBar(ProductsScreenState state) {
  //   int selectedCount = 0;
  //   if (state.isProductMode && state.productLists.length > 0) {
  //     selectedCount = state.productLists
  //         .where((element) => element.isChecked)
  //         .toList()
  //         .length;
  //   } else if (!state.isProductMode && state.collectionLists.length > 0) {
  //     selectedCount = state.collectionLists
  //         .where((element) => element.isChecked)
  //         .toList()
  //         .length;
  //   }
  //   return Stack(
  //     children: <Widget>[
  //       Container(
  //         height: 50,
  //         color: overlaySecondAppBar(),
  //         child: Row(
  //           children: <Widget>[
  //             Flexible(
  //               flex: 1,
  //               child: Row(
  //                       children: <Widget>[
  //                         Padding(
  //                           padding: EdgeInsets.only(left: 8),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             showSearchTextDialog(state);
  //                           },
  //                           child: Container(
  //                             padding: EdgeInsets.all(8),
  //                             child: SvgPicture.asset(
  //                               'assets/images/searchicon.svg',
  //                               width: 20,
  //                             ),
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: EdgeInsets.only(left: 8, right: 8),
  //                           child: Container(
  //                             width: 1,
  //                             color: Color(0xFF888888),
  //                             height: 24,
  //                           ),
  //                         ),
  //                         _filterButton(),
  //                         Padding(
  //                           padding: EdgeInsets.only(left: 8, right: 12),
  //                           child: Container(
  //                             width: 1,
  //                             color: Color(0xFF888888),
  //                             height: 24,
  //                           ),
  //                         ),
  //                         InkWell(
  //                           onTap: () {},
  //                           child: Text(
  //                             'Reset',
  //                             style: TextStyle(
  //                               fontSize: 14,
  //                               color: Colors.white,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     )
  //             ),
  //             Flexible(
  //               flex: 1,
  //               child: Container(
  //                       alignment: Alignment.centerRight,
  //                       padding: EdgeInsets.only(right: 8),
  //                       child: InkWell(
  //                         onTap: () {
  //                           showCupertinoModalPopup(
  //                             context: context,
  //                             builder: (BuildContext context) {
  //                               return ProductSortContentView(
  //                                 selectedIndex: state.sortType,
  //                                 onSelected: (val) {
  //                                   Navigator.pop(context);
  //                                   screenBloc.add(
  //                                       UpdateProductSortType(sortType: val));
  //                                 },
  //                               );
  //                             },
  //                           );
  //                         },
  //                         child: Container(
  //                           padding: EdgeInsets.all(8),
  //                           child: SvgPicture.asset(
  //                             'assets/images/sort-by-button.svg',
  //                             width: 20,
  //                           ),
  //                         ),
  //                       ),
  //                     )),
  //             Container(
  //               alignment: Alignment.centerRight,
  //               child: PopupMenuButton<MenuItem>(
  //                 icon: SvgPicture.asset(
  //                   isGridMode
  //                       ? 'assets/images/grid.svg'
  //                       : 'assets/images/list.svg',
  //                 ),
  //                 offset: Offset(0, 100),
  //                 onSelected: (MenuItem item) => item.onTap(),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 color: overlayFilterViewBackground(),
  //                 itemBuilder: (BuildContext context) {
  //                   return gridListPopUpActions(
  //                     (grid) => {
  //                       setState(() {
  //                         isGridMode = grid;
  //                       })
  //                     },
  //                   ).map((MenuItem item) {
  //                     return PopupMenuItem<MenuItem>(
  //                       value: item,
  //                       child: Row(
  //                         children: [
  //                           Expanded(
  //                             child: Text(
  //                               item.title,
  //                               style: TextStyle(
  //                                 fontSize: 14,
  //                                 fontWeight: FontWeight.w300,
  //                               ),
  //                             ),
  //                           ),
  //                           item.icon,
  //                         ],
  //                       ),
  //                     );
  //                   }).toList();
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       selectedCount > 0
  //           ? Container(
  //               height: 50,
  //               padding: EdgeInsets.only(
  //                 left: 16,
  //                 right: 16,
  //                 top: 4,
  //                 bottom: 4,
  //               ),
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   color: Color(0xFF888888),
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: <Widget>[
  //                     Row(
  //                       children: <Widget>[
  //                         Padding(
  //                           padding: EdgeInsets.only(left: 12),
  //                         ),
  //                         InkWell(
  //                           child: SvgPicture.asset(
  //                               'assets/images/xsinacircle.svg'),
  //                           onTap: () {
  //                             screenBloc.add(state.isProductMode
  //                                 ? UnSelectProductsEvent()
  //                                 : UnSelectCollectionsEvent());
  //                           },
  //                         ),
  //                         Padding(
  //                           padding: EdgeInsets.only(left: 8),
  //                         ),
  //                         Text(
  //                           '$selectedCount ITEM${selectedCount > 1 ? 'S' : ''} SELECTED',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     PopupMenuButton<OverflowMenuItem>(
  //                       icon: Icon(Icons.more_horiz),
  //                       offset: Offset(0, 100),
  //                       onSelected: (OverflowMenuItem item) => item.onTap(),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                       color: Colors.black87,
  //                       itemBuilder: (BuildContext context) {
  //                         return state.isProductMode
  //                             ? productsPopUpActions(context, state)
  //                                 .map((OverflowMenuItem item) {
  //                                 return PopupMenuItem<OverflowMenuItem>(
  //                                   value: item,
  //                                   child: Text(
  //                                     item.title,
  //                                     style: TextStyle(
  //                                       color: Colors.white,
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w300,
  //                                     ),
  //                                   ),
  //                                 );
  //                               }).toList()
  //                             : collectionsPopUpActions(context, state)
  //                                 .map((OverflowMenuItem item) {
  //                                 return PopupMenuItem<OverflowMenuItem>(
  //                                   value: item,
  //                                   child: Text(
  //                                     item.title,
  //                                     style: TextStyle(
  //                                       color: Colors.white,
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w300,
  //                                     ),
  //                                   ),
  //                                 );
  //                               }).toList();
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             )
  //           : Container(
  //               width: 0,
  //               height: 0,
  //             ),
  //     ],
  //   );
  // }
  //
  // Widget _filterButton() {
  //   return InkWell(
  //     onTap: () async {
  //       await showGeneralDialog(
  //         barrierColor: null,
  //         transitionBuilder: (context, a1, a2, wg) {
  //           final curvedValue =
  //               1.0 - Curves.ease.transform(a1.value);
  //           return Transform(
  //             transform: Matrix4.translationValues(
  //                 -curvedValue * 200, 0.0, 0),
  //             child: ProductsFilterScreen(
  //               screenBloc: screenBloc,
  //               globalStateModel: widget.globalStateModel,
  //             ),
  //           );
  //         },
  //         transitionDuration: Duration(milliseconds: 200),
  //         barrierDismissible: true,
  //         barrierLabel: '',
  //         context: context,
  //         pageBuilder: (context, animation1, animation2) {
  //           return null;
  //         },
  //       );
  //     },
  //     child: Container(
  //       padding: EdgeInsets.all(8),
  //       child: SvgPicture.asset(
  //         'assets/images/filter.svg',
  //         width: 20,
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _tagsBar(ProductsScreenState state) {
  //   _filterItems = [];
  //   if (state.filterTypes.length > 0) {
  //     for (int i = 0; i < state.filterTypes.length; i++) {
  //       String filterString =
  //           '${filterProducts[state.filterTypes[i].type]} ${filterConditions[state.filterTypes[i].condition]}: ${state.filterTypes[i].disPlayName}';
  //       TagItemModel item =
  //           TagItemModel(title: filterString, type: state.filterTypes[i].type);
  //       _filterItems.add(item);
  //     }
  //   }
  //   if (state.searchText.length > 0) {
  //     _filterItems.add(
  //         TagItemModel(title: 'Search is: ${state.searchText}', type: null));
  //     _searchTagIndex = _filterItems.length - 1;
  //   }
  //   return _filterItems.length > 0
  //       ? Container(
  //           width: Device.width,
  //           padding: EdgeInsets.only(
  //             left: 16,
  //             right: 16,
  //             top: 8,
  //             bottom: 8,
  //           ),
  //           child: Tags(
  //             key: _tagStateKey,
  //             itemCount: _filterItems.length,
  //             alignment: WrapAlignment.start,
  //             spacing: 4,
  //             runSpacing: 8,
  //             itemBuilder: (int index) {
  //               return ItemTags(
  //                 key: Key('filterItem$index'),
  //                 index: index,
  //                 title: _filterItems[index].title,
  //                 color: overlayColor(),
  //                 activeColor: overlayColor(),
  //                 textActiveColor: iconColor(),
  //                 textColor: iconColor(),
  //                 elevation: 0,
  //                 padding: EdgeInsets.only(
  //                   left: 16,
  //                   top: 8,
  //                   bottom: 8,
  //                   right: 16,
  //                 ),
  //                 removeButton: ItemTagsRemoveButton(
  //                     backgroundColor: Colors.transparent,
  //                     color: iconColor(),
  //                     onRemoved: () {
  //                       if (index == _searchTagIndex) {
  //                         _searchTagIndex = -1;
  //                         screenBloc
  //                             .add(UpdateProductSearchText(searchText: ''));
  //                       } else {
  //                         List<FilterItem> filterTypes = [];
  //                         filterTypes.addAll(state.filterTypes);
  //                         filterTypes.removeAt(index);
  //                         screenBloc.add(UpdateProductFilterTypes(
  //                             filterTypes: filterTypes));
  //                       }
  //                       return true;
  //                     }),
  //               );
  //             },
  //           ),
  //         )
  //       : Container();
  // }


}
