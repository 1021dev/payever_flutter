import 'package:flutter/material.dart';
import '../../commons/utils/app_style.dart';
import '../../commons/utils/translations.dart';
import '../models/models.dart';
import '../views/views.dart';

class ProductSections {
  List<Widget> _headers = List();
  List<Widget> _bodies = List();

  List<Widget> get headers => _headers;
  List<Widget> get bodies => _bodies;

  addHeader(Widget header) => _headers.add(header);
  addBody(Widget body) => _bodies.add(body);

  Map<String, bool> activeSection = Map();

  setProductSections(ProductsModel product) {
    addHeader(
      Text(
        Language.getProductStrings("sections.main"),
        style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),
      ),
    );
    if (product.variants?.isEmpty ?? true) {
      addHeader(
        Text(
          Language.getProductStrings("sections.inventory"),
          style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),
        ),
      );
    }
    addHeader(
      Text(
        Language.getProductStrings("sections.category"),
        style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),
      ),
    );
    addHeader(
      Text(
        Language.getProductStrings("sections.variants"),
        style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),
      ),
    );
    addHeader(
      Text(
        Language.getProductStrings("sections.channels"),
        style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),
      ),
    );
    addHeader(
      Text(
        Language.getProductStrings("sections.shipping"),
        style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),
      ),
    );
    addHeader(
      Text(
        Language.getProductStrings("sections.taxes"),
        style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),
      ),
    );
    // addHeader(
    //   Text(
    //     Language.getProductStrings("sections.visibility"),
    //     style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),
    //   ),
    // );
    addBody(
      MainBody(),
    );
    if (product.variants?.isEmpty ?? true) {
      addBody(
        InventoryBody(),
      );
    }

    addBody(
      CategoryBody(),
    );

    addBody(
      VariantBody(),
    );
    addBody(
      ChannelsBoby(),
    );
    addBody(
      product.type == ProductTypeEnum.physical ?ShippingBody():NoShipping(),
    );
    addBody(
      ProductTaxRow(),
    );
    // addBody(
    //   ProductVisibility(),
    // );
  }

  bool sectionFilter(String a) {
    return true;
  }
}
