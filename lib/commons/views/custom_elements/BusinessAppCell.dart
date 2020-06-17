import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/app_widget.dart';
import '../../utils/env.dart';
import '../../utils/translations.dart';

class BusinessAppCell extends StatelessWidget {
  final AppWidget _currentApp;

  BusinessAppCell(this._currentApp);

  String uiKit = Env.commerceOs + "/assets/ui-kit/icons-png/";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.black38
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            uiKit + _currentApp.icon),
                        fit: BoxFit.fitWidth)),
              ),
            ],
          ),
          Text(
            _currentApp.title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white
            ),
          )
        ],
      ),
    );
  }
}
