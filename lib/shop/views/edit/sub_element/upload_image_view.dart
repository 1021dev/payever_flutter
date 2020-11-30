import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';


class UploadImageView extends StatefulWidget {
  final TextStyles styles;
  final ShopEditScreenBloc screenBloc;
  final bool hasImage;
  final bool isBackground;
  final String imageUrl;
  final bool isVideo;

  const UploadImageView(
      {@required this.styles,
      @required this.screenBloc,
      @required this.hasImage,
      @required this.isBackground,
      @required this.imageUrl,
      this.isVideo = false});

  @override
  _UploadImageViewState createState() => _UploadImageViewState();
}

class _UploadImageViewState extends State<UploadImageView> {
  String url;
  String media;

  @override
  void initState() {
    url = widget.imageUrl;
    if (widget.isVideo && widget.hasImage && !url.contains('http'))
      url = 'https://payeverproduction.blob.core.windows.net/builder-video/${widget.imageUrl}';
    media = widget.isVideo ? 'Video' : 'Photo';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal:16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              child: Row(
                children: [
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: !widget.hasImage ? ClipPath(
                      child: Container(
                        color: Colors.red[900],
                      ),
                      clipper: NoBackGroundFillClipPath(),
                    ) : CachedNetworkImage(
                      imageUrl: url,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent /*background.backgroundColor*/,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: widget.isBackground ? BoxFit.cover : BoxFit.contain,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        child: Center(
                          child: Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16,),
                  PopupMenuButton<OverflowMenuItem>(
                    child: Container(
                        width: 100,
                        child: Text(widget.hasImage ? 'Change $media' : 'Upload $media', style: TextStyle(color: Colors.blue, fontSize: 15),)),
                    offset: Offset(0, 100),
                    onSelected: (OverflowMenuItem item) => item.onTap(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: overlayFilterViewBackground(),
                    itemBuilder: (BuildContext context) {
                      return appBarPopUpActions(context)
                          .map((OverflowMenuItem item) {
                        return PopupMenuItem<OverflowMenuItem>(
                          value: item,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              item.iconData,
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<OverflowMenuItem> appBarPopUpActions(BuildContext context) {
    return [
      OverflowMenuItem(
        title: 'Take $media',
        iconData: Icon(Icons.camera_alt_outlined),
        onTap: () {
          getImage(0);
        },
      ),
      OverflowMenuItem(
        title: 'Choose $media',
        iconData: Icon(Icons.photo,),
        onTap: () {
          getImage(1);
        },
      ),
      OverflowMenuItem(
        title: 'From Studio',
        iconData: Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          child: CachedNetworkImage(
            imageUrl: 'https://payever.azureedge.net/icons-png/icon-commerceos-studio-64.png',
          ),
        ),
        onTap: () {
          setState(() {

          });
        },
      ),
    ];
  }

  void getImage(int type) async {
    ImagePicker imagePicker = ImagePicker();
    if (widget.isVideo == true) {
      var video = await imagePicker.getVideo(
        source: type == 1 ? ImageSource.gallery : ImageSource.camera,
      );
      if (video != null)
        widget.screenBloc.add(UploadPhotoEvent(
            image: File(video.path), isBackground: widget.isBackground, isVideo: true));
    } else {
      var image = await imagePicker.getImage(
        source: type == 1 ? ImageSource.gallery : ImageSource.camera,
      );
      if (image != null) {
        File croppedFile = await GlobalUtils.cropImage(File(image.path));
        if (croppedFile != null)
          widget.screenBloc.add(UploadPhotoEvent(
              image: croppedFile, isBackground: widget.isBackground, isVideo: false));
      }
    }
  }
}

class OverflowMenuItem {
  final String title;
  final Color textColor;
  final Widget iconData;
  final Function onTap;

  OverflowMenuItem({
    this.title,
    this.iconData,
    this.textColor = Colors.black,
    this.onTap,
  });
}