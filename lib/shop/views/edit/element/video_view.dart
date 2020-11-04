import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/sub_element/resizeable_view.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyles sectionStyles;
  final bool isSelected;

  const VideoView(
      {this.child,
      this.stylesheets,
      this.deviceTypeId,
      this.sectionStyles,
      this.isSelected = false});

  @override
  _VideoViewState createState() => _VideoViewState(child, sectionStyles);
}

class _VideoViewState extends State<VideoView> {
  final Child child;
  final SectionStyles sectionStyles;
  ImageStyles styles;
  VideoData data;

  _VideoViewState(this.child, this.sectionStyles);

  VideoPlayerController _controller;
  bool videoLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    try {
      if (data.controls != null && _controller != null) _controller.dispose();
    } catch(e) {}
  }

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = ImageStyles.fromJson(child.styles);
    }
    if (styles == null || !styles.active) return Container();
    try {
      data = VideoData.fromJson(child.data);
    } catch (e) {}

    if (data == null /* || data.preview == null || data.preview.isEmpty*/)
      return Container();
    return body;
    return ResizeableView(
        width: styles.width,
        height: styles.height,
        left: styles.getMarginLeft(sectionStyles),
        top: styles.getMarginTop(sectionStyles),
        isSelected: widget.isSelected,
        child: body);
  }

  Widget get body {
    return Opacity(
      opacity: styles.opacity,
      child: Container(
        child: Stack(
          children: [
            previewView,
            videoPlayerView,
            Visibility(
                visible: data.controls,
                child: Positioned(bottom: 10, right: 10, child: playButton))
          ],
        ),
      ),
    );
  }

  get previewView {
    return CachedNetworkImage(
      imageUrl: data.preview,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
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
          color: Color.fromRGBO(245, 245, 245, 0.3),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/no_video.svg',
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.grey,
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
    );
  }

  get videoPlayerView {
    if (_controller == null) return Container();
    if (videoLoading) return Center(child: CircularProgressIndicator());

    return Center(
      child: _controller.value.initialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(),
    );
  }

  get playButton {
    return IconButton(
      onPressed: () {
        if (_controller == null) {
          print('Initializing videoView...');
          _controller = VideoPlayerController.network(data.source)
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(() {
                videoLoading = false;
                _controller.play();
              });
            });
          setState(() {
            videoLoading = true;
          });
          return;
        }
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      },
      icon: Icon(
        _controller == null || !_controller.value.isPlaying
            ? Icons.play_arrow
            : Icons.pause,
      ),
    );
  }

  ImageStyles styleSheet() {
    try {
      Map<String, dynamic> json = widget.stylesheets[widget.deviceTypeId][child.id];
//      if (json['display'] != 'none')
//        print('Video Styles: $json');
      return ImageStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
