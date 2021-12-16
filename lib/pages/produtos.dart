import 'package:flutter/material.dart';
import 'package:garen/components/animation.dart';
import 'package:garen/components/carregando_garen.dart';
import 'package:garen/provider/catalogo_provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaBasculante extends StatefulWidget {
  final String nome;

  TelaBasculante({Key key, @required this.nome}) : super(key: key);

  @override
  _TelaBasculanteState createState() => _TelaBasculanteState();
}

class _TelaBasculanteState extends State<TelaBasculante> {
  LocalizacaoServico _locate = new LocalizacaoServico();

  @override
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_azul.png"),
                fit: BoxFit.cover,
              ),
            ),
            width: tamanho.width,
            height: tamanho.height * 1.5,
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${_locate.locale['PRODUCT']['all']}",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.nome,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w900)),
                      ),
                      Visibility(
                        visible: true,
                        child: carregaProdutos(
                            "${_locate.locale['AWESOMEDIALOG']['no_informacao2']}",
                            "${_locate.locale['PRODUCT']['details']}",
                            "${_locate.locale['PRODUCT']['manual']}",
                            "${_locate.locale['PRODUCT']['exploded_view']}"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

Widget carregaProdutos(String semInformacao, String nomDetalhe,
    String nomManual, String nomVista) {
  return Consumer<CatalogoManager>(builder: (_, catalogoManager, __) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.hasData == null) {
          return Center(
            child: Text(semInformacao),
          );
        } else if (snapshot.data == null &&
            snapshot.connectionState == ConnectionState.waiting) {
          return CarregandoScreen(
            color: Colors.blue[900],
            opacity: 0.5,
          );
        }
        print(snapshot.data.length);
        return Flexible(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              print(snapshot.data[0].title);

              return Padding(
                padding: const EdgeInsets.only(
                    top: 11.0, left: 18.0, bottom: 0.0, right: 18.0),
                child: InkWell(
                  onTap: () async {},
                  child: FadeInUp(
                      index,
                      ItemLista(
                        nomDetalhe: nomDetalhe,
                        nomManual: nomManual,
                        nomVista: nomVista,
                        nome: snapshot.data[index].title,
                        foto: snapshot.data[index].imagens,
                        detalhe: snapshot.data[index].guid,
                        vista: snapshot.data[0].visaoExplodida,
                        manual: snapshot.data[0].manual,
                        onPressdetalhes: () =>
                            {print(snapshot.data[index].guid)},
                        onPressmanual: () => {print(snapshot.data[0].manual)},
                        onPressvista: () =>
                            {print(snapshot.data[index].visaoExplodida)},
                      )),
                ),
              );
            },
          ),
        );
      },
      future: catalogoManager.categoService.getProdutos(),
    );
  });
}

class ItemLista extends StatelessWidget {
  final String nomDetalhe;
  final String nomManual;
  final String nomVista;
  final String nome;
  final String foto;
  final String detalhe;
  final String vista;
  final String manual;
  final Function onPressmanual;
  final Function onPressvista;
  final Function onPressdetalhes;

  const ItemLista(
      {Key key,
      this.nomDetalhe,
      this.nomManual,
      this.nomVista,
      @required this.nome,
      this.foto,
      this.detalhe,
      this.manual,
      this.vista,
      this.onPressmanual,
      this.onPressdetalhes,
      this.onPressvista})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size tamanho = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0x00dd0008),
          border: Border.all(color: Color(0xff9e0301), width: 3),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
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
        height: 160,
        width: tamanho.width * 0.9,
        child: Row(
          children: [
            Container(
              width: tamanho.width * 0.43,
              height: 155,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
              child: Column(
                children: [
                  Text(nome,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      )),
                  FadeInImage.assetNetwork(
                    placeholder: 'assets/gifs/loading.gif',
                    image: foto,
                    fit: BoxFit.fill,
                    height: 120,
                  ),
                ],
              ),
            ),
            Container(
              width: tamanho.width * 0.445,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color(0xff9e0301),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15, left: 2),
                            child: Container(
                              width: tamanho.width * 0.36,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color(0xff112e4e),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(50),
                                    bottomRight: Radius.circular(60),
                                    bottomLeft: Radius.circular(40),
                                    topLeft: Radius.circular(40)),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: tamanho.width * 0.02),
                                    child: Text(
                                      nomDetalhe,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: tamanho.height * 0.015,
                              ),
                              child: GestureDetector(
                                onTap: () => launch(detalhe),
                                child: Container(
                                  width: 38,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            tamanho.height * 0.3),
                                        bottomLeft: Radius.circular(
                                            tamanho.height * 0.3),
                                        bottomRight: Radius.circular(
                                            tamanho.height * 0.3),
                                        topRight: Radius.circular(
                                            tamanho.height * 0.3)),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: vista != "" ? true : false,
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 15, left: 2),
                              child: Container(
                                width: tamanho.width * 0.36,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Color(0xffe2a83e),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50),
                                      bottomRight: Radius.circular(60),
                                      bottomLeft: Radius.circular(40),
                                      topLeft: Radius.circular(40)),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: tamanho.width * 0.02),
                                      child: Text(
                                        nomVista,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: tamanho.height * 0.015,
                                ),
                                child: GestureDetector(
                                  onTap: () => launch(vista),
                                  child: Container(
                                    width: 38,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              tamanho.height * 0.3),
                                          bottomLeft: Radius.circular(
                                              tamanho.height * 0.3),
                                          bottomRight: Radius.circular(
                                              tamanho.height * 0.3),
                                          topRight: Radius.circular(
                                              tamanho.height * 0.3)),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: manual != "" ? true : false,
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 15, left: 2),
                              child: Container(
                                width: tamanho.width * 0.36,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Color(0xffc11c3a),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50),
                                      bottomRight: Radius.circular(60),
                                      bottomLeft: Radius.circular(40),
                                      topLeft: Radius.circular(40)),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: tamanho.width * 0.02),
                                      child: Text(
                                        nomManual,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: tamanho.height * 0.015,
                                ),
                                child: GestureDetector(
                                  onTap: () => launch(manual),
                                  child: Container(
                                    width: 38,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              tamanho.height * 0.3),
                                          bottomLeft: Radius.circular(
                                              tamanho.height * 0.3),
                                          bottomRight: Radius.circular(
                                              tamanho.height * 0.3),
                                          topRight: Radius.circular(
                                              tamanho.height * 0.3)),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
