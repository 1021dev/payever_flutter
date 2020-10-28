import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/models/template_size_state_model.dart';
import 'package:payever/shop/views/edit/element/section_view.dart';
import 'package:provider/provider.dart';

class TemplateView extends StatefulWidget {
  final ShopPage shopPage;
  final Template template;
  final Map<String, dynamic> stylesheets;
  final Function onTap;
  final bool scrollable;
  final bool enableTapSection;

  const TemplateView(
      {this.shopPage,
      this.template,
      this.stylesheets,
      this.onTap,
      this.enableTapSection = false,
      this.scrollable = true});

  @override
  _TemplateViewState createState() =>
      _TemplateViewState(shopPage, template, stylesheets);
}

class _TemplateViewState extends State<TemplateView> {
  final ShopPage shopPage;
  final Template template;
  final Map<String, dynamic> stylesheets;

  String selectSectionId = '';

  _TemplateViewState(this.shopPage, this.template, this.stylesheets);
  TemplateSizeStateModel templateSizeStateModel = TemplateSizeStateModel();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: templateSizeStateModel),
        ChangeNotifierProvider<TemplateSizeStateModel>(create: (_) => templateSizeStateModel),
      ],
      child: body(),
    );
  }

  Widget body () {
    List sections = [];
    template.children.forEach((child) {
      SectionStyles styleSheet = getSectionStyleSheet(child.id);
      if (styleSheet == null) {
        return Container();
      }
      if (child.type == 'section' &&
          child.children != null &&
          /*child.children.isNotEmpty &&*/
          styleSheet.display != 'none') {
        SectionView sectionView = SectionView(
          shopPage: shopPage,
          child: child,
          stylesheets: stylesheets,
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
            templateSizeStateModel.setRefreshSelectedChild(true);
          }: null,
          child: sectionView,
        );
        sections.add(section);
      }
    });

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        color: Colors.grey,
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
      templateSizeStateModel.setSelectedSectionId(childId);
    });
  }

  SectionStyles getSectionStyleSheet(String childId) {
    try {
      Map json = stylesheets[shopPage.stylesheetIds.mobile][childId];
      if (json['display'] != 'none') {
        print('==============================================');
        print('SectionID: $childId');
        print('Section StyleSheet: $json');
      }

      return SectionStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
