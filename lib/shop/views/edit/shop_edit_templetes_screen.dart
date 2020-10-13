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
  _ShopEditTemplatesScreenState createState() =>
      _ShopEditTemplatesScreenState(screenBloc);
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
            return _templateItem(state.pages[index], state);
          },
        ),
      ),
    );
  }

  Widget _templateItem(ShopPage page, ShopEditScreenState state) {
    Template template;
    try {
      template = Template.fromJson(screenBloc.state.templates[page.templateId]);
    } catch (e) {
//      print(e.toString());
    }

    return Column(
      children: [
        Expanded(
            child: (template != null)
                ? TemplateView(
                    shopPage: page,
                    template: template,
                    stylesheets: state.stylesheets,
                  )
                : Container(
                    color: Colors.white,
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
}