import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/models/template_size_state_model.dart';
import 'package:payever/shop/views/edit/element/section_view.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:provider/provider.dart';

class TemplateView extends StatefulWidget {
  final PageDetail pageDetail;
  final Function onTap;
  final bool scrollable;
  final bool enableTapSection;
  final ShopEditScreenBloc screenBloc;

  const TemplateView(
      {this.pageDetail,
      this.onTap,
      this.enableTapSection = false,
      this.scrollable = true,
      this.screenBloc});

  @override
  _TemplateViewState createState() => _TemplateViewState();
}

class _TemplateViewState extends State<TemplateView> {
  String selectSectionId = '';
  TemplateSizeStateModel templateSizeStateModel/* = TemplateSizeStateModel()*/;

  @override
  Widget build(BuildContext context) {
    templateSizeStateModel = Provider.of<TemplateSizeStateModel>(context, listen: true);
    return BlocBuilder(
      bloc: widget.screenBloc,
      builder: (BuildContext context, state) {
        return body(state);
      },
    );
  }

  Widget body(ShopEditScreenState state) {
    if (state.isLoadingPage)
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    Template template =  widget.pageDetail.template;

    // templateSizeStateModel.setStylesheets(state.stylesheets);
    List sections = [];
    template.children.forEach((child) {
      SectionStyles styleSheet = getSectionStyles(child.id);
      if (styleSheet == null) {
        return Container();
      }
      if (child.type == 'section' &&
          child.children != null &&
          styleSheet.active) {
        SectionView sectionView = SectionView(
          screenBloc: widget.screenBloc,
          deviceTypeId: widget.pageDetail.stylesheetIds.mobile,
          enableTapChild: widget.enableTapSection,
          sectionId: child.id,
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
    FocusScope.of(context).unfocus();
    setState(() {
      selectSectionId = childId;
      widget.screenBloc.add(SelectSectionEvent(
          sectionId: selectSectionId,
          selectedBlock: null,
          selectedBlockId: '',
          selectedChild: null));
    });
  }

  SectionStyles getSectionStyles(String childId) {
    try {
      Map<String, dynamic> json = widget.pageDetail.stylesheets[childId];
      return SectionStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
