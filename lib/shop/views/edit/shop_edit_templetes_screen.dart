import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/template_view.dart';

class ShopEditTemplatesScreen extends StatefulWidget {

  final ShopEditScreenBloc screenBloc;

  const ShopEditTemplatesScreen(this.screenBloc);

  @override
  _ShopEditTemplatesScreenState createState() => _ShopEditTemplatesScreenState(screenBloc);
}

class _ShopEditTemplatesScreenState extends State<ShopEditTemplatesScreen> {
  final String TAG = 'ShopEditTemplatesScreen';
  bool isPortrait;
  bool isTablet;
  final ShopEditScreenBloc screenBloc;

  _ShopEditTemplatesScreenState(this.screenBloc);

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);

    return BlocListener(
      listener: (BuildContext context, ShopEditScreenState state) async {},
      bloc: screenBloc,
      child: BlocBuilder(
        bloc: screenBloc,
        builder: (BuildContext context, state) {
          return Scaffold(
              appBar: Appbar('Templates'),
              backgroundColor: Colors.grey[800],
              body: SafeArea(bottom: false, child: _body(state)));
        },
      ),
    );
  }

  Widget _body(ShopEditScreenState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: GridView.count(
        crossAxisCount: isTablet ? 3 : (isPortrait ? 2 : 3),
        crossAxisSpacing: isTablet ? 12 : (isPortrait ? 6 : 12),
        mainAxisSpacing: 12,
        children: List.generate(
          state.pages.length,
              (index) {
            return _templateItem(state.pages[index]);
          },
        ),
      ),
    );
  }

  Widget _templateItem(ShopPage page) {
    Template template = Template.fromJson(screenBloc.state.templates[page.templateId]);
    return Column(
      children: [
        Expanded(
            child: TemplateView(
              shopPage: page,
              template: template,
              background: getBackground(page),
//          width: double.infinity,
//          decoration: BoxDecoration(
//            color: Colors.white,
//            borderRadius: BorderRadius.circular(4),
//          ),
        )),
        SizedBox(
          height: 5,
        ),
        Text(
          page.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Background getBackground(ShopPage page) {
    Map<String, dynamic> stylesheets = screenBloc.state.stylesheets;

    if (stylesheets[page.stylesheetIds.mobile] != null && stylesheets[page.stylesheetIds.mobile] is Map) {
      Map<String, dynamic> obj = stylesheets[page.stylesheetIds.mobile];
      print(TAG + ' :page TemplateID : ${page.templateId}');
      print(TAG + ' :obj keys : ${obj.keys}');
      try{
        Background background = Background.fromJson(obj['6f3f8cea-ae2d-4501-965d-a3dc08addf4c'/*page.templateId*/]);
        return background;
      }
      catch(e) {
        print('$TAG : ${e.toString()}');
        return null;
      }
    }
    return null;
  }
}

// Mobile ID 68a386d7-a013-40de-bd5d-e521261dd1b2
// Template ID 6f3f8cea-ae2d-4501-965d-a3dc08addf4c
//             fecd4f2a-699a-4fa9-a4f1-ff8b896d984f