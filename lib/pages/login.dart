import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:garen/models/login_model.dart';
import 'package:garen/provider/user_provider.dart';
import 'package:garen/utils/validators/email.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_cmoon_icons/flutter_cmoon_icons.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:garen/servicos/refresh_token_servico.dart';
import 'package:garen/components/idioma-selecao.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:garen/pages/dashboard.dart';
import 'package:garen/pages/cadastro.dart';
import 'package:garen/bloc/auth_bloc.dart';
import 'package:garen/utils/request.dart';
import 'package:hexcolor/hexcolor.dart';

import 'esqueciSenha.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  RequestUtil _requestUtil = new RequestUtil();

  bool hidePassword = true;
  bool isApiCallProcess = false;

  bool _visible = false;
  bool _textoObscuro = false;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();

  final FocusNode _nodeEmail = FocusNode();
  final FocusNode _nodePass = FocusNode();

  LocalizacaoServico _locate = new LocalizacaoServico();
  RefreshTokenServico _servicoRefresh = new RefreshTokenServico();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<IdiomaSelecaoComponenteState> _idiomaComponenteKey =
      new GlobalKey<IdiomaSelecaoComponenteState>();

  String email;
  String senha;
  String idiomaEnvio = "pt-br";
  String contEmail;
  String contSenha;
  String logado;

  void _toggle() {
    if (_visible == true) {
    } else {
      setState(() {
        _visible = !_visible;
      });
    }
  }

  @override
  void initState() {
    _locate.iniciaLocalizacao(context);
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    carregaUsuarioLogado();
    _verificaLogado();
  }

  carregaUsuarioLogado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      email = prefs.getString('ins_c_email');
      _controllerEmail.text = email;
    });
  }

  @override
  void dispose() {
    _nodeEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

    Size tamanho = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: LocalizacaoWidget(
        child: StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: HexColor("004370"),
              body: Container(
                height: tamanho.height,
                width: tamanho.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg_azul.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Consumer<UserManager>(builder: (_, userManager, __) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: tamanho.height * 0.05, bottom: 61),
                              child: Image.asset(
                                'assets/images/garen-instalador-logo-v2.png',
                                width: 300,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: TextFormField(
                                controller: _controllerEmail,
                                focusNode: _nodeEmail,
                                style: new TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintText:
                                      '${_locate.locale['LOGIN']['email']}',
                                  hintStyle: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                  prefixIcon: Padding(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child:
                                        Icon(Icons.person, color: Colors.white),
                                  ),
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
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autocorrect: false,
                                validator: (email) {
                                  if (!emailValid(email))
                                    setState(() {
                                      return '${_locate.locale['LOGIN']['email_error']}';
                                    });
                                  return null;
                                },
                                onFieldSubmitted: (term) {
                                  _nodeEmail.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_nodePass);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _controllerPass,
                                obscureText:
                                    !_textoObscuro, //Isto sera usado para esconder ou mostrar o texto
                                style: TextStyle(
                                    fontSize: 20, color: Color(0xffffffff)),
                                onChanged: (String value) async {
                                  if (value == null) {
                                    _visible = false;
                                  } else {
                                    _toggle();
                                  }
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintText:
                                      "${_locate.locale['LOGIN']['password']}",
                                  hintStyle: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
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
                                    padding:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child:
                                        Icon(Icons.lock, color: Colors.white),
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
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, bottom: 8, right: 13),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      "${_locate.locale['LOGIN']['forgot_password']}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 18,
                                          color: Colors.white)),
                                ),
                              ),
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EsqueciSenha()))
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 24, bottom: 18),
                              child: ArgonButton(
                                height: 50,
                                roundLoadingShape: true,
                                width: MediaQuery.of(context).size.width * 0.81,
                                onTap: (startLoading, stopLoading,
                                    btnState) async {
                                  if (btnState == ButtonState.Idle) {
                                    startLoading();
                                    if (btnState == ButtonState.Busy) {
                                    } else {
                                      login(userManager, stopLoading);
                                    }
                                  } else {}
                                },
                                child: Text(
                                  "${_locate.locale['LOGIN']['login']}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                loader: Container(
                                  padding: EdgeInsets.all(10),
                                  child: SpinKitRotatingCircle(
                                    color: Colors.white,
                                    //size: 60 ,
                                  ),
                                ),
                                borderRadius: 5.0,
                                color: Color(0xFFfb4747),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.all(13),
                                child: RichText(
                                  text: TextSpan(
                                      text:
                                          '${_locate.locale['LOGIN']['register-line-1']}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                ' ${_locate.locale['LOGIN']['register-line-2']}',
                                            style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 14),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CadastroPage()));
                                              })
                                      ]),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: new Container(
                                        margin: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: Divider(
                                          color: Colors.white,
                                          height: 30,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          "${_locate.locale['LOGIN']['or_social']}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  Expanded(
                                    child: new Container(
                                        margin: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: Divider(
                                          color: Colors.white,
                                          height: 30,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: IconButton(
                                          icon: FaIcon(FontAwesomeIcons.google,
                                              color: Colors.white),
                                          onPressed: () {
                                            authBloc.loginGoogle();
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8),
                                      child: IconButton(
                                          icon: CIcon(IconMoon.icon_facebook2,
                                              color: Colors.white),
                                          onPressed: () {
                                            authBloc.loginFacebook();
                                          }),
                                    ),
                                    Visibility(
                                      visible: Platform.isIOS,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: IconButton(
                                            icon: FaIcon(
                                              FontAwesomeIcons.apple,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              authBloc.loginApple();
                                            }),
                                      ),
                                    )
                                  ],
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 0, bottom: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: new Container(
                                        margin: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: Divider(
                                          color: Colors.white,
                                          height: 30,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          "${_locate.locale['LOGIN']['select_languagem']}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  Expanded(
                                    child: new Container(
                                        margin: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: Divider(
                                          color: Colors.white,
                                          height: 30,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 40,
                                child: IdiomaSelecaoComponente(
                                  key: _idiomaComponenteKey,
                                  atualizaIdioma: _atualizaIdioma,
                                  atualizaIdiomaDeEnvio: _atualizaIdiomaDeEnvio,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }

  login(userManager, Function stopLoading) {
    contEmail = _controllerEmail.text;
    contSenha = _controllerPass.text;
    if (contEmail == "" || contSenha == "") {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: '${_locate.locale['AWESOMEDIALOG']['title_2']}',
        desc: '${_locate.locale['AWESOMEDIALOG']['empty_fields']}',
        btnCancelText: '${_locate.locale['AWESOMEDIALOG']['btn_close']}',
        btnCancelOnPress: () {
          stopLoading();
        },
      )..show();
    } else {
      setState(() {
        isApiCallProcess = true;
      });

      userManager.autenticar(
          login: LoginModel(
              insCEmail: _controllerEmail.text,
              insCPassword: _controllerPass.text),
          onSuccess: (v) async {
            if (await v != null &&
                v.toString() != "{erro: Usuário ou senha Inválidos}") {
              _requestUtil.saveIdInstaladorShared(
                  codigoInstalador: v['ins_n_codigo']);
              _refreshToken();
              stopLoading();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DashboardPage()));
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.BOTTOMSLIDE,
                title: '${_locate.locale['AWESOMEDIALOG']['title_2']}',
                desc: '${_locate.locale['AWESOMEDIALOG']['invalid_user']}',
                btnCancelText:
                    '${_locate.locale['AWESOMEDIALOG']['btn_close']}',
                btnCancelOnPress: () {
                  stopLoading();
                },
              )..show();
              stopLoading();
              setState(() {
                isApiCallProcess = false;
              });
            }
          },
          onFail: (e) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(
                  '${_locate.locale['AWESOMEDIALOG']['fail_to_login']} + $e'),
              backgroundColor: Colors.red,
            ));
            stopLoading();
            setState(() {
              isApiCallProcess = false;
            });
          });
    }
  }

  _verificaLogado() async {
    var authBlocF = Provider.of<AuthBloc>(context, listen: false);

    authBlocF.verificaUsuarioLogado();

    authBlocF.isSessionValid.listen((event) async {
      if (event) {
        String primeiraVez = await _requestUtil.obterNovoCadastroShared();
        if (primeiraVez == "true") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CadastroPage()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DashboardPage()));
        }
      }
    });
  }

  _atualizaIdioma() async {
    await _locate.iniciaLocalizacao(context);
    setState(() {});
  }

  _atualizaIdiomaDeEnvio(String idioma) {
    idiomaEnvio = idioma;
  }

  _refreshToken() {
    _servicoRefresh.getRefreshToken();
  }
}
