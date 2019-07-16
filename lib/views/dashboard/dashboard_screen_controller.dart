import 'dart:async';

import 'package:payever/utils/utils.dart';

enum LoadState{ LOADED, NOTLOADED }

abstract class DashboardStateListener {
  void onLoadStateChanged(LoadState state);
}

// A naive implementation of Observer/Subscriber Pattern. Will do for now.
class DashboardStateProvider {

  static final DashboardStateProvider _instance = new DashboardStateProvider.internal();
  List<DashboardStateListener> _subscribers;

  factory DashboardStateProvider() => _instance;
  DashboardStateProvider.internal() {

    _subscribers = new List<DashboardStateListener>();
    initState();

  }

  void initState() async {

    var isLoggedIn  = GlobalUtils.IS_DASHBOARD_LOADED;

    if(isLoggedIn)
      notify(LoadState.LOADED);
    else
      notify(LoadState.NOTLOADED);
      
    GlobalUtils.IS_DASHBOARD_LOADED = false;

  }

  void subscribe(DashboardStateListener listener) {
    _subscribers.add(listener);
  }

  void dispose(DashboardStateListener listener) {
    _subscribers = [];
  }

  Future<bool> notify(LoadState state) async {
    _subscribers.forEach((DashboardStateListener s){
      s.onLoadStateChanged(state);
    });

    return true;
  }
}