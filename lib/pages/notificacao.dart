import 'package:flutter/material.dart';
import 'package:garen/components/app_bar.dart';
import 'package:garen/pages/detalhesNotificacao.dart';
import 'package:garen/provider/notificacoes_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:provider/provider.dart';
import 'package:garen/servicos/notification_servico.dart';
import 'package:garen/components/carregando_garen.dart';

// ignore: must_be_immutable
class NotificacoesPage extends StatefulWidget {
  String idInstalador;

  NotificacoesPage({Key key, this.idInstalador}) : super(key: key);

  @override
  _NotificacoesPageState createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  bool visivel = true;

  LocalizacaoServico _locate = new LocalizacaoServico();
  NotificacaoServico _servicoNotificacao = new NotificacaoServico();

  @override
  void initState() {
    _locate.iniciaLocalizacao(context);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  excluirnot(String idNot) {
    _servicoNotificacao.getExcluiNotificacao(idNotificacao: idNot);
    Navigator.pop(context);
  }

  Future<void> _showChoiceDialog(BuildContext context, String idNot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "${_locate.locale['NOTIFICATION']['delete?']}",
                style: TextStyle(
                    fontSize: 18 * MediaQuery.of(context).textScaleFactor),
              ),
              content: SingleChildScrollView(
                  child: IntrinsicHeight(
                child: Container(
                  child: Column(
                    children: [
                      Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                              "${_locate.locale['NOTIFICATION']['delete_notification']}")),
                    ],
                  ),
                ),
              )),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("${_locate.locale['ACCREDITATION']['not']}")),
                FlatButton(
                    onPressed: () => excluirnot(idNot),
                    child: Text("${_locate.locale['ACCREDITATION']['yes']}")),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    Size tamanho = MediaQuery.of(context).size;
    return LocalizacaoWidget(child:
        StreamBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Scaffold(
        backgroundColor: Colors.blue[900],
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 60),
          child: AppBarComponent(
            backgroundColor: "004370",
            centerTitle: true,
            visivel: false,
            onpressed: () {
              setState(() {});
            },
          ),
        ),
        body: Center(
          child: Stack(children: <Widget>[
            IntrinsicHeight(
              child: Container(
                width: tamanho.width,
                height: tamanho.height * 1.1,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg_azul.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: tamanho.width * 0.62,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          width: tamanho.width * 0.7,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 2.0, color: Color(0xfffe0000)),
                            ),
                            color: Colors.transparent,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional.center,
                            child: Text(
                                "${_locate.locale['NOTIFICATION']['title']}",
                                style: GoogleFonts.audiowide(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: tamanho.height * 0.10),
              child: Consumer<NotificacoesManager>(
                  builder: (_, notificationManager, __) {
                return FutureBuilder(
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.none &&
                        snapshot.hasData == null) {
                      return Center(
                        child: Text(
                            '${_locate.locale['AWESOMEDIALOG']['no_data']}'),
                      );
                    } else if (snapshot.hasData == false &&
                        snapshot.connectionState == ConnectionState.waiting) {
                      return CarregandoScreen(
                        color: Colors.blue[900],
                        opacity: 0.5,
                      );
                    }

                    return snapshot.data['data'].length == 0
                        ? Center(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              strutStyle: StrutStyle(fontSize: 20.0),
                              text: TextSpan(
                                  style: TextStyle(color: Colors.white),
                                  text:
                                      "${_locate.locale['AWESOMEDIALOG']['no_information']}"),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: false,
                            itemCount: snapshot.data['data'].length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 150.0,
                                child: Card(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                flex: 5,
                                                fit: FlexFit.tight,
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: RichText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    strutStyle: StrutStyle(
                                                        fontSize: 12.0),
                                                    text: TextSpan(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        text: snapshot.data[
                                                                'data'][index]
                                                            ['not_c_origem']),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child: Flexible(
                                                  flex: 6,
                                                  fit: FlexFit.tight,
                                                  child: Container(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .centerStart,
                                                    width: 40,
                                                    height: 15,
                                                    color: Colors.transparent,
                                                    child: Container(
                                                      width: 50,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        color: snapshot.data[
                                                                            'data']
                                                                        [index][
                                                                    'not_b_lida'] ==
                                                                "${_locate.locale['NOTIFICATION']['readed']}"
                                                            ? Colors.blue
                                                            : Colors.red,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomLeft:
                                                                    Radius
                                                                        .circular(
                                                                            5),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        5),
                                                                topRight: Radius
                                                                    .circular(
                                                                        5)),
                                                      ),
                                                      child: Align(
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .center,
                                                          child: Text(
                                                            snapshot.data[
                                                                        'data']
                                                                    [index]
                                                                ['not_b_lida'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                  flex: 3,
                                                  fit: FlexFit.loose,
                                                  child: Align(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .centerEnd,
                                                      child: Text(snapshot
                                                                  .data['data']
                                                              [index]
                                                          ['data_criacao']))),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                strutStyle:
                                                    StrutStyle(fontSize: 12.0),
                                                text: TextSpan(
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    text: snapshot.data['data']
                                                            [index]
                                                        ['not_c_mensagem']),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15,
                                              bottom: 8,
                                              left: 8,
                                              right: 8),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .centerStart,
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          _showChoiceDialog(
                                                              context,
                                                              snapshot.data[
                                                                          'data']
                                                                      [index][
                                                                  'not_n_codigo']),
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  )),
                                              Flexible(
                                                flex: 2,
                                                fit: FlexFit.tight,
                                                child: Align(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .centerEnd,
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (_) =>
                                                                    DetalhesNotificacao1(),
                                                                settings:
                                                                    RouteSettings(
                                                                  arguments: snapshot
                                                                          .data[
                                                                      'data'][index],
                                                                ),
                                                              )),
                                                      child: Text(
                                                        "${_locate.locale['NOTIFICATION']['more_details']}",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[800],
                                                            fontSize: 10),
                                                      ),
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  },
                  future:
                      notificationManager.notificationService.getNotificacoes(),
                );
              }),
            ),
          ]),
        ),
      );
    }));
  }
}
