import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/commons/utils/draggable_widget.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/template_view.dart';
import 'element/sub_element/resizeable_widget.dart';
import 'package:payever/blocs/bloc.dart';


class TemplateDetailScreen extends StatefulWidget {
  final ShopPage shopPage;
  final Template template;
  final Map<String, dynamic> stylesheets;
  final ShopEditScreenBloc screenBloc;

  const TemplateDetailScreen(
      {this.shopPage, this.template, this.stylesheets, this.screenBloc});

  @override
  _TemplateDetailScreenState createState() => _TemplateDetailScreenState(
      shopPage: shopPage,
      template: template,
      stylesheets: stylesheets,
      screenBloc: screenBloc);
}

class _TemplateDetailScreenState extends State<TemplateDetailScreen> {
  final ShopPage shopPage;
  final Template template;
  final Map<String, dynamic> stylesheets;
  final ShopEditScreenBloc screenBloc;

  DragController dragController = DragController();
  int count = 0;

  _TemplateDetailScreenState(
      {this.shopPage, this.template, this.stylesheets, this.screenBloc});

  StreamController<double> controller = StreamController.broadcast();
  double position;
  @override
  void initState() {
    screenBloc.add(ActiveShopPageEvent(activeShopPage: widget.shopPage));
    super.initState();
  }

  @override
  void dispose() {
    // screenBloc.add(ActiveShopPageEvent(activeShopPage: null));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (BuildContext context, ShopEditScreenState state) async {},
      bloc: screenBloc,
      child: BlocBuilder(
        bloc: screenBloc,
        builder: (BuildContext context, state) {
          return Scaffold(
              appBar: Appbar('Templates'),
              backgroundColor: Colors.grey[800],
              body: SafeArea(
                  bottom: false,
                  child: TemplateView(
                    screenBloc: screenBloc,
                    shopPage: shopPage,
                    template: template,
                    enableTapSection: true,
                    stylesheets: stylesheets,
                  )));
        },
      ),
    );
  }

  get resizeableDemo {
    return Container(
      child: ResizeableWidget(
        child: Container(
          color: Colors.red,
          width: 500,
          height: 200,
        ),
      ),
    );
  }

  get _dragSize {
    return StreamBuilder(
      stream: controller.stream,
      builder: (context, snapshot) => Container(
        alignment: Alignment.bottomCenter,
        color: Colors.red,
        height: snapshot.hasData ? snapshot.data : 200.0,
        width: double.infinity,
        child: GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails details) {
              position = /*MediaQuery.of(context).size.height -*/
                  details.globalPosition.dy;
              print('position dy = ${position}');
              position.isNegative
                  ? Navigator.pop(context)
                  : controller.add(position);
            },
            behavior: HitTestBehavior.translucent,
            child: Text('Child')),
      ),
    );
  }

  get _draggable {
    return Container(
      color: Colors.white,
      child: Stack(children: [
        // other widgets...
        DraggableWidget(
          bottomMargin: 80,
          topMargin: 80,
          intialVisibility: true,
          horizontalSapce: 20,
          shadowBorderRadius: 50,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
          ),
          initialPosition: AnchoringPosition.topLeft,
          dragController: dragController,
        )
      ]),
    );
  }

  get _body {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Draggable(
              child: buildBox("+1", Colors.red[200]),
              feedback: buildBox("+1", Colors.red[200]),
              childWhenDragging: buildBox("+1", Colors.grey[300]),
              data: 1,
              onDragStarted: () {
                print("onDragStarted");
              },
              onDragCompleted: () {
                print("onDragCompleted");
              },
              onDragEnd: (details) {
                print("onDragEnd Accept = " + details.wasAccepted.toString());
                print("onDragEnd Velocity = " +
                    details.velocity.pixelsPerSecond.distance.toString());
                print("onDragEnd Offeset= " +
                    details.offset.direction.toString());
              },
              onDraggableCanceled: (Velocity velocity, Offset offset) {
                print("onDraggableCanceled " + velocity.toString());
              },
            ),
            Draggable(
              child: buildBox("-1", Colors.blue[200]),
              feedback: buildBox("-1", Colors.blue[200]),
              childWhenDragging: buildBox("-1", Colors.blue[300]),
              data: -1,
            )
          ]),
          DragTarget(
            builder: (BuildContext context, List<int> candidateData,
                List<dynamic> rejectedData) {
              print("candidateData = " +
                  candidateData.toString() +
                  " , rejectedData = " +
                  rejectedData.toString());
              return buildBox("$count", Colors.green[200]);
            },
            onWillAccept: (data) {
              print("onWillAccept");
              return data == 1 || data == -1; // accept when data = 1 only.
            },
            onAccept: (data) {
              print("onAccept");
              count += data;
            },
            onLeave: (data) {
              print("onLeave");
            },
          )
        ],
      ),
    );
  }

  Container buildBox(String title, Color color) {
    return Container(
        width: 100,
        height: 100,
        color: color,
        child: Center(
            child: Text(title,
                style: TextStyle(fontSize: 18, color: Colors.black))));
  }
}
