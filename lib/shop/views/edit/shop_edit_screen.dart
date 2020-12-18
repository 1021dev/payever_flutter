import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/libraries/utils/px_dp.dart';
import 'package:payever/libraries/utils/px_dp_design.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/models/template_size_state_model.dart';
import 'package:payever/shop/views/edit/shop_edit_templetes_screen.dart';
import 'package:payever/shop/views/edit/style_vew/style_control_view.dart';
import 'package:payever/shop/views/edit/template_detail_screen.dart';
import 'package:payever/shop/views/edit/template_view.dart';
import 'package:provider/provider.dart';
import 'add_object_screen.dart';
import 'appbar/shop_edit_appbar.dart';

class ShopEditScreen extends StatefulWidget {
  final ShopScreenBloc shopScreenBloc;
  final GlobalStateModel globalStateModel;
  const ShopEditScreen(this.shopScreenBloc, this.globalStateModel);

  @override
  _ShopEditScreenState createState() => _ShopEditScreenState();
}

class _ShopEditScreenState extends State<ShopEditScreen> {
  bool slideOpened = true;
  bool isPortrait;
  bool isTablet;
  ShopEditScreenBloc screenBloc;
  TemplateSizeStateModel templateSizeStateModel = TemplateSizeStateModel();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool showStyleControlView = false;

  @override
  void initState() {
    screenBloc = ShopEditScreenBloc(widget.shopScreenBloc, widget.globalStateModel)
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
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
    PxDp.init(context);
    PxDp.load(PxDpDesign.fromCompare(540.0, 1080));
    return MultiProvider(
      providers: [
        Provider.value(value: templateSizeStateModel),
        ChangeNotifierProvider<TemplateSizeStateModel>(
            create: (_) => templateSizeStateModel),
      ],
      child: BlocListener(
        listener: (BuildContext context, ShopEditScreenState state) async {
          if (state.selectedChild == null) {
            showStyleControlView = false;
          }
        },
        condition: (ShopEditScreenState previousState, ShopEditScreenState state) {
          if (previousState.selectedChild?.id != state.selectedChild?.id) {
            showStyleControlView = false;
          }
          return true;
        },
        bloc: screenBloc,
        child: BlocBuilder(
          bloc: screenBloc,
          builder: (BuildContext context, ShopEditScreenState state) {
            return Scaffold(
              key: scaffoldKey,
              appBar: ShopEditAppbar(
                onTapAdd: ()=> _navigateAddObjectScreen(state),
                onTapStyle: () {
                  if (state.selectedChild == null) return;
                  setState(() {
                    showStyleControlView = true;
                  });
                },
              ),
              backgroundColor: Colors.grey[800],
              body: SafeArea(
                bottom: false,
                child: _body(state),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _body(ShopEditScreenState state) {
    double dragDx = 5;
    double dragStartX = isPortrait ? 120 : 120;
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      child: Stack(children: [
        GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.globalPosition.dx < dragStartX && details.delta.dx > dragDx) {
                setState(() {
                  slideOpened = true;
                });
              }
            },
            child: TemplateView(
              screenBloc: screenBloc,
              pageDetail: state.pageDetail,
              enableTapSection: true,
            )),
        AnimatedPositioned(
            left: slideOpened ? 0 : -(Measurements.width / 3.5),
            top: 0,
            bottom: 0,
            duration: Duration(milliseconds: 400),
            child: _slidBar(state)),
        AnimatedPositioned(
          left: 0,
          right: 0,
          duration: Duration(milliseconds: 400),
          bottom: showStyleControlView
              ? 0
              : -500,
          child: state.selectedChild == null
              ? Container()
              : StyleControlView(
            screenBloc: screenBloc,
            onClose: () {
              FocusScope.of(context).unfocus();
              setState(() {
                showStyleControlView = false;
              });
            },
          ),
        )
      ]),
    );
  }

  Widget _slidBar(ShopEditScreenState state) {
    List<ShopPage> pages = state.pages
        .where((page) => page.type == 'replica')
        .toList();
    bool activeMode = true;
    int length = pages.length ;
    double aspectRatio = activeMode ? 1 : 2/1;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx < -5) {
          setState(() {
            slideOpened = false;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey[800],
        width: Measurements.width / 3.5,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return AspectRatio(
                        aspectRatio: aspectRatio,
                        child: _templateItem(state, pages[index]));
                  },
                  separatorBuilder: (index, context) => Divider(color: Colors.transparent,),
                  itemCount: length),
            ),
            Container(
              width: double.infinity,
              child: Center(
                  child:
                  IconButton(
                      icon: Icon(Icons.add_box),
                      onPressed: () {
                        _navigateTemplatesScreen();
                      })),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _templateItem(ShopEditScreenState state, ShopPage page, {bool showName = true}) {

    String pageName = page == null ? 'Empty' : page.name;
    // print('Page Name: $pageName PageID:${page.id} Template Id: ${page.templateId}');

    return InkWell(
      onTap: () {
        screenBloc.add(GetPageEvent(pageId: page.id));
      },
      child: Container(
        color: state.pageDetail?.id == page.id ? Colors.blue : Colors.transparent,
        padding: EdgeInsets.all(4),
        child: Column(
          children: [
            Expanded(
                child: (page != null)
                    ? getPreview(state, page, showName)
                    : Container(
                  color: Colors.white,
                )),
            if (showName)
              SizedBox(
                height: 5,
              ),
            if (showName)
              Text(
                pageName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
          ],
        ),
      ),
    );
  }

  Widget getPreview(ShopEditScreenState state,
      ShopPage page, bool showName) {
    Widget templateItem;
    if (state.pageDetail?.templateId == page.templateId && state.pageDetail.data != null) {
      String preview = '';
      try{
        if (state.pageDetail.data is String) {
          preview = state.pageDetail.data;
        } else if (state.pageDetail.data is Map) {
          preview = state.pageDetail.data['preview'][GlobalUtils.deviceType];
        }
      }catch(e){}


      templateItem = CachedNetworkImage(
        imageUrl: preview,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
      );
    }
    else {
      templateItem = Container(
        color: Colors.white,
      );
    }
    return templateItem;
    return GestureDetector(
      onTap: () => _navigateTemplateDetailScreen(page),
      child: templateItem,
    );
  }

  _navigateTemplateDetailScreen(ShopPage page) {
     Navigator.push(
          context,
          PageTransition(
              child: TemplateDetailScreen(
                screenBloc: screenBloc,
                shopPage: page,
              ),
              type: PageTransitionType.fade));
  }

  void _navigateAddObjectScreen(ShopEditScreenState state) async {
    if(state.selectedSectionId.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select Section to add new object.');
      return;
    }
    final result = await Navigator.push(
        context,
        PageTransition(
            child: AddObjectScreen(screenBloc: screenBloc, templateSizeStateModel: templateSizeStateModel,),
            type: PageTransitionType.fade)
    );

    print('result: $result');
    if (result == null) return;
    templateSizeStateModel.setShopObject(result as ShopObject);
  }

  void _navigateTemplatesScreen() {
    Navigator.push(
        context,
        PageTransition(
            child: ShopEditTemplatesScreen(screenBloc),
            type: PageTransitionType.fade));
  }
}
