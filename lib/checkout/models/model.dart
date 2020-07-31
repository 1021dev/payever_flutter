import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';

class Checkout {
  String businessId = '';
  List<String> connections = [];
  String createdAt;
  bool isDefault = false;
  String logo = '';
  String name = '';
  List<Section> sections = [];
  CheckoutSettings settings;
  String updatedAt = '';
  num v = 0;
  String id = '';

  Checkout.fromMap(dynamic obj) {
    businessId = obj['businessId'];
    createdAt = obj['createdAt'];
    isDefault = obj['default'];
    logo = obj['logo'];
    name = obj['name'];
    updatedAt = obj['updatedAt'];
    v = obj['__v'];
    id = obj['_id'];

    dynamic connectionsObj = obj['connections'];
    if (connectionsObj.isNotEmpty) {
      connectionsObj.forEach((element) {
        connections.add(element);
      });
    }
    dynamic _sections = obj[GlobalUtils.DB_CHECKOUT_SECTIONS];
    if (_sections.isNotEmpty) {
      _sections.forEach((section) {
        sections.add(Section.fromMap(section));
      });
    }
    dynamic settingsObj = obj['settings'];
    if (settingsObj.isNotEmpty) {
      settings = CheckoutSettings.fromMap(settingsObj);
    }
  }
}

class Section {
  String code = '';
  bool enabled = false;
  bool fixed = false;
  num order = 0;
  String id = '';
  List<dynamic> excludedChannels = [];

  Section.fromMap(dynamic obj) {
    code = obj[GlobalUtils.DB_CHECKOUT_SECTIONS_CODE];
    enabled = obj[GlobalUtils.DB_CHECKOUT_SECTIONS_ENABLED];
    fixed = obj[GlobalUtils.DB_CHECKOUT_SECTIONS_FIXED];
    order = obj[GlobalUtils.DB_CHECKOUT_SECTIONS_ORDER];
    id = obj['id'];
    print("Section $code enabled $enabled");
    var _excludedChannels = obj[GlobalUtils.DB_CHECKOUT_SECTIONS_EXCLUDED];
    if (_excludedChannels.isNotEmpty) {
      _excludedChannels.forEach((channel) {
        excludedChannels.add(channel);
      });
    }
  }
}

class CheckoutSettings {
  List<dynamic> cspAllowedHosts = [];
  List<Lang> languages = [];
  String message = '';
  String phoneNumber = '';
  Style styles;
  bool testingMode = false;

  CheckoutSettings.fromMap(dynamic obj) {
    dynamic cspAllowedHostObj = obj['cspAllowedHosts'];
    if (cspAllowedHostObj is List) {
      cspAllowedHostObj.forEach((element) {
        cspAllowedHosts.add(element);
      });
    }
    dynamic langObj = obj['languages'];
    if (langObj is List) {
      langObj.forEach((element) {
        languages.add(Lang.fromMap(element));
      });
    }
    message = obj['message'];
    phoneNumber = obj['phoneNumber'];
    testingMode = obj['testingMode'];
    dynamic stylesObj = obj['styles'];
    if (styles is Map) {
      styles = Style.fromMap(stylesObj);
    }

  }
}

class Lang {
  bool active = false;
  String code = '';
  bool isDefault = false;
  bool isHovered = false;
  bool isToggleButton = false;
  String name = '';
  String id = '';

  Lang.fromMap(dynamic obj) {
    active = obj['active'];
    code = obj['code'];
    isDefault = obj['isDefault'];
    isHovered = obj['isHovered'];
    isToggleButton = obj['isToggleButton'];
    name = obj['name'];
    id = obj['id'];
  }

}

class Style {
  ButtonStyle button;
  PageStyle page;
  String id = '';

  Style.fromMap(dynamic obj) {
    dynamic buttonObj = obj['button'];
    if (buttonObj is Map) {
      button = ButtonStyle.fromMap(buttonObj);
    }
    dynamic pageObj = obj['page'];
    if (pageObj is Map) {
      page = PageStyle.fromMap(pageObj);
    }
    id = obj['_id'];
  }

}

class PageStyle {
  String background = '';

  PageStyle.fromMap(dynamic obj) {
    background = obj['background'];
  }
}

class ButtonStyle {
  String corners = '';
  ButtonColorStyle color;

  ButtonStyle.fromMap(dynamic obj) {
    corners = obj['corners'];

    dynamic colorObj = obj['color'];
    if (colorObj is Map) {
      color = ButtonColorStyle.fromMap(colorObj);
    }
  }
}

class ButtonColorStyle {
  String borders = '';
  String fill = '';
  String text = '';

  ButtonColorStyle.fromMap(dynamic obj) {
    borders = obj['borders'];
    fill = obj['fill'];
    text = obj['text'];
  }

}