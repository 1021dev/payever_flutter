import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:payever/models/products.dart';
import 'package:payever/utils/appStyle.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/products/new_product.dart';

class ProductCategoryRow extends StatefulWidget {
  NewProductScreenParts parts;
  List<String> sugestions = List();
  String doc = "";
  String currentCat = "";
  ProductCategoryRow({@required this.parts});
  
  @override
  _ProductCategoryRowState createState() => _ProductCategoryRowState();

}

class _ProductCategoryRowState extends State<ProductCategoryRow> {
  
  String getCat;

  @override
  void initState() {
    super.initState();
    if(widget.parts.editMode){
      widget.parts.product.categories.forEach((f){
        widget.parts.categoryList.add(f.title);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    getCat = 
    '''
    query getCategory{getCategories(businessUuid: "${widget.parts.business}", title: "", pageNumber: 1, paginationLimit: 1000) {
           _id    
           slug    
           title    
           businessUuid
          }
          }
    ''';
    
    widget.doc  = getCat;
    return Expanded(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          //width: Measurements.width * 0.9,
          height: Measurements.height *(widget.parts.isTablet?0.05:0.07),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.parts.categoryList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.only(right: Measurements.width *0.015),
                child: Chip(
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  label:Text( widget.parts.categoryList[index],style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),),
                  deleteIcon: Icon(Icons.close),
                  onDeleted: (){
                    setState((){
                      widget.parts.categoryList.removeAt(index);
                    });
                  },
                ),
              );
            },
          )
        ),
        GraphQLProvider(
          client:widget.parts.client,
          child: Query(
            key: widget.parts.qkey,
            options: QueryOptions(variables: <String, dynamic>{}, document: widget.doc),
            builder: (QueryResult result, {VoidCallback refetch}) {
              if(result.errors != null){
                print(result.errors);
                return Center(
                  child:  Text("Error loading"),
                );
              }
              if(result.loading){
                return Center(
                  child:CircularProgressIndicator(),
                );
              }
              widget.sugestions = List();
              if(result.data["createCategory"] != null){
                widget.parts.categories.add(Categories.toMap(result.data["createCategory"]));
                widget.doc = getCat;
              }
              if(result.data["getCategories"] != null ){
                result.data["getCategories"].forEach((a){
                  widget.parts.categories.add(Categories.toMap(a));
                  widget.sugestions.add(a["title"]);
                });
              }
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left:Measurements.width * 0.025),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16)
                ),
                //width: Measurements.width * 0.9,
                height: Measurements.height *(widget.parts.isTablet?0.05:0.07),
                child:SimpleAutoCompleteTextField (
                  style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
                  textSubmitted: (text){
                    setState(() {
                      bool contained = true;
                      widget.parts.categories.forEach((s){
                        if(s.title.toLowerCase().compareTo(text.toLowerCase()) == 0) contained =false;
                      });
                      if(contained){
                        print("NEW Category");
                        widget.doc = '''mutation createCategory {
                            createCategory(category: {businessUuid: "${widget.parts.business}", title: "$text"}) {
                                _id
                                businessUuid
                                title
                                slug
                              }
                            }''';
                            refetch();
                      }else{
                        print("OLD");
                      }
                      widget.parts.categoryList.add(text);
                    });
                    
                  },
                  suggestionsAmount: 5,
                  decoration: InputDecoration(
                    hintText: Language.getProductStrings("category.add_category"),
                    border: InputBorder.none,
                  ), 
                  key: widget.parts.atfKey,
                  suggestions: widget.sugestions, 
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