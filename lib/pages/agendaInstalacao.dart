import 'package:flutter/material.dart';
import 'package:garen/components/animation.dart';
import 'package:garen/components/ProgressHUD.dart';
import 'package:garen/pages/adicionarInstalacao.dart';
import 'package:garen/components/carregando_garen.dart';
import 'package:garen/pages/dashboard.dart';
import 'package:garen/pages/ferramentas.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:provider/provider.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:garen/provider/orcamento_provider.dart';
import 'package:garen/models/orcamento_model.dart';
import 'package:garen/components/itemlista.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:hexcolor/hexcolor.dart';

class AgendaInstalacao extends StatefulWidget {
  final bool chamaAlerta;
  const AgendaInstalacao({Key key, this.chamaAlerta}) : super(key: key);

  @override
  _AgendaInstalacaoState createState() => _AgendaInstalacaoState();
}

class _AgendaInstalacaoState extends State<AgendaInstalacao> {

  Color naoSelecionadoCor = Colors.grey;

  Color selecionadoCor = Colors.white;

  bool isApiCallProcess = false;

  bool aprovados = true;

  bool visivel2 = false;

  bool visivel = true;

  bool alerta = false;

  bool edita;

  _verificar() {

    if (aprovados) {

      
      setState(() {

        visivel = true;

        visivel2 = false;

      });

    } else {
     
      visivel = false;

      visivel2 = true;

    }
  }

  LocalizacaoServico _locate = new LocalizacaoServico();

  OrcamantoManager orcamentoManager;

  @override
  void initState() {

    _locate.iniciaLocalizacao(context);

    super.initState();

  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {

    Size tamanho = MediaQuery.of(context).size;

    _chamaAlerta(context, widget.chamaAlerta, _locate.iniciaLocalizacao(context));

    return LocalizacaoWidget(

      child: StreamBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {

        return Scaffold(

          appBar: AppBar(

            
            
            backgroundColor: HexColor("#004370"),
            
            iconTheme: IconThemeData(
            
              color: Colors.white, //change your color here
            
            ),
            
            title: Image.asset(
              
              "assets/images/logo-branco.png",
              
              fit: BoxFit.cover,
              
              width: 100,

            ),

            centerTitle: true,

            actions: <Widget>[
              
              Visibility(

                visible: true,

                child: FlatButton(

                  textColor: Colors.white,

                  onPressed: () => {

                    Navigator.push(

                        context,

                        MaterialPageRoute(

                            builder: (context) => AdicionarInstalacao(
                              
                              valorPagar: null,

                              aprovado: false,

                              editar: false,

                            )

                        )
                    )
                  },
                  child: Row(

                    children: [

                      Icon(

                        Icons.add,

                        color: Colors.white,

                      )

                    ],

                  ),

                  shape:  CircleBorder(

                    side: BorderSide(

                      color: Colors.transparent

                    )

                  ),

                ),

              ),

            ],

            bottom: PreferredSize(

              preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.005),

              child: Container(

                decoration: BoxDecoration(

                gradient: LinearGradient(

                begin: Alignment.centerLeft,

                end: Alignment.centerRight,

                colors: [
                    Color(0xff8e1729),                    
                    Color(0xff4d1627),
                    Color(0xff00141c),
                    Color(0xff4d1627),
                    Color(0xff8e1729),
                  ]
                )),

                height: 5
              ),

            ),

          ),

          body: Container(

            width: double.infinity,

            constraints: BoxConstraints.expand(),

            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_azul.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: ProgressHUD(
                inAsyncCall: isApiCallProcess,
                opacity: 0.3,
                child: Container(
                  height: tamanho.height,
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              top: tamanho.height * 0.05, bottom: 20),
                          child: Text("${_locate.locale['SCHEDULE']['title']}",
                              style: GoogleFonts.audiowide(
                                  fontSize: 28 *
                                      MediaQuery.of(context).textScaleFactor,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700))),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => {
                                setState(() {
                                  selecionadoCor = Colors.white;
                                  aprovados = true;
                                  naoSelecionadoCor = Colors.grey;
                                  _verificar();
                                })
                              },
                              child: Container(
                                decoration: BoxDecoration(

                                  border: Border(
                                    bottom: BorderSide(width: 3.0, color: selecionadoCor),
                                  ),

                                  color: Colors.transparent,
                                ),
                                width: tamanho.width * 0.45,
                                height: 30,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "${_locate.locale['SCHEDULE']['approved_installations']}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: selecionadoCor,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => {
                                setState(() {
                                  naoSelecionadoCor = Colors.white;
                                  aprovados = false;
                                  selecionadoCor = Colors.grey;
                                  _verificar();
                                })
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 3.0, color: naoSelecionadoCor),
                                  ),
                                  color: Colors.transparent,
                                ),
                                width: tamanho.width * 0.45,
                                height: 30,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "${_locate.locale['SCHEDULE']['budgets_in_approval']}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: naoSelecionadoCor,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: visivel,
                        child: carregaAprovado(
                            '${_locate.locale['AWESOMEDIALOG']['no_data']}'),
                      ),
                      Visibility(
                        visible: visivel2,
                        child: carregaNaoAprovado(
                            '${_locate.locale['AWESOMEDIALOG']['no_data']}'),
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

_chamaAlerta(BuildContext context, mostra, locate) async {
  if (mostra == true) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        title: '${locate.locale['AWESOMEDIALOG']['congrats']}',
        text: "${locate.locale['AWESOMEDIALOG']['registered']}",
        confirmBtnText: '${locate.locale['BUDGET']['close']}',
        onConfirmBtnTap: () {});
  }
}

Widget carregaAprovado(String noData) {
  return Consumer<OrcamantoManager>(builder: (_, orcamentoManager, __) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        
        if (snapshot.data == null) {
          return CarregandoScreen(
            color: Colors.blue[900],
            opacity: 0.5,
          );
        }

        List lista = snapshot.data['data'];

        if (snapshot.hasError) {
          return Container(
            child: Text("Erro"),
          );
        }

        if (snapshot.connectionState == ConnectionState.none && snapshot.hasData == null || lista.length == 0) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(noData.toUpperCase(),
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
          );
        }

        if (snapshot.hasData == null && snapshot.connectionState == ConnectionState.waiting || snapshot.data['data'] == null || lista.length == 0) {
          return CarregandoScreen(
            color: Colors.blue[900],
            opacity: 0.5,
          );
        }

        return Flexible(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lista.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 11.0, left: 18.0, bottom: 0.0, right: 18.0),
                child: InkWell(
                  onTap: () async {
                    // var url = snapshot.data['data'][index]['ban_c_link'];
                  },
                  child: FadeInUp(
                    index,
                    ItemLista(
                        codigo: lista[index]['orc_n_codigo'] ?? 0,
                        data:

                          '${lista[index]['orc_d_dataEvento'].substring(0, 10)}' ??
                          '00:00',

                        nomeUsuario: lista[index]['orc_c_cliente'] ?? "",
                        cor: Colors.green,
                        onPressDetalhes: () => {},
                        hora: lista[index]['orc_d_dataEventoHora']
                          .toString()
                          .substring(10, 16) ??
                          '00:00',
                        telefone: lista[index]['orc_c_celular'] ?? '',
                        aprovado: true
                    )
                  ),
                ),
              );
            },
          ),
        );
      },
      future: orcamentoManager.orcamentoService
          .getOrcamento(orcamento: OrcamentoModel(orcBAprovado: "True")),
    );
  });
}

Widget carregaNaoAprovado(String noBudget) {
  return Consumer<OrcamantoManager>(builder: (_, orcamentoManager, __) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return CarregandoScreen(
            color: Colors.blue[900],
            opacity: 0.5,
          );
        }

        List lista = snapshot.data['data'];

        if (snapshot.hasError) {
          return Container(
            child: Text("Erro"),
          );
        }

        if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData == null ||
            lista.length == 0) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(noBudget.toUpperCase(),
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
          );
        }

        if (snapshot.hasData == null &&
                snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data['data'] == null ||
            lista.length == 0) {
          return CarregandoScreen(
            color: Colors.blue[900],
            opacity: 0.5,
          );
        }

        return Flexible(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lista.length ?? 0,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 11.0, left: 18.0, bottom: 18.0, right: 18.0),
                child: InkWell(
                  onTap: () async {},
                  child: FadeInUp(
                      index,
                      ItemLista(
                          codigo: lista[index]['orc_n_codigo'] ?? 0,
                          data:
                              '${lista[index]['orc_d_dataEvento'].substring(0, 10)}' ??
                                  "00:00", //Pegar Data Inserida Na Api
                          nomeUsuario: lista[index]['orc_c_cliente'] ?? "",
                          cor: Colors.red,
                          onPressDetalhes: () => {},
                          hora: lista[index]['orc_d_dataEventoHora']
                                  .toString()
                                  .substring(10, 16) ??
                              "00:00",
                          telefone: lista[index]['orc_c_celular'] ?? "",
                          aprovado: false)),
                ),
              );
            },
          ),
        );
      },
      future: orcamentoManager.orcamentoService
          .getOrcamento(orcamento: OrcamentoModel(orcBAprovado: "False")),
    );
  });
}
