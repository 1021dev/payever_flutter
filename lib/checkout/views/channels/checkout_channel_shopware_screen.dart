import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutChannelShopwareScreen extends StatefulWidget {

  final CheckoutScreenBloc checkoutScreenBloc;
  final String business;

  CheckoutChannelShopwareScreen({
    this.business,
    this.checkoutScreenBloc,
  });

  @override
  _CheckoutChannelShopwareScreenState createState() => _CheckoutChannelShopwareScreenState();
}

class _CheckoutChannelShopwareScreenState extends State<CheckoutChannelShopwareScreen> {
  bool _isPortrait;
  bool _isTablet;
  double iconSize;
  double margin;

  bool isAdd = false;
  bool isExpandedSection1 = false;
  bool isExpandedSection2 = false;

  TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    widget.checkoutScreenBloc.add(GetPluginsEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    return BlocListener(
      bloc: widget.checkoutScreenBloc,
      listener: (BuildContext context, CheckoutScreenState state) async {
        if (state is CheckoutScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
        bloc: widget.checkoutScreenBloc,
        builder: (BuildContext context, CheckoutScreenState state) {
          iconSize = _isTablet ? 120: 80;
          margin = _isTablet ? 24: 16;
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomPadding: false,
            appBar: _appBar(state),
            body: SafeArea(
              child: BackgroundBase(
                true,
                backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
                body: state.isLoading || state.shopware == null ?
                Center(
                  child: CircularProgressIndicator(),
                ): Center(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: _getBody(state),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(CheckoutScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Text(isAdd ? 'Create key' : 'Shopware',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            isAdd
                ? setState(() {
                    isAdd = false;
                  })
                : Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody(CheckoutScreenState state) {
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          child: SingleChildScrollView(
            child: isAdd ? _getAdd(state) : _getShopware(state),
          ),
        ),
      ),
    );
  }

  Widget _getShopware(CheckoutScreenState state) {
    return Container(
      child: Column(
        children: <Widget>[
          shopwareItem('Download', ()=>{
            setState(() {
              isExpandedSection1 = !isExpandedSection1;
              if (isExpandedSection1)
                isExpandedSection2 = false;
            })
          }),
          _divider(),
          _downloads(state),
          _divider(),
          shopwareItem('API keys', ()=>{
            setState(() {
              isExpandedSection2 = !isExpandedSection2;
              if (isExpandedSection2)
                isExpandedSection1 = false;
            })
          }),
          _divider(),
          _apikeys(state),
          _divider(),
          _add(),
        ],
      ),
    );
  }

  Widget _getAdd(CheckoutScreenState state) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            child: TextFormField(
              onChanged: (val) {

              },
              controller: controller,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Name required';
                } else {
                  return null;
                }
              },
              decoration: new InputDecoration(
                labelText: 'Name',
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                contentPadding: EdgeInsets.only(left: 16, right: 16),
              ),
              style: TextStyle(fontSize: 16),
              keyboardType: TextInputType.url,
            ),
          ),
          _divider(),
          Container(
            height: 50,
            color: Colors.grey,
            child: SizedBox.expand(
              child: MaterialButton(
                onPressed: (){

                },
                child: Text(
                  'Create',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget shopwareItem(String title, Function onTop) {
    return  GestureDetector(
      onTap: onTop,
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        height: 65,
        color: Colors.black54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              title == 'Download'
                  ? Icons.file_download
                  : Icons.lock,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Spacer(),
            Icon(
              isExpandedSection1
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            ),
          ],
        ),
      ),
    );
  }

  Widget _downloads(CheckoutScreenState state) {
    return isExpandedSection1 ?
        Container(
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Plugin plugin = index < state.shopware.pluginFiles.length ? state.shopware.pluginFiles[index] : null;
              return Container(
                height: 50,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: margin / 2),
                          ),
                          Flexible(
                            child: Text(plugin != null ?
                            'Plugin(${plugin.version})' : 'Instructions',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Helvetica Neue',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (plugin != null) {

                        } else {
                          _launchURL('https://getpayever.com/shopsystem/shopware');
                        }
                      },
                      color: Colors.black38,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      height: 24,
                      minWidth: 0,
                      padding:
                      EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        'Download',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'HelveticaNeueMed',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return _divider();
            },
            itemCount: state.shopware.pluginFiles.length + 1,
          ),
        ) :
        Container();

  }

  Widget _add(){
    return Container(
      height: 50,
      color: Colors.black54,
      child: SizedBox.expand(
        child: MaterialButton(
          onPressed: (){
            setState(() {
              isAdd = true;
            });
          },
          child: Row(
            children: <Widget>[
              Text(
                '+ Add',
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _apikeys(CheckoutScreenState state) {
    return isExpandedSection2 ? Container() : Container();
  }

  Widget _divider() {
    return Divider(
      height: 0,
      thickness: 0.5,
      color: Colors.white70,
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