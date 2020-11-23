import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/models/template_size_state_model.dart';
import 'package:payever/shop/views/edit/add_object_screen.dart';
import 'package:payever/shop/views/edit/sub_element/text_style_view.dart';
import 'package:payever/shop/views/edit/template_view.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:provider/provider.dart';
import 'sub_element/shop_edit_appbar.dart';

class TemplateDetailScreen extends StatefulWidget {
  final ShopPage shopPage;
  final String templateId;
  final ShopEditScreenBloc screenBloc;

  const TemplateDetailScreen(
      {this.shopPage, this.templateId, this.screenBloc});

  @override
  _TemplateDetailScreenState createState() => _TemplateDetailScreenState(
      shopPage: shopPage,
      templateId: templateId,
      screenBloc: screenBloc);
}

class _TemplateDetailScreenState extends State<TemplateDetailScreen> {
  final ShopPage shopPage;
  final String templateId;
  final ShopEditScreenBloc screenBloc;
  TemplateSizeStateModel templateSizeStateModel = TemplateSizeStateModel();
  _TemplateDetailScreenState(
      {this.shopPage, this.templateId, this.screenBloc});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    screenBloc.add(ActiveShopPageEvent(activeShopPage: widget.shopPage));
    super.initState();
  }

  @override
  void dispose() {
    // screenBloc.add(ActiveShopPageEvent(activeShopPage: null));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: templateSizeStateModel),
        ChangeNotifierProvider<TemplateSizeStateModel>(
            create: (_) => templateSizeStateModel),
      ],
      child: BlocListener(
        listener: (BuildContext context, ShopEditScreenState state) async {},
        bloc: screenBloc,
        child: BlocBuilder(
          bloc: screenBloc,
          builder: (BuildContext context, state) {
            return Scaffold(
              key: scaffoldKey,
              appBar: ShopEditAppbar(
                onTapAdd: () => _addObject(state),
                onTapStyle: () => _showStyleDialogView(state),
              ),
              backgroundColor: Colors.grey[800],
              body: SafeArea(
                bottom: false,
                child: TemplateView(
                  screenBloc: screenBloc,
                  shopPage: shopPage,
                  templateId: templateId,
                  enableTapSection: true,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _addObject(ShopEditScreenState state) async {
    if(state.selectedSectionId.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select Section to add new object.');
      return;
    }
    final result = await Navigator.push(
        context,
        PageTransition(
            child: AddObjectScreen(screenBloc: screenBloc, templateSizeStateModel: templateSizeStateModel,),
            type: PageTransitionType.fade)
    );

    print('result: $result');
    if (result == null) return;
    ShopObject shopObject;
    switch(result) {
      case 0:
        shopObject = ShopObject(name: 'text', type: 'text');
        break;
      case 1:
        shopObject = ShopObject(name: 'square', type: 'shape');
        break;
      case 2:
        shopObject = ShopObject(name: 'circle', type: 'shape');
        break;
      case 3:
        shopObject = ShopObject(name: 'triangle', type: 'shape');
        break;
      case 4:
        shopObject = ShopObject(name: 'button', type: 'button');
        break;
      case 5:
        shopObject = ShopObject(name: 'button--rounded', type: 'button');
        break;
    }

    if (shopObject == null) return;
    templateSizeStateModel.setShopObject(shopObject);
  }

  void _showStyleDialogView(ShopEditScreenState state) {
    if (state.selectedChild == null) {
      Fluttertoast.showToast(msg: 'Please select an element!');
      return;
    }
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.transparent,
        // isScrollControlled: true,
        builder: (builder) {
          return TextStyleView(
            screenBloc: screenBloc,
            stylesheets: state.stylesheets[state.activeShopPage.stylesheetIds.mobile][state.selectedChild.id],
          );
        });
  }
}
