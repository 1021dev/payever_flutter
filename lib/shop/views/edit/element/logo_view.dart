import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/shop/models/models.dart';
import 'package:provider/provider.dart';

class LogoView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;

  const LogoView(
      {this.child,
      this.stylesheets});

  @override
  _LogoViewState createState() => _LogoViewState(child);
}

class _LogoViewState extends State<LogoView> {
  final Child child;

  ImageStyles styles;
  GlobalStateModel globalStateModel;
  GlobalKey key = GlobalKey();
  _LogoViewState(this.child);


  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context, listen: true);
    styles = styleSheet();
    return body;
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
      Map<String, dynamic> json = widget.stylesheets[child.id];
//      if (json['display'] != 'none')
//        print('Logo Styles: $json');
      return ImageStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
