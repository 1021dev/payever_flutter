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

const ballDiameter = 30.0;
const wrongEdgeWidth = 2.0;

class _ResizeableViewState extends State<ResizeableView> {
  double width;
  double height;

  double top;
  double left;
  double width0;
  double height0;

  double top0;
  double left0;

  TemplateSizeStateModel templateSizeStateModel;
  _ResizeableViewState({this.width, this.height, this.top, this.left}){
    width0 = width;
    height0 = height;
    top0 = top;
    left0 = left;
  }

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
    templateSizeStateModel = Provider.of<TemplateSizeStateModel>(context, listen: false);
    return body;
    // return Consumer<TemplateSizeStateModel>(
    //     builder: (context, templateSizeState, child1) {
    //   return body;
    // });
  }

  Widget get body {
    List<Widget>widgets = [];
    widgets.add(Positioned(
      top: top,
      left: left,
      child: Container(
        height: height,
        width: width,
        child: widget.child,
      ),
    ),);
    addWrongPositionEdges(widgets);
    addDragBalls(widgets);
    return Stack(children: widgets);
  }

  addWrongPositionEdges(List<Widget> widgets) {
    if (!widget.isSelected) return;
    var isWrongPosition = context.select<TemplateSizeStateModel, bool>(
          (templateStateModel) => templateStateModel.wrongPosition,
    );
    Color edgeColor = isWrongPosition ? Colors.red :Colors.blue;
    // top
    widgets.add(Positioned(
      top: top,
      left: left,
      child: Container(
        width: width,
        height: wrongEdgeWidth,
        color: edgeColor,
      ),
    ),);
    // left
    widgets.add(Positioned(
      top: top,
      left: left,
      child: Container(
        width: wrongEdgeWidth,
        height: height,
        color: edgeColor,
      ),
    ),);
    // bottom
    widgets.add(Positioned(
      top: top + height - wrongEdgeWidth,
      left: left,
      child: Container(
        width: width,
        height: wrongEdgeWidth,
        color: edgeColor,
      ),
    ),);
    // right
    widgets.add(Positioned(
      top: top,
      left: left + width - wrongEdgeWidth,
      child: Container(
        width: wrongEdgeWidth,
        height: height,
        color: edgeColor,
      ),
    ),);
  }

  addDragBalls(List<Widget> widgets) {
    if (!widget.isSelected) return;
    // center center
    widgets.add(Positioned(
      top: top /*+ height / 2 - ballDiameter / 2*/,
      left: left /*+ width / 2 - ballDiameter / 2*/,
      child: ManipulatingBall(
        isCenter: true,
        width: width,
        height: height,
        onDragEnd: _dragEnd,
        onDrag: (dx, dy) {
          setState(() {
            top = top + dy;
            left = left + dx;
            updateSize();
          });
        },
      ),
    ));
    // top left
    widgets.add(Positioned(
      top: top - ballDiameter / 2,
      left: left - ballDiameter / 2,
      child: ManipulatingBall(
        onDragEnd: _dragEnd,
        onDrag: (dx, dy) {
          var mid = (dx + dy) / 2;
          var newHeight = height - mid;
          var newWidth = width - mid;

          setState(() {
            height = newHeight > 0 ? newHeight : 0;
            width = newWidth > 0 ? newWidth : 0;
            top = top + mid;
            left = left + mid;
            updateSize();
          });
        },
      ),
    ));

    // top middle
    if (!smallWidth)
      widgets.add(Positioned(
        top: top - ballDiameter / 2,
        left: left + width / 2 - ballDiameter / 2,
        child: ManipulatingBall(
          onDragEnd: _dragEnd,
          onDrag: (dx, dy) {
            var newHeight = height - dy;

            setState(() {
              height = newHeight > 0 ? newHeight : 0;
              top = top + dy;
              updateSize();
            });
          },
        ),
      ));

    // top right
    widgets.add(Positioned(
      top: top - ballDiameter / 2,
      left: left + width - ballDiameter / 2,
      child: ManipulatingBall(
        onDragEnd: _dragEnd,
        onDrag: (dx, dy) {
          var mid = (dx + (dy * -1)) / 2;

          var newHeight = height + mid;
          var newWidth = width + mid;

          setState(() {
            height = newHeight > 0 ? newHeight : 0;
            width = newWidth > 0 ? newWidth : 0;
            top = top - mid;
            // left = left - mid;
            updateSize();
          });
        },
      ),
    ));

    // center right
    if (!smallHeight)
      widgets.add(Positioned(
        top: top + height / 2 - ballDiameter / 2,
        left: left + width - ballDiameter / 2,
        child: ManipulatingBall(
          onDragEnd: _dragEnd,
          onDrag: (dx, dy) {
            var newWidth = width + dx;

            setState(() {
              width = newWidth > 0 ? newWidth : 0;
              updateSize();
            });
          },
        ),
      ));

    // bottom right
    widgets.add(Positioned(
      top: top + height - ballDiameter / 2,
      left: left + width - ballDiameter / 2,
      child: ManipulatingBall(
        onDragEnd: _dragEnd,
        onDrag: (dx, dy) {
          var mid = (dx + dy) / 2;

          var newHeight = height + mid;
          var newWidth = width + mid;

          setState(() {
            height = newHeight > 0 ? newHeight : 0;
            width = newWidth > 0 ? newWidth : 0;
            // top = top - mid;
            // left = left - mid;
            updateSize();
          });
        },
      ),
    ));

    // bottom center
    if (!smallWidth)
      widgets.add(Positioned(
        top: top + height - ballDiameter / 2,
        left: left + width / 2 - ballDiameter / 2,
        child: ManipulatingBall(
          onDragEnd: _dragEnd,
          onDrag: (dx, dy) {
            var newHeight = height + dy;

            setState(() {
              height = newHeight > 0 ? newHeight : 0;
              updateSize();
            });
          },
        ),
      ));

    // bottom left
    widgets.add(Positioned(
      top: top + height - ballDiameter / 2,
      left: left - ballDiameter / 2,
      child: ManipulatingBall(
        onDragEnd: _dragEnd,
        onDrag: (dx, dy) {
          var mid = ((dx * -1) + dy) / 2;

          var newHeight = height + mid;
          var newWidth = width + mid;

          setState(() {
            height = newHeight > 0 ? newHeight : 0;
            width = newWidth > 0 ? newWidth : 0;
            // top = top - mid;
            left = left - mid;
            updateSize();
          });
        },
      ),
    ));

    //left center
    if (!smallHeight)
      widgets.add(Positioned(
        top: top + height / 2 - ballDiameter / 2,
        left: left - ballDiameter / 2,
        child: ManipulatingBall(
          onDragEnd: _dragEnd,
          onDrag: (dx, dy) {
            var newWidth = width - dx;

            setState(() {
              width = newWidth > 0 ? newWidth : 0;
              left = left + dx;
              updateSize();
            });
          },
        ),
      ));
  }

  updateSize() {
    templateSizeStateModel.setNewChildSize(NewChildSize(
            newTop: top, newLeft: left, newWidth: width, newHeight: height));
  }

  _dragEnd() {
    if (context.read<TemplateSizeStateModel>().wrongPosition) {
      setState(() {
        width = width0;
        height = height0;
        left = left0;
        top = top0;

      });
      context.read<TemplateSizeStateModel>().setWrongPosition(false);
      updateSize();
    } else {
      templateSizeStateModel.setUpdateChildSize(NewChildSize(
          newTop: top, newLeft: left, newWidth: width, newHeight: height));
    }
  }

  bool get smallWidth {
    return width < 50;
  }

  bool get smallHeight {
    return height < 50;
  }
}

class ManipulatingBall extends StatefulWidget {
  ManipulatingBall({Key key, this.onDrag, this.onDragEnd, this.isCenter = false, this.width = 30, this.height = 30});

  final Function onDrag;
  final Function onDragEnd;
  final bool isCenter;
  final double width;
  final double height;

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

  _handleEnd(details) {
    widget.onDragEnd();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onVerticalDragStart: _handleDrag,
      onVerticalDragUpdate: _handleUpdate,
      onHorizontalDragStart: _handleDrag,
      onHorizontalDragUpdate: _handleUpdate,
      behavior: HitTestBehavior.translucent,
      onVerticalDragEnd: _handleEnd,
      onHorizontalDragEnd: _handleEnd,
      child: widget.isCenter ? centerBody :body,
    );
  }

  get body {
    double deg = 45 * pi / 180;
    return Container(
      padding: EdgeInsets.all(9),
      width: ballDiameter,
      height: ballDiameter,
      child: Container(
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

  get centerBody {
    return Container(
      // color: Colors.blue,
      width: widget.width,
      height: widget.height,
    );
  }
}