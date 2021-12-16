import 'package:flutter/material.dart';
import 'package:garen/components/app_bar.dart';
import 'package:garen/servicos/notification_servico.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:garen/utils/rotas.dart';

class DetalhesNotificacao1 extends StatefulWidget {
  @override
  _DetalhesNotificacao1State createState() => _DetalhesNotificacao1State();
}

class _DetalhesNotificacao1State extends State<DetalhesNotificacao1> {
  LocalizacaoServico locate = new LocalizacaoServico();
  NotificacaoServico _servicoNotificacao = new NotificacaoServico();

  @override
  void initState() {
    locate.iniciaLocalizacao(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  updateNotificacao(String idNot) {
    _servicoNotificacao.setUpdateNotificacao(idNotificacao: idNot);
  }

  excluirnot(String idNot) {
    _servicoNotificacao.getExcluiNotificacao(idNotificacao: idNot);
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NotificacoesPage()));
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> NotificacoesPage()), (route) => false);
    Navigator.pop(context);
    Rotas.vaParaNotificacao(context);
  }

  Future<void> _showChoiceDialog(BuildContext context, String idNot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "${locate.locale['NOTIFICATION']['delete?']}",
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
                              "${locate.locale['NOTIFICATION']['delete_notification']}")),
                    ],
                  ),
                ),
              )),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("${locate.locale['ACCREDITATION']['not']}")),
                FlatButton(
                    onPressed: () => excluirnot(idNot),
                    child: Text("${locate.locale['ACCREDITATION']['yes']}")),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> _notificacoes =
        ModalRoute.of(context).settings.arguments;
    updateNotificacao(_notificacoes['not_n_codigo']);
    Size tamanho = MediaQuery.of(context).size;
    return LocalizacaoWidget(
      child: StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
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
              child: Form(
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: tamanho.height * 0.02),
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
                                "${locate.locale['NOTIFICATION']['title']}",
                                style: GoogleFonts.audiowide(
                                    fontSize: 28 *
                                        MediaQuery.of(context).textScaleFactor,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IntrinsicHeight(
                        child: Container(
                            width: tamanho.width * 0.9,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                          flex: 3,
                                          fit: FlexFit.tight,
                                          child: Text(
                                              _notificacoes['not_c_origem'])),
                                      Flexible(
                                          flex: 1,
                                          fit: FlexFit.loose,
                                          child: Align(
                                              alignment: AlignmentDirectional
                                                  .centerEnd,
                                              child: Text(_notificacoes[
                                                  'data_criacao']))),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(_notificacoes[
                                              'not_c_mensagem']))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 12, left: 12, right: 12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Align(
                                            alignment: AlignmentDirectional
                                                .centerStart,
                                            child: GestureDetector(
                                              onTap: () => _showChoiceDialog(
                                                  context,
                                                  _notificacoes[
                                                      'not_n_codigo']),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
