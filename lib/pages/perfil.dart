import 'dart:convert';
import 'package:garen/pages/login.dart';
import 'package:garen/pages/sobre.dart';
import 'package:garen/bloc/auth_bloc.dart';
import 'package:garen/pages/editarperfil.dart';
import 'package:garen/models/usuario_cadastro.dart';
import 'package:garen/components/idioma-selecao.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:garen/components/carregando_garen.dart';
import 'package:garen/servicos/logoff_servico.dart';
import 'package:garen/provider/user_provider.dart';
import 'package:garen/components/animation.dart';
import 'package:garen/utils/request.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class PerfilPage extends StatefulWidget {

  final String texto;

  PerfilPage(this.texto);

  @override
  _PerfilPageState createState() => _PerfilPageState();

}

class _PerfilPageState extends State<PerfilPage> {

  Color cor = Colors.grey[500];
  bool botaoligado = true;
  bool status = false;
  String codigo;
  String foto;
  String nome;
  String cep;
  String email;
  String telefone;
  Uint8List decodificada;
  String idiomaEnvio = "pt-br";

  RequestUtil _request = new RequestUtil();

  LocalizacaoServico _locate = new LocalizacaoServico();
  final GlobalKey<IdiomaSelecaoComponenteState> _idiomaComponenteKey =
      new GlobalKey<IdiomaSelecaoComponenteState>();

  //StreamSubscription<FirebaseUser> homeStateSubscription;

  @override
  void initState() {
    _locate.iniciaLocalizacao(context);
    carregaUsuarioLogado();
    super.initState();
  }

  carregaUsuarioLogado() async {

    codigo = await _request.obterIdInstaladorShared();

    if (widget.texto != null) {
      _request.saveIdInstaladorShared(codigoInstalador: widget.texto);
    }

    if (codigo != null) {
    } else {
      codigo = await _request.obterIdInstaladorShared();
    }

  }

  @override
  void dispose() {
    //homeStateSubscription.cancel();
    super.dispose();
  }

  void logOutUser() async {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);

    await authBloc.logout();

    await LogOffService().logoff();

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Size tamanho = MediaQuery.of(context).size;
    codigo = widget.texto;
    return LocalizacaoWidget(
      child: StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          body: Stack(children: <Widget>[
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
                height: tamanho.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg_azul.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: IntrinsicHeight(
                    child: Consumer<UserManager>(builder: (_, userManager, __) {
                      return FutureBuilder(
                        future: userManager.usuarioService.carregaPerfil(idInstalador: codigo ?? "nulo"),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.none && snapshot.hasData == null) {

                            return Center(
                              child: Text('${_locate.locale['AWESOMEDIALOG']['no_information2']}'),
                            );

                          } else 

                          if (snapshot.hasError) {

                            return Text("ERRO"); 

                          }else 

                          if (snapshot.data == null &&
                              snapshot.connectionState ==
                                  ConnectionState.waiting) {
                            return CarregandoScreen(
                              color: Colors.blue[900],
                              opacity: 0.5,
                            );
                          }

                          List lista = snapshot.data['data'];

                          if (lista.length == 0) {
                            return CarregandoScreen(
                              color: Colors.blue[900],
                              opacity: 0.5,
                            );
                          }

                          if (snapshot.hasData == null &&
                                  snapshot.connectionState ==
                                      ConnectionState.waiting ||
                              snapshot.data['data'] == null ||
                              lista.length == 0) {
                            return CarregandoScreen(
                              color: Colors.blue[900],
                              opacity: 0.5,
                            );
                          }

                          UsuarioCadastroModel instalador =
                              UsuarioCadastroModel(
                                  insCNome: snapshot.data['data'][0]
                                      ['ins_c_nome'],
                                  insCEmail: snapshot.data['data'][0]
                                      ['ins_c_email'],
                                  insCTelefone: snapshot.data['data'][0]
                                      ['ins_c_telefone'],
                                  insCImage: snapshot.data['data'][0]
                                      ['ins_c_image'],
                                  insCCEP: snapshot.data['data'][0]
                                      ['ins_c_cep']);

                          var nome = instalador.insCNome;

                          if (nome != "") {
                            botaoligado = true;
                          } else {
                            botaoligado = false;
                          }

                          if (instalador.insCImage == null) {
                            print("sem foto");
                          } else {
                            // decodificada = convertImage64(foto);

                          }

                          return Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: tamanho.height * 0.02),
                                  child: (instalador.insCImage == null &&
                                          instalador.insCNome == null)
                                      ? CircularProgressIndicator(
                                          backgroundColor: Colors.white)
                                      : (instalador.insCImage == null ||
                                              instalador.insCImage == "")
                                          ? Container(
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/foto.png"),
                                                    fit: BoxFit.cover,
                                                  )),
                                              width: 90,
                                              height: 90,
                                            )
                                          : Container(
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                  image: MemoryImage(
                                                      convertImage64(instalador
                                                          .insCImage)),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              width: 90,
                                              height: 90,
                                            )),
                              FadeInUp(
                                1,
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: tamanho.height * 0.03),
                                  child: Text(
                                    instalador.insCNome ??
                                        '${_locate.locale['PROFILE']['loading']}',
                                    style: GoogleFonts.encodeSans(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              ),
                              FadeInUp(
                                2,
                                Text(
                                    instalador.insCEmail ??
                                        '${_locate.locale['PROFILE']['loading']}',
                                    style: GoogleFonts.openSansCondensed(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w100)),
                              ),
                              FadeInUp(
                                3,
                                Text(
                                    instalador.insCTelefone ??
                                        '${_locate.locale['PROFILE']['loading']}',
                                    style: GoogleFonts.openSansCondensed(
                                      color: Colors.white,
                                      fontSize: 18,
                                    )),
                              ),
                              FadeInUp(
                                4,
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: tamanho.height * 0.025),
                                  child: GestureDetector(
                                    onTap: () => {
                                      vaParaEditaraPerfil(
                                          context, instalador, userManager)
                                    },
                                    child: Container(
                                      width: tamanho.width * 0.9,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
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
                                              "${_locate.locale['PROFILE']['edit_profile']}",
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
                              FadeInUp(
                                5,
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 15.0),
                                          child: GestureDetector(
                                            onTap: () => {
                                              print(foto),
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Sobre()))
                                            },
                                            child: Container(
                                              width: tamanho.width * 0.43,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Icon(
                                                Icons.info_rounded,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => logOutUser(),
                                          child: Container(
                                            width: tamanho.width * 0.42,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Icon(
                                              Icons.power_settings_new,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              FadeInUp(
                                6,
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 0, bottom: 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                              ),
                              FadeInUp(
                                7,
                                Center(
                                  child: Container(
                                    height: 40,
                                    child: IdiomaSelecaoComponente(
                                      key: _idiomaComponenteKey,
                                      atualizaIdioma: _atualizaIdioma,
                                      atualizaIdiomaDeEnvio:
                                          _atualizaIdiomaDeEnvio,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            
                          );
                          
                        },
                        
                      );
                    }),
                  ),
                ),
              ),
              // Positioned para a appBar usar comente o tamanho dela.
            ),
          ]),
        );
      }),
    );
  }

  vaParaEditaraPerfil(BuildContext context, UsuarioCadastroModel instalador,
      UserManager userManager) async {
    print(instalador.insCImage);
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditarPerfil(
                nome: instalador.insCNome,
                email: instalador.insCEmail,
                telefone: instalador.insCTelefone,
                image: convertImage64(instalador.insCImage ?? null),
                cep: instalador.insCCEP)));

    if (result == true) {
      setState(() {
        userManager.usuarioService.carregaPerfil();
      });
    }
  }

  _atualizaIdioma() async {
    await _locate.iniciaLocalizacao(context);
    setState(() {});
  }

  _atualizaIdiomaDeEnvio(String idioma) {
    idiomaEnvio = idioma;
  }

  convertImage64(String img64) {
    var _img64 = base64Decode(img64);
    return _img64;
  }
}
