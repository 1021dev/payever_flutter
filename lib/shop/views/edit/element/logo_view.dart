import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/sub_element/resizeable_widget.dart';
import 'package:payever/theme.dart';
import 'package:provider/provider.dart';

class LogoView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const LogoView(
      {this.child,
      this.stylesheets,
      this.deviceTypeId,
      this.sectionStyleSheet});

  @override
  _LogoViewState createState() => _LogoViewState(child, sectionStyleSheet);
}

class _LogoViewState extends State<LogoView> {
  final Child child;
  final SectionStyleSheet sectionStyleSheet;
  ImageStyles styles;
  GlobalStateModel globalStateModel;
  GlobalKey key = GlobalKey();
  _LogoViewState(this.child, this.sectionStyleSheet);
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context, listen: true);

    if (child.styles != null && child.styles.isNotEmpty) {
      styles = ImageStyles.fromJson(child.styles);
    } else {
      styles = styleSheet();
    }
    return _body();
  }

  Widget _body() {
    if (styles == null ||
        styles.display == 'none' ||
        (styleSheet() != null && styleSheet().display == 'none'))
      return Container();
//    if (isSelected) {
//      RenderBox box = key.currentContext.findRenderObject();
//      Offset position = box.localToGlobal(Offset.zero);
//      return ResizeableWidget(
//        width: styles.width,
//        height: styles.height,
//        top: position.dy - 76,
//        left: styles.getMarginLeft(sectionStyleSheet),
//          child: _mainBody(),
//      );
//    }
    return _mainBody();
  }

  Widget _mainBody() {
    return Opacity(
      opacity: styles.opacity,
      child: Container(
        key: key,
        width: styles.width,
        height: styles.height,
        decoration: BoxDecoration(
          color: colorConvert(styles.backgroundColor),
          shape: BoxShape.circle,
        ),
        margin: EdgeInsets.only(
            left: styles.getMarginLeft(sectionStyleSheet),
            right: styles.marginRight,
            top: styles.getMarginTop(sectionStyleSheet),
            bottom: styles.marginBottom),
        child: CachedNetworkImage(
          imageUrl: '${globalStateModel.activeShop.picture}',
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              color: Colors.transparent /*background.backgroundColor*/,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.contain,
              ),
            ),
          ),
          errorWidget: (context, url, error) {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              child: SvgPicture.asset(
                'assets/images/no_image.svg',
              ),
            );
          },
        ),
      ),
    );
  }
  ImageStyles styleSheet() {
    try {
//      print(
//          'Logo Styles: ${widget.stylesheets[widget.deviceTypeId][child.id]}');
      return ImageStyles.fromJson(
          widget.stylesheets[widget.deviceTypeId][child.id]);
    } catch (e) {
      return null;
    }
  }
}
