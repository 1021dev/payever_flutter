import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:payever/checkout_process/checkout_process.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../utils/utils.dart';
import 'new_product.dart';

/// ***
/// Old and current implementation.
/// ***

class ProductCategoryRow extends StatefulWidget {
  final NewProductScreenParts parts;

  ProductCategoryRow({@required this.parts});

  @override
  createState() => _ProductCategoryRowState();
}

class _ProductCategoryRowState extends State<ProductCategoryRow> {
  String getCat;

  List<String> suggestions = List();
  String doc = "";
  String currentCat = "";

  @override
  void initState() {
    super.initState();
    if (widget.parts.editMode) {
      widget.parts.product.categories.forEach((f) {
        widget.parts.categoryList.add(f.title);
      });
    }
    getCat = '''
    query getCategory{getCategories(businessUuid: "${widget.parts.business}", title: "", pageNumber: 1, paginationLimit: 1000) {
           id    
           slug    
           title    
           businessUuid
          }
          }
    ''';

    doc = getCat;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            //width: Measurements.width * 0.9,
            height: widget.parts.categoryList.isEmpty
                ? 0
                : Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
            child: Container(
              alignment: Alignment.centerLeft,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.parts.categoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.only(right: Measurements.width * 0.015),
                    child: Chip(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      label: Text(
                        widget.parts.categoryList[index],
                        style:
                            TextStyle(fontSize: AppStyle.fontSizeTabContent()),
                      ),
                      deleteIcon: Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          widget.parts.categoryList.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          GraphQLProvider(
            client: widget.parts.client,
            child: Query(
              key: widget.parts.qKey,
              options:
                  QueryOptions(variables: <String, dynamic>{}, document: doc),
              builder: (QueryResult result,
                  {VoidCallback refetch, fetchMore: null}) {
                if (result.exception != null) {
                  print(result.exception);
                  return Center(
                    child: Text("Error loading"),
                  );
                }
                if (result.loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                suggestions = List();
                if (result.data["createCategory"] != null) {
                  widget.parts.categories.add(ProductCategoryInterface.fromMap(
                      result.data["createCategory"]));
                  doc = getCat;
                }
                if (result.data["getCategories"] != null) {
                  result.data["getCategories"].forEach(
                    (a) {
                      widget.parts.categories
                          .add(ProductCategoryInterface.fromMap(a));
                      suggestions.add(
                        a["title"],
                      );
                    },
                  );
                }
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: Measurements.width * 0.025),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16)),
                  //width: Measurements.width * 0.9,
                  height: Measurements.height *
                      (widget.parts.isTablet ? 0.05 : 0.07),
                  child: SimpleAutoCompleteTextField(
                    style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
                    textSubmitted: (text) {
                      setState(
                        () {
                          bool contained = true;
                          widget.parts.categories.forEach((s) {
                            if (s.title
                                    .toLowerCase()
                                    .compareTo(text.toLowerCase()) ==
                                0) contained = false;
                          });
                          if (contained) {
                            print("NEW Category");
                            doc = '''mutation createCategory {
                            createCategory(category: {businessUuid: "${widget.parts.business}", title: "$text"}) {
                                _id
                                businessUuid
                                title
                                slug
                              }
                            }''';
                          } else {
                            print("OLD");
                          }
                          widget.parts.categoryList.add(text);
                        },
                      );
                    },
                    suggestionsAmount: 5,
                    decoration: InputDecoration(
                      hintText:
                          Language.getProductStrings("category.add_category"),
                      border: InputBorder.none,
                    ),
                    key: widget.parts.atfKey,
                    suggestions: suggestions,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ***
/// ^ old implementation
/// 
/// HERE 
/// 
/// Current implementation
/// ***

class CategoryBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ValueNotifier<GraphQLClient>(
        GraphQLClient(
          cache: InMemoryCache(),
          link: HttpLink(
            uri: Env.products + "/products",
          ),
        ),
      ),
      child: Query(
        options: QueryOptions(variables: <String, dynamic>{}, document: '''
          query getCategory{getCategories(businessUuid: "${Provider.of<GlobalStateModel>(context).currentBusiness.id}", title: "", pageNumber: 1, paginationLimit: 1000) {
                  id    
                  slug    
                  title    
                  businessUuid
                }
                }
          '''),
        builder: (
          QueryResult result, {
          VoidCallback refetch,
          fetchMore: null,
        }) {
          if (result.exception != null) {
            print(result.exception);
            return Center(
              child: Text("Error loading"),
            );
          }
          if (result.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<String> suggestions = List();
          List<ProductCategoryInterface> categories = List();
          if (result.data["createCategory"] != null) {
            categories.add(
              ProductCategoryInterface.fromMap(
                result.data["createCategory"],
              ),
            );
          }
          if (result.data["getCategories"] != null) {
            result.data["getCategories"].forEach((a) {
              categories.add(ProductCategoryInterface.fromMap(a));
              suggestions.add(
                a["title"],
              );
            });
          }
          Provider.of<ProductStateModel>(context).fixCategories(categories);
          return CategoryPicker(
            suggestions: suggestions,
            categories: categories,
          );
        },
      ),
    );
  }
}

class CategoryPicker extends StatefulWidget {
  final List<String> suggestions;
  final List<ProductCategoryInterface> categories;

  const CategoryPicker({this.suggestions, this.categories});
  @override
  _CategoryPickerState createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  @override
  Widget build(BuildContext context) {
    ProductStateModel productProvider = Provider.of<ProductStateModel>(context);
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: (productProvider.editProduct.categories?.length ?? 0) == 0
                ? 0
                : 59,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: productProvider.editProduct.categories?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 15,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                          productProvider.editProduct.categories[index].title,
                          style: TextStyle(
                            fontSize: AppStyle.fontSizeTabContent(),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          child: Icon(
                            Icons.close,
                            size: 19,
                          ),
                          onTap: () {
                            setState(
                              () {
                                productProvider.editProduct.categories
                                    .removeAt(index);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 59,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SimpleAutoCompleteTextField(
              textSubmitted: (text) {
                setState(
                  () {
                    int catIndex = widget.categories
                        .indexWhere((cat) => cat.title == text);
                    if (catIndex > 0) {
                      if (!productProvider.editProduct.categories
                          .contains(widget.categories[catIndex]))
                        productProvider.editProduct.categories
                            .add(widget.categories[catIndex]);
                    }
                  },
                );
              },
              suggestionsAmount: 5,
              decoration: InputDecoration(
                hintText: Language.getProductStrings("category.add_category"),
                border: InputBorder.none,
              ),
              suggestions: widget.suggestions,
              key: null,
            ),
          ),
        ],
      ),
    );
  }
}
