import 'package:flutter/material.dart';
import 'package:garen/pages/agendaInstalacao.dart';
import 'package:garen/pages/calculadoraOrcamento.dart';
import 'package:garen/pages/calculadoraPontoGiro.dart';
import 'package:garen/pages/especificadorAutomatizadores.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:garen/components/animation.dart';

class FerramentasPage extends StatefulWidget {
  final String texto;

  FerramentasPage(this.texto);

  @override
  _FerramentasPageState createState() => _FerramentasPageState();
}

class _FerramentasPageState extends State<FerramentasPage> {
  LocalizacaoServico _locate = new LocalizacaoServico();
  String idiomaEnvio = "pt-br";
  void initState() {
    _locate.iniciaLocalizacao(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size tamanho = MediaQuery.of(context).size;
    return LocalizacaoWidget(
      child: StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          body: Center(
            child: Stack(children: <Widget>[
              // Fundo da appBar(Container) com cores gradiant.
              Container(
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
                      ])),
                  height: MediaQuery.of(context).size.height * 0.005),

              //Acima do Card
              Padding(
                padding: EdgeInsets.only(top: tamanho.height * 0.004),
                child: Container(
                  width: tamanho.width,
                  height: tamanho.height * 1.1,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bg_azul.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          FadeInUp(
                            1,
                            Container(
                              width: tamanho.width * 0.62,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 3.0,
                                    color: Color(0xff8e1729),
                                  ),
                                ),
                                color: Colors.transparent,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Align(
                                  alignment: AlignmentDirectional.center,
                                  child: Text(
                                      "${_locate.locale['TIPS']['title']}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30)),
                                ),
                              ),
                            ),
                          ),
                          FadeInUp(
                            2,
                            Padding(
                              padding:
                                  EdgeInsets.only(top: tamanho.height * 0.03),
                              child: GestureDetector(
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => AgendaInstalacao()))
                                },
                                child: Container(
                                  width: tamanho.width * 0.9,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.red[900],
                                    border: Border.all(
                                        color: Color(0xff9e0301), width: 3),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[800],
                                        spreadRadius: 2,
                                        blurRadius: 10,

                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.ballot,
                                            color: Colors.white,
                                            size: 50,
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${_locate.locale['TIPS']['installation_schedule_line_1']}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "${_locate.locale['TIPS']['installation_schedule_line_2']}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FadeInUp(
                            3,
                            Padding(
                              padding:
                                  EdgeInsets.only(top: tamanho.height * 0.03),
                              child: GestureDetector(
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              EspecificadorAutomatizadores()))
                                },
                                child: Container(
                                  width: tamanho.width * 0.9,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.red[900],
                                    border: Border.all(
                                        color: Color(0xff9e0301), width: 3),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[800],
                                        spreadRadius: 2,
                                        blurRadius: 10,

                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.settings,
                                            color: Colors.white,
                                            size: 50,
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${_locate.locale['TIPS']['atomager_specifier_line_1']}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "${_locate.locale['TIPS']['atomager_specifier_line_2']}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FadeInUp(
                            4,
                            Padding(
                              padding:
                                  EdgeInsets.only(top: tamanho.height * 0.03),
                              child: GestureDetector(
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              CalculadoraOrcamento()))
                                },
                                child: Container(
                                  width: tamanho.width * 0.9,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.red[900],
                                    border: Border.all(
                                        color: Color(0xff9e0301), width: 3),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[800],
                                        spreadRadius: 2,
                                        blurRadius: 10,

                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.attach_money_rounded,
                                            color: Colors.white,
                                            size: 50,
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${_locate.locale['TIPS']['budget_calculator_line_1']}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "${_locate.locale['TIPS']['budget_calculator_line_2']}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FadeInUp(
                            5,
                            Padding(
                              padding:
                                  EdgeInsets.only(top: tamanho.height * 0.03),
                              child: GestureDetector(
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => CalculadoraGiro()))
                                },
                                child: Container(
                                  width: tamanho.width * 0.9,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.red[900],
                                    border: Border.all(
                                        color: Color(0xff9e0301), width: 3),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[800],
                                        spreadRadius: 2,
                                        blurRadius: 10,

                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.calculate,
                                            color: Colors.white,
                                            size: 50,
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${_locate.locale['TIPS']['turn_point_calculator_line_1']}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "${_locate.locale['TIPS']['turn_point_calculator_line_2']}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Positioned para a appBar usar comente o tamanho dela.
              ),
            ]),
          ),
        );
      }),
    );
  }
}
