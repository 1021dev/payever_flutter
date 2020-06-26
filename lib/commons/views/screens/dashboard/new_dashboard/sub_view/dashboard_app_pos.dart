import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';

class DashboardAppPosView extends StatefulWidget {
  final AppWidget appWidget;
  final List<Terminal> terminals;
  final Terminal activeTerminal;
  final bool isLoading;
  final Function onTapOpen;
  final Function onTapEditTerminal;
  DashboardAppPosView({
    this.appWidget,
    this.terminals = const [],
    this.isLoading,
    this.activeTerminal,
    this.onTapEditTerminal,
    this.onTapOpen,
  });
  @override
  _DashboardAppPosViewState createState() => _DashboardAppPosViewState();
}

class _DashboardAppPosViewState extends State<DashboardAppPosView> {
  String uiKit = 'https://payeverstage.azureedge.net/icons-png/icons-apps-white/icon-apps-white-';
  String icon = 'https://payeverstage.azureedge.net/icons-png/icons-apps-white/icon-apps-white-point-of-sale.png';

  @override
  Widget build(BuildContext context) {
    List<Terminal> terminals = widget.terminals;
    String avatarName = '';
    if (widget.activeTerminal != null) {
      String name = widget.activeTerminal.name;
      if (name.contains(" ")) {
        avatarName = name.substring(0, 1);
        avatarName = avatarName + name.split(" ")[1].substring(0, 1);
      } else {
        avatarName = name.substring(0, 1) + name.substring(name.length - 1);
        avatarName = avatarName.toUpperCase();
      }
    }
    return BlurEffectView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage('${uiKit}point-of-sale.png'),
                            fit: BoxFit.fitWidth)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  Text(
                    'POINT OF SALE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              InkWell(
                onTap: widget.onTapOpen,
                child: Container(
                  height: 20,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.4)
                  ),
                  child: Center(
                    child: Text("Open",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
          ),
          widget.isLoading ? Container(
            height: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ):
          Row(
            children: <Widget>[
              // Terminal View
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    widget.activeTerminal.logo != null ?
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(widget.activeTerminal.logo),
                          fit: BoxFit.cover,
                        )
                      ),
                    ):
                        Container(
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.blueGrey.withOpacity(0.5),
                            child: Text(
                              avatarName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                    ),
                    AutoSizeText(
                      widget.activeTerminal.name,
                      minFontSize: 16,
                      maxFontSize: 24,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),

              ),
              Padding(
                padding: EdgeInsets.only(left: 12),
              ),
              // Edit Button
              Expanded(
                flex: 1,
                child: Material(
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.white.withOpacity(0.1),
                  child: MaterialButton(
                    onPressed: widget.onTapEditTerminal,
                    child: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text(
                            "Edit",
                            softWrap: true,
                            style: TextStyle(
                                color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
