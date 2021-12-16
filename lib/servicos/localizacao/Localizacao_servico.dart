import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:garen/utils/constantes/shared_preferences_constante.dart';
import 'package:garen/global/global.dart';
import 'dart:convert';

class LocalizacaoServico {
  var locale;

  Future<String> _localizacao(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var idioma = prefs.getString(SharedPreference.IDIOMA);

    int timer = 1;

    switch (idioma) {
      case ConfigIdioma.PORTUGUES_BRASIL:
        {
          return Future.delayed(Duration(milliseconds: timer), () {
            return DefaultAssetBundle.of(context)
                .loadString('assets/locale/br.json');
          });
        }
        break;

      case ConfigIdioma.ENGLISH_US:
        {
          return Future.delayed(Duration(milliseconds: timer), () {
            return DefaultAssetBundle.of(context)
                .loadString('assets/locale/en.json');
          });
        }
        break;

      case ConfigIdioma.ESPANOL_ESP:
        {
          return Future.delayed(Duration(milliseconds: timer), () {
            return DefaultAssetBundle.of(context)
                .loadString('assets/locale/es.json');
          });
        }
        break;

      default:
        {
          return Future.delayed(Duration(milliseconds: timer), () {
            return DefaultAssetBundle.of(context)
                .loadString('assets/locale/br.json');
          });
        }
        break;
    }
  }

  Future<dynamic> iniciaLocalizacao(BuildContext context) async {
    var resultadoLocalizacao = await _localizacao(context);
    locale = json.decode(resultadoLocalizacao.toString());
    return locale;
  }
}
