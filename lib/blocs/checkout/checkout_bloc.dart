import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/connect/models/connect.dart';

import 'checkout.dart';

class CheckoutScreenBloc extends Bloc<CheckoutScreenEvent, CheckoutScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;

  CheckoutScreenBloc({this.dashboardScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  CheckoutScreenState get initialState => CheckoutScreenState();

  @override
  Stream<CheckoutScreenState> mapEventToState(
      CheckoutScreenEvent event) async* {
    if (event is CheckoutScreenInitEvent) {
      if (event.business != null) {
        yield state.copyWith(
          business: event.business,
          checkouts: event.checkouts,
          defaultCheckout: event.defaultCheckout,
        );
      } else {

      }
      yield* fetchConnectInstallations(state.business, isLoading: true);
    } else if (event is GetPaymentConfig) {
      yield* getPaymentData();
    } else if (event is PatchCheckoutFlowEvent) {
      yield* patchCheckoutFlow(event.body);
    } else if (event is GetChannelConfig) {
      yield* getChannelConfig();
    } else if (event is GetConnectConfig) {
      yield* getConnectConfig();
    } else if (event is GetChannelSet) {
      yield* getCheckoutFlow();
    } else if (event is ReorderSection1Event) {
      yield* reorderSections1(event.oldIndex, event.newIndex);
    } else if (event is ReorderSection2Event) {
      yield* reorderSections2(event.oldIndex, event.newIndex);
    } else if (event is GetSectionDetails) {
      yield* getSectionDetails();
    } else if (event is UpdateCheckoutSections) {
      yield* updateCheckoutSections();
    } else if (event is AddSectionEvent) {
      yield state.copyWith(addSection: event.section,);
      yield* getAvailableSections();
    } else if (event is RemoveSectionEvent) {
      yield* removeSection(event.section);
    }
  }

  Stream<CheckoutScreenState> fetchConnectInstallations(String business,
      {bool isLoading = false}) async* {
    yield state.copyWith(isLoading: isLoading);

    List<Checkout> checkouts = [];
    List<String> integrations = [];
    Checkout defaultCheckout;

    dynamic checkoutsResponse = await api.getCheckout(token, business);
    if (checkoutsResponse is List) {
      checkoutsResponse.forEach((element) {
        checkouts.add(Checkout.fromMap(element));
      });
    }

    if (state.defaultCheckout == null) {
      List defaults = checkouts.where((element) => element.isDefault).toList();

      if (defaults.length > 0) {
        defaultCheckout = defaults.first;
      } else {
        if (checkouts.length > 0) {
          defaultCheckout = checkouts.first;
        }
      }
    } else {
      defaultCheckout = state.defaultCheckout;
    }

    if (defaultCheckout != null) {
      dynamic integrationsResponse = await api.getCheckoutIntegration(
          business, defaultCheckout.id, token);

      if (integrationsResponse is List) {
        integrationsResponse.forEach((element) {
          integrations.add(element);
        });
      }
    }

    await api.toggleSetUpStatus(token, business, 'checkout');
    dynamic response = await api.getAvailableSections(
        token, state.business, state.defaultCheckout.id);
    List<Section> availableSections = [];
    if (response is List) {
      response.forEach((element) {
        availableSections.add(Section.fromMap(element));
      });
    }

    yield state.copyWith(
      isLoading: false,
      checkouts: checkouts,
      integrations: integrations,
      defaultCheckout: defaultCheckout,
      availableSections: availableSections,
    );

    add(GetChannelSet());
  }

  Stream<CheckoutScreenState> getCheckoutFlow() async* {
    List<ChannelSet> channelSets = [];
    dynamic channelSetResponse = await api.getChannelSet(state.business, token);
    if (channelSetResponse is List) {
      channelSetResponse.forEach((element) {
        ChannelSet channelSet = ChannelSet.toMap(element);
        if (channelSet.checkout != null &&
            channelSet.checkout == state.defaultCheckout.id)
          channelSets.add(ChannelSet.toMap(element));
      });
    }

    ChannelSet channelSet = channelSets.firstWhere((element) =>
    (element.checkout == state.defaultCheckout.id && element.type == 'link'));

    CheckoutFlow checkoutFlow;
    Lang defaultLang;
    List<Lang> langList = state.defaultCheckout.settings.languages.where((
        element) => element.active).toList();
    if (langList.length > 0) {
      defaultLang = langList.first;
    }

    String langCode = defaultLang != null ? defaultLang.code : 'en';

    dynamic channelFlowResponse = await api.getCheckoutChannelFlow(
        token, channelSet.id);
    if (channelFlowResponse is Map) {
      checkoutFlow = CheckoutFlow.fromMap(channelFlowResponse);
    }

    ChannelSetFlow channelSetFlow;
    dynamic checkoutFlowResponse = await api.getCheckoutFlow(
        token, langCode, channelSet.id);
    if (checkoutFlowResponse is Map) {
      channelSetFlow = ChannelSetFlow.fromMap(checkoutFlowResponse);
    }


    yield state.copyWith(
      isLoading: false,
      channelSets: channelSets,
      channelSetFlow: channelSetFlow,
      checkoutFlow: checkoutFlow,
    );
  }

  Stream<CheckoutScreenState> getPaymentData() async* {
    yield state.copyWith(loadingPaymentOption: true);
    List<ConnectModel> integrations = [];
    dynamic integrationsResponse = await api.getCheckoutIntegrations(
        state.business, token);
    if (integrationsResponse is List) {
      integrationsResponse.forEach((element) {
        integrations.add(ConnectModel.toMap(element));
      });
    }

    List<IntegrationModel> connections = [];
    List<IntegrationModel> checkoutConnections = [];

    dynamic connectionResponse = await api.getConnections(
        state.business, token);
    if (connectionResponse is List) {
      connectionResponse.forEach((element) {
        connections.add(IntegrationModel.fromMap(element));
      });
    }

    dynamic checkoutConnectionResponse = await api.getCheckoutConnections(
        state.business, token, state.defaultCheckout.id);
    if (checkoutConnectionResponse is List) {
      checkoutConnectionResponse.forEach((element) {
        checkoutConnections.add(IntegrationModel.fromMap(element));
      });
    }

    yield state.copyWith(
      loadingPaymentOption: false,
      connects: integrations,
      connections: connections,
      checkoutConnections: checkoutConnections,
    );
  }

  Stream<CheckoutScreenState> patchCheckoutFlow(Map body) async* {
    yield state.copyWith(
      isUpdating: true,
    );
    ChannelSetFlow channelSetFlow;
    dynamic response = await api.patchCheckoutFlow(
        token, state.channelSetFlow.id, 'en', body);
    if (response is Map) {
      channelSetFlow = ChannelSetFlow.fromMap(response);
    }
    yield state.copyWith(
      isUpdating: false,
      channelSetFlow: channelSetFlow,
    );
  }

  Stream<CheckoutScreenState> getChannelConfig() async* {
    if (state.channelItems.length == 0) {
      yield state.copyWith(
        loadingChannel: true,
      );
    }
    List<ConnectModel> connectInstallations = [];
    dynamic categoryResponse = await api.getConnectIntegrationByCategory(
        token, state.business, 'shopsystems');
    if (categoryResponse is List) {
      categoryResponse.forEach((element) {
        connectInstallations.add(ConnectModel.toMap(element));
      });
    }

    List<BusinessApps> businessApps = [];
    businessApps.addAll(dashboardScreenBloc.state.businessWidgets);

    List<ChannelItem> items = [];
    List<String> titles = [];
    List<ChannelSet> list = [];
    list.addAll(state.channelSets);
    for (ChannelSet channelSet in list) {
      if (!titles.contains(channelSet.type)) {
        titles.add(channelSet.type);
      }
    }
    for (String title in titles) {
      if (title == 'link') {
        ChannelItem item = new ChannelItem(
          title: 'Pay by Link',
          button: 'Open',
          checkValue: null,
          image: SvgPicture.asset('assets/images/pay_link.svg', height: 24,),
        );
        items.insert(0, item);
      } else if (title == 'finance_express') {
        ChannelItem item1 = new ChannelItem(
          title: 'Text Link',
          button: 'Edit',
          checkValue: null,
          image: SvgPicture.asset('assets/images/pay_link.svg', height: 24,),
        );
        items.add(item1);
        ChannelItem item2 = new ChannelItem(
          title: 'Button',
          button: 'Edit',
          checkValue: null,
          image: SvgPicture.asset('assets/images/button.svg', height: 24,),
        );
        items.add(item2);
        ChannelItem item3 = new ChannelItem(
            title: 'Calculator',
            button: 'Edit',
            checkValue: null,
            image: SvgPicture.asset('assets/images/calculator.svg', height: 24,)
        );
        items.add(item3);
        ChannelItem item4 = new ChannelItem(
          title: 'Bubble',
          button: 'Edit',
          checkValue: null,
          image: SvgPicture.asset('assets/images/bubble.svg', height: 24,),
        );
        items.add(item4);
      } else if (title == 'marketing') {
        ChannelItem item = new ChannelItem(
          title: 'Mail',
          button: 'Open',
          checkValue: null,
          image: SvgPicture.asset('assets/images/mailicon.svg', height: 24,),
        );
        items.add(item);
      } else if (title == 'pos') {
        ChannelItem item = new ChannelItem(
          title: 'Point of Sale',
          button: 'Open',
          checkValue: null,
          image: SvgPicture.asset('assets/images/pos.svg', height: 24,),
        );
        items.add(item);
      } else if (title == 'shop') {
        ChannelItem item = new ChannelItem(
          title: 'Shop',
          button: 'Open',
          checkValue: null,
          image: SvgPicture.asset('assets/images/shopicon.svg', height: 24,),
        );
        items.add(item);
      } else {
        ConnectModel connectModel = connectInstallations.firstWhere((
            element) => element.integration.name == title);
        if (connectModel != null) {
          String iconType = connectModel.integration.displayOptions.icon ?? '';
          iconType = iconType.replaceAll('#icon-', '');
          iconType = iconType.replaceAll('#', '');

          ChannelItem item = new ChannelItem(
              title: Language.getPosConnectStrings(
                  connectModel.integration.displayOptions.title),
              button: 'Open',
              checkValue: connectModel.installed,
              image: SvgPicture.asset(
                Measurements.channelIcon(iconType), height: 24,)
          );
          items.add(item);
        }
      }
    }

    yield state.copyWith(
      loadingChannel: false,
      channelItems: items,
    );
  }

  Stream<CheckoutScreenState> getConnectConfig() async* {
    yield state.copyWith(
      loadingConnect: true,
    );
    List<ConnectModel> connectInstallations = [];
    dynamic categoryResponse = await api.getConnectIntegrationByCategory(
        token, state.business, 'communications');
    if (categoryResponse is List) {
      categoryResponse.forEach((element) {
        connectInstallations.add(ConnectModel.toMap(element));
      });
    }

    List<BusinessApps> businessApps = [];
    businessApps.addAll(dashboardScreenBloc.state.businessWidgets);

    List<ChannelItem> items = [];
    for (ConnectModel connectModel in connectInstallations) {
      if (connectModel != null) {
        String iconType = connectModel.integration.displayOptions.icon ?? '';
        iconType = iconType.replaceAll('#icon-', '');
        iconType = iconType.replaceAll('#', '');

        ChannelItem item = new ChannelItem(
            title: Language.getPosConnectStrings(
                connectModel.integration.displayOptions.title),
            button: 'Open',
            checkValue: connectModel.installed,
            image: SvgPicture.asset(
              Measurements.channelIcon(iconType), height: 24,)
        );
        items.add(item);
      }
    }

    yield state.copyWith(
      loadingConnect: false,
      connectItems: items,
    );
  }

  Stream<CheckoutScreenState> getSectionDetails() async* {
    if (state.checkoutFlow == null) {
      return;
    }

    List<Section> sections = [];
    List<Section> sections1 = [];
    List<Section> sections2 = [];
    sections.addAll(state.checkoutFlow.sections);
    for (int i = 0; i < sections.length; i++) {
      Section section = sections[i];
      if (section.code == 'order') {
        sections1.add(section);
      } else if (section.code == 'send_to_device') {
        sections1.add(section);
      } else if (section.code == 'choosePayment') {
        sections2.add(section);
      } else if (section.code == 'payment') {
        sections2.add(section);
      } else if (section.code == 'address') {
        sections2.add(section);
      } else if (section.code == 'user') {
        sections2.add(section);
      }
    }

    yield state.copyWith(
      sections1: sections1,
      sections2: sections2,
    );
  }

  Stream<CheckoutScreenState> updateCheckoutSections() async* {
    yield state.copyWith(
      sectionUpdate: true,
    );

    List<Section> sections = [];
    sections.addAll(state.sections1);
    sections.addAll(state.sections2);
    Map<String, dynamic> body = {};
    List<Map<String, dynamic>> sectionMapList = [];
    sections.forEach((section) {
      sectionMapList.add(section.toMap());
    });

    body['sections'] = sectionMapList;
    dynamic sectionsResponse = await api.patchCheckout(
        token, state.business, state.defaultCheckout.id, body);

    ChannelSet channelSet = state.channelSets.firstWhere((element) =>
    (element.checkout == state.defaultCheckout.id && element.type == 'link'));
    CheckoutFlow checkoutFlow;
    dynamic channelFlowResponse = await api.getCheckoutChannelFlow(
        token, channelSet.id);
    if (channelFlowResponse is Map) {
      checkoutFlow = CheckoutFlow.fromMap(channelFlowResponse);
    }

    yield state.copyWith(
      sectionUpdate: false,
      checkoutFlow: checkoutFlow,
    );
  }

  Stream<CheckoutScreenState> reorderSections1(int oldIndex,
      int newIndex) async* {
    List<Section> sections1 = [];
    sections1.addAll(state.sections1);
    final item = sections1[oldIndex];
    sections1.removeAt(oldIndex);
    sections1.insert(newIndex, item);

    yield state.copyWith(sections1: sections1);
  }

  Stream<CheckoutScreenState> reorderSections2(int oldIndex,
      int newIndex) async* {
    List<Section> sections2 = [];
    sections2.addAll(state.sections2);
    final item = sections2[oldIndex];
    sections2.removeAt(oldIndex);
    sections2.insert(newIndex, item);

    yield state.copyWith(sections2: sections2);
  }

  Stream<CheckoutScreenState> getAvailableSections() async* {
    List<Section> availableSections = [];
    availableSections.addAll(state.availableSections);

    if (state.sections1.length > 1) {
      yield state.copyWith(availableSections1: []);
    } else {
      List list = availableSections.where((element) =>
      element.code == 'send_to_device').toList();
      if (list.length > 0) {
        yield state.copyWith(availableSections1: list);
      }
    }
    if (state.sections2.length > 3) {
      yield state.copyWith(availableSections2: []);
    } else {
      List listUser = availableSections.where((element) =>
      element.code == 'user').toList();
      List listAddress = availableSections.where((element) =>
      element.code == 'address').toList();
      List<Section> available2 = [];
      if (state.sections2
          .where((element) => element.code == 'user')
          .toList()
          .length == 0) {
        if (listUser.length > 0) {
          available2.add(listUser.first);
        }
      }
      if (state.sections2
          .where((element) => element.code == 'address')
          .toList()
          .length == 0) {
        if (listUser.length > 0) {
          available2.add(listAddress.first);
        }
      }

      yield state.copyWith(availableSections2: available2);
    }
  }

  Stream<CheckoutScreenState> removeSection(Section section) async* {
    List<Section> section1 = [];
    List<Section> section2 = [];
    section1.addAll(state.sections1);
    section2.addAll(state.sections2);
    if (section.code == 'user') {
      int index = section2.indexWhere((element) => element.code == 'user');
      if (index >= 0) {
        section2.removeAt(index);
      }
    } else if (section.code == 'address') {
      int index = section2.indexWhere((element) => element.code == 'address');
      if (index >= 0) {
        section2.removeAt(index);
      }
    } else if (section.code == 'send_to_device') {
      int index = section1.indexWhere((element) => element.code == 'send_to_device');
      if (index >= 0) {
        section1.removeAt(index);
      }
    }

    yield state.copyWith(sections1: section1, sections2: section2);
  }
}