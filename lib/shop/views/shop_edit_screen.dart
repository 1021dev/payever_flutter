import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/shop/models/models.dart';

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
              body: SafeArea(bottom: false, child: _body(state)));
        },
      ),
    );
  }

  Widget _body(ShopEditScreenState state) {
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Row(
      children: [
        if (slideOpened) Expanded(flex: 10, child: _slidBar(state)),
        VerticalDivider(),
        Expanded(flex: 23, child: _mainBody()),
      ],
    );
  }

  Widget _mainBody() {
    return Container();
  }

  Widget _slidBar(ShopEditScreenState state) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  ShopPage page = state.pages[index];
                  return AspectRatio(
                      aspectRatio: 2 / 1,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text('1'),
                            Expanded(
                                child: CachedNetworkImage(
                              imageUrl: '${page.data.preview}',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              color: Colors.white,
                              placeholder: (context, url) => Container(
                                color: Colors.white,
                                child: Center(
                                  child: Container(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: 0.8,
                                    child: SvgPicture.asset(
                                      'assets/images/no_image.svg',
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                          ],
                        ),
                      ));
                },
                separatorBuilder: (index, context) => Divider(),
                itemCount: state.pages.length),
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
