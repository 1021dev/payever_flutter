import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

import '../../../../../theme.dart';

class BackgroundView extends StatefulWidget {
  final BaseStyles styles;

  const BackgroundView({this.styles});

  @override
  _BackgroundViewState createState() => _BackgroundViewState(styles);
}

class _BackgroundViewState extends State<BackgroundView> {
  final BaseStyles styles;

  _BackgroundViewState(this.styles);

  @override
  Widget build(BuildContext context) {
    return background();
  }

  Widget background() {
    if (styles.backgroundImage == null || styles.backgroundImage.isEmpty)
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: colorConvert(styles.backgroundColor),
      );
    // Gradient
    if (styles.backgroundImage.contains('linear-gradient')) {
      return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: styles.getGradient(),
          )

      );
    }

    // Image
    if (styles.backgroundSize == null) {
      return CachedNetworkImage(
        imageUrl: styles.backgroundImage,
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

    if (styles.backgroundPosition == 'initial') {
      return CachedNetworkImage(
        width: double.infinity,
        height: double.infinity,
        imageUrl: styles.backgroundImage,
        alignment: Alignment.topLeft,
        fit: imageFit(styles.backgroundSize),
        placeholder: (context, url) =>
            Container(child: Center(child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          size: 40,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: styles.backgroundImage,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          color: Colors.transparent /*background.backgroundColor*/,
          image: DecorationImage(
            image: imageProvider,
            fit: imageFit(styles.backgroundSize),
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

  BoxFit imageFit(String backgroundSize) {
    if (backgroundSize == '100%') return BoxFit.fitWidth;
    if (backgroundSize == '100% 100%') return BoxFit.fill;
    if (backgroundSize == 'cover') return BoxFit.cover;
    if (backgroundSize == 'contain') return BoxFit.contain;

    return BoxFit.contain;
  }

  get imageRepeat {
    return styles.backgroundRepeat == 'repeat' ||
        styles.backgroundRepeat == 'space';
  }
}
