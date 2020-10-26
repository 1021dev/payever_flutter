import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/section_view.dart';

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

  @override
  Widget build(BuildContext context) {
    List sections = [];
    template.children.forEach((child) {
      SectionStyleSheet styleSheet = getSectionStyleSheet(child.id);
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
            isActive: selectSectionId == child.id,
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
    setState(() {
      selectSectionId = childId;
    });
  }

  SectionStyleSheet getSectionStyleSheet(String childId) {
    try {
      Map json = stylesheets[shopPage.stylesheetIds.mobile][childId];
      if (json['display'] != 'none') print('Section StyleSheet: $json');
      return SectionStyleSheet.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
