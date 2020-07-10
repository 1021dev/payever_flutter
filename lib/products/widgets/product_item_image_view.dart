import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/utils/env.dart';

class ProductItemImage extends StatelessWidget {
  final String imageURL;
  final bool isRoundOnlyTopCorners;
  final File imageFile;

  ProductItemImage(this.imageURL, {this.isRoundOnlyTopCorners = false, this.imageFile});

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: isRoundOnlyTopCorners ? BorderRadius.only(topRight: Radius.circular(6.0), topLeft: Radius.circular(6.0)) : BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Image.file(imageFile),
      );
    } else {
      if (imageURL != null) {
        return CachedNetworkImage(
          imageUrl: '${Env.storage}/products/$imageURL',
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
                borderRadius: isRoundOnlyTopCorners ? BorderRadius.only(topRight: Radius.circular(6.0), topLeft: Radius.circular(6.0)) : BorderRadius.all(Radius.circular(12.0)),
                image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover
                )
            ),
          ),
          color: Colors.white,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) =>  ProductItemDefaultPlaceholder(isRoundOnlyTopCorners),
        );
      } else {
        return ProductItemDefaultPlaceholder(isRoundOnlyTopCorners);
      }
    }
  }
}

class ProductItemDefaultPlaceholder extends StatelessWidget {
  final bool isRoundOnlyTopCorners;

  ProductItemDefaultPlaceholder(this.isRoundOnlyTopCorners);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: isRoundOnlyTopCorners ? BorderRadius.only(topRight: Radius.circular(6.0), topLeft: Radius.circular(6.0)) : BorderRadius.all(Radius.circular(4.0)),
          color: Colors.white
      ),
    );
  }
}