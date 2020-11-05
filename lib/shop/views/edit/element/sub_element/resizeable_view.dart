import 'dart:math';
import 'package:flutter/material.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/models/template_size_state_model.dart';
import 'package:provider/provider.dart';

class ResizeableView extends StatefulWidget {
  ResizeableView(
      {this.child,
      this.height,
      this.width,
      this.top,
      this.left,
        this.isBlockParent = false,
      this.isSelected = false,
      this.sizeChangeable = true});

  final Widget child;
  final double height;
  final double width;
  final double top;
  final double left;
  final bool isSelected;
  final bool sizeChangeable;
  final bool isBlockParent;

  @override
  _ResizeableViewState createState() =>
      _ResizeableViewState(width: width, height: height, top: top, left: left);
}

const ballDiameter = 30.0;
const wrongEdgeWidth = 2.0;
const limitSize = 25.0;

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

  _ResizeableViewState({this.width, this.height, this.top, this.left}) {
    if (width == double.infinity) {
      width = Measurements.width;
    }
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
    templateSizeStateModel =
        Provider.of<TemplateSizeStateModel>(context, listen: true);
    return body;
  }

  Widget get body {
    List<Widget> widgets = [];
    widgets.add(
      Positioned(
        top: top,
        left: left,
        child: Container(
          height: height,
          width: width,
          child: widget.child,
        ),
      ),
    );
    addWrongPositionEdges(widgets);
    addDragBalls(widgets);
    return Stack(children: widgets);
  }

  addWrongPositionEdges(List<Widget> widgets) {
    if (!widget.isSelected) return;
    var isWrongPosition = templateSizeStateModel.wrongPosition;
    Color edgeColor = isWrongPosition ? Colors.red : Colors.blue;
    // top
    widgets.add(
      Positioned(
        top: top,
        left: left,
        child: Container(
          width: width,
          height: wrongEdgeWidth,
          color: edgeColor,
        ),
      ),
    );

    // left
    widgets.add(
      Positioned(
        top: top,
        left: left,
        child: Container(
          width: wrongEdgeWidth,
          height: height,
          color: edgeColor,
        ),
      ),
    );
    // bottom
    widgets.add(
      Positioned(
        top: top + height - wrongEdgeWidth,
        left: left,
        child: Container(
          width: width,
          height: wrongEdgeWidth,
          color: edgeColor,
        ),
      ),
    );
    // right
    widgets.add(
      Positioned(
        top: top,
        left: left + width - wrongEdgeWidth,
        child: Container(
          width: wrongEdgeWidth,
          height: height,
          color: edgeColor,
        ),
      ),
    );
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
    if (!widget.sizeChangeable) return;
    //left center
    widgets.add(Positioned(
      top: top + height / 2 - ballDiameter / 2,
      left: left - ballDiameter / 2,
      child: ManipulatingBall(
        disable: smallHeight,
        onDragEnd: _dragEnd,
        onDrag: (dx, dy) {
          var newWidth = width - dx;
          setState(() {
            width = newWidth > limitSize ? newWidth : limitSize;
            left = left + (newWidth > limitSize ? dx : 0);
            updateSize();
          });
        },
      ),
    ));
    // top middle
    widgets.add(Positioned(
      top: top - ballDiameter / 2,
      left: left + width / 2 - ballDiameter / 2,
      child: ManipulatingBall(
        disable: smallWidth,
        onDragEnd: _dragEnd,
        onDrag: (dx, dy) {
          var newHeight = height - dy;

          setState(() {
            height = newHeight > limitSize ? newHeight : limitSize;
            top = top + (newHeight > limitSize ? dy : 0);
            updateSize();
          });
        },
      ),
    ));
    // center right
    widgets.add(Positioned(
      top: top + height / 2 - ballDiameter / 2,
      left: left + width - ballDiameter / 2,
      child: ManipulatingBall(
        disable: smallHeight,
        onDragEnd: _dragEnd,
        onDrag: (dx, dy) {
          var newWidth = width + dx;
          setState(() {
            width = newWidth > limitSize ? newWidth : limitSize;
            updateSize();
          });
        },
      ),
    ));
    // bottom center
    widgets.add(Positioned(
      top: top + height - ballDiameter / 2,
      left: left + width / 2 - ballDiameter / 2,
      child: ManipulatingBall(
        disable: smallWidth,
        onDragEnd: _dragEnd,
        onDrag: (dx, dy) {
          var newHeight = height + dy;

          setState(() {
            height = newHeight > limitSize ? newHeight : limitSize;
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
          var newHeight = height - dy;
          var newWidth = width - dx;
          setState(() {
            height = newHeight > limitSize ? newHeight : limitSize;
            width = newWidth > limitSize ? newWidth : limitSize;
            top = top + (newHeight > limitSize ? dy: 0);
            left = left + (newWidth > limitSize ? dx : 0);
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
          var newHeight = height - dy;
          var newWidth = width + dx;

          setState(() {
            height = newHeight > limitSize ? newHeight : limitSize;
            width = newWidth > limitSize ? newWidth : limitSize;
            top = top + (newHeight > limitSize ? dy : 0);
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
          var newHeight = height + dy;
          var newWidth = width + dx;

          setState(() {
            height = newHeight > limitSize ? newHeight : limitSize;
            width = newWidth > limitSize ? newWidth : limitSize;
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
          var newHeight = height + dy;
          var newWidth = width - dx;

          setState(() {
            height = newHeight > limitSize ? newHeight : limitSize;
            width = newWidth > limitSize ? newWidth : limitSize;
            left = left + (newWidth > limitSize ? dx : 0);
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
    // print('Wrong position: ${templateSizeStateModel.wrongPosition}');
    if (templateSizeStateModel.wrongPosition) {
      setState(() {
        width = width0;
        height = height0;
        left = left0;
        top = top0;
      });
      templateSizeStateModel.setWrongPosition(false);
      updateSize();
      Future.delayed(Duration(milliseconds: 100)).then((value) {
        templateSizeStateModel.setUpdateChildSizeFailed(true);
      });
    } else {
      width0 = width;
      height0 = height;
      left0 = left;
      top0 = top;
      templateSizeStateModel.setUpdateChildSize(NewChildSize(
          newTop: top, newLeft: left, newWidth: width, newHeight: height));
    }
  }

  bool get smallWidth {
    return width <= limitSize;
  }

  bool get smallHeight {
    return height <= limitSize;
  }
}

class ManipulatingBall extends StatefulWidget {
  ManipulatingBall(
      {Key key,
      this.onDrag,
      this.onDragEnd,
      this.isCenter = false,
      this.width = 30,
      this.height = 30,
      this.disable = false});

  final Function onDrag;
  final Function onDragEnd;
  final bool isCenter;
  final double width;
  final double height;
  final bool disable;

  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  double initX;
  double initY;

  _handleDrag(details) {
    if (widget.disable) return;
    // if (widget.height < limitSize) return;
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    if (widget.disable) return;
    // if (widget.height < limitSize) return;
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  _handleEnd(details) {
    if (widget.disable) return;
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
      child: widget.isCenter ? centerBody : body,
    );
  }

  get body {
    double deg = 45 * pi / 180;
    return Container(
      padding: EdgeInsets.all(9),
      width: ballDiameter,
      height: ballDiameter,
      child: Container(
        decoration: widget.disable
            ? null
            : BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                color: Colors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 1.5,
                    blurRadius: 1.5,
                    offset: Offset(deg, deg), // changes position of shadow
                  )
                ],
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
