import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/connect/models/apikeys.dart';
import 'package:payever/connect/view_models/connect_state_model.dart';
import 'package:provider/provider.dart';

class ApiIntegration extends StatefulWidget {
  @override
  _ApiIntegrationState createState() => _ApiIntegrationState();
}

class _ApiIntegrationState extends State<ApiIntegration> {
  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      color: Colors.transparent,
      future: Provider.of<ConnectStateModel>(context).apiKeys(),
      onDataLoaded: (result) {
        List<Widget> _body = List();
        List<Widget> _headers = List();
        List<ApiKeys> _apiKey = List();

        result.forEach(
          (_key) {
            ApiKeys currentKey = ApiKeys.fromMap(_key);
            _apiKey.add(currentKey);
            _body.add(ApiKeyDetails(
              apiKeys: currentKey,
              deleteAction: () async {
                await Provider.of<ConnectStateModel>(context)
                    .deleteKey(currentKey.id);
                setState(() {});
              },
            ));
            _headers.add(Text(currentKey.name));
          },
        );
        _body.add(AddRow(
          actionAdd: (name) {
            Provider.of<ConnectStateModel>(context).addKey(name).then((_) {
              setState(() {});
            });
          },
        ));
        _headers.add(Text(Language.getConnectAppStrings("actions.add")));

        return SafeArea(
          child: ListView(
            children: <Widget>[
              CustomExpansionTile(
                widgetsBodyList: _body,
                widgetsTitleList: _headers,
                isWithCustomIcon: true,
                headerColor: Colors.transparent,
                scrollable: false,
              ),
            ],
          ),
        );
      },
    );
  }
}

class ApiKeyDetails extends StatefulWidget {
  final ApiKeys apiKeys;
  final Function deleteAction;
  const ApiKeyDetails({this.apiKeys, this.deleteAction});

  static const int titleFlex = 4;
  static const int contentFlex = 9;

  @override
  _ApiKeyDetailsState createState() => _ApiKeyDetailsState();
}

class _ApiKeyDetailsState extends State<ApiKeyDetails> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.parse(widget.apiKeys.createdAt);
    return Expanded(
      key: Key(widget.apiKeys.id),
      child: Column(
        children: <Widget>[
          _line(
              Language.getConnectAppStrings(
                  "categories.shopsystems.api_keys.default.titles.key_id"),
              widget.apiKeys.id),
          _line(
              Language.getConnectAppStrings(
                  "categories.shopsystems.api_keys.default.titles.key_secret"),
              widget.apiKeys.secret),
          _line(
              Language.getConnectAppStrings(
                  "categories.shopsystems.api_keys.default.titles.business_uuid"),
              widget.apiKeys.businessId),
          _line(
            Language.getConnectAppStrings(
                "categories.shopsystems.api_keys.default.titles.key_created"),
            "${DateFormat.d("en_US").add_M().add_y().format(time).replaceAll(" ", ".")} ${DateFormat.Hm("en_US").format(time.add(Duration(hours: 1)))}  ",
            click: false,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 17.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: _loading
                      ? CircularProgressIndicator()
                      : Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(
                            Language.getConnectAppStrings("actions.delete"),
                          ),
                        ),
                  onTap: () async {
                    if (!_loading) {
                      setState(() {
                        _loading = true;
                      });
                      await widget.deleteAction();
                      _loading = false;
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _line(String title, String value, {bool click = true}) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: ApiKeyDetails.titleFlex,
              child: Container(
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: ApiKeyDetails.contentFlex,
              child: Container(
                child: Text(
                  value,
                  style: TextStyle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
      onLongPress: () {
        if(click){
          Clipboard.setData(
            ClipboardData(
              text: value,
            ),
          );
          Scaffold.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              backgroundColor: Color(0xff262726),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Copied to Clipboard",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '"$value"',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }
}

class AddRow extends StatefulWidget {
  final Function(String) actionAdd;

  AddRow({this.actionAdd});
  TextEditingController _controller = TextEditingController(text: "");
  @override
  _AddRowState createState() => _AddRowState();
}

class _AddRowState extends State<AddRow> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: widget._controller,
                    onChanged: (text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: Language.getConnectAppStrings(
                        "shopsystem.add_key.name",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: widget._controller.text.isNotEmpty
                    ? Colors.white.withOpacity(0.25)
                    : Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              height: 59,
              child: Text(
                Language.getConnectAppStrings("actions.create"),
                style: TextStyle(
                    color: widget._controller.text.isNotEmpty
                        ? Colors.white
                        : Colors.white.withOpacity(0.5)),
              ),
            ),
            onTap: () {
              if (widget._controller.text.isNotEmpty)
                widget.actionAdd(widget._controller.text);
            },
          )
        ],
      ),
    );
  }
}
