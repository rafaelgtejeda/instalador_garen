import 'package:flutter/material.dart';
import 'package:garen/components/app_bar.dart';
import 'package:garen/pages/redefinirSenha.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:provider/provider.dart';
import 'package:garen/provider/altera_senha_provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EsqueciSenhaToken extends StatefulWidget {
  final String email;

  const EsqueciSenhaToken({this.email});

  @override
  _EsqueciSenhaTokenState createState() => _EsqueciSenhaTokenState();
}

class _EsqueciSenhaTokenState extends State<EsqueciSenhaToken> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final PageController _pageController = PageController(initialPage: 1);
  int pageIndex = 0;

  LocalizacaoServico _locate = new LocalizacaoServico();

  void initState() {
    _locate.iniciaLocalizacao(context);
    super.initState();
  }

  Widget onlySelectedBorderPinPut() {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: const Color.fromRGBO(235, 236, 237, 1),
      borderRadius: BorderRadius.circular(5.0),
    );
    return Form(
      key: _formKey,
      child: GestureDetector(
        onLongPress: () {},
        child: PinPut(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.text,
          withCursor: true,
          fieldsCount: 6,
          fieldsAlignment: MainAxisAlignment.spaceAround,
          textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
          eachFieldMargin: EdgeInsets.all(0),
          eachFieldWidth: 45.0,
          eachFieldHeight: 55.0,
          focusNode: _pinPutFocusNode,
          controller: _pinPutController,
          submittedFieldDecoration: pinPutDecoration,
          selectedFieldDecoration: pinPutDecoration.copyWith(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: Colors.red,
            ),
          ),
          followingFieldDecoration: pinPutDecoration,
          pinAnimationType: PinAnimationType.scale,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pinPuts = [
      onlySelectedBorderPinPut(),
    ];

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
            body: Consumer<AlteraSenhaManager>(
                builder: (_, alteraSenhaManager, __) {
              return Container(
                child: Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    Builder(
                      builder: (context) {
                        context = context;
                        return AnimatedContainer(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/bg_azul.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: PageView(
                            scrollDirection: Axis.vertical,
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() => pageIndex = index);
                            },
                            children: _pinPuts.map((p) {
                              return FractionallySizedBox(
                                heightFactor: 1.0,
                                child: Center(child: p),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "${_locate.locale['FORGOT']['token']}",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 45.0),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            widget.email,
                            style:
                                TextStyle(color: Colors.yellow, fontSize: 16),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${_locate.locale['FORGOT']['insert_token']}",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ArgonButton(
                          height: 50,
                          roundLoadingShape: true,
                          width: MediaQuery.of(context).size.width * 0.81,
                          onTap: (startLoading, stopLoading, btnState) async {
                            if (btnState == ButtonState.Idle) {
                              startLoading();
                              if (btnState == ButtonState.Busy) {
                              } else {
                                if (_pinPutController.text.length < 6) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title:
                                        '${_locate.locale['AWESOMEDIALOG']['title_2']}',
                                    desc:
                                        '${_locate.locale['AWESOMEDIALOG']['invalid_token']}',
                                    btnCancelText:
                                        '${_locate.locale['AWESOMEDIALOG']['btn_close']}',
                                    btnCancelOnPress: () {},
                                  )..show();
                                } else {
                                  alteraSenhaManager.getValidarToken(
                                      email: widget.email,
                                      validaToken:
                                          _pinPutController.text.toUpperCase(),
                                      onSuccess: (v) async {
                                        if (v['retorno'] == "true") {
                                          stopLoading();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RedefinirSenha(
                                                          email:
                                                              widget.email)));
                                        } else {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.ERROR,
                                            animType: AnimType.BOTTOMSLIDE,
                                            title:
                                                '${_locate.locale['AWESOMEDIALOG']['title_2']}',
                                            desc:
                                                '${_locate.locale['AWESOMEDIALOG']['invalid_token']}',
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
                                          animType: AnimType.BOTTOMSLIDE,
                                          title:
                                              '${_locate.locale['AWESOMEDIALOG']['title_2']}',
                                          desc:
                                              '${_locate.locale['AWESOMEDIALOG']['invalid_token']}',
                                          btnCancelText:
                                              '${_locate.locale['AWESOMEDIALOG']['btn_close']}',
                                          btnCancelOnPress: () {
                                            stopLoading();
                                          },
                                        )..show();
                                      });
                                }
                              }
                            } else {}
                          },
                          child: Text(
                            "${_locate.locale['FORGOT']['btn_send']}",
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
                    ),
                  ],
                ),
              );
            }));
      }),
    );
  }
}
