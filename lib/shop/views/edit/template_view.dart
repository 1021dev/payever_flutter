import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

class TemplateView extends StatefulWidget {
  final ShopPage shopPage;
  final Background background;
  final Template template;

  const TemplateView({this.shopPage, this.background, this.template});

  @override
  _TemplateViewState createState() => _TemplateViewState(shopPage, background, template);
}

class _TemplateViewState extends State<TemplateView> {

  final ShopPage shopPage;
  final Background background;
  final Template template;

  _TemplateViewState(this.shopPage, this.background, this.template);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(child: _background()),
        ],
      ),
    );
  }

  Widget _background() {
    if (background == null)
      return Container();
    
    return Container(
      child: CachedNetworkImage(
        imageUrl:
        '${background.backgroundImage}',
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            color: Colors.white/*background.backgroundColor*/,
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.contain,
            ),
          ),
        ),
        placeholder: (context, url) =>
            Container(child: Center(child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Icon(Icons.error, size: 80,),
      ),
    );
  }
}
