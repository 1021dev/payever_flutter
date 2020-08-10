import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';

class CheckoutLinkEditScreen extends StatefulWidget {

  final CheckoutScreenBloc screenBloc;
  final String type;

  CheckoutLinkEditScreen(
      {this.screenBloc, this.type});

  _CheckoutLinkEditScreenState createState() => _CheckoutLinkEditScreenState();

}

class _CheckoutLinkEditScreenState extends State<CheckoutLinkEditScreen> {

  TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: widget.screenBloc,
        listener: (BuildContext context, CheckoutScreenState state) async {
          if (state is CheckoutScreenStateFailure) {
          }
        },
      child: BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, CheckoutScreenState state) {
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomPadding: false,
            appBar: _appBar(state),
            body: SafeArea(
              child: BackgroundBase(
                true,
                backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
                body: state.isLoading ?
                Center(
                  child: CircularProgressIndicator(),
                ): Column(
                  children: <Widget>[
                    _getBody(state),
                  ],
                )
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
      title: Text(
        widget.type,
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
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody(CheckoutScreenState state) {
    switch (widget.type) {
      case 'Text Link':
        return _getTextLinkWidget(state);
      case 'Button':
        return _getTextLinkWidget(state);
      case 'Bubble':
        return _getTextLinkWidget(state);
      case 'Calculator':
        return _getTextLinkWidget(state);
    }
    return Container();
  }

  Widget _getTextLinkWidget(CheckoutScreenState state) {
    return Container(
      height: 64,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            Text(
              'Height',
            ),
            Expanded(
              child: TextField(
                controller: heightController,
                decoration: InputDecoration.collapsed(
                  hintText: '',
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}