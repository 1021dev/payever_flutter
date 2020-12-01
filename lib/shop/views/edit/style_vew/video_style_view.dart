import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/sub_view/upload_image_view.dart';

class VideoStyleView extends StatefulWidget {

  final TextStyles styles;
  final VideoData data;
  final ShopEditScreenBloc screenBloc;
  final Function onChangeData;

  const VideoStyleView(
      {this.styles, this.data, this.screenBloc, this.onChangeData});

  @override
  _VideoStyleViewState createState() => _VideoStyleViewState();
}

class _VideoStyleViewState extends State<VideoStyleView> {
  bool autoPlay = false;
  bool playLoop = false;
  bool controls = false;
  bool sounds = false;
  VideoData data;
  @override
  void initState() {
    super.initState();
    autoPlay = widget.data.autoplay;
    playLoop =  widget.data.loop;
    controls = widget.data.controls;
    sounds = widget.data.sound;
    data = widget.data;
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            UploadImageView(
                styles: widget.styles,
                screenBloc: widget.screenBloc,
                hasImage: widget.data.preview != null &&
                    widget.data.preview.isNotEmpty,
                isBackground: false,
                isVideo: true,
                imageUrl: widget.data?.preview),
            SizedBox(
              height: 16,
            ),
            Divider(
              height: 1,
              thickness: 0.5,
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Text(
                    'Auto plays',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Spacer(),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: autoPlay,
                      onChanged: (value) {
                        setState(() {
                          autoPlay = value;
                          data.autoplay = autoPlay;
                          _updateData();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.5,
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Text(
                    'Plays in a loop',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Spacer(),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: playLoop,
                      onChanged: (value) {
                        setState(() {
                          playLoop = value;
                          data.loop = playLoop;
                          _updateData();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.5,
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Text(
                    'Controls',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Spacer(),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: controls,
                      onChanged: (value) {
                        setState(() {
                          controls = value;
                          data.controls = controls;
                          _updateData();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.5,
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Text(
                    'Sound',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Spacer(),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: sounds,
                      onChanged: (value) {
                        setState(() {
                          sounds = value;
                          data.sound = sounds;
                          _updateData();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _updateData() {
    if (data.sourceType == null || data.sourceType.isEmpty) {
      data.sourceType = {'name': 'My video', 'value': 'my-video'};
    }
    widget.onChangeData(data);
  }
}
