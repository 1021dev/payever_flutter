import 'package:flutter/material.dart';
import 'package:payever/checkout_process/checkout_process.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:provider/provider.dart';

class ThemeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);
    return BackgroundBase(
      true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Theme"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          PickerTile(
              isPrimary: true,
              title: "Primary color",
              initialColor: globalStateModel.currentBusiness.primaryColor),
          Divider(
            height: 0,
            thickness: 1,
          ),
          PickerTile(
              isPrimary: false,
              title: "Secondary color",
              initialColor: globalStateModel.currentBusiness.primaryColor),
          Divider(
            height: 0,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

class PickerTile extends StatefulWidget {
  final bool isPrimary;
  final String title;
  final String initialColor;
  const PickerTile({Key key, this.isPrimary, this.title, this.initialColor})
      : super(key: key);

  @override
  _PickerTileState createState() => _PickerTileState();
}

class _PickerTileState extends State<PickerTile> {
  Color _color;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.initialColor != null)
      _color = Color(Hex.stringToInt(widget.initialColor));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        trailing: IconButton(
          icon: Container(
            decoration: BoxDecoration(
              color: _color ?? (widget.isPrimary ? Colors.white : Colors.black),
              shape: BoxShape.circle,
            ),
          ),
          onPressed: () => _showDialog(
              context: context,
              function: (a) => setState(() => _color = a),
              title: widget.title),
        ),
        title: Text(widget.title),
      ),
      onTap: () => _showDialog(
        context: context,
        function: (a) => setState(() => _color = a),
        title: widget.title,
      ),
    );
  }

  _showDialog({
    BuildContext context,
    Function(Color) function,
    int color,
    String title = "",
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(title),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SwatchesPicker(
                  // color: Color(0xff000000),
                  onChanged: (Color value) {
                    function(value);
                    String color = Hex.colorToString(value);
                    print(color);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
