import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/theme/theme_event.dart';
import 'package:payever/blocs/theme/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeThemeBloc extends Bloc<ChangeThemeEvent, ChangeThemeState> {
  void onLightThemeChange() => LightTheme();
  void onDarkThemeChange() => DarkTheme();
  void onDecideThemeChange() => DecideTheme();
  @override
  ChangeThemeState get initialState => ChangeThemeState.lightTheme();

  @override
  Stream<ChangeThemeState> mapEventToState(ChangeThemeEvent event) async* {
    if (event is DecideTheme) {
      print('inside Theme decision body');
      final int optionValue = await getOption();
      if (optionValue == 0) {
        yield ChangeThemeState.lightTheme();
      } else if (optionValue == 1) {
        yield ChangeThemeState.darkTheme();
      }
    }

    if (event is DarkTheme) {
      print('inside darktheme body');

      yield ChangeThemeState.darkTheme();
      try {
        _saveOptionValue(1);
      } catch (_) {
        throw Exception("Could not persist change");
      }
    }
    if (event is LightTheme) {
      print('inside LightTheme body');

      yield ChangeThemeState.lightTheme();
      try {
        _saveOptionValue(0);
      } catch (_) {
        throw Exception("Could not persist change");
      }
    }
    if (event is DefaultTheme) {
      print('inside DefaultTheme body');

      yield ChangeThemeState.lightTheme();
      try {
        _saveOptionValue(0);
      } catch (_) {
        throw Exception("Could not persist change");
      }
    }
  }

  Future<Null> _saveOptionValue(int optionValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('theme_option', optionValue);
    print('Saving option value as $optionValue successfully');
  }

  Future<int> getOption() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int option = preferences.get('theme_option') ?? 0;
    return option;
  }
}

final ChangeThemeBloc changeThemeBloc = ChangeThemeBloc()
  ..onDecideThemeChange();
