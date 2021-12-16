import 'package:flutter/material.dart';
import 'package:garen/pages/termos_uso.dart';
import 'package:garen/utils/config.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';

class Sobre extends StatefulWidget {
  @override
  _SobreState createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  LocalizacaoServico _locate = new LocalizacaoServico();

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
            width: tamanho.width,
            height: tamanho.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_azul.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: tamanho.width * 0.5,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 2.0, color: Colors.red),
                      ),
                      color: Colors.transparent,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: AlignmentDirectional.center,
                        child: Text("${_locate.locale['INFO']['title']}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 35)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: tamanho.height * 0.06),
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${_locate.locale['INFO']['name']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          Text(
                            "${_locate.locale['INFO']['version']} ${Config.versao}",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: tamanho.height * 0.03,
                        left: tamanho.width * 0.09,
                        right: tamanho.width * 0.09),
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            "${_locate.locale['INFO']['info']}",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: tamanho.height * 0.1),
                    child: GestureDetector(
                        onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TermosUso()))
                            },
                        child: Container(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Text(
                            "${_locate.locale['INFO']['terms']}",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline),
                          ),
                        ))),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
