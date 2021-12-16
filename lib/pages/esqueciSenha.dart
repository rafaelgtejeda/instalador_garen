import 'package:flutter/material.dart';
import 'package:garen/components/app_bar.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:garen/provider/altera_senha_provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:garen/components/animation.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'esqueciSenhaToken.dart';

class EsqueciSenha extends StatefulWidget {
  @override
  _EsqueciSenhaState createState() => _EsqueciSenhaState();
}

class _EsqueciSenhaState extends State<EsqueciSenha> {
  TextEditingController _controllerEmail = TextEditingController();
  LocalizacaoServico _locate = new LocalizacaoServico();

  @override
  void initState() {
    _locate.iniciaLocalizacao(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LocalizacaoWidget(
      child: StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: HexColor("004370"),
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
            constraints: BoxConstraints.expand(),
            width: size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_azul.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Container(
                width: size.width,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: size.height * 0.05, bottom: 61),
                      child: Image.asset(
                        'assets/images/garen-instalador-logo-v2.png',
                        width: 300,
                      ),
                    ),
                    FadeInUp(
                      1,
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, top: 0, left: 10, right: 10),
                        child: Text(
                          "${_locate.locale['FORGOT']['warn_email']}",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    Consumer<AlteraSenhaManager>(
                      builder: (_, alteraSenhaManager, __) {
                        return Container(
                          child: Column(
                            children: [
                              FadeInUp(
                                2,
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: size.width * 0.045,
                                      right: size.width * 0.045,
                                      top: size.height * 0.015),
                                  child: TextField(
                                    enabled: true,
                                    controller: _controllerEmail,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      hintText:
                                          "${_locate.locale['FORGOT']['email']}",
                                      hintStyle: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey[400]),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 1,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 1,
                                        ),
                                      ),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Icon(Icons.email,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              FadeInUp(
                                3,
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 120, bottom: 18),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ArgonButton(
                                      height: 50,
                                      roundLoadingShape: true,
                                      width: MediaQuery.of(context).size.width *
                                          0.81,
                                      onTap: (startLoading, stopLoading,
                                          btnState) async {
                                        if (btnState == ButtonState.Idle) {
                                          startLoading();
                                          if (btnState == ButtonState.Busy) {
                                          } else {
                                            alteraSenhaManager.getEsqueciSenha(
                                                email: _controllerEmail.text,
                                                onSuccess: (v) async {
                                                  if (v['retorno'] == "true") {
                                                    stopLoading();
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EsqueciSenhaToken(
                                                                  email:
                                                                      _controllerEmail
                                                                          .text,
                                                                )));
                                                  } else {
                                                    AwesomeDialog(
                                                      context: context,
                                                      dialogType:
                                                          DialogType.ERROR,
                                                      animType:
                                                          AnimType.BOTTOMSLIDE,
                                                      title:
                                                          '${_locate.locale['AWESOMEDIALOG']['title_2']}',
                                                      desc:
                                                          '${_locate.locale['AWESOMEDIALOG']['invalid_email']}',
                                                      btnCancelText:
                                                          '${_locate.locale['AWESOMEDIALOG']['btn_close']}',
                                                      btnCancelOnPress: () {
                                                        stopLoading();
                                                      },
                                                    )..show();
                                                  }
                                                },
                                                onFail: (v) {
                                                  AwesomeDialog(
                                                    context: context,
                                                    dialogType:
                                                        DialogType.ERROR,
                                                    animType:
                                                        AnimType.BOTTOMSLIDE,
                                                    title:
                                                        '${_locate.locale['AWESOMEDIALOG']['title_2']}',
                                                    desc:
                                                        '${_locate.locale['AWESOMEDIALOG']['invalid_email']}',
                                                    btnCancelText:
                                                        '${_locate.locale['AWESOMEDIALOG']['btn_close']}',
                                                    btnCancelOnPress: () {
                                                      stopLoading();
                                                    },
                                                  )..show();
                                                });
                                          }
                                        } else {}
                                      },
                                      child: Text(
                                        "${_locate.locale['FORGOT']['btn_send']}",
                                        style: TextStyle(
                                            color: Color(0xFFCF203B),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      loader: Container(
                                        padding: EdgeInsets.all(10),
                                        child: SpinKitRotatingCircle(
                                          color: Color(0xFFCF203B),
                                          //size: 60 ,
                                        ),
                                      ),
                                      borderRadius: 5.0,
                                      color: Color(0xFFffffff),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
