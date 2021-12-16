import 'dart:core';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:garen/provider/woocomerce_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:garen/components/cidade-modal.dart';
import 'package:garen/components/estados-modal.dart';
import 'package:garen/servicos/distribuidor_servico.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:flutter/foundation.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:garen/provider/distribuidor_provider.dart';
import 'package:garen/components/carregando_garen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:garen/components/animation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:ui' as ui;

class DistribuidorPage extends StatefulWidget {
  
  final String texto;

  DistribuidorPage(this.texto);

  @override
  _DistribuidorPageState createState() => _DistribuidorPageState();

}

class Estado {

  final String nome;

  final String sigla;

  Estado({

    this.nome,
    this.sigla,

  });
}

class _DistribuidorPageState extends State<DistribuidorPage> {

  String opcaoEstado = 'Escolha';

  String estado;

  String cidade;

  String opcaoCidade = 'Escolha';

  LocalizacaoServico _locate = new LocalizacaoServico();

  final ScrollController _scrollController = ScrollController(); 
    
  Stream<dynamic> _streamDistribuidor;

  DistribuidorServico distribuidorServico = new DistribuidorServico();

  List listaDistribuidor = [];

  List listaDistribuidorBusca = [];

  String selecionado;

  bool visivel = false;

  int quantidade = 0;

  dynamic distribuidores;

  double latitude;

  double longitude;

  LatLng garenLatLng = LatLng(
    -22.2283362, 
    -49.6550563
  );
  
  LatLng centerMap;  

  GoogleMapController mapController;

  CameraUpdate updateCamera;

  Position _currentPosition;

  BitmapDescriptor pinLocationIcon;  
 
  Future<ui.Image> getImageFromUrl(Uint8List imagePath) async {

    Uint8List imageBytes = imagePath;

    final Completer<ui.Image> completer = new Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {

      return completer.complete(img);

    });

    return completer.future;

  }

  Future<BitmapDescriptor> getMarkerIcon(Uint8List imagePath, Size size) async {
    
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();

    final Canvas canvas1 = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(100);

    final double shadowWidth = 15.0;

    final Paint borderPaint = Paint()..color = Colors.white;

    final double borderWidth = 3.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas1.drawRRect(

        RRect.fromRectAndCorners(

          Rect.fromLTWH(0.0, 0.0, size.width, size.height),

          topLeft: radius,

          topRight: radius,

          bottomLeft: radius,

          bottomRight: radius,

        ),

        shadowPaint
    );

    // Add border circle
    canvas1.drawRRect(

        RRect.fromRectAndCorners(

          Rect.fromLTWH(

              shadowWidth, 

              shadowWidth,

             size.width - (shadowWidth * 2),

            size.height - (shadowWidth * 2)

          ),

          topLeft: radius,

          topRight: radius,

          bottomLeft: radius,

          bottomRight: radius,

        ),

        borderPaint

    );

    Rect oval = Rect.fromLTWH(
      
        imageOffset

      , imageOffset

      , size.width - (imageOffset * 2)

      , size.height - (imageOffset * 2)

    );
    
    canvas1.clipPath(

      Path()..addOval(oval)

    );
    
    ui.Image image = await getImageFromUrl(imagePath);

    paintImage(

      canvas: canvas1, 

      image: image, 

      rect: oval, 

      fit: BoxFit.fitWidth

    );

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder

            .endRecording()

            .toImage(

              size.width.toInt(), 

              size.height.toInt()
              
            );

      final ByteData byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);   
   
    final Uint8List uint8List = byteData.buffer.asUint8List();
      
       return BitmapDescriptor.fromBytes(uint8List);

  }

  _iconeCustomizado( String nome, Coordinates position, String url, String id, String endereco, String telefone) async {

    var iconurl = url;

    var request = await http.get(iconurl);

    var bytes = request.bodyBytes;

    LatLng _lastMapPositionPoints = LatLng(position.latitude, position.longitude);
    
    if(url.isEmpty){
      return;
    }else{

      markers.add(Marker(
      
      icon: await getMarkerIcon(bytes, Size(150, 150)), 
      
      // BitmapDescriptor.fromBytes(dataBytes.buffer.asUint8List()),
     
      markerId: MarkerId(id),

      position: _lastMapPositionPoints,

      infoWindow: InfoWindow(
        
        title: nome,

        snippet: "$telefone",

      ),

    ));

    }

  }

  final List<_PositionItem> _positionItems = <_PositionItem>[];

  void _getCurrentLocation() async {

    var currentPosition = await Geolocator.getCurrentPosition();

    latitude = currentPosition.latitude;

    longitude = currentPosition.longitude;

    _positionItems.add(

      _PositionItem(

        _PositionItemType.position, 

        currentPosition.toString()

      )

    );

    setState(

      () {

        markers.add(Marker(

          markerId: MarkerId(_currentPosition.toString()),

          position: LatLng(latitude, longitude),

          visible: true,

          infoWindow: InfoWindow(

            title: 'Meu Local',

          ),

          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),

        ));

      },

    );

  }

  int _page = 1;
  int index = 1;

  void initState() {

    _locate.iniciaLocalizacao(context);

    _getCurrentLocation();    
    
    var costumersList = Provider.of<WoocommerceProvider>(context, listen: false);

    super.initState();

    costumersList.resetStream();
    costumersList.fetchCustomers(_page);

    loadMore(costumersList);

  }

  loadMore(costumersList) {

       _scrollController..addListener(() {   

          var triggerFetchMoreSize = 0.9 * _scrollController.position.maxScrollExtent;

              print('Pixels: ' + _scrollController.position.pixels.toString());
          print('Max Scroll: ' + _scrollController.position.maxScrollExtent.toString());     

          if (_scrollController.position.pixels > triggerFetchMoreSize) {
            costumersList.setLoadingState(LoadMoreStatus.LOADING);
            print('Cheguei');
            costumersList.fetchProducts(++_page);     
          }          

      });

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future _getDistribuidor() async {

    var requisicao = await distribuidorServico.getDistribuidorCidade(

      cidade: cidade

    ); 

    listaDistribuidor = requisicao;

    listaDistribuidorBusca.addAll(

      listaDistribuidor

    );

    print('quantidade: $listaDistribuidorBusca.length');

    return listaDistribuidorBusca;

  }
    
  Set<Marker> markers = new Set<Marker>();

  void onMapCreated(GoogleMapController controller) {
    
    mapController = controller;

  }

  @override
  Widget build(BuildContext context) {

    Size tamanho = MediaQuery.of(context).size;

    return LocalizacaoWidget(

      child: StreamBuilder(

        builder: (BuildContext context, AsyncSnapshot snapshot) {

        return Scaffold(body: Consumer<WoocommerceProvider>(

          builder: (context, customersModel, child) {

            return Center(

              child: Stack(children: <Widget>[

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

                          ]

                        )

                    ),

                    height: MediaQuery.of(context).size.height * 0.005
                    
                ),

                //Acima do Card
                Padding(

                  padding: EdgeInsets.only(top: tamanho.height * 0.004),

                  child: Container(

                    width: tamanho.width,

                    decoration: BoxDecoration(

                      image: DecorationImage(

                        image: AssetImage("assets/images/bg_azul.png"),

                        fit: BoxFit.cover,

                      ),

                    ),

                    child: SingleChildScrollView(

                      child: Column(

                        children: [

                          Padding(

                              padding: EdgeInsets.only(top: tamanho.height * 0.05),

                              child: Container(

                                width: tamanho.width * 0.7,

                                decoration: BoxDecoration(

                                  border: Border(

                                    bottom: BorderSide(

                                      width: 2.0, 

                                      color: Color(0xff8e1729)

                                    ),

                                  ),

                                  color: Colors.transparent,

                                ),

                                child: Align(

                                  alignment: AlignmentDirectional.center,

                                  child: Padding(

                                    padding: const EdgeInsets.only(bottom: 8.0),

                                    child: Text(

                                      "${_locate.locale['DISTRIBUTOR']['title']}",

                                      style: TextStyle(

                                        color: Colors.white,

                                        fontSize: 30,

                                        fontFamily: "Garen-Font",

                                        fontWeight: FontWeight.w900

                                      ),

                                    ),

                                  ),

                                ),

                              )

                          ),

                          Align(

                            alignment: AlignmentDirectional.center,

                            child: Padding(

                              padding: const EdgeInsets.only(left: 40.0, right: 40, top: 10, bottom: 20),

                              child: Text("${_locate.locale['DISTRIBUTOR']['select_state_city']}",

                                style: TextStyle(color: Colors.white, fontSize: 12),

                              ),

                            ),

                          ),

                          // titulo
                          Container(

                            child: Column(

                              children: [

                                FadeInUp(

                                  1,

                                  Padding(

                                    padding: EdgeInsets.only(

                                      top: tamanho.height * 0.01

                                    ),

                                    child: GestureDetector(

                                      onTap: () => {

                                        // distribuidorManage.getDistribuidorCidade(
                                          
                                        //   cidade: cidade,

                                        //   onSuccess: (v) async {

                                        //   print(v);

                                        //   if (v == "true") {

                                        //   } else {

                                        //     for (var i = 0; i < v.length; i++) {

                                        //       quantidade++;

                                        //       final query = (v[i]["cep"] + " , " + v[i]["end"]);

                                        //       var addresses = await Geocoder
                                        //           .local
                                        //           .findAddressesFromQuery(query);

                                        //       var first = addresses.first;

                                        //       _iconeCustomizado(

                                        //         v[i]["title"]["rendered"],

                                        //         first.coordinates,

                                        //         v[i]["logomarca"]["guid"],

                                        //         v[i]["id"].toString(),

                                        //         v[i]["telefone"],

                                        //         v[i]["end"]

                                        //       );

                                        //     }

                                        //     if (quantidade > 0) {

                                        //       setState(() {

                                        //         visivel = true;

                                        //       });

                                        //     }

                                        //   }

                                        // }, 
                                        
                                        //   onFail: (v) async {

                                        //   AwesomeDialog(

                                        //     context: context,

                                        //     dialogType: DialogType.ERROR,

                                        //     animType: AnimType.BOTTOMSLIDE,

                                        //     title:'${_locate.locale['AWESOMEDIALOG']['title_2']}',

                                        //     desc: '${_locate.locale['AWESOMEDIALOG']['something_go_wrong']}',

                                        //     btnCancelText:'${_locate.locale['AWESOMEDIALOG']['btn_close']}',

                                        //     btnCancelOnPress: () {},

                                        //   )..show();

                                        // }),

                                      },

                                      child: Container(

                                        width: tamanho.width * 0.9,

                                        height: 50,

                                        decoration: BoxDecoration(

                                          color: Colors.red[900],

                                          border: Border.all(

                                            color: Color(0xff9e0301),

                                            width: 3

                                          ),

                                          borderRadius: BorderRadius.all(

                                            Radius.circular(12),

                                          ),

                                          boxShadow: [

                                            BoxShadow(

                                              color: Colors.grey[800],

                                              spreadRadius: 1,

                                              blurRadius: 10,
                                              
                                              offset: Offset(0,0), 

                                            ),

                                          ],

                                        ),

                                        child: Row(

                                          children: [

                                            Flexible(

                                              flex: 1,

                                              fit: FlexFit.tight,

                                              child: Padding(

                                                padding: const EdgeInsets.all(8.0),

                                                child: Text("${_locate.locale['DISTRIBUTOR']['state']}:",
                                                 
                                                 style: TextStyle(color: Colors.white,
                                                  
                                                    fontWeight: FontWeight.bold,
                                                  
                                                    fontSize: 17

                                                  ),

                                                ),

                                              ),

                                            ),

                                            Flexible(

                                              flex: 2,

                                              fit: FlexFit.tight,

                                              child: Padding(

                                                padding: const EdgeInsets.all(8.0),

                                                child: Align(

                                                  alignment: AlignmentDirectional.centerEnd,

                                                  child: GestureDetector(

                                                    onTap: () => {

                                                     _modalEstado(context)

                                                    },

                                                    child: Text(opcaoEstado ?? "${_locate.locale['AUTOMAT']['choose']}",

                                                      style: TextStyle(

                                                        color: Colors.white,

                                                        fontWeight: FontWeight.bold,

                                                        fontSize: 17
                                                      
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
   
                                ),
   
                              ],
   
                            ),
   
                          ),
                          // titulo

                          // filtro
                          FadeInUp(
   
                            4,
   
                            Padding(
   
                              padding: EdgeInsets.only(top: tamanho.height * 0.03),
   
                              child: GestureDetector(
   
                                onTap: () => {

                                  _modalCidade(context)
                                  
                                },
   
                                child: Container(
   
                                  width: tamanho.width * 0.9,
   
                                  height: 50,
   
                                  decoration: BoxDecoration(
   
                                    color: Colors.red[900],
   
                                    border: Border.all(
   
                                        color: Color(0xff9e0301), 
                                        
                                        width: 3

                                    ),
   
                                    borderRadius: BorderRadius.all(
   
                                      Radius.circular(12),
   
                                    ),
   
                                    boxShadow: [
   
                                      BoxShadow(
   
                                        color: Colors.grey[800],
   
                                        spreadRadius: 2,
   
                                        blurRadius: 10,

                                        offset: Offset(0, 0), // changes position of shadow

                                      ),

                                    ],

                                  ),

                                  child: Row(

                                    children: [
                                      
                                      Flexible(

                                        flex: 1,

                                        fit: FlexFit.tight,

                                        child: Padding(

                                          padding: const EdgeInsets.all(8.0),

                                          child: Text(

                                            "${_locate.locale['DISTRIBUTOR']['cities']}:",

                                            style: TextStyle(

                                                color: Colors.white,

                                                fontWeight: FontWeight.bold,

                                                fontSize: 17

                                            ),

                                          ),

                                        ),

                                      ),

                                      Flexible(
                                        
                                        flex: 2,
                                        
                                        fit: FlexFit.tight,
                                        
                                        child: Padding(
                                                                                   
                                          padding: const EdgeInsets.all(8.0),
                                          
                                          child: Align(
                                            
                                            alignment: AlignmentDirectional.centerEnd,

                                            child: GestureDetector(

                                              onTap: () => {

                                                _modalCidade(context),

                                              },

                                              child: Text(

                                                opcaoCidade ?? "${_locate.locale['AUTOMAT']['choose']}",                                                style: TextStyle(
                                                
                                                    color: Colors.white,
                                               
                                                    fontWeight: FontWeight.bold,
                                               
                                                    fontSize: 17

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

                          ),                          
                          // filtro

                          // contador   
                          Visibility(

                            visible: true,

                            child: FadeInUp(
                              
                              5,

                              Padding(

                                padding: const EdgeInsets.only(top: 20),

                                child: Container(

                                  child: Column(

                                    children: [

                                      Container(

                                        width: 50,

                                        height: 50,

                                        decoration: BoxDecoration(

                                          color: Colors.yellow[800],

                                          border: Border.all(
                                            
                                            color: Color(0xff9e0301),
                                             
                                            width: 0

                                          ),

                                          borderRadius: BorderRadius.all(

                                            Radius.circular(49),

                                          ),

                                          boxShadow: [

                                            BoxShadow(

                                              color: Color(0xffff9900),

                                              spreadRadius: 1,

                                              blurRadius: 10,

                                              offset: Offset(0,0),

                                            ),

                                          ],

                                        ),

                                        child: Align(

                                            alignment: Alignment.center,

                                            child: Text(

                                              (quantidade == 0)

                                                ? "0"

                                                : quantidade.toString(),

                                              style: TextStyle(
                                                  
                                                color: Colors.white,
                                                  
                                                fontSize: 20

                                              ),

                                            )

                                        ),

                                      ),

                                      Padding(

                                        padding:  const EdgeInsets.only(top: 20.0),

                                        child: Text(

                                          "${_locate.locale['DISTRIBUTOR']['distributors_found']}",
                                          
                                          style: TextStyle(

                                              color: Colors.white,
                                          
                                              fontSize: 20
                                          ),

                                        ),

                                      )

                                    ],

                                  ),

                                ),
                            
                              ),

                            ),

                          ),
                          // contador

                          // mapa
                          FadeInUp(
                            
                            6,

                            Padding(
                              
                              padding: const EdgeInsets.only(top: 20.0),
                              
                              child: Container(

                                width: 350,

                                height: 300,

                                child: ClipRRect(

                                  borderRadius: BorderRadius.only(
                                    
                                    topLeft: Radius.circular(20),
                                    
                                    topRight: Radius.circular(20),
                                    
                                    bottomRight: Radius.circular(20),
                                    
                                    bottomLeft: Radius.circular(20),

                                  ),

                                  child: Align(
                                    
                                    alignment: Alignment.bottomRight,
                                    
                                    heightFactor: 0.3,

                                    widthFactor: 2.5,

                                    child: GoogleMap(

                                      markers: markers,

                                      onMapCreated:

                                      onMapCreated,
                                      
                                      onTap: (position) {},

                                      initialCameraPosition: CameraPosition(

                                        target: this.garenLatLng,
                                        
                                        zoom: 13.0

                                      ),
                                      
                                      gestureRecognizers: Set()..add(Factory<PanGestureRecognizer>(

                                          () => PanGestureRecognizer ()

                                        )

                                      )

                                    ),

                                  ),

                                ),

                              ),

                            ),

                          ),
                          //mapa

                          // card                          
                          Visibility(

                            visible: visivel,

                            child: FutureBuilder(

                              builder: (context, projectSnap) {

                                if (projectSnap.data == null &&
                                
                                  projectSnap.connectionState == ConnectionState.waiting) {

                                  return CarregandoScreen(

                                    color: Colors.blue[900],

                                    opacity: 0.5,

                                  );

                                }
                                                                
                                quantidade = int.parse(customersModel.allCustomer.length.toString());  
                                
                                return ListView.builder(
                                  
                                  physics: const NeverScrollableScrollPhysics(),

                                  shrinkWrap: true,

                                  itemCount: projectSnap.data.length,

                                  itemBuilder: (context, index) {

                                    return FadeInUp(
                                      
                                      index,

                                      ListaDistribuidor(
                                             
                                              logo: projectSnap.data[index]["logomarca"],

                                             email: projectSnap.data[index]["e-mail"],

                                        localidade: projectSnap.data[index]["end"],

                                              nome: projectSnap.data[index]["title"],

                                               url: projectSnap.data[index]["link"],

                                          telefone: projectSnap.data[index]["telefone"],

                                              mapa: projectSnap.data[index]["link_do_google_maps"],

                                      ),

                                    );

                                  },

                                );

                              },

                              future: null

                            ),

                          ),
                          // card

                          SizedBox(
                            height: 81,
                          )
                        ],

                      ),

                    ),

                  ),


                ),

              ]),

            );

          },

        ));

      }),

    );

  }

  void _modalEstado(BuildContext context) async {
        
    final result = await Navigator.push(

      context,
    
      MaterialPageRoute(builder: (context) => ModalEstadoPage()),

    );

    setState(() {

      opcaoEstado = result;

      estado = result;  

      opcaoCidade = 'Escolha';

    });



    print(estado);

  }

  void _modalCidade(BuildContext context) async {    

    if(estado == null){
      
      AwesomeDialog(

        context: context,

        dialogType: DialogType.ERROR,

        animType: AnimType.BOTTOMSLIDE,

        title:'${_locate.locale['AWESOMEDIALOG']['title_2']}',

        desc: '${_locate.locale['AWESOMEDIALOG']['select_state']}',

        btnCancelText:'${_locate.locale['AWESOMEDIALOG']['btn_close']}',

        btnCancelOnPress: () {},

      )..show();

    } else {

      final result = await Navigator.push(

        context,
      
        MaterialPageRoute(builder: (context) => ModalCidadePage(estado: estado)),

      );

      setState(() { 

             cidade = result;

        opcaoCidade = result;


        visivel = true;

      });

      if(cidade != null) {

        _streamDistribuidor = Stream.fromFuture(_getDistribuidor());
      
        final query = (cidade + " , " + estado);

            var addressesLocation = 
          await Geocoder
                .local
                .findAddressesFromQuery(query);
      
        centerMap = LatLng(

          addressesLocation[0].coordinates.latitude,

          addressesLocation[0].coordinates.longitude

        );

        mapController.animateCamera(

          CameraUpdate.newCameraPosition(

            CameraPosition(

              target: centerMap,

              zoom: 13

            ),

          ),

        );

        for (var i = 0; i < listaDistribuidorBusca.length; i++) {

          quantidade++;
        
          final query = (listaDistribuidorBusca[i]["cep"] + " , " + listaDistribuidorBusca[i]["endereco"]);

          var addresses = await Geocoder

              .local

              .findAddressesFromQuery(query);

          var first = addresses.first;

          _iconeCustomizado(

            listaDistribuidorBusca[i]["title"],
            first.coordinates,
            listaDistribuidorBusca[i]["logomarca"],
            listaDistribuidorBusca[i]["id"].toString(),
            listaDistribuidorBusca[i]["telefone"],
            listaDistribuidorBusca[i]["endereco"]

          );

        }

        print('Cidade: $listaDistribuidorBusca.length');

      }

      

    }

  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await mapController.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }

}


class ListaDistribuidor extends StatelessWidget {

  String logo;

  String nome;

  String telefone;

  String localidade;

  String email;

  String url;

  String mapa;

  ListaDistribuidor(

      {

        Key key,

        @required this.email,

        @required this.localidade,

        @required this.logo,

        @required this.nome,

        @required this.telefone,

        @required this.url,

        @required this.mapa

      }
      
  )
  
      : super(key: key);
      
  @override
  Widget build(BuildContext context) {

    final Uri _emailLaunchUri = Uri(

      scheme: 'mailto',

      path: email,

      queryParameters: {'subject': "Instalador"}

    );

    return Padding(

      padding: EdgeInsets.all(20),

      child: IntrinsicHeight(

        child: Container(

          width: 350,

          height: 336,

          decoration: BoxDecoration(

            color: Color(0xff6f1525),

            border: Border.all(color: Color(0xff6f1525), width: 3),

            borderRadius: BorderRadius.all(

              Radius.circular(20),

            ),

            boxShadow: [

              BoxShadow(

                color: Colors.grey[900],

                spreadRadius: 2,

                blurRadius: 10,

                offset: Offset(0, 0), 
                
              ),

            ],

          ),

          child: Padding(

            padding: EdgeInsets.all(0),

            child: Container(

              decoration: BoxDecoration(

                color: Colors.white,

                border: Border.all(color: Color(0xff6f1525), width: 1),

                borderRadius: BorderRadius.all(

                  Radius.circular(18),

                ),

              ),

              width: 300,

              height: 300,

              child: Column(

                children: [

                  Padding(

                    padding: EdgeInsets.all(8),

                    child: (logo == null)

                      ? CircularProgressIndicator(

                          backgroundColor: Colors.white

                      )

                      : Center(

                          child: Image.network(

                          logo,

                          width: 150,

                          height: 116,

                        )

                      ),

                  ),

                  Padding(

                    padding: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
                    
                    child: Text( nome, style:

                      TextStyle(

                        fontWeight: FontWeight.w900, 

                        fontSize: 15

                      ),

                    ),
                    
                  ),

                  GestureDetector(

                    onTap: () async {

                      if (await canLaunch(telefone)) {

                        await launch(telefone);

                      } else {

                        throw 'Could not launch $url';

                      }

                    },

                    child: Padding(

                      padding: const EdgeInsets.only(left: 15.0, top: 5),

                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.start,

                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [

                          Icon(Icons.phone_android),

                          Row(

                            children: [

                              Text(telefone),

                            ],

                          )

                        ],

                      ),

                    ),

                  ),

                  GestureDetector(

                    onTap: () async {

                      if (await canLaunch(mapa)) {

                        await launch(mapa);

                      } else {

                        throw 'Could not launch $url';

                      }

                    },

                    child: Padding(

                      padding: const EdgeInsets.only(left: 15.0, top: 5),

                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.start,

                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [

                          Icon(Icons.gps_fixed),

                          Flexible(

                            child: RichText(

                              overflow: TextOverflow.ellipsis,

                              strutStyle: StrutStyle(fontSize: 10.0),

                              text: TextSpan(

                                  style: TextStyle(color: Colors.black),

                                  text: localidade),

                            ),

                          ),

                        ],

                      ),

                    ),

                  ),

                  Padding(

                    padding: const EdgeInsets.only(left: 15.0, top: 5),

                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.start,

                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [

                        Icon(Icons.email),

                        Flexible(

                          child: RichText(

                            overflow: TextOverflow.ellipsis,

                            strutStyle: StrutStyle(fontSize: 10.0),
                            
                            text: TextSpan(

                              style: TextStyle(color: Colors.black),

                              text: email

                            ),

                          ),

                        ),

                      ],

                    ),

                  ),

                  Row(

                    mainAxisAlignment: MainAxisAlignment.center,

                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [

                      Padding(

                        padding: const EdgeInsets.only(top: 2, right: 6.0),

                        child: Container(

                          width: 130,

                          child: RaisedButton(

                            child: Icon(

                              Icons.link_sharp,

                              color: Colors.black,
                              
                              size: 30,

                            ),

                            onPressed: () async {

                              if (await canLaunch(url)) {

                                await launch(url);

                              } else {

                                throw 'Could not launch $url';

                              }

                            },

                          ),

                        ),

                      ),

                      Padding(

                        padding: const EdgeInsets.only(top: 2, left: 6.0),

                        child: Container(

                          width: 130,

                          child: RaisedButton(

                            child: Icon(

                              Icons.email,

                              color: Colors.black,

                            ),
                            
                            onPressed: () =>
                              {
                                launch(_emailLaunchUri.toString())
                              },
                          ),

                        ),

                      )

                    ],

                  ),

                ],

              ),

            ),

          ),

        ),

      ),

    );

  }

}

enum _PositionItemType { position }

class _PositionItem {

  _PositionItem(this.type, this.displayValue);
  
  final _PositionItemType type;
  
  final String displayValue;

}

