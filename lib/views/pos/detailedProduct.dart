


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:payever/models/products.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/customelements/color_picker.dart';
import 'package:payever/views/customelements/custom_toast_notification.dart';
import 'package:payever/views/pos/native_pos_screen.dart';

class DetailScreen extends StatefulWidget {
  PosScreenParts parts;
  ProductsModel currentProduct;
  DetailScreen({this.parts,this.currentProduct});
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close,color: Colors.black,),
            onPressed: ()=>Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text("Product details",style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(child: DetailedProduct(currentProduct: widget.currentProduct, parts: widget.parts,)),
      ),
    );
  }
}
class DetailedProduct extends StatefulWidget {
  ProductsModel currentProduct;
  PosScreenParts parts;
  List<String> imagesBase = List();
  bool haveVariants = false;
  int currentVariantIndex = 0;
  ValueNotifier<bool> stockCount = ValueNotifier(false);
  ValueNotifier<int> currentVariant = ValueNotifier(0);
  Map<String,String> productStock = Map();
  DetailedProduct({@required this.currentProduct,@required this.parts}){
    imagesBase = currentProduct.images;
  }

  @override
  _DetailedProductState createState() => _DetailedProductState();
}

class _DetailedProductState extends State<DetailedProduct> {
  List<String> imagesVariants = List();
  @override
  void initState() {
    super.initState();
    widget.currentVariant.addListener(listener);

    // List<Map<String,String>> skuStock = List();
    // if(widget.currentProduct.variants.isNotEmpty){
    // widget.currentProduct.variants.forEach((current){
    //   RestDatasource().getInvetory(widget.parts.business.id, GlobalUtils.ActiveToken.accessToken, current.sku, context).then((inv){
    //     widget.productStock.addAll({"${current.sku}" : "${InventoryModel.toMap(inv).stock.toString()}"});
    //     if(current.sku == widget.currentProduct.variants.last.sku){
    //       widget.stockCount.value = true;
    //     }
    //   });
    // });
    // }else{
    //   RestDatasource().getInvetory(widget.parts.business.id, GlobalUtils.ActiveToken.accessToken, widget.currentProduct.sku, context).then((inv){
    //     widget.productStock.addAll({"${InventoryModel.toMap(inv).sku}" : "${InventoryModel.toMap(inv).stock.toString()}"});        
    //     widget.stockCount.value = true;
    //   });
    // }

  }
  listener(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Measurements.width *0.05),
        child:ListView(
          shrinkWrap: true,
          children: <Widget>[
            DetailDetails(currentVariant: widget.currentVariant, parts: widget.parts, currentProduct: widget.currentProduct, haveVariants: widget.haveVariants,stockCount: widget.stockCount,productStock: widget.productStock),  
          ],
        ),
      ),
    );
  }
}

class DetailImage extends StatefulWidget{

  ProductsModel currentProduct;
  ValueNotifier<int> currentVariant;
  PosScreenParts parts;
  List<String> images= List();
  int index;
  bool haveVariants;
  DetailImage({@required this.currentVariant,@required this.parts,@required this.images,@required this.index,});
  @override
  _DetailImageState createState() => _DetailImageState();

}

class _DetailImageState extends State<DetailImage> {
  @override
  void initState() {
    super.initState();
    widget.currentVariant.addListener(listener);
  }

  listener(){

    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    List<Widget> images = List();
    widget.images.forEach((f){
      images.add(CachedNetworkImage(
        imageUrl: Env.Storage +"/products/"+ f,
        placeholder: (context, url) =>  Container(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
        fit: BoxFit.contain,
      ));
    });
    
    return Container(
      child: Column(
        children: <Widget>[
          // Container(
          //   height: widget.parts.isTablet?Measurements.width *0.45 : Measurements.height * 0.4,
          //   width: widget.parts.isTablet? Measurements.width *0.45 : Measurements.height * 0.4,
          //   child:Swiper(
          //     loop: false,
          //     controller: SwiperController(),
          //     index: widget.index,
          //     itemCount: widget.images.length,
          //     itemBuilder: (BuildContext context,int index){
          //       return CachedNetworkImage(
          //         imageUrl: Env.Storage +"/products/"+ widget.images[index],
          //         placeholder: (context, url) =>  Container(),
          //         errorWidget: (context, url, error) => new Icon(Icons.error),
          //         fit: BoxFit.contain,
          //         );
          //     },
          //     )
          // ),
          // Container(
          //   height: widget.parts.isTablet?Measurements.width *0.45 : Measurements.height * 0.4,
          //   width: widget.parts.isTablet? Measurements.width *0.45 : Measurements.height * 0.4,
          //   child:CarouselSlider(
          //     aspectRatio: 1,
          //     realPage: widget.index,
          //     initialPage: widget.index,
          //     items: images,
          //     enableInfiniteScroll: false,
          //     )
          // ),
          Container(
            height: widget.parts.isTablet?Measurements.width *0.45 : Measurements.height * 0.4,
            width: widget.parts.isTablet? Measurements.width *0.45 : Measurements.height * 0.4,
            child: widget.images.isNotEmpty?
            CachedNetworkImage(
              imageUrl: Env.Storage +"/products/"+ widget.images[widget.index],
              placeholder: (context, url) =>  Container(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
              fit: BoxFit.contain,
            ):Container(child: Center(child: SvgPicture.asset("images/noimage.svg",color: Colors.grey.withOpacity(0.7),width:widget.parts.isTablet? Measurements.width *0.2 : Measurements.height * 0.1,),),),
          ),
          Container(
            width: widget.parts.isTablet?Measurements.width *0.45 : Measurements.height * 0.4,
            height: Measurements.height * 0.1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.images.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: Container(
                    height: Measurements.height * 0.1,
                    width: Measurements.height * 0.1,
                    padding: EdgeInsets.all(Measurements.width * 0.01),
                      child:CachedNetworkImage(
                        imageUrl: Env.Storage +"/products/"+ widget.images[index],
                        placeholder: (context, url) =>  Container(),
                        errorWidget: (context, url, error) => new Icon(Icons.error),
                        fit: BoxFit.contain,
                      )
                  ),
                  onTap: (){
                    setState(() {
                      widget.index=index;
                    });
                  },
                );
              },),
          )
        ],
      ),
    );
  }
}

class DetailDetails extends StatefulWidget {
  ValueNotifier<int> currentVariant;
  ValueNotifier<bool> stockCount;
  PosScreenParts parts;
  ProductsModel currentProduct;
  num price,salePrice;
  bool onSale,haveVariants;
  String description;
  List<String> imagesBase = List();
  List<PopupMenuItem<String>> products= List();
  Map<String,String> productStock = Map();
  TextStyle textStyle = TextStyle(color: Colors.black);
  DetailDetails({@required this.currentVariant,@required this.parts,@required this.currentProduct,@required this.haveVariants,@required this.stockCount,@required this.productStock}){
    imagesBase = currentProduct.images;
  }
  @override
  _DetailDetailsState createState() => _DetailDetailsState();
}

class _DetailDetailsState extends State<DetailDetails> {
   List<String> imagesVariants = List();
  @override
  void initState() {
    
    super.initState();
    widget.stockCount.addListener(listener);
    widget.currentVariant.addListener(listener);
  }

  listener(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    widget.haveVariants = widget.currentProduct.variants.isNotEmpty;
    if(widget.haveVariants){
      imagesVariants = widget.imagesBase + widget.currentProduct.variants[widget.currentVariant.value].images;
    }else{
      imagesVariants = widget.imagesBase;
    }
    if(widget.haveVariants){
      var index= 0;
      widget.products = List();
      widget.currentProduct.variants.forEach((f){
        var temp = widget.parts.productStock[f.sku];
        if(((temp.contains("null")? 0:int.parse(temp??"0")) > 0)){
        PopupMenuItem<String> variant = PopupMenuItem(
          value: "$index", 
          child: Container(
            width: Measurements.width,
            child: ListTile(
              dense: true,
              title:  Container(
                width: Measurements.width,
                child: Text(f.title,style: widget.textStyle,overflow: TextOverflow.ellipsis,),
              ),
            ),
          ),
        );
        widget.products.add(variant);
        }
        index++;
      });
      if(widget.currentVariant.value == 0){
        print("${widget.currentVariant.value }  =  ${int.parse(widget.products.first.value)}");
        widget.currentVariant.value = int.parse(widget.products.first.value);
      }
      widget.price = widget.currentProduct.variants[widget.currentVariant.value].price;
      widget.salePrice = widget.currentProduct.variants[widget.currentVariant.value].salePrice;
      widget.onSale = !widget.currentProduct.variants[widget.currentVariant.value].hidden;
      widget.description = widget.currentProduct.variants[widget.currentVariant.value].description;

    }else{
      widget.price = widget.currentProduct.price;
      widget.salePrice = widget.currentProduct.salePrice;
      widget.onSale = !widget.currentProduct.hidden;
      widget.description = widget.currentProduct.description;
    }
    String _stc = widget.parts.productStock[widget.haveVariants?widget.currentProduct.variants[widget.currentVariant.value].sku:widget.currentProduct.sku];
    int stc  = _stc == null ? 0:_stc.contains("null")? 0:int.parse(_stc??"0");
    return Container(
      width:  Measurements.height * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //for sale
          Container(alignment: Alignment.center,height:Measurements.height * 0.05,child: widget.onSale?Text("Sale",style: TextStyle(color: widget.parts.saleColor),):Container()),   
          //name
          Container(
            alignment: Alignment.center,
            child: Text("${widget.currentProduct.title}",style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),
          ),
          //price
          Container(
            height: Measurements.height *0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("${widget.parts.f.format(widget.price)}${Measurements.currency(widget.parts.business.currency)}",style: TextStyle(fontSize: 17,color: widget.parts.titleColor.withOpacity(0.5),fontWeight: FontWeight.w300,decoration: widget.onSale?TextDecoration.lineThrough:TextDecoration.none),),
                widget.onSale?Text("  ${widget.parts.f.format(widget.salePrice)}${Measurements.currency(widget.parts.business.currency)}",style: TextStyle(fontSize: 17,color: widget.parts.saleColor,fontWeight: FontWeight.w300),):Container(),
              ],
            ),
          ),
          //Stock
          Container(
            child: StockText(parts: widget.parts,stc: stc,productStock: widget.productStock,),
          ),
          //images
          DetailImage(currentVariant: widget.currentVariant,parts: widget.parts,images: imagesVariants,index: (widget.haveVariants && (widget.currentProduct.variants[widget.currentVariant.value].images.isNotEmpty))?widget.imagesBase.length:0,),
          //variant Picker
          Padding(  padding: EdgeInsets.symmetric(vertical: Measurements.height *0.01),),
          widget.haveVariants?
          Container(
            padding: EdgeInsets.symmetric(horizontal: Measurements.width * (widget.parts.isTablet? 0.15:0)),
            height: Measurements.height * 0.07,
            child: Theme(
              data: ThemeData.light(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: PopupMenuButton(
                  initialValue: "${widget.currentVariant.value}",
                  onSelected: (value){
                    setState(() {
                      widget.currentVariant.value = int.parse(value);
                      widget.currentVariant.notifyListeners();
                    });
                  },
                  child: ListTile(
                    dense: true,
                    trailing: Icon(Icons.keyboard_arrow_down),
                    title:  Container(
                      width: Measurements.width,
                      child: Text(widget.currentProduct.variants[widget.currentVariant.value].title,style: widget.textStyle,overflow: TextOverflow.ellipsis,),
                    ),
                  ),
                  itemBuilder: (BuildContext context) => widget.products,
                ),
              ),
            ),
          ):Container(),
          Padding(padding: EdgeInsets.symmetric(vertical: Measurements.height *0.01),),
          Container(
            alignment: Alignment.center,
            height: Measurements.height *0.08,
            padding: EdgeInsets.symmetric(vertical: Measurements.height *0.01,horizontal: Measurements.width * (widget.parts.isTablet? 0.15:0)),
            child: InkWell(
              child:Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: stc ==0?Colors.grey:Colors.black,
                ),
                child:Center(child: Text("Add to cart",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)),
              ),
              onTap: (){

                ToastFuture toastFuture = showToastWidget(
                  CustomToastNotification(icon: Icons.check_circle_outline, toastText: "Product added to Bag",),
                  duration: Duration(seconds: 3),
                  onDismiss: () {
                    print("The toast was dismised"); // the method will be called on toast dismiss.
                  },
                );

                Future.delayed(Duration(seconds: 3), () {
                  toastFuture.dismiss();
                });

                if(stc != 0){
                  if(widget.haveVariants){
                    var image = widget.currentProduct.variants[widget.currentVariant.value].images.isNotEmpty?widget.currentProduct.variants[widget.currentVariant.value].images[0]:widget.currentProduct.images.isNotEmpty?widget.currentProduct.images[0]:null;
                    widget.parts.add2cart(id:widget.currentProduct.variants[widget.currentVariant.value].id,image:image,uuid: widget.currentProduct.variants[widget.currentVariant.value].id,name: widget.currentProduct.variants[widget.currentVariant.value].title,price:widget.onSale?widget.currentProduct.variants[widget.currentVariant.value].salePrice:widget.currentProduct.variants[widget.currentVariant.value].price,qty: 1,sku:widget.currentProduct.variants[widget.currentVariant.value].sku);
                  }else{
                    var image = widget.currentProduct.images.isNotEmpty?widget.currentProduct.images[0]:null;
                    widget.parts.add2cart(id:widget.currentProduct.uuid,image:image,uuid: widget.currentProduct.uuid,name: widget.currentProduct.title,price:widget.onSale?widget.currentProduct.salePrice:widget.currentProduct.price,qty: 1,sku:widget.currentProduct.sku);
                  }
//                  Navigator.pop(context);
                }
              },
            ),
          ),
            Container(
              padding: EdgeInsets.only(bottom: Measurements.height * 0.04,top: Measurements.height * 0.02),
              child: Text("${widget.description}",style: TextStyle(color: Colors.black,fontSize: 13),
            )
          ),
          ColorButtomGrid(colors: <Color>[Colors.red,Colors.blue,Colors.green,Colors.deepOrange,Colors.red,Colors.blue,Colors.green,Colors.deepOrange,Colors.red,Colors.blue,Colors.green,Colors.deepOrange], controller: controller, size: Measurements.height * 0.03,),
          //ColorButtomContainer(controller: controller,displayColor: Colors.red, size: Measurements.height * 0.03,),
          widget.parts.isTablet? Padding(padding: EdgeInsets.only(bottom: Measurements.height * 0.02),):Container(),
        ],
      ),
    );
  }
  ColorButtomController controller = ColorButtomController();
}
class StockText extends StatefulWidget {

  String value = "";
  PosScreenParts parts;
  Color color  = Colors.white;
  var productStock;
  int stc;
  String sku;
  StockText({this.parts,this.sku,@required this.productStock,this.stc});
  @override
  _StockTextState createState() => _StockTextState();
}

class _StockTextState extends State<StockText> {
  
  @override
  Widget build(BuildContext context) {
    widget.value = (widget.stc > 0 )? Language.getProductListStrings("filters.quantity.inStock"):Language.getProductListStrings("filters.quantity.outStock");
    widget.color = (widget.stc > 6 )? Colors.green: widget.stc > 0?Colors.orangeAccent:Colors.red;
    return Text(widget.value ,style: TextStyle(color: widget.color)); 
  }
}