import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

class TemplateView extends StatefulWidget {
  final ShopPage shopPage;
  final Template template;
  final Map<String, dynamic> stylesheets;

  const TemplateView({this.shopPage, this.template, this.stylesheets});

  @override
  _TemplateViewState createState() => _TemplateViewState(shopPage, template, stylesheets);
}

class _TemplateViewState extends State<TemplateView> {

  final ShopPage shopPage;
  final Template template;
  final Map<String, dynamic> stylesheets;

  _TemplateViewState(this.shopPage, this.template, this.stylesheets);

  @override
  Widget build(BuildContext context) {
    List sections = [];
    template.children.forEach((child) {

      if (child.type == 'section') {
          sections.add(_section(child));
      }
    });

    print('Sections Length: ${sections.length}');
    return Container(
      color: Colors.amber,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: sections.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return sections[index];
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 14,
            thickness: 0,
            color: Colors.transparent,
          );
        },
      ),
    );
  }

  Widget _section(TemplateChild child) {
    Background background = stylesheets[child.id];
    List widgets = [];
    child.children.forEach((child) {
        if (child.type == 'text') {
          widgets.add(_textWidget(child));
        } else if (child.type == 'button') {
//        widgets.add(_buttonWidget(child));
        } else if (child.type == 'image') {
        widgets.add(_imageWidget(child));
        }
    });

    return Container(
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: widgets.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return widgets[index];
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 14,
            thickness: 0,
            color: Colors.transparent,
          );
        },
      ),
    );
  }

  Widget _textWidget(TemplateChild child) {
//    Background background = stylesheets[child.id];
//    if (background == null) return Container();
    return Align(
      alignment: Alignment.center,
      child: Container(
//        height: background.height,
//        width: background.width,
        alignment: Alignment.center,
        child: Text(child.data.text),
      ),
    );
  }

  Widget _buttonWidget(TemplateChild child) {
    Background background = stylesheets[child.id];
    if (background == null) return Container();
    return Container(
      height: background.height,
      width: background.width,
      child: Text(child.data.text),
    );
  }

  Widget _imageWidget(TemplateChild child) {
    Background background = stylesheets[child.id];
    if (background == null) return Container();
    return Container(
      height: background.height,
      width: background.width,
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
