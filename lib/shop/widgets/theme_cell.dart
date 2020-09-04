import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/theme.dart';

class ThemeCell extends StatelessWidget {
  final ThemeListModel themeListModel;
  final Function onTapInstall;
  final Function onTapDuplicate;
  final Function onTapEdit;
  final Function onTapDelete;
  final Function onCheck;
  final Function onTapPreview;
  ThemeCell({
    this.themeListModel,
    this.onTapInstall,
    this.onTapDuplicate,
    this.onTapEdit,
    this.onTapDelete,
    this.onCheck,
    this.onTapPreview,
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
            child: Stack(
              children: <Widget>[
                themeListModel.themeModel.picture != null
                    ? CachedNetworkImage(
                        imageUrl:
                            '${Env.storage}${themeListModel.themeModel.picture}',
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
                        errorWidget: (context, url, error) => Container(
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
                      )
                    : Container(
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
                Container(
                  padding: EdgeInsets.only(top: 4, left: 4),
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      onTap: () {
                        onCheck(themeListModel);
                      },
                      child: themeListModel.isChecked
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.black87,
                            )
                          : Icon(
                              Icons.radio_button_unchecked,
                              color: Colors.black87,
                            )),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
            color: overlayColor(),
            width: double.infinity,
            height: (Measurements.width - 38) * 0.13,
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  themeListModel.themeModel.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  themeListModel.themeModel.type,
                  style: TextStyle(
                    color: Color(0xffff9000),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black87,
            height: (Measurements.width - 38) * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: onTapPreview,
                  child: Container(
                      color: overlayButtonBackground(),
                      child: Center(child: Text('Preview'))),
                ),
                Container(
                  width: 1,
                  color: Color(0xFF888888),
                ),
                InkWell(
                  onTap: () {
                    onTapInstall(themeListModel.themeModel);
                  },
                  child: Container(
                      color: overlayButtonBackground(),
                      child: Center(child: Text('Install'))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
