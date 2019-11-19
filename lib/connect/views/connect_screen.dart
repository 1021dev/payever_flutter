import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/connect/models/integration.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../commons/commons.dart';
import '../../connect/view_models/connect_state_model.dart';
import '../../commons/view_models/view_models.dart';

class ConnectScreenInit extends StatelessWidget {
  final GlobalStateModel globalStateModel;

  const ConnectScreenInit({this.globalStateModel});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConnectStateModel>(
      builder: (BuildContext context) => ConnectStateModel(globalStateModel),
      child: BackgroundBase(
        true,
        appBar: CustomAppBar(
          onTap: () => Navigator.pop(context),
          title: Text("Connect"),
        ),
        body: ConnectScreen(),
      ),
    );
  }
}

class ConnectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      future: Provider.of<ConnectStateModel>(context).getIntegrations(),
      errorMessage: "Error loading apps.",
      onDataLoaded: (_) {
        return Scrollbar(
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Measurements.width < 600
                  ? 1
                  : (MediaQuery.of(context).orientation == Orientation.portrait
                      ? 2
                      : 3),
              childAspectRatio: 7 / 8,
            ),
            children: loadConnectCards(context),
          ),
        );
      },
    );
  }

  List<Widget> loadConnectCards(BuildContext context) {
    List<IntegrationItem> _items = List();
    Provider.of<ConnectStateModel>(context).integration.forEach((_integration) {
      if (_integration.integration.enabled)
        _items.add(IntegrationItem(
          integration: _integration,
        ));
    });
    return _items;
  }
}

class IntegrationItem extends StatelessWidget {
  final ConnectIntegration integration;

  const IntegrationItem({Key key, this.integration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            /// ***
            ///
            /// Implementation to be define web version still in process
            ///
            /// ***
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Title(
                  integration: integration,
                ),
              ),
              Expanded(
                flex: 20,
                child: PictureDescription(
                  integration: integration,
                ),
              ),
              Divider(
                color: Colors.white.withOpacity(0.4),
                height: 1,
              ),
              Expanded(
                flex: 4,
                child: IntegrationDetails(
                  integration: integration,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Title extends StatefulWidget {
  final ConnectIntegration integration;
  const Title({Key key, this.integration}) : super(key: key);
  @override
  _TitleState createState() => _TitleState();
}

class _TitleState extends State<Title> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 15),
            child: SvgPicture.asset(
              Provider.of<ConnectStateModel>(context)
                  .icon(widget.integration.integration.displayOptions.icon),
              alignment: Alignment.centerLeft,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Language.getConnectIntegrationsStrings(
                    widget.integration.integration.displayOptions.title,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  Language.getConnectIntegrationsStrings(
                        widget
                            .integration.integration.installationOptions.price,
                      ) ??
                      "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
                      child: _loading
                          ? Container(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              Language.getConnectAppStrings(
                                widget.integration.installed
                                    ? "actions.open"
                                    : "actions.install",
                              ),
                            ),
                    ),
                    onTap: () async {
                      if (_loading) return;
                      if (widget.integration.installed) {
                        openIntegration(
                            context, Provider.of<ConnectStateModel>(context));
                      } else {
                        setState(() {
                          _loading = true;
                        });
                        try {
                          var a = await Provider.of<ConnectStateModel>(context)
                              .installIntegration(
                                  widget.integration.integration.name);
                          print(a);
                          widget.integration.installed = a["installed"];
                        } catch (e) {
                          print(e);
                        }
                        setState(
                          () {
                            _loading = false;
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
              widget.integration.installed
                  ? Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            PopupMenuButton(
                              onSelected: (option) async {
                                if (option.contains("uninstall")) {
                                  setState(() {
                                    _loading = true;
                                  });
                                  try {
                                    var a =
                                        await Provider.of<ConnectStateModel>(
                                                context)
                                            .uninstallIntegration(widget
                                                .integration.integration.name);
                                    print(a);
                                    widget.integration.installed =
                                        a["installed"];
                                  } catch (e) {
                                    print(e);
                                  }
                                  setState(() {
                                    _loading = false;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 5,
                                ),
                                child: Icon(Icons.more_vert),
                              ),
                              elevation: 0,
                              color: Color(0xff272627),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuItem<String>>[
                                PopupMenuItem<String>(
                                  value: "uninstall",
                                  child: Container(
                                    child: Text(
                                      Language.getConnectStrings(
                                          "actions.uninstall"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // InkWell(
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       color: Colors.white.withOpacity(0.2),
                            //       borderRadius: BorderRadius.circular(30),
                            //     ),
                            //     padding: EdgeInsets.symmetric(
                            //       vertical: 7.5,
                            //       horizontal: 7.5,
                            //     ),
                            //     child: Icon(Icons.more_horiz),
                            //   ),
                            //   onTap: () {},
                            // ),
                          ],
                        ),
                      ],
                    )
                  : Container()
            ],
          ),
        ],
      ),
    );
  }

  openIntegration(context, ConnectStateModel _provider) {
    Navigator.push(
      context,
      PageTransition(
        child: ChangeNotifierProvider<ConnectStateModel>.value(
          value: _provider,
          child: IntegrationScreen(
            integration: widget.integration,
          ),
        ),
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 50),
      ),
    );
  }
}

class IntegrationScreen extends StatelessWidget {
  final ConnectIntegration integration;

  const IntegrationScreen({Key key, this.integration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundBase(
      true,
      appBar: CustomAppBar(
        onTap: () => Navigator.of(context).pop(),
        title: Text(
          Language.getConnectIntegrationsStrings(
            integration.integration.displayOptions.title,
          ),
        ),
      ),
      body: Provider.of<ConnectStateModel>(context)
          .integrationWidgets[integration.integration.name],
    );
  }
}

class PictureDescription extends StatelessWidget {
  final ConnectIntegration integration;
  const PictureDescription({Key key, this.integration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Container(
            child: Image.network(
              integration.integration.installationOptions.links[0].url,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.topLeft,
            child: Text(
              Language.getConnectIntegrationsStrings(
                    integration.integration.installationOptions.description,
                  ) ??
                  "",
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class IntegrationDetails extends StatelessWidget {
  final ConnectIntegration integration;

  const IntegrationDetails({Key key, this.integration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      Language.getConnectAppStrings(
                          "installation.labels.category"),
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    Language.getConnectAppStrings(
                            "categories.${integration.integration.category}.title") ??
                        "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      Language.getConnectAppStrings(
                          "installation.labels.developer"),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    Language.getConnectIntegrationsStrings(integration
                            .integration.installationOptions.developer) ??
                        "",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      Language.getConnectAppStrings(
                          "installation.labels.languages"),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      Language.getConnectIntegrationsStrings(integration
                              .integration.installationOptions.languages) ??
                          "",
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        Language.getConnectAppStrings(
                            "installation.labels.app_support"),
                        style: TextStyle(color: Colors.blue),
                        maxLines: 1,
                        minFontSize: 8,
                      ),
                    ),
                    onTap: () async {
                      _launchURL(Language.getConnectAppStrings(integration
                          .integration.installationOptions.appSupport));
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      // alignment: Alignment.center,
                      child: AutoSizeText(
                        Language.getConnectAppStrings(
                            "installation.labels.pricing"),
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                        maxLines: 1,
                        minFontSize: 8,
                      ),
                    ),
                    onTap: () async {
                      // launch(Language.getConnectAppStrings(integration.integration.installationOptions.pricingLink);
                      _launchURL(
                        Language.getConnectAppStrings(
                          integration
                              .integration.installationOptions.pricingLink,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
