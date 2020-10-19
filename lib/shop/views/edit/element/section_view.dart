import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/text_view.dart';
import 'package:payever/commons/utils/draggable_widget.dart';
import '../../../../theme.dart';
import 'button_view.dart';
import 'image_view.dart';

class SectionView extends StatefulWidget {
  final ShopPage shopPage;
  final Child child;
  final Map<String, dynamic> stylesheets;

  const SectionView({this.shopPage, this.child, this.stylesheets});

  @override
  _SectionViewState createState() => _SectionViewState(
      shopPage: shopPage, child: child, stylesheets: stylesheets);
}

class _SectionViewState extends State<SectionView> {
  final ShopPage shopPage;
  final Child child;
  final Map<String, dynamic> stylesheets;
  DragController dragController = DragController();
  SectionStyleSheet styleSheet;

  StreamController<double> controller = StreamController.broadcast();
  double position = 0;

  _SectionViewState({this.shopPage, this.child, this.stylesheets}) {
    styleSheet = getSectionStyleSheet(child.id);
    position = styleSheet.height;
  }

  @override
  Widget build(BuildContext context) {
    return _section();
  }

  Widget _section() {
    if (styleSheet == null) {
      return Container();
    }
    List<Widget> widgets = [];
    widgets.add(_sectionBackgroundWidget(styleSheet));
    child.children.forEach((child) {
      if (child.type == EnumToString.convertToString(ChildType.text)) {
        Widget text = TextView(
          child: child,
          stylesheets: stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyleSheet: styleSheet,
        );
        if (text != null) widgets.add(text);
      } else if (child.type == EnumToString.convertToString(ChildType.button)) {
        Widget button = ButtonView(
          child: child,
          stylesheets: stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyleSheet: styleSheet,
        );
        if (button != null) widgets.add(button);
      } else if (child.type == EnumToString.convertToString(ChildType.image)) {
        Widget image = ImageView(
          child: child,
          stylesheets: stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyleSheet: styleSheet,
        );
        if (image != null) widgets.add(image);
      } else if (child.type == EnumToString.convertToString(ChildType.shape)) {
      } else if (child.type == EnumToString.convertToString(ChildType.block)) {
        // If Type only Block, has sub children
//        widgets.add(_blockWidget(child));
      } else if (child.type == EnumToString.convertToString(ChildType.menu)) {
      } else if (child.type == EnumToString.convertToString(ChildType.logo)) {
      } else if (child.type == 'shop-cart') {
      } else if (child.type == 'shop-category') {
      } else if (child.type == 'shop-products') {
      } else {
        print('Special Child Type: ${child.type}');
      }
    });
    // Add Drag Buttons
    if (widgets.isNotEmpty) {
      widgets.add(Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    position = details.globalPosition.dy;
                    position.isNegative
                        ? Navigator.pop(context)
                        : controller.add(position);
                  });
                },
                behavior: HitTestBehavior.translucent,
                child: Icon(
                  Icons.arrow_drop_up,
                  color: Colors.black,
                ))),
      ));
    }

    return StreamBuilder(
      stream: controller.stream,
      builder: (context, snapshot) => Container(
        height: snapshot.hasData ? snapshot.data : styleSheet.height,
        width: double.infinity,
        child: Stack(
          children: widgets,
        ),
      ),
    );
  }

  Widget _sectionBackgroundWidget(SectionStyleSheet styleSheet) {
    return Container(
      width: double.infinity,
      //styleSheet.width,
      height: position,
      alignment: styleSheet.getBackgroundImageAlignment(),
      color: colorConvert(styleSheet.backgroundColor),
      child: background(),
    );
  }

  Widget background() {
    if (styleSheet.backgroundImage == null ||
        styleSheet.backgroundImage.isEmpty) return Container();
    // Gradient
    if (styleSheet.backgroundImage.contains('linear-gradient')) {
      return Container(
        width: double.infinity,
        height: position,
        decoration: styleSheet.getDecoration(),
      );
    }

    // Image
    if (styleSheet.backgroundSize == null) {
      return CachedNetworkImage(
        imageUrl: styleSheet.backgroundImage,
        height: double.infinity,
        repeat: imageRepeat ? ImageRepeat.repeat : ImageRepeat.noRepeat,
        placeholder: (context, url) =>
            Container(child: Center(child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          size: 40,
        ),
      );
    }

    if (styleSheet.backgroundPosition == 'initial') {
      return CachedNetworkImage(
        width: double.infinity,
        height: double.infinity,
        imageUrl: styleSheet.backgroundImage,
        alignment: Alignment.topLeft,
        fit: imageFit(styleSheet.backgroundSize),
        placeholder: (context, url) =>
            Container(child: Center(child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          size: 40,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: styleSheet.backgroundImage,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          color: Colors.transparent /*background.backgroundColor*/,
          image: DecorationImage(
            image: imageProvider,
            fit: imageFit(styleSheet.backgroundSize),
          ),
        ),
      ),
      placeholder: (context, url) =>
          Container(child: Center(child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => Icon(
        Icons.error,
        size: 40,
      ),
    );
  }

  SectionStyleSheet getSectionStyleSheet(String childId) {
    try {
      print(
          'Section StyleSheet: ${stylesheets[shopPage.stylesheetIds.mobile][childId]}');
      return SectionStyleSheet.fromJson(
          stylesheets[shopPage.stylesheetIds.mobile][childId]);
    } catch (e) {
      return null;
    }
  }

  BoxFit imageFit(String backgroundSize) {
    if (backgroundSize == '100%') return BoxFit.fitWidth;
    if (backgroundSize == '100% 100%') return BoxFit.fill;
    if (backgroundSize == 'cover') return BoxFit.cover;
    if (backgroundSize == 'contain') return BoxFit.contain;

    return BoxFit.contain;
  }

  get imageRepeat {
    return styleSheet.backgroundRepeat == 'repeat' ||
        styleSheet.backgroundRepeat == 'space';
  }
}
