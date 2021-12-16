import 'package:flutter/material.dart';
import 'package:garen/components/carregando_alerta.dart';
import 'package:garen/models/idioma-item.modelo.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:garen/utils/constantes/shared_preferences_constante.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:garen/global/global.dart';
import 'package:flutter/widgets.dart';

class IdiomaSelecaoComponente extends StatefulWidget {
  final Function atualizaIdioma;
  final Function(String) atualizaIdiomaDeEnvio;
  final bool atualizaEmBanco;

  IdiomaSelecaoComponente(
      {Key key,
      this.atualizaIdioma,
      this.atualizaIdiomaDeEnvio,
      this.atualizaEmBanco = false})
      : super(key: key);

  @override
  IdiomaSelecaoComponenteState createState() => IdiomaSelecaoComponenteState();
}

class IdiomaSelecaoComponenteState extends State<IdiomaSelecaoComponente> {
  List<IdiomaItemModelo> _listaIdiomas = new List<IdiomaItemModelo>();
  Stream<dynamic> _listaIdiomasStream;

  @override
  void initState() {
    _listaIdiomasStream = Stream.fromFuture(_preencheLista());
    _verificaIdiomaSelecionado();
    super.initState();
  }

  Future<dynamic> _preencheLista() async {
    if (_listaIdiomas.length == 0) {
      IdiomaItemModelo ptBr = new IdiomaItemModelo(
          isSelected: false,
          corSplash: Colors.green,
          idioma: ConfigIdioma.PORTUGUES_BRASIL,
          tooltip: ConfigIdioma.PORTUGUES_BRASIL_TOOLTIP,
          imagemCaminho: 'assets/images/flags/br.png');

      IdiomaItemModelo enUs = new IdiomaItemModelo(
          isSelected: false,
          corSplash: Colors.blue[900],
          idioma: ConfigIdioma.ENGLISH_US,
          tooltip: ConfigIdioma.ENGLISH_US_TOOLTIP,
          imagemCaminho: 'assets/images/flags/us.png');

      IdiomaItemModelo esES = new IdiomaItemModelo(
          isSelected: false,
          corSplash: Colors.orange[900],
          idioma: ConfigIdioma.ESPANOL_ESP,
          tooltip: ConfigIdioma.ESPANOL_ESP_TOOLTIP,
          imagemCaminho: 'assets/images/flags/es.png');

      _listaIdiomas.add(ptBr);
      _listaIdiomas.add(enUs);
      _listaIdiomas.add(esES);
    }

    return _listaIdiomas;
  }

  _verificaIdiomaSelecionado() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    String idioma = _prefs.getString(SharedPreference.IDIOMA);

    for (int i = 0; i < _listaIdiomas.length; i++) {
      if (_listaIdiomas[i].idioma == idioma) {
        _listaIdiomas[i].isSelected = true;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LocalizacaoWidget(
      exibirOffline: false,
      child: StreamBuilder(builder: (context, snapshot) {
        return Container(
          height: 620,
          child: StreamBuilder(
              stream: _listaIdiomasStream,
              builder: (context, snapshot) {
                return ListView.separated(
                  separatorBuilder: (context, index) => Container(width: 8),
                  itemBuilder: (context, index) {
                    return _idiomaItemBuilder(context, _listaIdiomas[index]);
                  },
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _listaIdiomas.length,
                );
              }),
        );
      }),
    );
  }

  Widget _idiomaItemBuilder(BuildContext context, IdiomaItemModelo item) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        color: item.isSelected ? item.corSplash : Colors.transparent,
      ),
      child: Tooltip(
        message: item.tooltip,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          focusColor: item.corSplash,
          highlightColor: item.corSplash,
          splashColor: item.corSplash,
          onTap: () async {
            SharedPreferences _prefs = await SharedPreferences.getInstance();

            if (_prefs.getString(SharedPreference.IDIOMA) != item.idioma) {
              widget.atualizaIdiomaDeEnvio(item.idioma);

              if (widget.atualizaEmBanco) {
                // dynamic resultadoRequest = await _locate.alterarIdiomaEmBanco(context: context, idioma: item.idioma);

                // if (resultadoRequest.statusCode == 200) {
                // if ((resultadoRequest is Response && resultadoRequest.statusCode == 200)
                //   || (resultadoRequest is bool && resultadoRequest == true)) {
                //   _prefs.setString(SharedPreference.IDIOMA, item.idioma);
                //   CarregandoAlertaComponente().showCarregarSemTexto(context);
                //   await widget.atualizaIdioma();
                //   CarregandoAlertaComponente().dismissCarregar(context);
                //   for(int i = 0; i < _listaIdiomas.length; i++) {
                //     _listaIdiomas[i].isSelected = false;
                //   }
                //   item.isSelected = true;
                //   setState(() {});
                // }

              } else {
                _prefs.setString(SharedPreference.IDIOMA, item.idioma);
                CarregandoAlertaComponente().showCarregarSemTexto(context);
                await widget.atualizaIdioma();
                CarregandoAlertaComponente().dismissCarregar(context);
                for (int i = 0; i < _listaIdiomas.length; i++) {
                  _listaIdiomas[i].isSelected = false;
                }
                item.isSelected = true;
                setState(() {});
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  // shape: BoxShape.rectangle,
                  shape: BoxShape.circle,
                  // borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: AssetImage(item.imagemCaminho),
                      fit: BoxFit.fitHeight)),
            ),
          ),
        ),
      ),
    );
  }
}
