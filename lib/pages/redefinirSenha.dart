import 'package:flutter/material.dart';
import 'package:garen/components/app_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/Localizacao_widget.dart';
import 'package:provider/provider.dart';
import 'package:garen/provider/altera_senha_provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:garen/pages/login.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RedefinirSenha extends StatefulWidget {
  final String email;

  const RedefinirSenha({this.email});

  @override
  _RedefinirSenhaState createState() => _RedefinirSenhaState();
}

class _RedefinirSenhaState extends State<RedefinirSenha> {
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerConfirmSenha = TextEditingController();
  bool _textoObscuro = false;
  bool _visible = false;

  LocalizacaoServico _locate = new LocalizacaoServico();

  @override
  void initState() {
    _locate.iniciaLocalizacao(context);
    super.initState();
  }

  bool validarSenha(String senha) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(senha);
  }

  void _toggle() {
    if (_visible == true) {
    } else {
      setState(() {
        _visible = !_visible;
      });
    }
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
                      padding: EdgeInsets.only(top: size.height * 0.05, bottom: 61),
                      child: Image.asset('assets/images/garen-instalador-logo-v2.png',
                        width: 300,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 0),
                      child: Text("${_locate.locale['FORGOT']['redefine_password']}",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _controllerSenha,
                        obscureText: !_textoObscuro, //Isto sera usado para esconder ou mostrar o texto
                        style:
                            TextStyle(fontSize: 20, color: Color(0xffffffff)),
                        onChanged: (String value) async {
                          if (value == null) {
                            _visible = false;
                          } else {
                            _toggle();
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: "${_locate.locale['FORGOT']['password']}",
                          hintStyle:
                              TextStyle(fontSize: 20.0, color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1,
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Icon(Icons.lock, color: Colors.white),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _textoObscuro
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _textoObscuro = !_textoObscuro;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _controllerConfirmSenha,
                        obscureText:
                            !_textoObscuro, //Isto sera usado para esconder ou mostrar o texto
                        style:
                            TextStyle(fontSize: 20, color: Color(0xffffffff)),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText:
                              "${_locate.locale['FORGOT']['confirm_password']}",
                          hintStyle:
                              TextStyle(fontSize: 20.0, color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1,
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Icon(Icons.lock, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Consumer<AlteraSenhaManager>(
                        builder: (_, alteraSenhaManager, __) {
                      return Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 35, left: 20.0, right: 20.0),
                              child: ArgonButton(
                                height: 50,
                                roundLoadingShape: true,
                                width: size.width,
                                onTap: (startLoading, stopLoading,
                                    btnState) async {
                                  if (btnState == ButtonState.Idle) {
                                    startLoading();
                                    if (btnState == ButtonState.Busy) {
                                    } else {
                                      if (_controllerSenha.text == "" ||
                                          _controllerConfirmSenha.text == "") {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.ERROR,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title:
                                              '${_locate.locale['AWESOMEDIALOG']['title_2']}',
                                          desc:
                                              '${_locate.locale['AWESOMEDIALOG']['empty_fields']}',
                                          btnCancelText:
                                              '${_locate.locale['AWESOMEDIALOG']['btn_close']}',
                                          btnCancelOnPress: () {
                                            stopLoading();
                                          },
                                        )..show();
                                      } else {
                                        if (_controllerSenha.text !=
                                            _controllerConfirmSenha.text) {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.ERROR,
                                            animType: AnimType.BOTTOMSLIDE,
                                            title:
                                                '${_locate.locale['AWESOMEDIALOG']['title_2']}',
                                            desc:
                                                '${_locate.locale['AWESOMEDIALOG']['password_different']}',
                                            btnCancelText:
                                                '${_locate.locale['AWESOMEDIALOG']['btn_close']}',
                                            btnCancelOnPress: () {
                                              stopLoading();
                                            },
                                          )..show();
                                        } else {
                                          alteraSenhaManager.getAtualizarSenha(
                                              email: widget.email,
                                              atualizaSenha:
                                                  _controllerSenha.text,
                                              onSuccess: (v) async {
                                                if (v['retorno'] == "true") {
                                                  stopLoading();
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginPage()),
                                                      (route) => false);

                                                  /* Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage()));*/
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
                                                        '${_locate.locale['AWESOMEDIALOG']['something_go_wrong']}',
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
                                                  dialogType: DialogType.ERROR,
                                                  animType:
                                                      AnimType.BOTTOMSLIDE,
                                                  title:
                                                      '${_locate.locale['AWESOMEDIALOG']['title_2']}',
                                                  desc:
                                                      '${_locate.locale['AWESOMEDIALOG']['something_go_wrong']}',
                                                  btnCancelText:
                                                      '${_locate.locale['AWESOMEDIALOG']['btn_close']}',
                                                  btnCancelOnPress: () {
                                                    stopLoading();
                                                  },
                                                )..show();
                                              });
                                        }
                                      }
                                    }
                                  } else {}
                                },
                                child: Text(
                                  "${_locate.locale['SCHEDULE']['save']}",
                                  style: TextStyle(
                                      color: Color(0xFFfb4747),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                loader: Container(
                                  padding: EdgeInsets.all(10),
                                  child: SpinKitRotatingCircle(
                                    color: Color(0xFFfb4747),
                                    //size: 60 ,
                                  ),
                                ),
                                borderRadius: 5.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
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
