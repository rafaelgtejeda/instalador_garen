import 'package:flutter/material.dart';
import 'package:garen/components/animation.dart';
import 'package:garen/components/app_bar.dart';
import 'package:garen/components/forms/card_input.dart';
import 'package:garen/pages/especificadorResultado.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import 'automatizadores.dart';

class EspecificadorAutomatizadores extends StatefulWidget {
  @override
  _EspecificadorAutomatizadoresState createState() =>
      _EspecificadorAutomatizadoresState();
}

class _EspecificadorAutomatizadoresState
    extends State<EspecificadorAutomatizadores> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _controllerCumprimento = TextEditingController();
  LocalizacaoServico _locate = new LocalizacaoServico();

  bool visivel = false;

  String opcaoAbertura;
  String opcaoFluxo;
  String opcaoVelocidade;

  void initState() {
    _locate.iniciaLocalizacao(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _calcular() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TelaAutomatizador(

              abertura: opcaoAbertura,
              fluxo_de_uso: opcaoFluxo,
              velocidade: opcaoVelocidade,
              comprimento_da_folha: _controllerCumprimento.text,
              
            )

        )
    );
  }

  Future<void> _showChoiceDialogAbertura(BuildContext context) {

    String piv = "${_locate.locale['AUTOMAT']['pivoting']}";
    String tip = "${_locate.locale['AUTOMAT']['tipping']}";
    String sli = "${_locate.locale['AUTOMAT']['sliding']}";

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "${_locate.locale['AUTOMAT']['warn_select_type_aperture']}",
              style: TextStyle(
                  fontSize: 18 * MediaQuery.of(context).textScaleFactor),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text(
                      "$piv",
                      style: TextStyle(
                          fontSize:
                              16 * MediaQuery.of(context).textScaleFactor),
                    ),
                    onTap: () {
                      setState(() {
                        opcaoAbertura = "$piv";
                        visivel = true;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text(
                      "$tip",
                      style: TextStyle(
                          fontSize:
                              16 * MediaQuery.of(context).textScaleFactor),
                    ),
                    onTap: () {
                      setState(() {
                        opcaoAbertura = "$tip";
                        visivel = true;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text(
                      "$sli",
                      style: TextStyle(
                          fontSize:
                              16 * MediaQuery.of(context).textScaleFactor),
                    ),
                    onTap: () {
                      setState(() {
                        opcaoAbertura = "$sli";
                        visivel = true;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showChoiceDialogFluxo(BuildContext context) {

    String low = "${_locate.locale['AUTOMAT']['low_flow']}";
    String med = "${_locate.locale['AUTOMAT']['medium_flow']}";
    String hig = "${_locate.locale['AUTOMAT']['high_flow']}";

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              
              "${_locate.locale['AUTOMAT']['warn_select_flow']}",
              
              style: TextStyle(
                
                fontSize: 18 
                * 
                MediaQuery.of(context).textScaleFactor

              ),

            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text(
                      "$low",
                      style: TextStyle(
                          fontSize:
                              16 * MediaQuery.of(context).textScaleFactor),
                    ),
                    onTap: () {
                      setState(() {
                        opcaoFluxo = "$low";
                      });
                      Navigator.pop(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text(
                      "$med",
                      style: TextStyle(
                          fontSize:
                              16 * MediaQuery.of(context).textScaleFactor),
                    ),
                    onTap: () {
                      setState(() {
                        opcaoFluxo = "$med";
                      });
                      Navigator.pop(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text(
                      "$hig",
                      style: TextStyle(
                          fontSize:
                              16 * MediaQuery.of(context).textScaleFactor),
                    ),
                    onTap: () {
                      setState(() {
                        opcaoFluxo = "$hig";
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showChoiceDialogVelocidade(BuildContext context) {
    String nor = "${_locate.locale['AUTOMAT']['normal']}";
    String qui = "${_locate.locale['AUTOMAT']['quick']}";

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "${_locate.locale['AUTOMAT']['warn_select_velocity']}",
              style: TextStyle(
                  fontSize: 18 * MediaQuery.of(context).textScaleFactor),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text(
                      "$nor",
                      style: TextStyle(
                          fontSize:
                              16 * MediaQuery.of(context).textScaleFactor),
                    ),
                    onTap: () {
                      setState(() {
                        opcaoVelocidade = "$nor";
                      });
                      Navigator.pop(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text(
                      "$qui",
                      style: TextStyle(
                          fontSize:
                              16 * MediaQuery.of(context).textScaleFactor),
                    ),
                    onTap: () {
                      setState(() {
                        opcaoVelocidade = "$qui";
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size tamanho = MediaQuery.of(context).size;

    return LocalizacaoWidget(
      child: StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 60),
            child: AppBarComponent(
              backgroundColor: "004370",
              centerTitle: true,
              visivel: true,
              onpressed: () {
                setState(() {
                  _controllerCumprimento.text = "";
                });
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
                        padding: EdgeInsets.only(top: tamanho.height * 0.05),
                        child: Text(
                            "${_locate.locale['AUTOMAT']['title_line_1']}",
                            style: GoogleFonts.audiowide(
                                fontSize:
                                    18 * MediaQuery.of(context).textScaleFactor,
                                color: Colors.white,
                                fontWeight: FontWeight.w700))),

                    Text("${_locate.locale['AUTOMAT']['title_line_2']}",
                        style: GoogleFonts.audiowide(
                            fontSize:
                                28 * MediaQuery.of(context).textScaleFactor,
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),

                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "${_locate.locale['AUTOMAT']['choose_correct_automator']}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                14 * MediaQuery.of(context).textScaleFactor,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(bottom: tamanho.height * 0.02),
                      child: Column(
                        children: [
                          FadeInUp(
                            1,
                            caixaEscolhaEspecificador(
                                tamanho,
                                context,
                                "${_locate.locale['AUTOMAT']['aperture_type']}",
                                () => {_showChoiceDialogAbertura(context)},
                                opcaoAbertura),
                          ),
                          FadeInUp(
                            2,
                            caixaEscolhaEspecificador(
                                tamanho,
                                context,
                                "${_locate.locale['AUTOMAT']['flow_type']}",
                                () => {_showChoiceDialogFluxo(context)},
                                opcaoFluxo),
                          ),
                          FadeInUp(
                            3,
                            caixaEscolhaEspecificador(
                                tamanho,
                                context,
                                "${_locate.locale['AUTOMAT']['velocity_type']}",
                                () => {_showChoiceDialogVelocidade(context)},
                                opcaoVelocidade),
                          ),
                          Visibility(
                              visible: visivel,
                              child: FadeInUp(
                                  4,
                                  CardInputComponente(
                                    controller: _controllerCumprimento,
                                    keyboardType: TextInputType.number,
                                    titulo:
                                        "${_locate.locale['AUTOMAT']['sheet_length']}",
                                    dica:
                                        "${_locate.locale['AUTOMAT']['for_pivoting_gate']} $opcaoAbertura)",
                                    prefixTexto:
                                        "${_locate.locale['AUTOMAT']['value_in_meters']}",
                                    onchanged: (_) {},
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              '${_locate.locale['AUTOMAT']['warn']}'),
                                          backgroundColor: Colors.red,
                                        ));
                                      }

                                      return null;
                                    },
                                    inputFormatters: [],
                                  ))),
                          FadeInUp(
                            5,
                            Visibility(
                              visible: visivel,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: tamanho.height * 0.015),
                                child: GestureDetector(
                                  onTap: () => {_calcular()},
                                  child: Container(
                                    width: tamanho.width * 0.875,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xffffffff),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 10,

                                          offset: Offset(0,
                                              0), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${_locate.locale['AUTOMAT']['view_equipment']}",
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Botão Calcular

                    // Botão calcular
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Padding caixaEscolhaEspecificador(Size tamanho, BuildContext context,
      String titulo, Function apertar, String opcao) {
    return Padding(
      padding: EdgeInsets.only(bottom: tamanho.height * 0.02),
      child: GestureDetector(
        onTap: apertar,
        child: Container(
          width: tamanho.width * 0.875,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xfffe0000),
            border: Border.all(color: Color(0xff9e0301), width: 3),
            borderRadius: BorderRadius.all(
              Radius.circular(13),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,

                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 10),
                  child: Text(
                    titulo,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12 * MediaQuery.of(context).textScaleFactor),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: EdgeInsets.only(),
                    child: GestureDetector(
                      onTap: apertar,
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            opcao ?? "${_locate.locale['AUTOMAT']['choose']}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13 *
                                    MediaQuery.of(context).textScaleFactor),
                          ),
                        ),
                      ),
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
