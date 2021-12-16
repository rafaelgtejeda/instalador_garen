
import 'package:flutter/material.dart';
import 'package:garen/components/animation.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/provider/catalogo_provider.dart';
import 'package:garen/components/carregando_garen.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class TelaAutomatizador extends StatefulWidget {


  final String abertura;
  final String fluxo_de_uso;
  final String velocidade;
  final String comprimento_da_folha;

  TelaAutomatizador({ 
                   
                      Key key, 
                      @required this.abertura,
                      @required this.fluxo_de_uso,
                      @required this.velocidade,
                      @required this.comprimento_da_folha,
                           
                   }) : super(key: key);

  @override
  _TelaAutomatizadorState createState() => _TelaAutomatizadorState();
}

class _TelaAutomatizadorState extends State<TelaAutomatizador> {

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

              color: Colors.white,
              
            ),

            title: Image.asset(

              "assets/images/logo-branco.png",

              fit: BoxFit.cover,

              width: 100,

            ),

            centerTitle: true,

            actions: <Widget>[],

            bottom: PreferredSize(

              preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.005),

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
                        ]

                    )

                  ),

                  height: 5

              ),

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
            
            height: tamanho.height,

            child: SingleChildScrollView(

              child: Column(

                children: [

                  Padding(

                    padding: const EdgeInsets.all(8.0),
                    
                    child: Text("",

                      style: TextStyle(
                    
                        color: Colors.white, 
                    
                        fontSize: 20

                      )

                    ),

                  ),

                  Padding(

                    padding: const EdgeInsets.all(8.0),

                    child: Text("",
                        
                        style: TextStyle(

                            color: Colors.white,

                            fontSize: 25,

                            fontWeight: FontWeight.w900

                        )

                    ),

                  ),

                  Consumer<CatalogoManager>(builder: (_, catalogoManager, __) {
                        
                        return FutureBuilder(
                            
                            builder: (context, AsyncSnapshot snapshot) {

                              if (snapshot.connectionState == ConnectionState.none && snapshot.hasData == null) {
                                
                                return Center(

                                  child: Text(""),

                                );

                              } else if (snapshot.data == null && snapshot.connectionState == ConnectionState.waiting) {

                                return CarregandoScreen(

                                  color: Colors.blue[900],

                                  opacity: 0.5,

                                );

                              }                         

                              return ListView.builder(

                                physics: const NeverScrollableScrollPhysics(),

                                shrinkWrap: true,

                                itemCount: snapshot.data.length ?? 0,

                                itemBuilder: (context, index) {
                                
                                  return Padding(

                                    padding: const EdgeInsets.only(

                                      top: 11.0, 
                                      left: 18.0, 
                                      bottom: 0.0, 
                                      right: 18.0

                                    ),

                                    child: InkWell(

                                      onTap: () async {},

                                      child: FadeInUp(

                                        index,

                                        ItemLista(

                                          nome: snapshot.data[index]["title"],
                                          
                                          foto: snapshot.data[index]["imagens"] ?? "https://img2.gratispng.com/20180422/dlw/kisspng-photography-no-symbol-film-stock-5adc94910d0b03.2271530715244053930534.jpg",
                                          
                                          vista: snapshot.data[index]["visaoExplodida"],
                                          
                                          detalhes: snapshot.data[index]["slug"],
                                          
                                          manual: snapshot.data[index]["manual"],
                                          
                                          nommanual: "Manual",
                                          
                                          nomdetalhes: "Detalhes",
                                          
                                          nomvista: "Visão explodida",

                                          onPressdetalhess: () => {},
                                          
                                          onPressmanual: () => {},
                                          
                                          onPressvista: () => {},

                                        )

                                      ),

                                    ),

                                  );

                                },

                              );

                            },
                            
                            future: catalogoManager.catalogoService.getAutomatizadores(abertura: widget.abertura, fluxo_de_uso: widget.fluxo_de_uso, velocidade: widget.velocidade, comprimento_da_folha: widget.comprimento_da_folha),

                          );

                        }),

                ],

              ),

            ),

          ),

        );
        
      }),

    );

  }

}

class ItemLista extends StatelessWidget {

  final String nome;

  final String foto;

  final String detalhes;

  final String nomdetalhes;

  final String nomvista;

  final String nommanual;

  final String vista;

  final String manual;

  final Function onPressmanual;

  final Function onPressvista;

  final Function onPressdetalhess;

  const ItemLista(
      {

        Key key,
        @required this.nome,
        this.foto,
        this.detalhes,
        this.manual,
        this.vista,
        this.nomdetalhes,
        this.nommanual,
        this.nomvista,
        this.onPressmanual,
        this.onPressdetalhess,
        this.onPressvista

      }
  )
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size tamanho = MediaQuery.of(context).size;

    return Padding(

      padding: EdgeInsets.only(top: 15),

      child: Container(

        decoration: BoxDecoration(

          color: Color(0x00dd0008),

          border: Border.all(color: Color(0xff9e0301), width: 3),

          borderRadius: BorderRadius.all(

            Radius.circular(20),

          ),

          boxShadow:

           [

            BoxShadow(

              color: Colors.black.withOpacity(0.5),

              spreadRadius: 3,

              blurRadius: 10,

              offset: Offset(0, 0), // changes position of shadow

            ),

          ],

        ),

        height: 160,

        width: tamanho.width * 0.82,

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

                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Padding(

                    padding: const EdgeInsets.all(3.0),

                    child: Text(nome,

                        textAlign: TextAlign.center,

                        style: TextStyle(

                          fontSize: 11,

                          color: Colors.black,

                          fontWeight: FontWeight.w900,

                        )

                    ),

                  ),
                  
                  Center(

                    child: FadeInImage.assetNetwork(

                      placeholder: 'assets/gifs/loading.gif',

                      image: foto,

                      fit: BoxFit.fill,

                      height: 109,

                    ),

                  ),

                ],
                
              ),

            ),

            Container(

              width: tamanho.width * 0.437,

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

                              child: Visibility(

                                visible: detalhes != null ? true : false,

                                child: Row(

                                  children: [

                                    Padding(
                                      
                                      padding: EdgeInsets.only(

                                        left: tamanho.width * 0.02

                                      ),

                                      child: Text(
                                        
                                        nomdetalhes,
                                        
                                        style: TextStyle(color: Colors.white),

                                      ),

                                    )

                                  ],

                                ),
                              
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

                                onTap: () => launch('https://www.garen.com.br/produto/' + detalhes),

                                child: Container(

                                  width: 38,

                                  height: 30,

                                  decoration: BoxDecoration(

                                    shape: BoxShape.rectangle,

                                    color: Colors.white,

                                    borderRadius: BorderRadius.only(

                                        topLeft: Radius.circular(

                                          tamanho.height * 0.3
                                        
                                        ),

                                        bottomLeft: Radius.circular(

                                          tamanho.height * 0.3
                                        ),

                                        bottomRight: Radius.circular(

                                          tamanho.height * 0.3

                                        ),

                                        topRight: Radius.circular(

                                          tamanho.height * 0.3
                                        )

                                    ),

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

                        visible: vista != null ? true : false,

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

                                          left: tamanho.width * 0.02

                                      ),

                                      child: Text(

                                        nomvista,

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

                                        topLeft: Radius.circular(tamanho.height * 0.3),
                                        
                                        bottomLeft: Radius.circular(tamanho.height * 0.3),
                                        
                                        bottomRight: Radius.circular(tamanho.height * 0.3),
                                       
                                        topRight: Radius.circular(tamanho.height * 0.3)
                                        
                                      ),

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

                        visible: manual != null ? true : false,

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

                                      topLeft: Radius.circular(40)

                                  ),

                                ),

                                child: Row(

                                  children: [

                                    Padding(

                                      padding: EdgeInsets.only(left: tamanho.width * 0.02),
                                      
                                      child: Text(

                                        nommanual,

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

                                            tamanho.height * 0.3

                                          ),

                                          bottomLeft: Radius.circular(

                                            tamanho.height * 0.3

                                          ),

                                          bottomRight: Radius.circular(

                                            tamanho.height * 0.3

                                          ),

                                          topRight: Radius.circular(

                                            tamanho.height * 0.3

                                          )

                                      ),

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
