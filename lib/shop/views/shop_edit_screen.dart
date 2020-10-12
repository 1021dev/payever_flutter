import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';

class ShopEditScreen extends StatefulWidget {
  final ShopScreenBloc shopScreenBloc;

  const ShopEditScreen(this.shopScreenBloc);

  @override
  _ShopEditScreenState createState() => _ShopEditScreenState();
}

class _ShopEditScreenState extends State<ShopEditScreen> {
  bool slideOpened = true;

  ShopEditScreenBloc screenBloc;

  @override
  void initState() {
    screenBloc = ShopEditScreenBloc(widget.shopScreenBloc)
      ..add(ShopEditScreenInitEvent());
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (BuildContext context, ShopEditScreenState state) async {},
      bloc: screenBloc,
      child: BlocBuilder(
        bloc: screenBloc,
        builder: (BuildContext context, state) {
          return Scaffold(
              appBar: CustomAppBar(''),
              backgroundColor: Colors.grey[800],
              body: SafeArea(bottom: false, child: _body()));
        },
      ),
    );
  }

  Widget _body() {
    return Row(
      children: [
        if (slideOpened) Expanded(flex: 10, child: _slidBar()),
        VerticalDivider(),
        Expanded(flex: 23, child: _mainBody()),
      ],
    );
  }

  Widget _mainBody() {
    return Container();
  }

  Widget _slidBar() {
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
                itemBuilder: (index, context) {
                  return AspectRatio(
                      aspectRatio: 2 / 1,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ));
                },
                separatorBuilder: (index, context) => Divider(),
                itemCount: 3),
          ),
          IconButton(icon: Icon(Icons.add_box), onPressed: null),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Function onClose;

  CustomAppBar(this.title, {this.onClose});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            InkWell(
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onTap: null,
            ),
            InkWell(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              onTap: null,
            ),
            InkWell(
              child: Icon(
                Icons.brush,
                color: Colors.white,
              ),
              onTap: null,
            ),
            InkWell(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onTap: null,
            ),
            InkWell(
                child: Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
                onTap: null),
            InkWell(
              child: Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
              onTap: null,
            ),
            InkWell(
              child: Icon(
                Icons.remove_red_eye,
                color: Colors.white,
              ),
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }
}
