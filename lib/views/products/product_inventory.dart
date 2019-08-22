import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payever/models/products.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/appStyle.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/products/new_product.dart';

class InventoryManagement{
  List<Inventory> inventories = List();
  addInventory(Inventory currentInv){
    List<Inventory> _inventories = List();
    Inventory temp = Inventory(amount:null , barcode: null, sku: null, tracking: null);
    inventories.forEach((inv){
      print(inv.sku);
      if(inv.sku != currentInv.sku){
        _inventories.add(inv);
      }else{
        temp.amount = inv.amount;
      }
    });
    currentInv.amount = currentInv.amount??temp.amount??0;
    _inventories.add(currentInv);
    inventories..clear()..addAll(_inventories);
  }

  printAll(){
    print("________________________");
    print("Invetories");
    inventories.forEach((inv){
      print("Sku:       ${inv.sku}");
      print("NewAmount: ${inv.newAmount}");
      print("amount:    ${inv.amount}");
    });
    print("_______________________");
  }

  saveInventories(String businessID,BuildContext context){
    inventories.forEach((inventory){
      num dif = (inventory.newAmount??0) - (inventory.amount??0);
      print("num dif = (inventory.newAmount??0) - (inventory.amount??0)");
      print("$dif = (${inventory.newAmount}) - (${inventory.amount})");
      print(dif);
      RestDatasource().checkSKU(businessID, GlobalUtils.ActiveToken.accessToken, inventory.sku,).then((onValue){
        if(inventory.newAmount != null)
        RestDatasource().patchInventory(businessID, GlobalUtils.ActiveToken.accessToken, inventory.sku, inventory.barcode, inventory.tracking).then((_){
          //if( dif != 0 && (inventory.newAmount != 0)){
          if( dif != 0){
            dif > 0 ? add(dif,inventory.sku,businessID):sub(dif.abs(),inventory.sku,businessID);
          }
        });
        if(inventories.last.sku == inventory.sku){
            Navigator.pop(context);
            Navigator.pop(context);
          }
      }).catchError((onError){
        if(onError.toString().contains("404")){
          RestDatasource().postInventory(businessID, GlobalUtils.ActiveToken.accessToken, inventory.sku, inventory.barcode, inventory.tracking).then((_){
            if( dif != 0 && (inventory.newAmount != 0)){
              dif > 0 ? add(dif,inventory.sku,businessID):sub(dif.abs(),inventory.sku,businessID);
            }
            if(inventories.last.sku == inventory.sku){
              Navigator.pop(context);
              Navigator.pop(context);
            }
          });
        }
      });
    });
    
  }
  

  Future add(num dif,String sku,String id) async {
    return RestDatasource().patchInventoryAdd(id, GlobalUtils.ActiveToken.accessToken, sku, dif).then((result){
      print("$dif added");
    });
  }

  Future sub(num dif,String sku,String id) async {
    return RestDatasource().patchInventorySubtract(id, GlobalUtils.ActiveToken.accessToken, sku, dif).then((result){
      print("$dif substracted");
    });
  }

}

class Inventory{
  String sku;
  String barcode;
  bool   tracking;
  num    amount;
  num    newAmount;
  Inventory({@required this.sku,@required this.barcode,this.amount,@required this.tracking,this.newAmount});
}

class ProductInventoryRow extends StatefulWidget {

  NewProductScreenParts parts;
  bool get isInventoryRowOK {
    return parts.product.variants.length>0?
     true:
     !parts.skuError;
  }
  
  ProductInventoryRow({@required this.parts});
  @override
  _ProductInventoryRowState createState() => _ProductInventoryRowState();

}

class _ProductInventoryRowState extends State<ProductInventoryRow> {
  
  @override
  void initState() {
    super.initState();
    print("widget.parts.business: ${widget.parts.business}");
    print("widget.parts.product: ${widget.parts.product}");
  if(widget.parts.editMode)
    RestDatasource().getInvetory(widget.parts.business, GlobalUtils.ActiveToken.accessToken, widget.parts.product.sku,context).
    then((inv){
      var _inv = InventoryModel.toMap(inv);
      widget.parts.invManager.inventories.add(Inventory(barcode: _inv.barcode,sku: _inv.sku,tracking: _inv.isTrackable,amount: _inv.stock));
      setState(() {
        widget.parts.prodTrackInv   = _inv.isTrackable??false;
        widget.parts.prodStock      = _inv.stock??0;
      });
    });
   
    
  }
  

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Measurements.width * 0.025),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16))),
                        width: Measurements.width * 0.4475,
                        height: Measurements.height *
                            (widget.parts.isTablet ? 0.05 : 0.07),
                        child: TextFormField(
                          style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
                          initialValue: widget.parts.editMode?widget.parts.product.sku:"",
                          inputFormatters: [
                            WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9 _]")),
                            ],
                          onSaved: (sku) {
                            print("sku");
                            widget.parts.product.sku = sku;
                          },
                          validator: (sku) {
                            if (sku.isEmpty) {
                              setState(() {
                                widget.parts.skuError = true;
                              });
                            } else {
                              setState(() {
                                widget.parts.skuError = false;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: Language.getProductStrings("variants.placeholders.skucode"),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                color: widget.parts.skuError
                                    ? Colors.red
                                    : Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2.5),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Measurements.width * 0.025),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16))),
                        width: Measurements.width * 0.4475,
                        height: Measurements.height *
                            (widget.parts.isTablet ? 0.05 : 0.07),
                        child: TextFormField(
                          style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
                          onSaved: (bar) {
                            print("barcode");
                            widget.parts.product.barcode = bar;
                          },
                          decoration: InputDecoration(
                            hintText: Language.getProductStrings("price.placeholders.barcode"),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.5),
              ),
              Container(
                //width: Measurements.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: Measurements.width * 0.025),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16))),
                          height: Measurements.height *
                              (widget.parts.isTablet ? 0.05 : 0.07),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Switch(
                                activeColor: widget.parts.switchColor,
                                value: widget.parts.prodTrackInv,
                                onChanged: (bool value) {
                                  setState(() {
                                    widget.parts.prodTrackInv = value;
                                  });
                                },
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  Language.getProductStrings("info.placeholders.inventoryTrackingEnabled"),minFontSize: 12,maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2.5),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(16))),
                        width: Measurements.width * 0.3375,
                        height: Measurements.height *
                            (widget.parts.isTablet ? 0.05 : 0.07),
                        child: TextFormField(
                          style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
                          inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9]"))],                      
                          onSaved: (value) {
                            print("on save $value");
                            widget.parts.invManager.addInventory(Inventory(newAmount: num.parse(value), barcode: widget.parts.product.barcode??"", sku: widget.parts.product.sku, tracking: widget.parts.prodTrackInv));
                          },
                          textAlign: TextAlign.center,
                          controller: TextEditingController(
                            text: "${widget.parts.prodStock??0}",
                          ),
                          onFieldSubmitted: (qtt){
                            widget.parts.prodStock = num.parse(qtt);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (widget.parts.prodStock > 0) widget.parts.prodStock--;
                                });
                              },
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  widget.parts.prodStock++;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
      ),
    );
  }
}