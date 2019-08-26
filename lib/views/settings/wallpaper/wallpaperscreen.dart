import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/models/wallpaper.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/appStyle.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/view_models/dashboard_state_model.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/views/customelements/custom_app_bar.dart';
import 'package:payever/views/customelements/custom_expansion_tile.dart';
import 'package:payever/views/customelements/custom_future_builder.dart';
import 'package:payever/views/customelements/wallpaper.dart';
import 'package:provider/provider.dart';

class WallpaperScreen extends StatefulWidget {
  @override
  _WallpaperScreenState createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  @override
  Widget build(BuildContext context) {
    return BackgroundBase(true,
      appBar: CustomAppBar(onTap: ()=> Navigator.of(context).pop(),title: Text("Wallpaper",style:TextStyle(fontSize: AppStyle.fontSizeAppBar()),),),
      body:CustomFutureBuilder(
        future: Provider.of<DashboardStateModel>(context).getWallpaper(),
        errorMessage: "",
        onDataLoaded: (List<WallpaperCategory> result) {
          List<Widget> bodies = List();
          List<Widget> heads  = List();
          for(WallpaperCategory cat in result){
            heads.add(Text(Language.getSettingsStrings("assets.product.${cat.code}"),style: TextStyle(fontSize: AppStyle.fontSizeTabTitle()),overflow: TextOverflow.ellipsis,));
            bodies.add(WallpaperRow(cat.industries));
          }
          return CustomExpansionTile(
            isWithCustomIcon: true,
            scrollable: true,
            headerColor: Colors.transparent,
            widgetsBodyList: bodies,
            widgetsTitleList: heads
          );
        },
      ),
    );
  }
}

class WallpaperRow extends StatefulWidget {
  List<WallpaperIndustry> industries = List();
  WallpaperRow(this.industries);
  @override
  _WallpaperRowState createState() => _WallpaperRowState();
}

class _WallpaperRowState extends State<WallpaperRow> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.industries.length,
        itemBuilder: (BuildContext context, int index) {
          List<WallpaperItem> items = List();
          widget.industries[index].wallapapers.forEach((_w){
            items.add(WallpaperItem(_w));
          });
          return Container(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(Language.getSettingsStrings("assets.industry.${widget.industries[index].code}"),style: TextStyle(fontSize: AppStyle.fontSizeTabTitle())),
                      ],
                    ),
                  ),
                  Container(
                    
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Wrap(alignment: WrapAlignment.start,
                            // direction: Axis.horizontal,
                            // runAlignment:WrapAlignment.spaceBetween,
                            //  crossAxisAlignment: WrapCrossAlignment.start,
                            children: items,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class WallpaperItem extends StatelessWidget {
  String id;
  WallpaperItem(this.id);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        child: Container(
          height: 81,
          width: 144,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(Env.Storage + "/wallpapers/$id"),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onTap: (){
          GlobalStateModel global = Provider.of<GlobalStateModel>(context);
          RestDatasource().postWallpaper(GlobalUtils.ActiveToken.accessToken,id,global.currentBusiness.id).then((_){
            global.setCurrentWallpaper(Env.Storage + '/wallpapers/' +id,notify: false);
            Navigator.of(context).pop();
          });
        },
      ),
    );
  }
}