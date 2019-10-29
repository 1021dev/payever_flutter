import 'package:flutter/material.dart';

class ColorButtonContainer extends StatefulWidget {
  final Color borderColor = Color(0XFF0084ff);
  final Color displayColor;
  final double size;
  final int index;
  final ColorButtonController controller;

  ColorButtonContainer(
      {@required this.size,
      @required this.displayColor,
      this.controller,
      this.index});

  @override
  createState() => _ColorButtonContainerState();
}

class _ColorButtonContainerState extends State<ColorButtonContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: PhysicalModel(
        shadowColor: widget.displayColor,
        color: widget.controller != null
            ? widget.index == widget.controller.currentIndex.value
                ? widget.borderColor
                : Colors.white
            : Colors.white,
        borderRadius: BorderRadius.circular(widget.size),
        child: Container(
          padding: EdgeInsets.all(1),
          child: PhysicalModel(
            borderRadius: BorderRadius.circular(widget.size),
            color: Colors.white,
            child: ColorCircle(
              color: widget.displayColor,
              size: widget.size,
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          if (widget.controller != null)
            widget.controller.currentIndex.value = widget.index;
        });
      },
    );
  }
}

class ColorCircle extends StatelessWidget {
  final Color color;
  final num size;

  ColorCircle({@required this.color, @required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Stack(
        children: <Widget>[
          Container(
            height: size + 2,
            width: size + 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          Container(
            height: size + 2,
            width: size + 2,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.black12,
                  ],
                )),
            padding: EdgeInsets.only(top: 2),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
                Container(
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[Colors.white12, Colors.transparent],
                    ),
                  ),
                ),
                Container(
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[Colors.white24, Colors.transparent],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ColorButtonGrid extends StatefulWidget {
  final num size;
  final ColorButtonController controller;
  final List<Color> colors;

  ColorButtonGrid(
      {@required this.size, this.controller, @required this.colors});

  @override
  createState() => _ColorButtonGridState();
}

class _ColorButtonGridState extends State<ColorButtonGrid> {
  int quantity;
  List<ColorButtonContainer> colorVariants = List();

  listener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller != null)
      widget.controller.currentIndex.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    colorVariants.clear();
    int index = 0;
    widget.colors.forEach((color) {
      colorVariants.add(ColorButtonContainer(
        size: widget.size,
        controller: widget.controller,
        displayColor: color,
        index: index,
      ));
      index++;
    });
    return Wrap(
      spacing: widget.size / 4,
      alignment: WrapAlignment.center,
      children: colorVariants,
    );
  }
}

class ColorButtonController {
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  int get selectedIndex => currentIndex.value;
}
