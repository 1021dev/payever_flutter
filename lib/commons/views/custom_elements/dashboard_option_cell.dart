import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/commons/models/models.dart';
import 'package:payever/commons/utils/translations.dart';

class DashboardOptionCell extends StatelessWidget {
  final NotificationModel notificationModel;
  final Function onTapOpen;
  final Function onTapDelete;
  DashboardOptionCell({
    this.notificationModel,
    this.onTapOpen,
    this.onTapDelete,
  });
  @override
  Widget build(BuildContext context) {
    String actionKey = notificationModel.message.replaceAll('notification.', '');
    String message = 'info_boxes.notifications.messages.$actionKey';
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.white12,
        ),
        Container(
          height: 49,
          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.white
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    Language.getCommerceOSStrings(message),
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(width: 12),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      onTapOpen(notificationModel);
                    },
                    child: Container(
                      height: 20,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white12
                      ),
                      child: Center(
                        child: Text(
                          Language.getCommerceOSStrings('actions.open'),
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      onTapDelete(notificationModel);
                    },
                    child: Container(
                      width: 21,
                      height: 21,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.5),
                          color: Colors.white12
                      ),
                      child: Center(
                        child: SvgPicture.asset('assets/images/closeicon.svg', width: 8,),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
