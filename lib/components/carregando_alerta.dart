import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:garen/components/carregando.dart';
import 'dart:io' show Platform;

class CarregandoAlertaComponente {
  LocalizacaoServico _locate = new LocalizacaoServico();

  showCarregar(BuildContext context, {bool exibirTexto = true}) {
    _locate.iniciaLocalizacao(context);

    if (!Platform.isIOS || !Platform.isMacOS) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => LocalizacaoWidget(
          child: StreamBuilder(builder: (context, snapshot) {
            return AlertDialog(
              content: Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Carregando(size: 30),
                    Visibility(
                      visible: exibirTexto,
                      child: Text("${_locate.locale['LOGIN']['loading']}"),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (_) => LocalizacaoWidget(
          child: StreamBuilder(builder: (context, snapshot) {
            return CupertinoAlertDialog(
              content: Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Carregando(size: 30),
                    Visibility(
                        visible: exibirTexto,
                        child: Text("${_locate.locale['Carregando']}"))
                  ],
                ),
              ),
            );
          }),
        ),
      );
    }
  }

  showCarregarSemTexto(BuildContext context) {
    if (!Platform.isIOS || !Platform.isMacOS) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => LocalizacaoWidget(
          child: StreamBuilder(builder: (context, snapshot) {
            return AlertDialog(
              content: Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Carregando(size: 30),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (_) => LocalizacaoWidget(
          child: StreamBuilder(builder: (context, snapshot) {
            return CupertinoAlertDialog(
              content: Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Carregando(size: 30),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    }
  }

  dismissCarregar(BuildContext context) {
    // Navigator.pop(context);
    Navigator.of(context).pop();
  }
}
