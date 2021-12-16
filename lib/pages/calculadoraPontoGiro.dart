import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:garen/components/animation.dart';

class CalculadoraGiro extends StatefulWidget {
  @override
  _CalculadoraGiroState createState() => _CalculadoraGiroState();
}

class _CalculadoraGiroState extends State<CalculadoraGiro> {
  TextEditingController _controllerAltura = TextEditingController();

  LocalizacaoServico _locate = new LocalizacaoServico();

  void initState() {
    _locate.iniciaLocalizacao(context);

    super.initState();
  }

  double resultadoPG = 0;
  double resultadoBA = 0;
  double resultadoMB = 0;

  String abreviacao = "m";
  String dropdownValue = 'Metros';
  //Resultado = (((altura/2))-(altura*0.05));

  _calcular() {
    double altura = double.parse(_controllerAltura.text);

    if (altura > 100 || altura < 1) {
      _limite(context);
    } else {
      setState(() {
        resultadoPG = ((altura / 2) + 0.02);
        resultadoBA = resultadoPG / 2;
        resultadoMB = resultadoBA - 0.055;
      });
    }
  }

  _limite(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("${_locate.locale['CALC']['warn_invalid_meters']}"),
            content: SingleChildScrollView(
                child: Text(
                    "${_locate.locale['CALC']['info_warn_invalid_meters']}")),
            actions: [
              FlatButton(
                  onPressed: () => {Navigator.pop(context)}, child: Text("OK"))
            ],
          );
        });
  }

  _pG(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("${_locate.locale['CALC']['turn_point']}"),
            content: SingleChildScrollView(
                child: Text("${_locate.locale['CALC']['info_turn_point']}")),
            actions: [
              FlatButton(
                  onPressed: () => {Navigator.pop(context)}, child: Text("OK"))
            ],
          );
        });
  }

  _bA(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("${_locate.locale['CALC']['articulated_arm']}"),
            content: SingleChildScrollView(
                child:
                    Text("${_locate.locale['CALC']['info_articulated_arm']}")),
            actions: [
              FlatButton(
                  onPressed: () => {Navigator.pop(context)}, child: Text("OK"))
            ],
          );
        });
  }

  _mB(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("${_locate.locale['CALC']['arm_bearing']}"),
            content: SingleChildScrollView(
                child: Text("${_locate.locale['CALC']['info_arm_bearing']}")),
            actions: [
              FlatButton(
                  onPressed: () => {Navigator.pop(context)}, child: Text("OK"))
            ],
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
            actions: <Widget>[],
            bottom: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.005),
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
                      ])),
                  height: 5),
            ),
          ),
          body: Container(
            child: Center(
              child: Stack(children: <Widget>[
                // Fundo da appBar(Container) com cores gradiant.
                //Acima do Card
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    width: tamanho.width,
                    height: 800,
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
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: tamanho.height * 0.05),
                                  child: Text(
                                      "${_locate.locale['CALC']['turn_point_calculator_line_1']}",
                                      style: GoogleFonts.audiowide(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700))),
                            ),
                            FadeInUp(
                                2,
                                Text(
                                    "${_locate.locale['CALC']['turn_point_calculator_line_2']}",
                                    style: GoogleFonts.audiowide(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700))),
                            FadeInUp(
                              3,
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Text(
                                    "${_locate.locale['CALC']['des_turn_point_calculator']}",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            FadeInUp(
                              4,
                              Padding(
                                padding:
                                    EdgeInsets.only(top: tamanho.height * 0.00),
                                child: Container(
                                  width: tamanho.width * 0.875,
                                  height: 109,
                                  decoration: BoxDecoration(
                                    color: Color(0xfffe0000),
                                    border: Border.all(
                                        color: Color(0xff9e0301), width: 3),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(13),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 10,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10),
                                        child: Text(
                                          "${_locate.locale['CALC']['how_tall_gate']}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        autofocus: false,
                                        textAlign: TextAlign.center,
                                        controller: _controllerAltura,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText:
                                              "${_locate.locale['CALC']['type_here']}",
                                          hintStyle: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w900),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(0),
                                                bottomRight:
                                                    Radius.circular(9.5),
                                                bottomLeft:
                                                    Radius.circular(9.5),
                                                topLeft: Radius.circular(0)),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(0),
                                                bottomRight:
                                                    Radius.circular(9.5),
                                                bottomLeft:
                                                    Radius.circular(9.5),
                                                topLeft: Radius.circular(0)),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            FadeInUp(
                              6,
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20.0, bottom: 8),
                                child: GestureDetector(
                                  onTap: () => {_pG(context)},
                                  child: Container(
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          "${_locate.locale['CALC']['turn_point']}: ",
                                          style: GoogleFonts.audiowide(
                                              fontSize: tamanho.width * 0.055,
                                              color: Colors.white)),
                                      Text(
                                          "${resultadoPG == 0 ? resultadoPG.toStringAsFixed(0) : resultadoPG.toStringAsFixed(2)} " +
                                              "$abreviacao",
                                          style: GoogleFonts.audiowide(
                                              fontSize: tamanho.width * 0.055,
                                              color: Colors.white)),
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            FadeInUp(
                              7,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () => {_bA(context)},
                                  child: Container(
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          "${_locate.locale['CALC']['articulated_arm']}r: ",
                                          style: GoogleFonts.audiowide(
                                              fontSize: tamanho.width * 0.055,
                                              color: Colors.white)),
                                      Text(
                                          "${resultadoBA == 0 ? resultadoBA.toStringAsFixed(0) : resultadoBA.toStringAsFixed(3)} " +
                                              "$abreviacao",
                                          style: GoogleFonts.audiowide(
                                              fontSize: tamanho.width * 0.055,
                                              color: Colors.white)),
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            FadeInUp(
                              8,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () => {_mB(context)},
                                  child: Container(
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          "${_locate.locale['CALC']['arm_bearing']}: ",
                                          style: GoogleFonts.audiowide(
                                              fontSize: tamanho.width * 0.055,
                                              color: Colors.white)),
                                      Text(
                                          "${resultadoMB == 0 ? resultadoMB.toStringAsFixed(0) : resultadoMB.toStringAsFixed(4)} " +
                                              "$abreviacao",
                                          style: GoogleFonts.audiowide(
                                              fontSize: tamanho.width * 0.055,
                                              color: Colors.white)),
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            FadeInUp(
                              9,
                              Padding(
                                padding: EdgeInsets.only(
                                    top: tamanho.height * 0.015, bottom: 20),
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
                                            "${_locate.locale['CALC']['btn_calculate']}",
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
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
                ),
              ]),
            ),
          ),
        );
      }),
    );
  }
}
