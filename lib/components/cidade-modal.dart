import 'package:flutter/material.dart';
import 'package:garen/components/carregando.dart';
import 'package:garen/servicos/distribuidor_servico.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/Localizacao_widget.dart';
import 'package:garen/components/ProgressHUD.dart';
import 'package:garen/components/animation.dart';
import 'package:garen/components/app_bar.dart';
import 'package:hexcolor/hexcolor.dart';

class ModalCidadePage extends StatefulWidget {

  final String estado;

  const ModalCidadePage({Key key, this.estado}) : super(key: key);

  @override
  _ModalCidadePageState createState() => _ModalCidadePageState();

}

class _ModalCidadePageState extends State<ModalCidadePage> {

  
  bool isApiCallProcess = false;

  LocalizacaoServico _locate = new LocalizacaoServico();

  DistribuidorServico distribuidorServico = new DistribuidorServico();

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

    var requisicao = await distribuidorServico.getDistribuidorEstado(

      estado: widget.estado

    ); 

    listaEstados = requisicao;

    listaEstadosBusca.addAll(

      listaEstados

    );

    return listaEstadosBusca;

  }
 
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

                              child: Column(

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
                                                  
                                                      text: '${_locate.locale['DISTRIBUTOR']['cities']}',
                                                  
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
                                                    
                                                        text: '${_locate.locale['DISTRIBUTOR']['select_city']}',
                                                    
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

            Navigator.pop(context, listaEstadosBusca[index]["cidade"]);

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

                    child: Text('${listaEstadosBusca[index]["cidade"]}', textAlign: TextAlign.left,),

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
