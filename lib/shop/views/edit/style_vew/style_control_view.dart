import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/arrange_style_view.dart';
import 'package:payever/shop/views/edit/style_vew/fill_view.dart';
import 'package:payever/shop/views/edit/style_vew/image_style_view.dart';
import 'package:payever/shop/views/edit/style_vew/products_style_view.dart';
import 'package:payever/shop/views/edit/style_vew/shadow_view.dart';
import 'package:payever/shop/views/edit/style_vew/table/format_style_view.dart';
import 'package:payever/shop/views/edit/style_vew/table/table_cell_style_view.dart';
import 'package:payever/shop/views/edit/style_vew/table/table_style_view.dart';
import 'package:payever/shop/views/edit/style_vew/text/text_style_view.dart';
import 'package:payever/shop/views/edit/style_vew/video_style_view.dart';
import 'package:payever/theme.dart';
import 'sub_view/border_view.dart';
import 'fill_color_grid_view.dart';
import 'fill_color_view.dart';
import 'sub_view/opacity_view.dart';

class StyleControlView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Function onClose;

  const StyleControlView({this.screenBloc, this.onClose});

  @override
  _StyleControlViewState createState() => _StyleControlViewState();
}

class _StyleControlViewState extends State<StyleControlView> {

  _StyleControlViewState();

  bool isPortrait;
  bool isTablet;

  Color fillColor;
  Color borderColor;

  StyleType styleType = StyleType.style;

  String selectedChildId;
  TextStyles styles;

  final List<String> hasFillChildren = [
    'text',
    'button',
    'shape',
    'shop-cart',
    'social-icon',
  ];
  final List<String> hasComplexFillChildren = ['text', 'button', 'shape'];
  final List<String> hasBorderChildren = ['button', 'image', 'logo'];
  final List<String> hasShadowChildren = [
    'button',
    'shape',
    'image',
    'social-icon',
    'logo',
    'shop-cart'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);

    return BlocListener(
      listener: (BuildContext context, ShopEditScreenState state) async {
        if (state.blobName.isNotEmpty) {
          if (state.selectedChild.type == 'image') {
            _updateImage(state, 'https://payeverproduction.blob.core.windows.net/builder/${state.blobName}');
          } else if(state.selectedChild.type == 'video') {
            _updateVideo(state, 'https://payeverproduction.blob.core.windows.net/builder-video/${state.blobName}');
          } else {
            BackGroundModel model = BackGroundModel(
                backgroundColor: '',
                backgroundImage:
                'https://payeverproduction.blob.core.windows.net/builder/${state.blobName}',
                backgroundPosition: 'center',
                backgroundRepeat: 'no-repeat',
                backgroundSize: '100%');
            _updateImageFill(state, model);
          }
          widget.screenBloc.add(InitBlobNameEvent());
        }
      },
      bloc: widget.screenBloc,
      child: BlocBuilder(
        bloc: widget.screenBloc,
        builder: (BuildContext context, state) {
          return body(state);
        },
      ),
    );
  }

  Widget body(ShopEditScreenState state) {
    if (state.selectedChild == null) return Container();
    _initTextProperties(state);
    return Container(
      height: 400,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Container(
            color: Color.fromRGBO(23, 23, 25, 1),
            padding: EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 34),
            child: Column(
              children: [
                _segmentedControl(state),
                SizedBox(
                  height: 10,
                ),
                Expanded(child: mainBody(state)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _initTextProperties (ShopEditScreenState state) {
    selectedChildId = state.selectedChild.id;
    styles = TextStyles.fromJson(state.pageDetail.stylesheets[selectedChildId]);
    fillColor = colorConvert(styles.backgroundColor, emptyColor: true);
    borderColor = colorConvert(styles.borderColor, emptyColor: true);
  }

  Widget _segmentedControl(ShopEditScreenState state) {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: CupertinoSegmentedControl<StyleType>(
              selectedColor: Color.fromRGBO(110, 109, 116, 1),
              unselectedColor: Color.fromRGBO(46, 45, 50, 1),
              borderColor: Color.fromRGBO(23, 23, 25, 1),
              children: <StyleType, Widget>{
                if (state.selectedChild.type == 'shop-products')
                  StyleType.products: segmentTitleWidget('Products'),
                StyleType.style: segmentTitleWidget(
                    state.selectedChild.type == 'table' ? 'Table' : 'Style'),
                if (state.selectedChild.type == 'table')
                  StyleType.cell: segmentTitleWidget('Cell'),
                if (state.selectedChild.type == 'table')
                  StyleType.format: segmentTitleWidget('Format'),
                if (widget.screenBloc.isTextSelected())
                  StyleType.text: segmentTitleWidget('Text'),
                if (state.selectedChild.type == 'image')
                  StyleType.image: segmentTitleWidget('Image'),
                if (state.selectedChild.type == 'video')
                  StyleType.video: segmentTitleWidget('video'),
                StyleType.arrange: segmentTitleWidget('Arrange'),
              },
              onValueChanged: (StyleType value) {
                setState(() {
                  styleType = value;
                });
              },
              groupValue: styleType,
            ),
          ),
          InkWell(
            // onTap: () => Navigator.pop(context),
            onTap: () => widget.onClose(),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(46, 45, 50, 1),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.close, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  Widget segmentTitleWidget(String title) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
        ));
  }

  Widget mainBody(ShopEditScreenState state) {
    try{
      switch (styleType) {
        case StyleType.style:
          if (state.selectedChild.type == 'table')
            return TableStyleView(
              screenBloc: widget.screenBloc,
              onClose: widget.onClose,
              onUpdateStyles: (sheets) => _updateStyles(sheets),
            );
          return _styleBody(state);
        case StyleType.text:
          return TextStyleView(screenBloc: widget.screenBloc, onClose: widget.onClose,)/*_textBody(state)*/;
        case StyleType.image:
          Map<String, dynamic>map = getData(state);
          ImageData data = (map == null) ? null : ImageData.fromJson(map);
          return ImageStyleView(
            styles: styles,
            screenBloc: widget.screenBloc,
            description: data?.description,
            onChangeDescription: (value) => _updateImageDescription(state, value),
          );
        case StyleType.video:
          Map<String, dynamic>map = getData(state);
          VideoData data = (map == null) ? null : VideoData.fromJson(map);
          return VideoStyleView(
            styles: styles,
            screenBloc: widget.screenBloc,
            data: data,
            onChangeData: (value) => _updateVideoData(state, value),
          );
        case StyleType.arrange:
          return ArrangeStyleView();
        case StyleType.products:
          ShopProductsStyles productsStyles = ShopProductsStyles.fromJson(widget.screenBloc.state.pageDetail.stylesheets[selectedChildId]);
          return ProductsStyleView(
            screenBloc: widget.screenBloc,
            styles: productsStyles,
            onChangeGaps: (value, updateApi) => _updateProductsGaps(state, value, updateApi: updateApi),
          );
        case StyleType.cell:
          return TableCellStyleView(
            screenBloc: widget.screenBloc,
            onClose: widget.onClose,
            onUpdateStyles: (sheets) => _updateStyles(sheets),
          );
        case StyleType.format:
          return FormatStyleView();
        default:
          return _styleBody(state);
      }
    } catch(e) {
      styleType = StyleType.style;
      return _styleBody(state);
    }

  }

  // region Style Body
  Widget _styleBody(ShopEditScreenState state) {
    List<Widget> textStyleWidgets = [
      if (hasFill)
        FillColorGridView(
          onUpdateColor: (color) => _updateFillColor(state, color),
          hasText: widget.screenBloc.isTextSelected() ||
              state.selectedChild.type == 'button',
        ),
      if (hasFill)
        FillColorView(
          pickColor: fillColor,
          styles: styles,
          colorType: ColorType.backGround,
          onUpdateColor: (color) => _updateFillColor(state, color),
          onTapFillView: () {
            navigateSubView(FillView(
              widget.screenBloc,
              hasComplexFill: hasComplexFill,
              onUpdateColor: (Color color) => _updateFillColor(state, color),
              onUpdateGradientFill: (GradientModel model, bool updateApi) =>
                  _updateGradientFillColor(state, model, updateApi: updateApi),
              onUpdateImageFill: (BackGroundModel model) =>
                  _updateImageFill(state, model),
            ));
          },
        ),
      if (hasBorder)
        BorderView(
          styles: styles,
          type: state.selectedChild.type,
          onUpdateBorderRadius: (radius, updateApi) =>
              _updateBorderRadius(state, radius, updateApi: updateApi),
          onUpdateBorderModel: (model, updateApi) {
            _updateImageBorderModel(state, model, updateApi: updateApi);
          },
        ),
      if (hasShadow)
        ShadowView(
          stylesheets: state.pageDetail.stylesheets[selectedChildId],
          styles: styles,
          type: state.selectedChild.type,
          onUpdateShadow: (ShadowModel model, updateApi) => _updateShadow(state, model, updateApi: updateApi ?? true),
        ),
      OpacityView(
        styles: styles,
        onUpdateOpacity: (value, updateApi) =>
            _updateOpacity(state, value, updateApi: updateApi),
      )
    ];
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: textStyleWidgets.length,
      itemBuilder: (context, index) {
        return textStyleWidgets[index];
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 0,
          thickness: 0.5,
        );
      },
    );
  }

  bool get hasFill {
    return hasFillChildren.contains(widget.screenBloc.state.selectedChild.type);
  }

  bool get hasComplexFill {
    return hasComplexFillChildren.contains(widget.screenBloc.state.selectedChild.type);
  }

  bool get hasBorder {
    return hasBorderChildren.contains(widget.screenBloc.state.selectedChild.type);
  }

  bool get hasShadow {
    return hasShadowChildren.contains(widget.screenBloc.state.selectedChild.type);
  }
  // endregion

  // region Update Styles
  void _updateFillColor(ShopEditScreenState state, Color color) {
    fillColor = color;
    String newBgColor;
    if (color == Colors.transparent) {
      newBgColor = '';
    } else {
      newBgColor = encodeColor(color);
    }
    Map<String, dynamic> sheets = state.pageDetail.stylesheets[selectedChildId];
    sheets['backgroundColor'] = newBgColor;
    sheets['backgroundImage'] = '';
    _updateStyles(sheets);
  }

  void _updateGradientFillColor(ShopEditScreenState state, GradientModel model, {bool updateApi = true}) {
    // backgroundImage: "linear-gradient(90deg, #ff0000ff, #fffef8ff)"
    String color1 = encodeColor(model.startColor);
    String color2 = encodeColor(model.endColor);
    Map<String, dynamic> sheets = state.pageDetail.stylesheets[selectedChildId];
    sheets['backgroundColor'] = '';
    sheets['backgroundImage'] = 'linear-gradient(${model.angle.toInt()}deg, $color1, $color2)';
    _updateStyles(sheets, updateApi: updateApi);
  }

  void _updateImageFill(ShopEditScreenState state, BackGroundModel backgroundModel) {
    Map<String, dynamic> sheets = state.pageDetail.stylesheets[selectedChildId];
    sheets['backgroundColor'] = backgroundModel.backgroundColor;
    sheets['backgroundImage'] = backgroundModel.backgroundImage;
    sheets['backgroundPosition'] =  backgroundModel.backgroundPosition;
    sheets['backgroundRepeat'] =  backgroundModel.backgroundRepeat;
    sheets['backgroundSize'] =  backgroundModel.backgroundSize;
    _updateStyles(sheets);
  }

  void _updateImage(ShopEditScreenState state, String url) {
    Map<String, dynamic> sheets = state.pageDetail.stylesheets[selectedChildId];
    sheets['background'] = url;
    _updateStyles(sheets);
  }

  void _updateImageDescription(ShopEditScreenState state, String description) {
    Map<String, dynamic> sheets = state.pageDetail.stylesheets[selectedChildId];
    Map<String, dynamic> data = {
      'description': description,
      'text': '',
      'sync': false
    };
    List<Map<String, dynamic>> effects = styles.getUpdateDataPayload(
        state.selectedSectionId,
        selectedChildId,
        sheets,
        data,
        'image',
        state.pageDetail.templateId);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }

  // region Video
  void _updateVideo(ShopEditScreenState state, String url) {
    Map<String, dynamic> sheets = state.pageDetail.stylesheets[selectedChildId];
    Map<String, dynamic> map = getData(state);
    VideoData data = VideoData.fromJson(map);
    data.source = url;
    List<Map<String, dynamic>> effects = styles.getUpdateDataPayload(
        state.selectedSectionId,
        selectedChildId,
        sheets,
        data.toJson(),
        'video',
        state.pageDetail.templateId);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }

  void _updateVideoData(ShopEditScreenState state, VideoData data) {
    print('updateVideoData: ${data.toJson()}');
    Map<String, dynamic> sheets = state.pageDetail.stylesheets[selectedChildId];
    List<Map<String, dynamic>> effects = styles.getUpdateDataPayload(
        state.selectedSectionId,
        selectedChildId,
        sheets,
        data.toJson(),
        'video',
        state.pageDetail.templateId);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }
  // endregion

  void _updateProductsGaps(ShopEditScreenState state, Map<String, dynamic> value, {bool updateApi = true}) {
    Map<String, dynamic> sheets = state.pageDetail.stylesheets[selectedChildId];
    sheets['columnGap'] = value['columnGap'];
    sheets['rowGap'] = value['rowGap'];
    _updateStyles(sheets, updateApi: updateApi);
  }

  void _updateOpacity(ShopEditScreenState state, double value, {bool updateApi = true}) {
    Map<String, dynamic> sheets = state.pageDetail.stylesheets[selectedChildId];
    sheets['opacity'] = num.parse(value.toStringAsFixed(1));
    _updateStyles(sheets, updateApi: updateApi);
  }

  void _updateShadow(ShopEditScreenState state, ShadowModel model, {bool updateApi = true}) {
    Map<String, dynamic> sheets = state.pageDetail.stylesheets[selectedChildId];
    String field = state.selectedChild.type == 'shape' ? 'shadow' : 'boxShadow';
    if (state.selectedChild.type == 'social-icon') {
      field = 'filter';
    }
    sheets[field] = model?.shadowString;

    if (state.selectedChild.type == 'logo') {
      sheets['dropShadow'] = model?.logoShadowString;
      sheets['filter'] = model?.logoShadowString;
    }

    print('shadowString: ${model?.shadowString}');
    if (state.selectedChild.type == 'image') {
      sheets['shadowAngle'] =  model?.shadowAngle?.toInt();
      sheets['shadowBlur'] =  model?.shadowBlur?.toInt();
      sheets['shadowColor'] =  model?.shadowColor;
      sheets['shadowFormColor'] =  model?.shadowFormColor;
      sheets['shadowOffset'] =  model?.shadowOffset?.toInt();
      sheets['shadowOpacity'] =  model?.shadowOpacity?.toInt();
      sheets[field] = model?.shadowString ?? false;
    }
    _updateStyles(sheets, updateApi: updateApi);
  }

  void _updateBorderRadius(ShopEditScreenState state, double radius, {bool updateApi = true}) {
    Map<String, dynamic> sheets = state.pageDetail.stylesheets[selectedChildId];
    sheets['borderRadius'] = radius.toInt();
    _updateStyles(sheets, updateApi: updateApi);
  }

  void _updateImageBorderModel(ShopEditScreenState state, BorderModel model, {bool updateApi = true}) {
    Map<String, dynamic> sheets = state.pageDetail.stylesheets[selectedChildId];
    sheets['borderColor'] =  model.borderColor;
    if (state.selectedChild.type == 'image') {
      sheets['border'] = model.border;
      sheets['borderSize'] =  model.borderWidth;
      sheets['borderType'] =  model.borderStyle;
    } else if (state.selectedChild.type == 'logo') {
      sheets['borderWidth'] =  model.borderWidth;
      sheets['borderStyle'] =  model.borderStyle;
    }
    _updateStyles(sheets, updateApi: updateApi);
  }

  _updateStyles(Map<String, dynamic> sheets, {bool updateApi = true}) {
    ShopEditScreenState state = widget.screenBloc.state;
    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        selectedChildId, sheets, state.pageDetail.stylesheetIds);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects, updateApi: updateApi));
  }

  // endregion

  Map<String, dynamic> getData(ShopEditScreenState state) {
    Child section = state.pageDetail.template.children.firstWhere((element) => element.id == state.selectedSectionId);
    Child child = section.children.firstWhere((element) => element.id == state.selectedChild.id);
    return child.data;
  }

  void navigateSubView(Widget subview) {
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.transparent,
        // isScrollControlled: true,
        builder: (builder) {
          return subview;
        });
  }
}
