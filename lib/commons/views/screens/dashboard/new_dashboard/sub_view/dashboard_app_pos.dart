import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';

class DashboardAppPosView extends StatefulWidget {
  final AppWidget appWidget;
  final List<Terminal> terminals;
  final Terminal activeTerminal;
  final bool isLoading;
  DashboardAppPosView({
    this.appWidget,
    this.terminals = const [],
    this.isLoading = true,
    this.activeTerminal,
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
      String firstCharacter = name.substring(0, 0).toUpperCase();
      String lastCharacter = name.substring(name.length - 1, name.length -1).toUpperCase();
      avatarName = '$firstCharacter$lastCharacter';
    }
    return BlurEffectView(
      padding: EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                onTap: () {

                },
                child: Container(
                  height: 20,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withAlpha(100)
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
                    CircleAvatar(
                      radius: 25,
                      child: Text(
                        avatarName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text(
                      widget.activeTerminal.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),

              ),
              // Edit Button
              Expanded(
                flex: 1,
                child: Container(
                  child: InkWell(
                    onTap: () {

                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.black26
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.mode_edit),
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
