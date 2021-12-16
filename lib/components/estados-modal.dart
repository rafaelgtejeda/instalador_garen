import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:garen/components/carregando.dart';
import 'package:garen/provider/user_provider.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/Localizacao_widget.dart';
import 'package:garen/components/ProgressHUD.dart';
import 'package:garen/components/animation.dart';
import 'package:garen/components/app_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

class ModalEstadoPage extends StatefulWidget {

  @override
  _ModalEstadoPageState createState() => _ModalEstadoPageState();

}

class _ModalEstadoPageState extends State<ModalEstadoPage> {
  
  bool isApiCallProcess = false;

  LocalizacaoServico _locate = new LocalizacaoServico();

  List listaEstados = [];

  List listaEstadosBusca = [];

  Stream<dynamic> _streamEstados;

  bool visivel = false;

  void initState() {
    
    _locate.iniciaLocalizacao(context);

    _streamEstados = Stream.fromFuture(_getStates());

    super.initState();

  }

  Future _getStates() async {

    String requisicao = await DefaultAssetBundle.of(context).loadString('assets/data/br-states.json');
    
    listaEstados = json.decode(requisicao);

    listaEstadosBusca.addAll(listaEstados);

    return listaEstadosBusca;

  }  

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

                height: size.height,

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

                                      mainAxisAlignment: MainAxisAlignment.start,

                                      mainAxisSize: MainAxisSize.max,

                                      children: <Widget>[

                                        FadeInUp(

                                          1,

                                          Padding(

                                            padding: const EdgeInsets.only(top: 41, bottom: 15),

                                            child: RichText(

                                              text: TextSpan(

                                                style: TextStyle(

                                                    color: Colors.black,

                                                    fontSize: 36

                                                ),

                                                children: <TextSpan>[

                                                  TextSpan(
                                                  
                                                      text: '${_locate.locale['DISTRIBUTOR']['state']}',
                                                  
                                                      style: TextStyle(
                                                  
                                                          fontFamily:'GarenFont',
                                                  
                                                          fontSize: 30,
                                                  
                                                          color: Colors.white,
                                                  
                                                           fontWeight: FontWeight.bold

                                                      )

                                                  ),
   
                                                ],
  
                                              ),
  
                                            ),
  
                                          ),
  
                                        ),

                                        FadeInUp(

                                          1,

                                          Padding(

                                            padding: const EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 41),

                                            child: Center(

                                              child: RichText(

                                                text: TextSpan(

                                                  style: TextStyle(

                                                      color: Colors.black,

                                                      fontSize: 36

                                                  ),

                                                  children: <TextSpan>[                                                  
                                                    
                                                    TextSpan(
                                                    
                                                        text: '${_locate.locale['DISTRIBUTOR']['select_state']}',
                                                    
                                                        style: TextStyle(
                                                    
                                                            fontFamily: 'GarenFont',
                                                    
                                                            fontSize: 14,
                                                    
                                                            color: Colors.white,
                                                    
                                                            fontWeight: FontWeight.w300

                                                        )

                                                    ),
   
                                                  ],
  
                                                ),
  
                                              ),
                                            ),
  
                                          ),
  
                                        ),


                                        StreamBuilder(

                                            stream: _streamEstados,
                                            
                                            builder: (BuildContext context, AsyncSnapshot snapshot) {

                                              switch(snapshot.connectionState) {

                                                case ConnectionState.none:
                                                
                                                case ConnectionState.waiting:

                                                  return Center(

                                                    child: Carregando(),

                                                  );

                                                default:

                                                  if (!snapshot.hasData) {

                                                    return Center(

                                                      child: Carregando(),

                                                    );

                                                  }

                                                  else {

                                                    return ListView.builder(

                                                      shrinkWrap: true,

                                                      physics: const NeverScrollableScrollPhysics(),

                                                      itemCount: listaEstadosBusca == null ? 0 : listaEstadosBusca.length,

                                                      itemBuilder: (BuildContext context, int index){

                                                        return _estadoItem(context, index);

                                                      }

                                                    );

                                                  }

                                              }

                                            },

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

            opacity: 0.3

        );

      }),

    );

  }

  _estadoItem(BuildContext context, int index) {

    return FadeInUp(
      
      1,

      Card(
        

        child: InkWell(

          onTap: () async{

            Navigator.pop(context, listaEstadosBusca[index]["name"]);

          },

          child: Padding(

          padding: const EdgeInsets.all(18.0),

          child: Column(

            children: <Widget>[

              Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: <Widget>[

                  Flexible(   

                    flex: 2,

                    fit: FlexFit.tight,

                    child: Text('${listaEstadosBusca[index]["name"]}', textAlign: TextAlign.left,),

                  )

                ],

              ),

            ],

          ),

        ),

        ),

      )

    );

  }

}
