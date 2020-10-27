import 'dart:math';

import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/models/template_size_state_model.dart';
import 'package:provider/provider.dart';

class ResizeableView extends StatefulWidget {
  ResizeableView({this.child, this.height, this.width , this.top, this.left, this.isSelected = false});

  final Widget child;
  final double height;
  final double width;
  final double top;
  final double left;
  final bool isSelected;

  @override
  _ResizeableViewState createState() => _ResizeableViewState(
      width: width, height: height, top: top, left: left);
}

const ballDiameter = 12.0;

class _ResizeableViewState extends State<ResizeableView> {
  double width;
  double height;

  double top;
  double left;

  _ResizeableViewState({this.width, this.height, this.top, this.left});

  void onDrag(double dx, double dy) {
    var newHeight = height + dy;
    var newWidth = width + dx;

    setState(() {
      height = newHeight > 0 ? newHeight : 0;
      width = newWidth > 0 ? newWidth : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: Container(
            height: height,
            width: width,
            child: widget.child,
          ),
        ),

        // top left
        if(widget.isSelected)
        Positioned(
          top: top - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;
              var newHeight = height - 2 * mid;
              var newWidth = width - 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top + mid;
                left = left + mid;
                updateSize();
              });
            },
          ),
        ),

        // top middle
        if(widget.isSelected && !smallWidth)
        Positioned(
          top: top - ballDiameter / 2,
          left: left + width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newHeight = height - dy;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                top = top + dy;
                updateSize();
              });
            },
          ),
        ),

        // top right
        if(widget.isSelected)
        Positioned(
          top: top - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + (dy * -1)) / 2;

              var newHeight = height + 2 * mid;
              var newWidth = width + 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top - mid;
                left = left - mid;
                updateSize();
              });
            },
          ),
        ),

        // center right
        if(widget.isSelected && !smallHeight)
        Positioned(
          top: top + height / 2 - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newWidth = width + dx;

              setState(() {
                width = newWidth > 0 ? newWidth : 0;
                updateSize();
              });
            },
          ),
        ),

        // bottom right
        if(widget.isSelected)
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;

              var newHeight = height + 2 * mid;
              var newWidth = width + 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top - mid;
                left = left - mid;
                updateSize();
              });
            },
          ),
        ),

        // bottom center
        if(widget.isSelected && !smallWidth)
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left + width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newHeight = height + dy;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                updateSize();
              });
            },
          ),
        ),

        // bottom left
        if(widget.isSelected)
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = ((dx * -1) + dy) / 2;

              var newHeight = height + 2 * mid;
              var newWidth = width + 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top - mid;
                left = left - mid;
                updateSize();
              });
            },
          ),
        ),

        //left center
        if(widget.isSelected && !smallHeight)
        Positioned(
          top: top + height / 2 - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newWidth = width - dx;

              setState(() {
                width = newWidth > 0 ? newWidth : 0;
                left = left + dx;
                updateSize();
              });
            },
          ),
        ),

        // center center
        if(widget.isSelected && !smallWidth && !smallHeight)
        Positioned(
          top: top + height / 2 - ballDiameter / 2,
          left: left + width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              setState(() {
                top = top + dy;
                left = left + dx;
                updateSize();
              });
            },
          ),
        ),
      ],
    );
  }

  bool get smallWidth {
    return width < 50;
  }

  bool get smallHeight {
    return height < 50;
  }

  void updateSize() {
    Provider.of<TemplateSizeStateModel>(context, listen: false).setNewChildSize(
        NewChildSize(
            newTop: top, newLeft: left, newWidth: width, newHeight: height));
  }
}

class ManipulatingBall extends StatefulWidget {
  ManipulatingBall({Key key, this.onDrag});

  final Function onDrag;

  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  double initX;
  double initY;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    double deg = 45 * pi / 180;
    return GestureDetector(
      onVerticalDragStart: _handleDrag,
      onVerticalDragUpdate: _handleUpdate,
      onHorizontalDragStart: _handleDrag,
      onHorizontalDragUpdate: _handleUpdate,
      child: Container(
        width: ballDiameter,
        height: ballDiameter,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          color: Colors.blue,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(
            color: Colors.black38,
            spreadRadius: 1.5,
            blurRadius: 1.5,
            offset: Offset(deg,
                deg), // changes position of shadow
          )],
        ),
      ),
    );
  }
}