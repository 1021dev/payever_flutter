import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/shop/models/models.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';

class LogoView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;

  const LogoView(
      {this.child,
      this.stylesheets});

  @override
  _LogoViewState createState() => _LogoViewState();
}

class _LogoViewState extends State<LogoView> {

  ImageStyles styles;
  GlobalStateModel globalStateModel;
  GlobalKey key = GlobalKey();
  _LogoViewState();

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
        // decoration: styles.decoration(widget.child.type),
        child: Container(
          alignment: Alignment.center,
          child: DottedBorder(
            dashPattern: [8, 4],
            strokeWidth: 2,
            child: CachedNetworkImage(
              imageUrl: '${globalStateModel.activeShop.picture}',
            ),
          ),
        ),
      ),
    );
  }

  ImageStyles styleSheet() {
    try {
      Map<String, dynamic> json = widget.stylesheets[widget.child.id];
     // if (json['display'] != 'none')
     //   print('Logo Styles: $json');
      return ImageStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
