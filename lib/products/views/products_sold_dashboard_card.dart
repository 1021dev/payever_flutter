import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../commons/view_models/view_models.dart';
import '../../commons/views/screens/dashboard/dashboard_card_ref.dart';
import 'products_sold_dashboard_card_item.dart';
import 'product_screen.dart';

class ProductsSoldCard extends StatelessWidget {
  final String _appName;
  final ImageProvider _imageProvider;
  final String _help;

  ProductsSoldCard(this._appName, this._imageProvider, this._help);

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    print(_help);
    
    return DashboardCardRef(
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
