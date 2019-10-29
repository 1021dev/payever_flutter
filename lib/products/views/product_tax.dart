import 'package:flutter/material.dart';
import 'package:payever/checkout_process/checkout_process.dart';
import 'package:payever/checkout_process/view_models/view_models.dart';
import '../../commons/views/custom_elements/custom_elements.dart';
import 'package:provider/provider.dart';

class ProductTaxRow extends StatefulWidget {
  ProductTaxRow();
  @override
  createState() => _ProductTaxRowState();
}

class _ProductTaxRowState extends State<ProductTaxRow> {
  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalProvider = Provider.of<GlobalStateModel>(context);
    ProductStateModel productProvider = Provider.of<ProductStateModel>(context);
    List<String> rates = List();
    String selectedRate = "";
    globalProvider.vatRates.forEach(
      (rate) {
        rates.add("${rate.description} - ${rate.rate} %");
      },
    );
    if (globalProvider.vatRates.isNotEmpty) {
      int index = globalProvider.vatRates.indexWhere(
        (r) => r.rate == productProvider.editProduct.vatRate,
      );
      selectedRate = rates[index < 0 ? 0 : index];
    }
    return Expanded(
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            height: 59,
            child: DropDownMenu(
              customColor: false,
              backgroundColor: Colors.transparent,
              optionsList: rates,
              placeHolderText: globalProvider.vatRates.isEmpty
                  ? "Default taxes apply"
                  : selectedRate,
              onChangeSelection: (value, index) {
                if (globalProvider.vatRates.isNotEmpty) {
                  selectedRate = value;
                  setState(
                    () {
                      productProvider.editProduct.vatRate =
                          globalProvider.vatRates[index].rate;
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
