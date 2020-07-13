import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/utils/env.dart';

class ProductItemImage extends StatelessWidget {
  final String imageURL;
  final File imageFile;

  ProductItemImage(this.imageURL, {this.imageFile});

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Image.file(imageFile),
      );
    } else {
      if (imageURL != null) {
        return CachedNetworkImage(
          imageUrl: '${Env.storage}/products/$imageURL',
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover
                )
            ),
          ),
          color: Colors.white,
          placeholder: (context, url) => Container(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>  Container(child: Icon(Icons.error)),
        );
      } else {
        return Container(child: Icon(Icons.error));
      }
    }
  }
}
