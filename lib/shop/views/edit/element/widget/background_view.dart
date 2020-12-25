import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../../theme.dart';

class BackgroundView extends StatefulWidget {
  final BaseStyles styles;

  const BackgroundView({this.styles});

  @override
  _BackgroundViewState createState() => _BackgroundViewState();
}

class _BackgroundViewState extends State<BackgroundView> {

  _BackgroundViewState();

  @override
  Widget build(BuildContext context) {
    return background();
  }

  Widget background() {
    if (widget.styles.backgroundImage == null || widget.styles.backgroundImage.isEmpty)
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: colorConvert(widget.styles.backgroundColor, emptyColor: true),
      );
    // Gradient
    if (widget.styles.isGradientBackGround) {
      return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: widget.styles.gradient,
          )

      );
    }

    // Image
    if (widget.styles.backgroundSize == null) {
      return CachedNetworkImage(
        imageUrl: widget.styles.backgroundImage,
        height: double.infinity,
        repeat: imageRepeat ? ImageRepeat.repeat : ImageRepeat.noRepeat,
      );
    }

    if (widget.styles.backgroundPosition == 'initial') {
      return CachedNetworkImage(
        width: double.infinity,
        height: double.infinity,
        imageUrl: widget.styles.backgroundImage,
        alignment: Alignment.topLeft,
        fit: imageFit(widget.styles.backgroundSize),
      );
    }

    return CachedNetworkImage(
      imageUrl: widget.styles.backgroundImage,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: imageFit(widget.styles.backgroundSize),
          ),
        ),
      ),
    );
  }

  BoxFit imageFit(String backgroundSize) {
    if (backgroundSize == '100%') return BoxFit.fitWidth;
    if (backgroundSize == '100% 100%') return BoxFit.fill;
    if (backgroundSize == 'cover') return BoxFit.cover;
    if (backgroundSize == 'contain') return BoxFit.contain;
    try{
      if (int.parse(backgroundSize.replaceAll('%', '')) > 100) return BoxFit.cover;
    } catch(e) {}
    return BoxFit.contain;
  }

  get imageRepeat {
    return widget.styles.backgroundRepeat == 'repeat' ||
        widget.styles.backgroundRepeat == 'space';
  }
}
