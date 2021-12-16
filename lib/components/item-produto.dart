import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemCatalogo extends StatelessWidget { 

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

  const ItemCatalogo(
      {
        Key key,
        this.foto,
        this.vista,
        this.manual,
        this.nomvista,
        this.detalhes,
        this.nommanual,
        this.nomdetalhes,
        this.onPressvista,
        this.onPressmanual,
        @required this.nome,
        this.onPressdetalhess
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

                                onTap: () => launch(detalhes, forceSafariVC: true, forceWebView: true, webOnlyWindowName: this.nome),

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
