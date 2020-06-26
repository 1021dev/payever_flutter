import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/pos.dart';
import 'package:payever/commons/utils/common_utils.dart';

import '../bloc.dart';

class PosScreenBloc extends Bloc<PosScreenEvent, PosScreenState> {
  PosScreenBloc();
  ApiService api = ApiService();

  @override
  PosScreenState get initialState => PosScreenState();

  @override
  Stream<PosScreenState> mapEventToState(PosScreenEvent event) async* {
    if (event is PosScreenInitEvent) {
      if (event.terminals != null) {
        if (event.activeTerminal != null) {
          state.copyWith(
            isLoading: false,
            terminals: event.terminals,
            activeTerminal: event.activeTerminal,
          );
          return;
        }
      }
      yield* fetchPos(event.currentBusiness);
    } else if (event is GetPosIntegrationsEvent) {
      yield* getIntegrations(event.businessId);
    }
  }

  Stream<PosScreenState> fetchPos(Business activeBusiness) async* {
    String token = GlobalUtils.activeToken.accessToken;
    yield state.copyWith(isLoading: true);
    List<Terminal> terminals = [];
    List<ChannelSet> channelSets = [];
    dynamic terminalsObj = await api.getTerminal(activeBusiness.id, token);
    terminalsObj.forEach((terminal) {
      terminals.add(Terminal.toMap(terminal));
    });
//    if (terminals.isEmpty) {
//      _parts._noTerminals = true;
//      _parts._mainCardLoading.value = false;
//    }
    dynamic channelsObj = await api.getChannelSet(activeBusiness.id, token);
    channelsObj.forEach((channelSet) {
      channelSets.add(ChannelSet.toMap(channelSet));
    });

    terminals.forEach((terminal) async {
      channelSets.forEach((channelSet) async {
        if (terminal.channelSet == channelSet.id) {
          dynamic paymentObj = await api.getCheckoutIntegration(activeBusiness.id, channelSet.checkout, token);
          paymentObj.forEach((pm) {
            terminal.paymentMethods.add(pm);
          });

          dynamic daysObj = await api.getLastWeek(activeBusiness.id, channelSet.id, token);
          int length = daysObj.length - 1;
          for (int i = length; i > length - 7; i--) {
            terminal.lastWeekAmount += Day.map(daysObj[i]).amount;
          }
          daysObj.forEach((day) {
            terminal.lastWeek.add(Day.map(day));
          });

          dynamic productsObj = await api.getPopularWeek(activeBusiness.id, channelSet.id, token);
          productsObj.forEach((product) {
            terminal.bestSales.add(Product.toMap(product));
          });
        }
      });
    });

    Terminal activeTerminal = terminals.where((element) => element.active).toList().first;
    yield state.copyWith(activeTerminal: activeTerminal, terminals: terminals, isLoading: false);
  }

  Stream<PosScreenState> getIntegrations(String businessId) async* {
    dynamic integrationObj = await api.getPosIntegrations(GlobalUtils.activeToken.accessToken, businessId);
  }
}