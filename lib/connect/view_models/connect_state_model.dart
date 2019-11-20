import 'package:flutter/material.dart';
import 'package:payever/connect/models/apikeys.dart';
import 'package:payever/connect/models/integration.dart';
import 'package:payever/connect/network/connect_api.dart';
import 'package:payever/connect/views/integrations/api_integration.dart';
import 'package:payever/settings/view_models/view_models.dart';

class ConnectStateModel extends ChangeNotifier {
  ConnectStateModel(this._globalStateModel);
  ConnectApi _api = ConnectApi();
  GlobalStateModel _globalStateModel;
  GlobalStateModel get globalStateModel => _globalStateModel;
  setGlobalStateModel(GlobalStateModel globalStateModel) =>
      _globalStateModel = globalStateModel;

  List<ConnectIntegration> _integration = List();
  List<ConnectIntegration> get integration => _integration;
  setIntegration(List<ConnectIntegration> ss) => _integration = ss;

  Future getIntegrations() async {
    _integration = List();
    var integrations = await _getAllIntegrations();
    if (integrations != null) {
      integrations.forEach((_i) {
        _integration.add(ConnectIntegration.fromMap(_i));
      });
    }
    return true;
  }

  _getAllIntegrations() async {
    return await _api.getAllIntegrations(_globalStateModel.currentBusiness.id);
  }

  Future getRandomIntegrations() async {
    return await _api
        .getRandomIntegrations(_globalStateModel.currentBusiness.id);
  }

  installIntegration(String integration) async {
    return _api.patchInstallIntegration(
        _globalStateModel.currentBusiness.id, integration);
  }

  uninstallIntegration(String integration) async {
    return _api.patchUninstallIntegration(
        _globalStateModel.currentBusiness.id, integration);
  }

  apiKeys() async {
    var _idList = await _api.getApiKey(
      _globalStateModel.currentBusiness.id,
    );
    String clientid = "";
    _idList.forEach((_tempId) {
      clientid += "clients%5B%5D=$_tempId";
      if (_tempId != _idList.last) {
        clientid += "&";
      }
    });
    if (_idList.length == 0) return List();
    return _api.getApiKeyList(
        _globalStateModel.currentBusiness.id, "/clients?$clientid");
  }

  deleteKey(String key) async {
    return await _api.deleteApiKey(_globalStateModel.currentBusiness.id, key);
  }

  addKey(String name) async {
    ApiKeys key = ApiKeys.fromMap(
        await _api.postApiKey(_globalStateModel.currentBusiness.id, name));

    return await _api.postApiKeyPlugin(
        _globalStateModel.currentBusiness.id, key.id);
  }

  static const Map<String, String> iconRoute = {
    "#payment-method-amazon": "assets/images/connecticon/amazon.svg",
    "#icon-api": "assets/images/connecticon/api.svg",
    "#icon-dan-domain-bw": "assets/images/connecticon/dan_domain.svg",
    "#icon-communications-device-payments-white":
        "assets/images/connecticon/device.svg",
    "#icon-shipping-dhl-32": "assets/images/connecticon/dhl.svg",
    "#icon-products-ebay": "assets/images/connecticon/ebay.svg",
    "#icon-shipping-hermes-white": "assets/images/connecticon/hermes.svg",
    "#icon-products-google-shopping": "assets/images/connecticon/google.svg",
    "#icon-jtl": "assets/images/connecticon/jtl.svg",
    "#icon-magento": "assets/images/connecticon/magento.svg",
    "#icon-oxid": "assets/images/connecticon/oxid.svg",
    "#icon-payment-option-payex": "assets/images/connecticon/payex.svg",
    "#icon-payment-option-paypall": "assets/images/connecticon/paypal.svg",
    "#icon-plenty-markets-bw": "assets/images/connecticon/plentymarkets.svg",
    "#icon-prestashop-bw": "assets/images/connecticon/prestashop.svg",
    "#icon-communications-qr-white": "assets/images/connecticon/qr.svg",
    "#icon-payment-option-santander": "assets/images/connecticon/santander.svg",
    "#icon-shopify": "assets/images/connecticon/shopify.svg",
    "#icon-shopware": "assets/images/connecticon/shopware.svg",
    "#icon-payment-option-sofort": "assets/images/connecticon/sofort.svg",
    "#icon-payment-option-stripe": "assets/images/connecticon/stripe.svg",
    "#icon-payment-option-stripe-direct-debit":
        "assets/images/connecticon/stripe.svg",
    "#icon-communication-twillio": "assets/images/connecticon/twillio.svg",
    "#icon-shipping-ups-white": "assets/images/connecticon/ups.svg",
    "#icon-woo-commerce-bw": "assets/images/connecticon/woo.svg",
    "#icon-xt-commerce-bw": "assets/images/connecticon/xt.svg",
    "#payment-method-cash-2": "assets/images/connecticon/wiretransfer.svg"
  };


  ValueNotifier<bool> apiIntegrationNotifier = ValueNotifier(false);
  
  Map<String, Widget> integrationWidgets = {
    "api": ApiIntegration(),
  };

  Map<String, Widget> actionsWidgets = {
    "api": AddApiCredentials(),
  };
  
  String icon(String tag) {
    return iconRoute[tag];
  }
}
