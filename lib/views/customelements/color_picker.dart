import 'package:flutter/material.dart';

class ColorButtomContainer extends StatefulWidget {
  Color borderColor =  Color(0XFF0084ff);
  Color displayColor;
  double size;
  int index;
  ColorButtomController controller;
  ColorButtomContainer({@required this.size,@required this.displayColor,this.controller,this.index});
  @override
  _ColorButtomContainerState createState() => _ColorButtomContainerState();
}

class _ColorButtomContainerState extends State<ColorButtomContainer> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor:    Colors.transparent,
      highlightColor: Colors.transparent,
      child: PhysicalModel(
        shadowColor: widget.displayColor,
        color:widget.index == widget.controller.currentIndex.value? widget.borderColor:Colors.white,
        borderRadius: BorderRadius.circular(widget.size),
        child: Container(
          padding: EdgeInsets.all(1),
          child: PhysicalModel(
            borderRadius: BorderRadius.circular(widget.size),
            color: Colors.white,
            child: ColorCircle(color: widget.displayColor,size: widget.size)
          ),
        ),
      ),
      onTap: (){
        setState(() {
          widget.controller.currentIndex.value = widget.index;
        });
      },
    );
  }
}

class ColorCircle extends StatelessWidget {
  Color color;
  num   size;
  ColorCircle({@required this.color,@required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Container(
        height: size,
        width:  size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class ColorButtomGrid extends StatefulWidget {
  num size;
  int quantity;
  ColorButtomController controller;
  List<Color> colors = List();
  List<ColorButtomContainer> colorVariants = List();

  ColorButtomGrid({@required this.size,@required this.controller,@required this.colors});

  @override
  _ColorButtomGridState createState() => _ColorButtomGridState();
}

class _ColorButtomGridState extends State<ColorButtomGrid> {
  
  listener(){
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.currentIndex.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    widget.colorVariants.clear();
    int index = 0;
    widget.colors.forEach((color){
      widget.colorVariants.add(ColorButtomContainer(size: widget.size,controller: widget.controller,displayColor: color,index: index,));
      index++;
    });
    return Wrap(
      spacing:  widget.size / 4,
      alignment: WrapAlignment.center,
      children: widget.colorVariants,
    );
  }
}

class ColorButtomController{
  
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  int get selectedIndex => currentIndex.value;

}