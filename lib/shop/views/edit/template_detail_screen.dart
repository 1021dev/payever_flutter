import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/add_object_screen.dart';
import 'package:payever/shop/views/edit/template_view.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:uuid/uuid.dart';
import 'sub_element/shop_edit_appbar.dart';

class TemplateDetailScreen extends StatefulWidget {
  final ShopPage shopPage;
  final Template template;
  final ShopEditScreenBloc screenBloc;

  const TemplateDetailScreen(
      {this.shopPage, this.template, this.screenBloc});

  @override
  _TemplateDetailScreenState createState() => _TemplateDetailScreenState(
      shopPage: shopPage,
      template: template,
      screenBloc: screenBloc);
}

class _TemplateDetailScreenState extends State<TemplateDetailScreen> {
  final ShopPage shopPage;
  final Template template;
  final ShopEditScreenBloc screenBloc;

  _TemplateDetailScreenState(
      {this.shopPage, this.template, this.screenBloc});

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
    return BlocListener(
      listener: (BuildContext context, ShopEditScreenState state) async {},
      bloc: screenBloc,
      child: BlocBuilder(
        bloc: screenBloc,
        builder: (BuildContext context, state) {
          return Scaffold(
              appBar: ShopEditAppbar(onTapAdd: ()=> _addObject(state),),
              backgroundColor: Colors.grey[800],
              body: SafeArea(
                  bottom: false,
                  child: TemplateView(
                    screenBloc: screenBloc,
                    shopPage: shopPage,
                    template: template,
                    enableTapSection: true,
                  )));
        },
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
            child: AddObjectScreen(),
            type: PageTransitionType.fade)
    );
    print('result: $result');
    if (result != 0) return;

  }
}
