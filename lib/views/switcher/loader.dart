import 'dart:async';

import 'package:payever/utils/utils.dart';
import 'package:payever/views/switcher/switcher_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoadState{ LOADED, NOTLOADED }

abstract class LoadStateListener {
  void onLoadStateChanged(LoadState state);
}

// A naive implementation of Observer/Subscriber Pattern. Will do for now.
class LoadStateProvider {

  static final LoadStateProvider _instance = new LoadStateProvider.internal();
  List<LoadStateListener> _subscribers;

  factory LoadStateProvider() => _instance;
  LoadStateProvider.internal() {

    _subscribers = new List<LoadStateListener>();
    initState();

  }

  void initState() async {
    var isLoggedIn  = GlobalUtils.IS_LOADED;
    
    if(isLoggedIn)
      notify(LoadState.LOADED);
    else
      notify(LoadState.NOTLOADED);
      GlobalUtils.IS_DASHBOARD_LOADED = false;
  }

  void subscribe(LoadStateListener listener) {
    _subscribers.add(listener);
  }

  void dispose(LoadStateListener listener) {
    _subscribers = [];
  }

  Future<bool> notify(LoadState state) async {
    _subscribers.forEach((LoadStateListener s){
      s.onLoadStateChanged(state);
    });

    return true;
  }
}