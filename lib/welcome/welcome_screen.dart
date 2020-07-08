import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/welcome/welcome_bloc.dart';
import 'package:payever/blocs/welcome/welcome_event.dart';
import 'package:payever/blocs/welcome/welcome_state.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/transactions/views/transactions_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

bool _isPortrait;
bool _isTablet;

class WelcomeScreen extends StatefulWidget {
  final BusinessApps businessApps;
  final Business business;

  WelcomeScreen({this.business, this.businessApps,});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();

}

class _WelcomeScreenState extends State<WelcomeScreen> {

  WelcomeScreenBloc screenBloc = WelcomeScreenBloc();
  @override
  void initState() {
    screenBloc.add(WelcomeScreenInitEvent(businessId: widget.business.id, uuid: widget.businessApps.microUuid,));
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
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
      bloc: screenBloc,
      listener: (BuildContext context, WelcomeScreenState state) async {
        if (state is WelcomeScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is WelcomeScreenStateSuccess) {
          GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context, listen: false);
          globalStateModel.setRefresh(true);
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: TransactionScreenInit(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<WelcomeScreenBloc, WelcomeScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, WelcomeScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(WelcomeScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: BackgroundBase(
        true,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('${Env.cdnIcon}icon-comerceos-${widget.businessApps.code}-not-installed.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Text(
                        Language.getWelcomeStrings('welcome.${widget.businessApps.code}.title'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Text(
                        Language.getWelcomeStrings('welcome.${widget.businessApps.code}.message'),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Container(
                        width: Measurements.width * 0.7,
                        child: MaterialButton(
                          onPressed: () {
                            screenBloc.add(ToggleEvent(businessId: widget.business.id, type: widget.businessApps.code,));
                          },
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: state.isLoading ? SizedBox(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              strokeWidth: 2,
                            ),
                            height: 24.0,
                            width: 24.0,
                          ) : Text(
                            Language.getWelcomeStrings('welcome.get-started'),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Container(
                        width: Measurements.width * 0.6,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: new TextSpan(
                            children: [
                              new TextSpan(
                                text: 'Hereby I confirm the ',
                                style: new TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              new TextSpan(
                                text: 'terms',
                                style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () { launch(Language.getWelcomeStrings('welcome.${widget.businessApps.code}.terms_link'));
                                  },
                              ),
                              new TextSpan(
                                text: ' and ',
                                style: new TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              new TextSpan(
                                text: 'pricing',
                                style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () { launch(Language.getWelcomeStrings('welcome.${widget.businessApps.code}.pricing_link'));
                                  },
                              ),
                              new TextSpan(
                                text: ' of the payever ',
                                style: new TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              new TextSpan(
                                text: Language.getCommerceOSStrings(widget.businessApps.dashboardInfo.title),
                                style: new TextStyle(color: Colors.white,),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}