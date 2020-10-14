import 'package:flutter/material.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/template_view.dart';

class TemplateDetailScreen extends StatefulWidget {
  final ShopPage shopPage;
  final Template template;
  final Map<String, dynamic> stylesheets;

  const TemplateDetailScreen({this.shopPage, this.template, this.stylesheets});

  @override
  _TemplateDetailScreenState createState() => _TemplateDetailScreenState(shopPage, template, stylesheets);
}

class _TemplateDetailScreenState extends State<TemplateDetailScreen> {
  final ShopPage shopPage;
  final Template template;
  final Map<String, dynamic> stylesheets;

  _TemplateDetailScreenState(this.shopPage, this.template, this.stylesheets);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Appbar(shopPage.name),
        body: SafeArea(
          child: TemplateView(
            shopPage: shopPage,
            template: template,
            stylesheets: stylesheets,
          ),
        ));
  }
}
