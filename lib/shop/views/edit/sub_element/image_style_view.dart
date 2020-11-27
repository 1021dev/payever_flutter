import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/shop/models/models.dart';
import 'upload_image_view.dart';

class ImageStyleView extends StatefulWidget {
  final TextStyles styles;
  final ShopEditScreenBloc screenBloc;
  final Function onChangeDescription;
  final String description;

  const ImageStyleView(
      {this.styles, this.screenBloc, this.onChangeDescription, this.description});

  @override
  _ImageStyleViewState createState() => _ImageStyleViewState();
}

class _ImageStyleViewState extends State<ImageStyleView> {
  bool adjustmentExpanded = false;
  bool descriptionExpanded = false;
  double exposure = 0;
  double saturate = 0;
  TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    controller.text = widget.description;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && widget.description != controller.text) {
        widget.onChangeDescription(controller.text);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
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
                hasImage: widget.styles.background != null &&
                    widget.styles.background.isNotEmpty,
                isBackground: false,
                imageUrl: widget.styles.background),
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
                    'Adjustment',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Spacer(),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: adjustmentExpanded,
                      onChanged: (value) {
                        setState(() {
                          adjustmentExpanded = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (adjustmentExpanded) addJustView,
            Divider(
              height: 1,
              thickness: 0.5,
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Text(
                    'Description',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Spacer(),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: descriptionExpanded,
                      onChanged: (value) {
                        setState(() {
                          descriptionExpanded = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (descriptionExpanded) descriptionView,
          ],
        ),
      ),
    );
  }

  Widget get addJustView {
    return Container(
      padding: EdgeInsets.only(left: 16),
      child: Column(
        children: [
          Container(
            height: 60,
            child: Row(
              children: [
                Container(
                  width: 70,
                  child: Text(
                    'Exposure',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: exposure,
                    min: -100,
                    max: 100,
                    onChanged: (double value) {
                      setState(() {
                        exposure = value;
                      });
                    },
                    onChangeEnd: (double value) {},
                  ),
                ),
                Text(
                  '${exposure.round()} %',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            child: Row(
              children: [
                Container(
                  width: 70,
                  child: Text(
                    'Saturate',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: saturate,
                    min: -100,
                    max: 100,
                    onChanged: (double value) {
                      setState(() {
                        saturate = value;
                      });
                    },
                    onChangeEnd: (double value) {},
                  ),
                ),
                Text(
                  '${saturate.round()} %',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get descriptionView {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.white),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              focusNode: _focusNode,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                // border: InputBorder.none,
                // focusedBorder: InputBorder.none,
                // enabledBorder: InputBorder.none,
                // errorBorder: InputBorder.none,
                // disabledBorder: InputBorder.none,
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              maxLines: 100,
              onChanged: (text) {
                // widget.onChangeText(text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
