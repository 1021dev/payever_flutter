import 'package:flutter/material.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/view_models/view_models.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class AppBarAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _container;
    bool noPicture =
        Provider.of<GlobalStateModel>(context).currentBusiness.logo == null;
    var image;
    if (noPicture) {
      String name = Provider.of<GlobalStateModel>(context).currentBusiness.name;
      String displayName;
      if (name.contains(" ")) {
        displayName = name.substring(0, 1);
        displayName = displayName + name.split(" ")[1].substring(0, 1);
      } else {
        displayName = name.substring(0, 1) + name.substring(name.length - 1);
        displayName = displayName.toUpperCase();
      }
      _container = Container(
        child: Center(
            child: Text(
          displayName,
          style: TextStyle(color: Colors.black),
        )),
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
      );
    } else {
      image = NetworkImage(
        Env.storage +
            '/images/' +
            Provider.of<GlobalStateModel>(context).currentBusiness.logo,
      );
    }
    return Theme(
      child: CircleAvatar(
        backgroundImage: noPicture ? MemoryImage(kTransparentImage) : image,
        child: _container,
      ),
      data: ThemeData(canvasColor: Colors.grey),
    );
  }
}
