import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/connect/models/integration.dart';
import 'package:payever/connect/view_models/connect_state_model.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:provider/provider.dart';
import '../../commons/views/views.dart';
import 'connect_screen.dart';

class ConnectCard extends StatelessWidget {
  final String _appName;
  final ImageProvider _imageProvider;
  final String _help;

  ConnectCard(this._appName, this._imageProvider, this._help);
  @override
  Widget build(BuildContext context) {
    GlobalStateModel global = Provider.of<GlobalStateModel>(context);
    return DashboardCardRef(
      _appName,
      _imageProvider,
      ChangeNotifierProvider<ConnectStateModel>(
        builder: (BuildContext context) => ConnectStateModel(global),
        child: ConnectCardRow(),
      ),
    );
  }
}

class ConnectCardRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      color: Colors.transparent,
      future: Provider.of<ConnectStateModel>(context).getRandomIntegrations(),
      onDataLoaded: (result) {
        List<Widget> _integrations = List();
        result.forEach((_int) {
          _integrations.add(
            ConnectCardItem(
              integration: ConnectIntegration.fromMap(_int),
            ),
          );
        });
        if (_integrations.length > 4) {
          _integrations = _integrations.sublist(0, 4);
        }
        return Row(
          children: _integrations,
        );
      },
    );
  }
}

class ConnectCardItem extends StatefulWidget {
  final ConnectIntegration integration;

  const ConnectCardItem({this.integration});
  @override
  _ConnectCardItemState createState() => _ConnectCardItemState();
}

class _ConnectCardItemState extends State<ConnectCardItem> {
  @override
  Widget build(BuildContext context) {
    Color _color = widget.integration.installed
        ? Colors.white
        : Colors.white.withOpacity(0.6);
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: InkWell(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    Provider.of<ConnectStateModel>(context).icon(
                        widget.integration.integration.displayOptions.icon),
                    alignment: Alignment.centerLeft,
                    // color: _color,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.file_download,
                          size: 12,
                          color: _color,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          Language.getConnectIntegrationsStrings(
                                widget.integration.integration.displayOptions
                                    .title,
                              ) ??
                              "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 11,
                            color: _color,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onTap: () async {
            Navigator.push(
              context,
              PageTransition(
                child: ConnectScreenInit(
                  globalStateModel: Provider.of<GlobalStateModel>(context),
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 50),
              ),
            );
          },
        ),
      ),
    );
  }
}
