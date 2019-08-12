import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/views/dashboard/products_sold_card_item.dart';
import 'package:payever/views/products/product_screen.dart';
import 'package:provider/provider.dart';

import 'dashboardcard_ref.dart';

class ProductsSoldCard extends StatelessWidget {
  final String _appName;
  final ImageProvider _imageProvider;

  ProductsSoldCard(this._appName, this._imageProvider);

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return DashboardCard_ref(
      _appName,
      _imageProvider,
      Padding(
        padding: EdgeInsets.symmetric(vertical: 1),
        child: InkWell(
          highlightColor: Colors.transparent,
          child: ProductsSoldCardItem(),
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: ProductScreen(
                      business: globalStateModel.currentBusiness,
                      wallpaper: globalStateModel.currentWallpaper,
                      posCall: false,
                    ),
                    type: PageTransitionType.fade));
          },
        ),
      ),
    );
  }
}
