import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';

class LanguageScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc settingBloc;
  LanguageScreen({this.settingBloc, this.globalStateModel,});

  _LanguageScreenScreenState createState() => _LanguageScreenScreenState();

}

class _LanguageScreenScreenState extends State<LanguageScreen> {

  String defaultLanguage;

  Map<String, String> languages = {
    'en': 'English',
    'de': 'Deutsch',
    'no': 'Norsk',
    'da': 'Dansk',
    'sv': 'Svenska',
  };

  @override
  void initState() {
    widget.settingBloc.add(GetCurrentUserEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.settingBloc,
      listener: (BuildContext context, SettingScreenState state) async {
        if (state is SettingScreenUpdateSuccess) {
          Navigator.pop(context);
        } else if (state is SettingScreenStateFailure) {

        }
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.settingBloc,
        builder: (BuildContext context, SettingScreenState state) {
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomPadding: false,
            appBar: _appBar(state),
            body: SafeArea(
              child: BackgroundBase(
                true,
                backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
                body: state.isLoading ?
                Center(
                  child: CircularProgressIndicator(),
                ): Center(
                  child: _getBody(state),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(SettingScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Text(
        Language.getPosStrings('settings.language.title'),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody(SettingScreenState state) {
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          radius: 20,
          child: Wrap(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12),
                child: BlurEffectView(
                  radius: 8,
                  child: DropdownButtonFormField(
                    items: List.generate(languages.keys.toList().length, (index) {
                      return DropdownMenuItem(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            languages[languages.keys.toList()[index]],
                          ),
                        ),
                        value: languages.keys.toList()[index],
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        defaultLanguage = val;
                      });
                    },
                    value: state.user.language,
                    hint: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        Language.getSettingsStrings('form.create_form.language.label'),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () {
                      if (!state.isUpdating) {
                        Map<String, dynamic> body = {
                          'language': defaultLanguage,
                        };
                        widget.settingBloc.add(UpdateCurrentUserEvent(body: body));
                      }
                    },
                    color: Colors.black,
                    child: state.isUpdating
                        ? CircularProgressIndicator(
                      strokeWidth: 2,
                    )
                        : Text(
                      Language.getCommerceOSStrings('actions.save'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}