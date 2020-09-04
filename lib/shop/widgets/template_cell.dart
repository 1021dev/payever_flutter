import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';
import 'package:payever/shop/models/models.dart';

class TemplateCell extends StatelessWidget {
  final TemplateModel templateModel;
  final Function onTapInstall;

  TemplateCell({
    this.templateModel,
    this.onTapInstall
  });

  List<OverflowMenuItem> templatePopup(BuildContext context) {
    return [
      OverflowMenuItem(
        title: 'Install',
        onTap: (TemplateModel template) async {
          onTapInstall(template);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // print('Images: ${Env.storage}${templateModel.picture}');
    // return Container(
    //   width: Measurements.width - 72,
    //   height: (Measurements.width - 72) * 1.8,
    //   clipBehavior: Clip.antiAlias,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(16),
    //     shape: BoxShape.rectangle,
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: <Widget>[
    //       Expanded(
    //         child: templateModel.picture != null ? CachedNetworkImage(
    //           imageUrl: '${Env.storage}${templateModel.picture}',
    //           imageBuilder: (context, imageProvider) => Container(
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: BorderRadius.all(Radius.circular(12.0)),
    //               image: DecorationImage(
    //                 image: imageProvider,
    //                 fit: BoxFit.contain,
    //               ),
    //             ),
    //           ),
    //           color: Colors.white,
    //           placeholder: (context, url) => Container(
    //             child: Center(
    //               child: Container(
    //                 child: CircularProgressIndicator(
    //                   strokeWidth: 2,
    //                 ),
    //               ),
    //             ),
    //           ),
    //           errorWidget: (context, url, error) =>  Container(
    //             color: Colors.white,
    //             child: Center(
    //               child: SvgPicture.asset(
    //                 'assets/images/no_image.svg',
    //                 color: Colors.black54,
    //                 width: 100,
    //                 height: 100,
    //               ),
    //             ),
    //           ),
    //         ) : Container(
    //           color: Colors.white,
    //           child: Center(
    //             child: SvgPicture.asset(
    //               'assets/images/no_image.svg',
    //               color: Colors.black54,
    //               width: 100,
    //               height: 100,
    //             ),
    //           ),
    //         ),
    //       ),
    //       Container(
    //         color: Colors.black87,
    //         height: (Measurements.width - 72) * 0.18,
    //         child: Stack(
    //           alignment: Alignment.center,
    //           children: <Widget>[
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: <Widget>[
    //                 Text(
    //                   'new',
    //                   style: TextStyle(
    //                     color: Color(0xffff9000),
    //                     fontSize: 10,
    //                   ),
    //                 ),
    //                 Text(
    //                   templateModel.name ?? '-',
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontSize: 16,
    //                     fontWeight: FontWeight.w400,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             Container(
    //               alignment: Alignment.centerRight,
    //               child: PopupMenuButton<OverflowMenuItem>(
    //                 icon: Icon(Icons.more_horiz),
    //                 offset: Offset(0, 0),
    //                 onSelected: (OverflowMenuItem item) => item.onTap(templateModel),
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(8),
    //                 ),
    //                 color: Colors.black87,
    //                 itemBuilder: (BuildContext context) {
    //                   return templatePopup(context)
    //                       .map((OverflowMenuItem item) {
    //                     return PopupMenuItem<OverflowMenuItem>(
    //                       value: item,
    //                       child: Text(
    //                         item.title,
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                           fontSize: 14,
    //                           fontWeight: FontWeight.w300,
    //                         ),
    //                       ),
    //                     );
    //                   }).toList();
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}