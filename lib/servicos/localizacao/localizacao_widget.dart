import 'package:flutter/material.dart';
import 'package:garen/components/carregando_garen.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/traducao-strings_constante.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:provider/provider.dart';

class LocalizacaoWidget extends StatefulWidget {
  final StreamBuilder child;
  final bool exibirOffline;

  LocalizacaoWidget({this.child, this.exibirOffline = true});

  @override
  _LocalizacaoWidgetState createState() => _LocalizacaoWidgetState();
}

class _LocalizacaoWidgetState extends State<LocalizacaoWidget> {
  Stream<dynamic> _streamlocale;
  LocalizacaoServico _locale = new LocalizacaoServico();

  @override
  void initState() {
    super.initState();
    _streamlocale = Stream.fromFuture(_locale.iniciaLocalizacao(context));
  }

  @override
  Widget build(BuildContext context) {
    // final bool isOffline = Provider.of<ConnectivityStatus>(context) != ConnectivityStatus.CONNECTED;
    // Função para Sincronizar quando voltar a ficar online pode ser chamada aqui da seguinte forma:
    //
    // RequestUtil().verificaOnline()
    //   .then((value) => print("Verificando: $value"));
    //
    // Apenas Colocar a função dentro do then passando o valor
    return StreamBuilder(
      stream: _streamlocale,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CarregandoScreen(color: Colors.blue[900], opacity: 0.3),
            );

          default:
            if (!snapshot.hasData) {
              return Center(
                child: CarregandoScreen(color: Colors.blue[900], opacity: 0.3),
              );
            } else {
              return widget.child;
            }
        }
      },
    );
  }
}

class OfflineMessageWidget extends StatefulWidget {
  @override
  _OfflineMessageWidgetState createState() => _OfflineMessageWidgetState();
}

class _OfflineMessageWidgetState extends State<OfflineMessageWidget> {
  LocalizacaoServico _locate = new LocalizacaoServico();

  @override
  void initState() {
    super.initState();
    _locate.iniciaLocalizacao(context);
  }

  @override
  Widget build(BuildContext context) {
    return LocalizacaoWidget(
      child: StreamBuilder(builder: (context, snapshot) {
        return Container(
          height: 30,
          color: Theme.of(context).primaryColor,
          child: Center(
              child: Text(
            _locate.locale[TraducaoStringsConstante.Offline],
            style: TextStyle(color: Colors.white),
          )),
        );
      }),
    );
  }
}

class CustomOfflineWidget extends StatefulWidget {
  final Widget child;
  final bool disableInteraction;
  final double height;
  final bool disabledIconOnly;
  final double borderRadius;

  CustomOfflineWidget(
      {this.child,
      this.disableInteraction = true,
      this.height = 40,
      this.disabledIconOnly = false,
      this.borderRadius});

  @override
  _CustomOfflineWidgetState createState() => _CustomOfflineWidgetState();
}

class _CustomOfflineWidgetState extends State<CustomOfflineWidget> {
  LocalizacaoServico _locate = new LocalizacaoServico();

  @override
  void initState() {
    super.initState();
    _locate.iniciaLocalizacao(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isOffline = Provider.of<ConnectivityStatus>(context) !=
        ConnectivityStatus.CONNECTED;

    return LocalizacaoWidget(
      exibirOffline: false,
      child: StreamBuilder(builder: (context, snapshot) {
        return Stack(
          children: <Widget>[
            widget.child,
            widget.disableInteraction && isOffline
                ? Column(
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(
                                  widget.borderRadius ?? 0)),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white70),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: widget.disabledIconOnly
                                    ? Icon(
                                        Icons.network_check,
                                        size: 40,
                                        color: Colors.grey[700],
                                      )
                                    : Text(
                                        _locate.locale[TraducaoStringsConstante
                                            .IndisponivelOffline],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),
          ],
        );
      }),
    );
  }
}
