import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/utils/constantes/shared_preferences_constante.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class DatePickerUtil {
  LocalizacaoServico _locate = new LocalizacaoServico();
  Future<DateTime> datePicker(
      {BuildContext context, DateTime dataInicial}) async {
        await _locate.iniciaLocalizacao(context);

    SharedPreferences _prefs = await SharedPreferences.getInstance();

    String idioma = _prefs.getString(SharedPreference.IDIOMA) ?? 'pt';

    return await showDatePicker(

      context: context,

      initialDate: dataInicial,

      firstDate: DateTime(1900),

      helpText: _locate.locale['SelecionarData'],

      lastDate: DateTime(2100),

      locale: Locale(idioma)

    );

  }
}
