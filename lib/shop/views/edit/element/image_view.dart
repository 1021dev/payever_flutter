import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/theme.dart';

class ImageView extends StatefulWidget {
  final Child child;

  const ImageView(this.child);
  @override
  _ImageViewState createState() => _ImageViewState(child);
}

class _ImageViewState extends State<ImageView> {
  final Child child;

  _ImageViewState(this.child);

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    if (child.styles == null || child.styles.isEmpty) {
      return Container();
    }
    ImageStyles styles = ImageStyles.fromJson(child.styles) ;
    Data data;
    try {
      data = Data.fromJson(child.data);
    } catch (e) {}


    String url;
    if (styles.background.isNotEmpty) {
      url = styles.background;
    } else {
      if (data == null || data.src == null || data.src.isEmpty)
        return Container();
      url = data.src;
    }
    return Container(
      height: styles.height,
      width: styles.width,
      color: colorConvert(styles.backgroundColor),
      margin: EdgeInsets.only(
          left: styles.marginLeft,
          right: styles.marginRight,
          top: styles.marginTop,
          bottom: styles.marginBottom),
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            color: Colors.white /*background.backgroundColor*/,
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.contain,
            ),
          ),
        ),
        placeholder: (context, url) =>
            Container(child: Center(child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          size: 80,
        ),
      ),
    );
  }

}
