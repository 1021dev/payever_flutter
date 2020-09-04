import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';
import 'package:payever/shop/models/models.dart';

class ThemeCell extends StatelessWidget {
  final ThemeModel themeModel;
  final Function onTapInstall;
  final Function onTapDuplicate;
  final Function onTapEdit;
  final Function onTapDelete;
  ThemeCell({
    this.themeModel,
    this.onTapInstall,
    this.onTapDuplicate,
    this.onTapEdit,
    this.onTapDelete,
  });

  List<OverflowMenuItem> themePopup(BuildContext context) {
    return [
      OverflowMenuItem(
        title: 'Install',
        onTap: (theme) async {
          onTapInstall(theme);
        },
      ),
      OverflowMenuItem(
        title: 'Duplicate',
        onTap: (theme) async {
          onTapDuplicate(theme);
        },
      ),
      OverflowMenuItem(
        title: 'Edit',
        onTap: (theme) async {
          onTapEdit(theme);
        },
      ),
      OverflowMenuItem(
        title: 'Delete',
        onTap: (theme) async {
          onTapDelete(theme);
        },
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: Measurements.width - 38,
      height: (Measurements.width - 38) * 1.8,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: themeModel.picture != null ? CachedNetworkImage(
              imageUrl: '${Env.storage}${themeModel.picture}',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              color: Colors.white,
              placeholder: (context, url) => Container(
                color: Colors.white,
                child: Center(
                  child: Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) =>  Container(
                color: Colors.white,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/no_image.svg',
                    color: Colors.black54,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ) : Container(
              color: Colors.white,
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/no_image.svg',
                  color: Colors.black54,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black87,
            height: (Measurements.width - 38) * 0.1,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'new',
                      style: TextStyle(
                        color: Color(0xffff9000),
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      themeModel.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton<OverflowMenuItem>(
                    icon: Icon(Icons.more_horiz),
                    offset: Offset(0, 0),
                    onSelected: (OverflowMenuItem item) => item.onTap(themeModel),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.black87,
                    itemBuilder: (BuildContext context) {
                      return themePopup(context)
                          .map((OverflowMenuItem item) {
                        return PopupMenuItem<OverflowMenuItem>(
                          value: item,
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}