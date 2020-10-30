import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/models/template_size_state_model.dart';
import 'package:payever/shop/views/edit/element/section_view.dart';
import 'package:provider/provider.dart';
import 'package:payever/blocs/bloc.dart';

class TemplateView extends StatefulWidget {
  final ShopPage shopPage;
  final Template template;
  final Function onTap;
  final bool scrollable;
  final bool enableTapSection;
  final ShopEditScreenBloc screenBloc;

  const TemplateView(
      {this.shopPage,
      this.template,
      this.onTap,
      this.enableTapSection = false,
      this.scrollable = true,
      this.screenBloc});

  @override
  _TemplateViewState createState() => _TemplateViewState(
      shopPage: shopPage,
      template: template,
      screenBloc: screenBloc);
}

class _TemplateViewState extends State<TemplateView> {
  final ShopPage shopPage;
  final Template template;
  final ShopEditScreenBloc screenBloc;
  String selectSectionId = '';

  _TemplateViewState(
      {this.shopPage, this.template, this.screenBloc});

  TemplateSizeStateModel templateSizeStateModel = TemplateSizeStateModel();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: templateSizeStateModel),
        ChangeNotifierProvider<TemplateSizeStateModel>(
            create: (_) => templateSizeStateModel),
      ],
      child: BlocListener(
        listener: (BuildContext context, ShopEditScreenState state) async {

        },
        bloc: screenBloc,
        child: BlocBuilder(
          bloc: screenBloc,
          builder: (BuildContext context, state) {
            return body(state);
          },
        ),
      ),
    );
  }

  Widget body(ShopEditScreenState state) {
    List sections = [];
    template.children.forEach((child) {
      SectionStyles styleSheet = getSectionStyles(child.id);
      if (styleSheet == null) {
        return Container();
      }
      if (child.type == 'section' &&
          child.children != null &&
          styleSheet.display != 'none') {
        SectionView sectionView = SectionView(
          screenBloc: screenBloc,
          shopPage: shopPage,
          enableTapChild: widget.enableTapSection,
          section: child,
          isSelected: selectSectionId == child.id,
          onTapChild: () {
            setState(() {
              selectSectionId = '';
            });
          },
        );
        Widget section = GestureDetector(
          onTap: widget.enableTapSection ? () {
            onTapSection(child.id);
          }: null,
          child: sectionView,
        );
        sections.add(section);
      }
    });

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        color: Colors.white,
        child: ListView.separated(
          physics: widget.scrollable
              ? AlwaysScrollableScrollPhysics()
              : NeverScrollableScrollPhysics(),
          itemCount: sections.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return sections[index];
          },
          separatorBuilder: (context, index) {
            return Container();
          },
        ),
      ),
    );
  }
  void onTapSection(String childId) {
    print('Selected SectionID: $childId');
    setState(() {
      selectSectionId = childId;
      screenBloc.add(SelectSectionEvent(sectionId: selectSectionId));
    });
  }

  SectionStyles getSectionStyles(String childId) {
    try {
      Map<String, dynamic> json = widget.screenBloc.state.stylesheets[shopPage.stylesheetIds.mobile][childId];
      return SectionStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
