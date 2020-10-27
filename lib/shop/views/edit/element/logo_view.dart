import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/sub_element/resizeable_view.dart';
import 'package:provider/provider.dart';

class LogoView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;
  final bool isSelected;

  const LogoView(
      {this.child,
      this.stylesheets,
      this.deviceTypeId,
      this.sectionStyleSheet,
      this.isSelected});

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


  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context, listen: true);
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = ImageStyles.fromJson(child.styles);
    }

    if (styles == null ||
        styles.display == 'none')
      return Container();

    return ResizeableView(
        width: styles.width,
        height: styles.height,
        left: styles.getMarginLeft(sectionStyleSheet),
        top: styles.getMarginTop(sectionStyleSheet),
        isSelected: widget.isSelected,
        child: body);
  }

  Widget get body {
    return Opacity(
      opacity: styles.opacity,
      child: Container(
        key: key,
        width: styles.width,
        height: styles.height,
        child: CachedNetworkImage(
          imageUrl: '${globalStateModel.activeShop.picture}',
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
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
      Map json = widget.stylesheets[widget.deviceTypeId][child.id];
//      if (json['display'] != 'none')
//        print('Logo Styles: $json');
      return ImageStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
