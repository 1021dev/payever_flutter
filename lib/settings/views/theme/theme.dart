import 'package:flutter/material.dart';
import 'package:payever/checkout_process/checkout_process.dart';
import 'package:payever/commons/commons.dart';
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
              initialColor: globalStateModel.currentBusiness.primary),
          Divider(
            height: 0,
            thickness: 1,
          ),
          PickerTile(
              isPrimary: false,
              title: "Secondary color",
              initialColor: globalStateModel.currentBusiness.secondary),
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
  final int initialColor;
  const PickerTile({Key key, this.isPrimary, this.title, this.initialColor})
      : super(key: key);

  @override
  _PickerTileState createState() => _PickerTileState();
}

class _PickerTileState extends State<PickerTile> {
  Color _color;
  @override
  void initState() {
    super.initState();

    if (widget.initialColor != null) _color = Color(widget.initialColor);
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
              function: (a) => setState(() => _color = Color(a)),
              // function: (a) => setState(() => _color = a),
              title: widget.title),
        ),
        title: Text(widget.title),
      ),
      onTap: () => _showDialog(
        context: context,
        function: (a) => setState(() => _color = Color(a)),
        title: widget.title,
      ),
    );
  }

  _showDialog({
    BuildContext context,
    Function(int) function,
    int color,
    String title = "",
  }) {
    showDialog(
      context: context,
      builder: (context) {
        GlobalStateModel globalStateModel =
            Provider.of<GlobalStateModel>(context);
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
                  onChanged: (Color value) {
                    String color = Hex.colorToString(value);

                    var _color = Hex.stringToInt(
                        "${value.alpha.toRadixString(16)}$color");

                    /// ***
                    /// 
                    /// The theming is just for PoS customization
                    /// the color is separated into color hex and 
                    /// transparency hex so if needed the web front
                    /// end could be able to use them.
                    /// 
                    /// ***
                    
                    
                    if (widget.isPrimary) {
                      globalStateModel.currentBusiness.setPrimaryColor(color);
                      globalStateModel.currentBusiness
                          .setPrimaryTransparency(value.alpha.toRadixString(16));
                    } else {
                      globalStateModel.currentBusiness.setSecondaryColor(color);
                      globalStateModel.currentBusiness.setSecondaryTransparency(value.alpha.toRadixString(16));
                    }
                    Object data = {
                      "primaryColor":
                          "${globalStateModel.currentBusiness.primaryColor}",
                      "secondaryColor":
                          "${globalStateModel.currentBusiness.secondaryColor}",
                      "primaryTransparency":
                          "${globalStateModel.currentBusiness.primaryTransparency}",
                      "secondaryTransparency":
                          "${globalStateModel.currentBusiness.secondaryTransparency}",
                    };
                    RestDataSource().patchBusinessPOS(
                      GlobalUtils.activeToken.accessToken,
                      globalStateModel.currentBusiness.id,
                      data,
                    );
                    function(_color);
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
