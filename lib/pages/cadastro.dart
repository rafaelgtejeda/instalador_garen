import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:garen/pages/termos_uso.dart';
import 'package:garen/components/app_bar.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:garen/provider/user_provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:garen/servicos/viacep_servico.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:garen/servicos/localizacao/Localizacao_widget.dart';
import 'package:garen/servicos/ibge_estado_servico.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garen/models/usuario_cadastro.dart';
import 'package:garen/components/ProgressHUD.dart';
import 'package:garen/utils/validators/email.dart';
import 'package:garen/components/animation.dart';
import 'package:garen/pages/dashboard.dart';
import 'package:garen/bloc/auth_bloc.dart';
import 'package:garen/utils/request.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  LocalizacaoServico _locate = new LocalizacaoServico();

  String nome;
  String cidCod;
  String estado;
  String _result;
  String telefone;
  String novoCadastro;
  bool enable = true;
  String fotoCod;
  String estCod;
  String codigo;
  String email;

  RequestUtil _request = new RequestUtil();

  void initState() {
    _locate.iniciaLocalizacao(context);
    super.initState();
    carregaUsuarioLogado();
    pegarDados();
  }

  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
  }

  carregaUsuarioLogado() async {}

  pegarDados() async {

    await Future.delayed(const Duration(seconds: 3), () {});

    nome = await _request.obterNomeInstaladorShared();
    email = await _request.obterEmailInstaladorShared();
    telefone = await _request.obterTelefoneInstaladorShared();
    novoCadastro = await _request.obterNovoCadastroShared();
    codigo = await _request.obterIdInstaladorShared();

    _controllerNome.text = nome;
    _controllerEmail.text = email;
    _controllerTelefone.text = telefone;

    setState(() {
      enable = email == null ? true : false;
    });
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
    });
  }

  Future _searchCep() async {
    _searching(true);

    final cep = _controllerCEP.text;
    final resultCep = await ViaCepService.fetchCep(cep: cep);
    if (resultCep.uf == null) {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Erro',
          desc: 'Insira um Cep Valido',
          btnCancelText: 'Ok',
          btnCancelOnPress: () {})
        ..show();

      setState(() {
        _controllerCEP.text = "";
      });
    }
    String localidade = resultCep.localidade;
    String uf = resultCep.uf;
    cidCod = resultCep.ibge;

    // Exibindo somente a localidade no terminal

    setState(() {
      _result = resultCep.toJson();
    });

    if (_result.isNotEmpty) {
      _controllerCidade.text = localidade;
      _searchIBGE(uf);
    }

    _searching(false);
  }

  Future _searchIBGE(String uf) async {
    _searching(true);
    final estado = uf;
    final resultIbge = await IbgeEstadoService.fetchIBGE(ibge: estado);
    estCod = resultIbge.id.toString();

    setState(() {
      _result = resultIbge.toJson();
    });

    if (_result.isNotEmpty) {
      _controllerEstado.text = uf;
    }

    _searching(false);
  }

  var stateList;
  var sList;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerCidade = TextEditingController();
  final TextEditingController _controllerTelefone = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerEstado = TextEditingController();
  final TextEditingController _controllerCEP = TextEditingController();

  bool _textoObscuro = false;
  bool _visible = false;
  String dropdownValueState;

  var maskFormatter = new MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')}
  );

  void failOnLogin() async {

    var authBloc = Provider.of<AuthBloc>(context, listen: false);

    await authBloc.logout();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LocalizacaoWidget(
      child: StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ProgressHUD(
            child: Scaffold(
              key: _scaffoldKey,
              resizeToAvoidBottomInset: false,              
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
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg_azul.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        child: SingleChildScrollView(
                          child: Center(
                            child: new Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: HexColor("002d52"),
                              ),
                              child: Form(
                                key: _formKey,
                                child: Consumer<UserManager>(
                                  builder: (_, userManager, __) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        FadeInUp(
                                          1,
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 31, bottom: 41),
                                            child: RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 36),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          '${_locate.locale['SIGNUP']['title_line_1']}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'GarenFont',
                                                          fontSize: 30,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w100)),
                                                  TextSpan(
                                                      text:
                                                          '${_locate.locale['SIGNUP']['title_line_2']}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'GarenFont',
                                                          fontSize: 30,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        FadeInUp(
                                          2,
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              controller: _controllerNome,
                                              style: new TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                hintText:
                                                    '${_locate.locale['SIGNUP']['name']}',
                                                hintStyle: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                prefixIcon: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15, right: 15),
                                                  child: Icon(Icons.person,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              validator: (name) {
                                                if (name.isEmpty)
                                                  return '${_locate.locale['SIGNUP']['warn_name']}';
                                                else
                                                  return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        FadeInUp(
                                          3,
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              enabled: enable,
                                              controller: _controllerEmail,
                                              style: enable
                                                  ? new TextStyle(
                                                      color: Colors.white)
                                                  : new TextStyle(
                                                      color: Colors.grey[400]),
                                              decoration: InputDecoration(
                                                hintText:
                                                    '${_locate.locale['SIGNUP']['email']}',
                                                hintStyle: enable
                                                    ? TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.white)
                                                    : TextStyle(
                                                        fontSize: 15.0,
                                                        color:
                                                            Colors.grey[400]),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey[500],
                                                    width: 1,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
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
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              validator: (email) {
                                                if (email.isEmpty)
                                                  return '${_locate.locale['SIGNUP']['warn_email']}';
                                                else if (!emailValid(email))
                                                  return '${_locate.locale['ACCREDITATION']['please_enter_valid_email']}';
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        FadeInUp(
                                          4,
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              controller: _controllerTelefone,
                                              keyboardType: TextInputType.phone,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                TelefoneInputFormatter(),
                                              ],
                                              style: new TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                hintText:
                                                    '${_locate.locale['SIGNUP']['cell_phone']}',
                                                hintStyle: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                prefixIcon: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15, right: 15),
                                                  child: Icon(
                                                      Icons.phone_android,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              validator: (phone) {
                                                if (phone.isEmpty)
                                                  return '${_locate.locale['SIGNUP']['warn_cell_phone']}';
                                                else if (phone.length < 14)
                                                  return '${_locate.locale['ACCREDITATION']['please_enter_valid_phone']}';
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        FadeInUp(
                                          5,
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: TextFormField(
                                              controller: _controllerCEP,
                                              inputFormatters: [maskFormatter],
                                              onChanged: (String value) async {
                                                if (value.length < 9) {
                                                  setState(() {
                                                    _controllerCidade.text = "";
                                                    _controllerEstado.text = "";
                                                  });
                                                } else {
                                                  _searchCep();
                                                }
                                                if (value.length == 1) {}
                                              },
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                hintText: "CEP",
                                                hintStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey[300]),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                prefixIcon: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15, right: 15),
                                                  child: Icon(Icons.map,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              validator: (cep) {
                                                if (cep.isEmpty)
                                                  return '${_locate.locale['ACCREDITATION']['zip_code']}';
                                                else if (cep.length < 9)
                                                  return '${_locate.locale['ACCREDITATION']['please_enter_zip_code']}';
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: size.width,
                                          height: 55,
                                          child: Row(
                                            children: [
                                              Flexible(
                                                flex: 3,
                                                child: FadeInUp(
                                                  7,
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, right: 8),
                                                    child: TextField(
                                                      enabled: false,
                                                      controller:
                                                          _controllerCidade,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                          fontSize: 15),
                                                      decoration:
                                                          InputDecoration(
                                                        fillColor: Colors.white,
                                                        hintText:
                                                            "${_locate.locale['ACCREDITATION']['city']}",
                                                        hintStyle: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors
                                                                .grey[400]),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(5),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors
                                                                .grey[500],
                                                            width: 1,
                                                          ),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(1),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        prefixIcon: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 15,
                                                                  right: 15),
                                                          child: Icon(Icons.map,
                                                              color: Colors
                                                                  .grey[500]),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: FadeInUp(
                                                  6,
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, right: 8),
                                                    child: TextField(
                                                      enabled: false,
                                                      controller:
                                                          _controllerEstado,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                          fontSize: 15),
                                                      decoration:
                                                          InputDecoration(
                                                        fillColor: Colors.white,
                                                        hintText:
                                                            "${_locate.locale['ACCREDITATION']['state']}",
                                                        hintStyle: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors
                                                                .grey[400]),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(5),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors
                                                                .grey[500],
                                                            width: 1,
                                                          ),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(5),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors
                                                                .grey[500],
                                                            width: 1,
                                                          ),
                                                        ),
                                                        prefixIcon: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 15,
                                                                  right: 15),
                                                          child: Icon(Icons.map,
                                                              color: Colors
                                                                  .grey[500]),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        FadeInUp(
                                          8,
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 8.0,
                                                bottom: 8.0),
                                            child: TextFormField(
                                              validator: (pass) {
                                                if (pass.isEmpty)
                                                  return '${_locate.locale['AWESOMEDIALOG']['empty_fields']}';
                                                else if (pass.length < 6)
                                                  return '${_locate.locale['SIGNUP']['warn_confirm_password']}';
                                                return null;
                                              },
                                              keyboardType: TextInputType.text,
                                              controller: _controllerPassword,
                                              obscureText: !_textoObscuro,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xffffffff)),
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
                                                    "${_locate.locale['SIGNUP']['password']}",
                                                hintStyle: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                prefixIcon: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15, right: 15),
                                                  child: Icon(Icons.lock,
                                                      color: Colors.white),
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
                                                      _textoObscuro =
                                                          !_textoObscuro;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        FadeInUp(
                                          9,
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0),
                                            child: new TextFormField(
                                              validator: (cPassword) {
                                                if (cPassword.isEmpty)
                                                  return '${_locate.locale['SIGNUP']['password']}';
                                                else if (cPassword !=
                                                    _controllerPassword.text)
                                                  return '${_locate.locale['SIGNUP']['warn_confirm_password']}';
                                                return null;
                                              },
                                              keyboardType: TextInputType.text,
                                              controller:
                                                  _controllerConfirmPassword,
                                              obscureText:
                                                  !_textoObscuro, //Isto sera usado para esconder ou mostrar o texto
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xffffffff)),
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                hintText:
                                                    "${_locate.locale['SIGNUP']['confirm_password']}",
                                                hintStyle: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                prefixIcon: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15, right: 15),
                                                  child: Icon(Icons.lock,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        FadeInUp(
                                          10,
                                          Container(
                                              padding: EdgeInsets.all(13),
                                              child: RichText(
                                                text: TextSpan(
                                                    text: '${_locate.locale['SIGNUP']['on_register_line_1']}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: '${_locate.locale['SIGNUP']['on_register_line_2']}',
                                                          style: TextStyle(
                                                            color: Colors.redAccent,
                                                            fontSize: 18
                                                          ),
                                                          recognizer: TapGestureRecognizer()
                                                                ..onTap =
                                                                    () async {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              TermosUso()));
                                                                })
                                                    ]),
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        FadeInUp(
                                          11,
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0, bottom: 0),
                                            child: ArgonButton(
                                              height: 50,
                                              roundLoadingShape: true,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.81,
                                              onTap: (startLoading, stopLoading,
                                                  btnState) {
                                                startLoading();

                                                if (_formKey.currentState
                                                    .validate()) {
                                                  setState(() {
                                                    isApiCallProcess = true;
                                                  });

                                                  if (_controllerPassword
                                                          .text !=
                                                      _controllerConfirmPassword
                                                          .text) {
                                                    stopLoading();

                                                    setState(() {
                                                      isApiCallProcess = false;
                                                      _scaffoldKey.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            '${_locate.locale['SIGNUP']['warn_password_different']}'),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ));
                                                    });
                                                  } else {
                                                    if (novoCadastro ==
                                                        "true") {
                                                      userManager
                                                          .atualizaCadastro(
                                                              cadastro: UsuarioCadastroModel(
                                                                  insNCodigo:
                                                                      codigo,
                                                                  insCEmail:
                                                                      _controllerEmail
                                                                          .text,
                                                                  insCNome:
                                                                      _controllerNome
                                                                          .text,
                                                                  insCTelefone:
                                                                      _controllerTelefone
                                                                          .text,
                                                                  insCPassword:
                                                                      _controllerPassword
                                                                          .text,
                                                                  insCidNCodigo:
                                                                      cidCod,
                                                                  insEstNCodigo:
                                                                      estCod,
                                                                  insBNovoCadastro:
                                                                      false),
                                                              onSuccess:
                                                                  (v) async {
                                                                _request.saveNovoCadastroShared(
                                                                    cadastroInstalador:
                                                                        false
                                                                            .toString());
                                                                _request.saveIdInstaladorShared(
                                                                    codigoInstalador:
                                                                        codigo);

                                                                if (await v != null && v.toString() != "{retorno: duplicado}") {

                                                                  AwesomeDialog(

                                                                    context: context,

                                                                    dialogType: DialogType.SUCCES,

                                                                    animType: AnimType.BOTTOMSLIDE,
                                                                    
                                                                    title: '${_locate.locale['AWESOMEDIALOG']['congrats']}',

                                                                    desc: '${_locate.locale['AWESOMEDIALOG']['successfully_created']}',

                                                                    btnOkText: '${_locate.locale['AWESOMEDIALOG']['btn_close']}',

                                                                    btnOkOnPress: () {

                                                                      stopLoading();

                                                                      Navigator.push(

                                                                        context,

                                                                        MaterialPageRoute(

                                                                          builder: (context) => DashboardPage(idInstalador: codigo)

                                                                        )

                                                                      );
                                                                    }

                                                                  )..show();

                                                                  setState(() {
                                                                    isApiCallProcess = false;
                                                                  });

                                                                  stopLoading();

                                                                } else {

                                                                  AwesomeDialog(

                                                                    context: context,

                                                                    dialogType: DialogType.ERROR,

                                                                    animType: AnimType.BOTTOMSLIDE,

                                                                    title: 'Ops...',

                                                                    desc: '${_locate.locale['SIGNUP']['warn_user_exists']}',

                                                                    btnCancelText: '${_locate.locale['BUDGET']['close']}',

                                                                    btnCancelOnPress: () {

                                                                      stopLoading();

                                                                    },

                                                                  )..show();

                                                                  setState(() {

                                                                    isApiCallProcess = false;
                                                                    
                                                                  });

                                                                  stopLoading();
                                                                }

                                                              },

                                                              onFail: (e) {

                                                                setState(() {

                                                                  isApiCallProcess = false;

                                                                });

                                                                _scaffoldKey
                                                                  .currentState
                                                                  .showSnackBar(
                                                                    SnackBar(
                                                                      content: Text('${_locate.locale['AWESOMEDIALOG']['fail_to_login']}: $e'),
                                                                      backgroundColor: Colors.red,
                                                                    )
                                                                  );

                                                                setState(() {
                                                                  isApiCallProcess = false;
                                                                });

                                                              }
                                                          );
                                                    } else {
                                                      userManager.cadastro(

                                                          cadastro: UsuarioCadastroModel(

                                                                 insCNome: _controllerNome.text,
                                                                insCEmail: _controllerEmail.text,
                                                             insCTelefone: _controllerTelefone.text,
                                                             insCPassword: _controllerPassword.text,                                                            
                                                                  insCCEP: _controllerCEP.text,

                                                            insCidNCodigo: cidCod,
                                                            insEstNCodigo: estCod,

                                                            insBNovoCadastro: false

                                                          ),
                                                          onSuccess: (v) async {
                                                            _request.saveNovoCadastroShared(
                                                                cadastroInstalador:
                                                                    false);
                                                            _request.saveIdInstaladorShared(
                                                                codigoInstalador:
                                                                    codigo);

                                                            if (await v !=
                                                                    null &&
                                                                v.toString() !=
                                                                    "{retorno: duplicado}") {
                                                              AwesomeDialog(
                                                                  context:
                                                                      context,
                                                                  dialogType:
                                                                      DialogType
                                                                          .SUCCES,
                                                                  animType: AnimType
                                                                      .BOTTOMSLIDE,
                                                                  title:
                                                                      '${_locate.locale['AWESOMEDIALOG']['congrats']}',
                                                                  desc:
                                                                      '${_locate.locale['AWESOMEDIALOG']['successfully_created']}',
                                                                  btnOkText:
                                                                      '${_locate.locale['AWESOMEDIALOG']['btn_close']}',
                                                                  btnOkOnPress:
                                                                      () {
                                                                    stopLoading();

                                                                    Navigator.pushNamedAndRemoveUntil(
                                                                        context,
                                                                        "/login",
                                                                        (route) =>
                                                                            false);
                                                                  })
                                                                ..show();

                                                              setState(() {
                                                                isApiCallProcess =
                                                                    false;
                                                              });

                                                              stopLoading();
                                                            } else {
                                                              AwesomeDialog(
                                                                context:
                                                                    context,
                                                                dialogType:
                                                                    DialogType
                                                                        .ERROR,
                                                                animType: AnimType
                                                                    .BOTTOMSLIDE,
                                                                title: 'Ops...',
                                                                desc:
                                                                    '${_locate.locale['SIGNUP']['warn_user_exists']}',
                                                                btnCancelText:
                                                                    '${_locate.locale['BUDGET']['close']}',
                                                                btnCancelOnPress:
                                                                    () {
                                                                  failOnLogin();
                                                                  stopLoading();
                                                                },
                                                              )..show();

                                                              setState(() {
                                                                isApiCallProcess =
                                                                    false;
                                                              });

                                                              stopLoading();
                                                            }
                                                          },
                                                          onFail: (e) {
                                                            setState(() {
                                                              isApiCallProcess =
                                                                  false;
                                                            });

                                                            _scaffoldKey
                                                                .currentState
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                  '${_locate.locale['AWESOMEDIALOG']['fail_to_login']}: $e'),
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ));

                                                            setState(() {
                                                              isApiCallProcess =
                                                                  false;
                                                            });
                                                          });
                                                    }
                                                  }
                                                } else {
                                                  stopLoading();
                                                }
                                              },
                                              child: Text(
                                                "${_locate.locale['SIGNUP']['btn_register']}"
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              loader: Container(
                                                padding: EdgeInsets.all(10),
                                                child: SpinKitRotatingCircle(
                                                  color: Colors.pink[900],
                                                  // size: loaderWidth ,
                                                ),
                                              ),
                                              borderRadius: 5.0,
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 60,
                                        ),
                                      ],
                                    );
                                  },
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
            ),
            inAsyncCall: isApiCallProcess,
            opacity: 0.3);
      }),
    );
  }
}
