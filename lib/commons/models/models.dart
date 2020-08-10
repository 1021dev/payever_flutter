export 'acl.dart';
export 'app_widget.dart';
export 'business.dart';
export 'business_apps.dart';
export 'business_employees_groups.dart';
export 'buttons_data.dart';
export 'employees.dart';
export 'employees_list.dart';
export 'expandable_header.dart';
export 'group_acl.dart';
export 'pos.dart';
export 'shop.dart';
export 'token.dart';
export 'tutorial.dart';
export 'transaction.dart';
export 'user.dart';
export 'version.dart';
export 'wallpaper.dart';

class NotificationModel {
  String id;
  String app;
  String kind;
  String entity;
  String message;
  String hash;
  String createdAt;
  String updatedAt;
  num v;
  dynamic data;

  NotificationModel.fromMap(dynamic obj) {
    id = obj['_id'];
    app = obj['app'];
    entity = obj['entity'];
    kind = obj['kind'];
    message = obj['message'];
    createdAt = obj['createdAt'];
    updatedAt = obj['updatedAt'];
    hash = obj['hash'];
    v = obj['__v'];
    if (obj['data'] != null) {
      data = obj['data'];
    }
  }
}
