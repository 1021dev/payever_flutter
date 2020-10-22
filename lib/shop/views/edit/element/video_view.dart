import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/theme.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const VideoView({this.child, this.stylesheets, this.deviceTypeId, this.sectionStyleSheet});

  @override
  _VideoViewState createState() => _VideoViewState(child, sectionStyleSheet);
}

class _VideoViewState extends State<VideoView> {
  final Child child;
  final SectionStyleSheet sectionStyleSheet;
  ImageStyles styles;
  _VideoViewState(this.child, this.sectionStyleSheet);
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = ImageStyles.fromJson(child.styles) ;
    }
    if (styles == null || styles.display == 'none') return Container();

    VideoData data;
    try {
      data = VideoData.fromJson(child.data);
    } catch (e) {}

    if (data == null/* || data.preview == null || data.preview.isEmpty*/)
      return Container();

    String url = data.preview;

    _controller = VideoPlayerController.network(data.source)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    return Container(
      height: styles.height,
      width: styles.width,
      color: colorConvert(styles.backgroundColor),
      margin: EdgeInsets.only(
          left: styles.getMarginLeft(sectionStyleSheet),
          right: styles.marginRight,
          top: styles.getMarginTop(sectionStyleSheet),
          bottom: styles.marginBottom),
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.contain,
            ),
          ),
        ),
        placeholder: (context, url) =>
            Container(child: Center(child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Container(
          width: styles.width,
          height: styles.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.grey, width: 0.5),
            color: Color.fromRGBO(245, 245, 245, 1),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/no_video.svg',
                    color: Colors.grey,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Text(
                'Add video',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }

  get videoPlayerView {
    return Center(
      child: _controller.value.initialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      )
          : Container(),
    );
  }

  ImageStyles styleSheet() {
    try {
      print(
          'Video Styles: ${widget.stylesheets[widget.deviceTypeId][child.id]}');
      return ImageStyles.fromJson(
          widget.stylesheets[widget.deviceTypeId][child.id]);
    } catch (e) {
      return null;
    }
  }
}
