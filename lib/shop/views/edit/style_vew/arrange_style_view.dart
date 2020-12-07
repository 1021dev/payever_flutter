import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ArrangeStyleView extends StatefulWidget {
  @override
  _ArrangeStyleViewState createState() => _ArrangeStyleViewState();
}

class _ArrangeStyleViewState extends State<ArrangeStyleView> {
  @override
  Widget build(BuildContext context) {
    return _arrangeBody;
  }

  // region Arrange Body
  Widget get _arrangeBody {
    return Container(
        margin: EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _moveToBackFront,
              _constrainProportion,
              _flipView,
              _lock,
            ],
          ),
        ));
  }

  get _moveToBackFront {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MOVE TO BACK/FRONT',
            style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              children: [
                SvgPicture.asset('assets/images/send-to-back.svg'),
                Expanded(
                  child: Slider(
                    value: 0,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    // label: opacityValue.toString(),
                    onChanged: (double value) {
                      setState(() {
                        // opacityValue = value;
                      });
                    },
                  ),
                ),
                SvgPicture.asset('assets/images/send-to-top.svg'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  get _constrainProportion {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            'Constrain Proportions',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Spacer(),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              value: false,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  get _flipView {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          decoration: BoxDecoration(
              color: Color.fromRGBO(51, 48, 53, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          child: Row(
            children: [
              Text(
                'Flip Horizontally',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Spacer(),
              SvgPicture.asset('assets/images/flip-horizontal.svg'),
            ],
          ),
        ),
        SizedBox(
          height: 1,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          decoration: BoxDecoration(
              color: Color.fromRGBO(51, 48, 53, 1),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8))),
          child: Row(
            children: [
              Text(
                'Flip Vertically',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Spacer(),
              SvgPicture.asset('assets/images/flip-vertical.svg')
            ],
          ),
        ),
      ],
    );
  }

  get _lock {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 16,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      height: 50,
      decoration: BoxDecoration(
          color: Color.fromRGBO(51, 48, 53, 1),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        children: [
          Text(
            'Lock',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Spacer(),
          Icon(Icons.lock_outlined),
        ],
      ),
    );
  }
// endregion
}
