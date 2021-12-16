import 'package:flutter/material.dart';
import 'package:garen/pages/basculante.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:garen/components/animation.dart';

class CatalogoPage extends StatefulWidget {
  final String texto;

  CatalogoPage(this.texto);

  @override
  _CatalogoPageState createState() => _CatalogoPageState();
}

class Cat {

  final String name;
  final String seguimento;
  final int categoriaId;
  final int id;

  Cat({
    this.id,
    this.name,
    this.categoriaId,
    this.seguimento
  });

}

class Categoria {

  final String name;
  final List<String> finalidade;
  final int id;
  final int categoriaId;

  Categoria({
    this.id,
    this.name,
    this.categoriaId,
    this.finalidade,
  });

}

class _CatalogoPageState extends State<CatalogoPage> {

  String finalidade = 'Escolha';
  String filtro;
  List<int> ids;

  List<Cat> categoria = [

           new Cat(name: "Portão Deslizante", seguimento: "Residêncial", id: 110, categoriaId: 111),
           new Cat(name: "Portão Basculante", seguimento: "Residêncial", id: 0, categoriaId: 112),
            new Cat(name: "Portão Pivotante", seguimento: "Residêncial", id: 97, categoriaId: 113),
          new Cat(name: "Portas Automáticas", seguimento: "Residêncial", id: 0, categoriaId: 114),
           new Cat(name: "Portas de Enrolar", seguimento: "Residêncial", id: 0, categoriaId: 115),
                         new Cat(name: "BRT", seguimento: "BRT", id: 0, categoriaId: 125),
                    new Cat(name: "Cancelas", seguimento: "Cancelas", id: 0, categoriaId: 116),
                  new Cat(name: "Fechaduras", seguimento: "Fechaduras", id: 0, categoriaId: 117),
              new Cat(name: "Cerca Elétrica", seguimento: "Cerca Elétrica", id: 0, categoriaId: 119),
                  new Cat(name: "Acessórios", seguimento: "Acessórios", id: 0, categoriaId: 118),
                    new Cat(name: "Centrais", seguimento: "Centrais", id: 0, categoriaId: 121),
                    //  new Cat(name: "G.Solar", seguimento: "G.Solar", id: 0, categoriaId: 127),
          // new Cat(name: "Controle de Acesso", seguimento: "Controle de Acesso", id: 0, categoriaId: 120),
      new Cat(name: "Kit Portão de Alumínio", seguimento: "Kit Portão de Alumínio", id: 0, categoriaId: 122),
        new Cat(name: "Centrais Eletrônicas", seguimento: "Centrais Eletrônicas", id: 0, categoriaId: 121),
          //  new Cat(name: "Casa Inteligentes", seguimento: "Casa Inteligentes", id: 0, categoriaId: 124)
  ];

  List<Categoria> cat = [
     new Categoria(name: "Portão Basculante", finalidade: ["Residêncial", "Comercial"],             id: 0,   categoriaId: 112),
     new Categoria(name: "Portão Deslizante", finalidade: ["Residêncial"],                          id: 110, categoriaId: 111),
      new Categoria(name: "Portão Pivotante", finalidade: ["Residêncial", "Condomínio", "Empresa"], id: 97,  categoriaId: 113),
    new Categoria(name: "Portas Automáticas", finalidade: ["Residêncial", "Empresa"],               id: 0,   categoriaId: 114),
     new Categoria(name: "Portas de Enrolar", finalidade: ["Indústria"],                            id: 0,   categoriaId: 115)                 
  ];

  List<Cat> filterCatego;
  LocalizacaoServico _locate = new LocalizacaoServico();

  preencheCatalogo() {
    filterCatego = categoria.toList();
  }

  seleciona(finalidade) {
    List<Categoria> listaFiltrada = cat.where((c) => c.finalidade.any((f) => f == finalidade)).toList();
  }

  void initState() {
     super.initState();
    _locate.iniciaLocalizacao(context);
     preencheCatalogo();
  }

  String opcao;

  @override
  Widget build(BuildContext context) {

    Future<void> _showChoiceDialog(BuildContext context) {

      return showDialog(

          context: context,
          
          builder: (BuildContext context) {

            return AlertDialog(

              title: Text("Escolha Um"),

              content: SingleChildScrollView(

                child: ListBody(

                  children: [

                    GestureDetector(

                      child: Text("Todos"),

                      onTap: () {

                        setState(() {

                          finalidade = 'Todos';

                        });

                        Navigator.of(context).pop();

                      },

                    ),

                    Padding(padding: EdgeInsets.all(8.0)),

                    GestureDetector(

                      child: Text("Residêncial"),

                      onTap: () {

                        setState(() {

                          finalidade = 'Residêncial';   

                          filterCatego = categoria.where((f) =>

                               f.name == "Casas Inteligentes"|| 
                                f.name == "Portão Basculante"||
                                f.name == "Portão Deslizante"|| 
                                 f.name == "Portão Pivotante"||                                 
                                f.name == "Portão Deslizante"||
                               f.name == "Portas Automáticas"||
                                       f.name == "Acessórios"||
                                       f.name == "Acessórios"||
                                   f.name == "Cerca Elétrica"||
                               f.name == "Controle de Acesso"||
                             f.name == "Centrais Eletrônicas"||
                           f.name == "Kit Portão de Alumínio"||                                          
                                       f.name == "Fechaduras"

                          ).toList();

                          seleciona(finalidade);

                        });

                        Navigator.of(context).pop();

                      },
                      
                    ),

                    Padding(padding: EdgeInsets.all(8.0)),

                    GestureDetector(

                      child: Text("Empresa"),

                      onTap: () {

                        setState(() {

                          finalidade = 'Empresa';

                          filterCatego = categoria.where((f) => 
                                             f.name == "BRT" || 
                              f.name == "Casas Inteligentes" || 
                               f.name == "Portão Basculante" || 
                              f.name == "Portas Automáticas" || 
                               f.name == "Portas de Enrolar" || 
                                        f.name == "Cancelas" ||
                                      f.name == "Fechaduras" ||
                                      f.name == "Acessórios" ||
                                  f.name == "Cerca Elétrica" ||
                              f.name == "Controle de Acesso" ||
                            f.name == "Centrais Eletrônicas" ||
                          f.name == "Kit Portão de Alumínio" ||
                                          f.name == "G.Track"||
                                f.name == "Portão Pivotante"
                          ).toList();

                          seleciona(finalidade);

                        });

                        Navigator.of(context).pop();

                      },

                    ),

                    Padding(padding: EdgeInsets.all(8.0)),

                    GestureDetector(

                      child: Text("Condomínio"),

                      onTap: () {

                        setState(() {

                          finalidade = 'Condomínio';

                          filterCatego = categoria.where((f) => 
                                f.name == "Portão Deslizante"|| 
                                f.name == "Portão Basculante"||
                               f.name == "Portas Automáticas"|| 
                                         f.name == "Cancelas"||
                                       f.name == "Fechaduras"||
                                       f.name == "Acessórios"||
                                   f.name == "Cerca Elétrica"||
                               f.name == "Controle de Acesso"|| 
                             f.name == "Centrais Eletrônicas"||
                           f.name == "Kit Portão de Alumínio"||
                                          f.name == "G.Track"||
                                 f.name == "Portão Pivotante"
                          ).toList();

                           seleciona(finalidade);

                        });

                        Navigator.of(context).pop();

                      },

                    ),

                    Padding(padding: EdgeInsets.all(8.0)),

                    GestureDetector(

                      child: Text("Indústria"),

                      onTap: () {

                        setState(() {

                          finalidade = 'Indústria';

                          filterCatego = categoria.where((f) => 
                               f.name == "Portão Deslizante" || 
                               f.name == "Portão Basculante" || 
                              f.name == "Portas Automáticas" || 
                               f.name == "Portas de Enrolar" ||
                                      f.name == "Fechaduras" ||
                                      f.name == "Acessórios" ||
                                  f.name == "Cerca Elétrica" ||
                              f.name == "Controle de Acesso" ||
                            f.name == "Centrais Eletrônicas" ||
                          f.name == "Kit Portão de Alumínio" ||
                                          f.name == "G.Track"||
                                f.name == "Portão Pivotante"
                          ).toList();

                          seleciona(finalidade);

                        });

                        Navigator.of(context).pop();

                      },

                    ),

                  ],

                ),

              ),

            );

          });
    }

    Size tamanho = MediaQuery.of(context).size;

    return LocalizacaoWidget(

      child: StreamBuilder(

        builder: (BuildContext context, AsyncSnapshot snapshot) {

        return Scaffold(

          body: Center(

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

                  height: tamanho.height,

                  decoration: BoxDecoration(

                    image: DecorationImage(

                      image: AssetImage("assets/images/bg_azul.png"),

                      fit: BoxFit.cover,

                    ),

                  ),

                  child: SingleChildScrollView(

                    child: IntrinsicHeight(

                      child: Column(

                        children: [

                          Padding(

                            padding: EdgeInsets.only(top: tamanho.height * 0.05),

                            child: Text("${_locate.locale['CATALOG']['catalog-subtitle-line-1']}",

                              style: TextStyle(

                                  color: Colors.white,

                                  fontSize: 30,

                                  fontFamily: "Garen-Font",

                                  fontWeight: FontWeight.w900),

                            ),

                          ),

                          Text("${_locate.locale['CATALOG']['catalog-subtitle-line-2']}",
                            
                            style: TextStyle(

                              color: Colors.white,

                              fontSize: 30,

                              fontFamily: "Garen-Font",

                              fontWeight: FontWeight.w900

                            ),

                          ),

                          FadeInUp(
                            
                            1,

                            Padding(

                              padding: EdgeInsets.only(top: tamanho.height * 0.05),

                              child: GestureDetector(

                                onTap: () => _showChoiceDialog(context),

                                child: Container(

                                  width: tamanho.width * 0.9,

                                  height: 60,

                                  decoration: BoxDecoration(

                                    color: Colors.red[900],

                                    border: Border.all(color: Color(0xff9e0301), width: 3),

                                    borderRadius: BorderRadius.all(Radius.circular(20)),

                                    boxShadow: [

                                      BoxShadow(

                                        color: Colors.grey[800],

                                        spreadRadius: 2,

                                        blurRadius: 10,

                                        offset: Offset(0, 0),
                                       
                                      ),

                                    ],

                                  ),

                                  child: Row(

                                    children: [

                                      Flexible(

                                        flex: 1,

                                        fit: FlexFit.tight,

                                        child: Padding(padding: const EdgeInsets.only(left: 5.0),

                                          child: Text("${_locate.locale['CATALOG']['application']}",

                                            style: TextStyle(

                                                color: Colors.white,

                                                fontWeight: FontWeight.bold,

                                                fontSize: 16

                                            ),

                                          ),

                                        ),

                                      ),

                                      Flexible(

                                        flex: 2,

                                        fit: FlexFit.tight,

                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 5.0),

                                          child: Align(alignment: AlignmentDirectional.centerEnd,

                                            child: GestureDetector(

                                              onTap: () => {

                                                _showChoiceDialog(context),

                                              },

                                              child: Text(

                                                finalidade ?? "${_locate.locale['AUTOMAT']['choose']}",

                                                style: TextStyle(

                                                    color: Colors.white,

                                                    fontWeight: FontWeight.bold,

                                                    fontSize: 16),

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

                          FadeInUp(

                            5,

                            Padding(

                              padding: EdgeInsets.only(top: tamanho.height * 0.03),

                              child: Container(

                                width: tamanho.width * 0.83,

                                height: tamanho.height * 0.4,

                                decoration: BoxDecoration(

                                  color: Colors.red[900],

                                  border: Border.all(color: Color(0xff9e0301), width: 3),

                                  borderRadius: BorderRadius.all(Radius.circular(20)),

                                  boxShadow: [

                                    BoxShadow(

                                      color: Colors.grey[800],

                                      spreadRadius: 2,

                                      blurRadius: 10,

                                      offset: Offset(0, 0),

                                    ),

                                  ],

                                ),

                                child: Scrollbar(

                                  child: ListView.builder(

                                    shrinkWrap: true,

                                    itemCount: filterCatego.length,

                                    itemBuilder: (context, idx) {

                                      Cat _catego = filterCatego.elementAt(idx);
                                      
                                      return FadeInUp(

                                        idx + 5,

                                        GestureDetector(

                                          onTap: () => {

                                            Navigator.push(

                                                context,

                                                MaterialPageRoute(

                                                  builder: (context) => TelaBasculante(

                                                    categoria: _catego.name,

                                                    finalidade: finalidade,

                                                    ids: _catego.id,

                                                    categoriaId: _catego.categoriaId,

                                                  ),

                                                )

                                            )

                                          },

                                          child: Padding(padding: EdgeInsets.only(bottom: 16.0),

                                            child: Container(

                                              margin: const EdgeInsets.only(left: 20.0, right: 20.0),

                                              width: tamanho.width * 0.6,

                                              decoration: BoxDecoration(

                                                color: Color(0x00),

                                                border: Border(

                                                  bottom: BorderSide(

                                                      width: 2.0,

                                                      color: Color(0xff9e0301)),

                                                ),

                                              ),

                                              child: Column(

                                                mainAxisAlignment: MainAxisAlignment.center,

                                                crossAxisAlignment: CrossAxisAlignment.center,

                                                children: [
                                                  
                                                  Padding(padding: const EdgeInsets.only(bottom: 5.0, top: 5),

                                                    child: Text(

                                                      _catego.name,

                                                      style: TextStyle(

                                                        fontSize: 18.0,

                                                        height: 1.6,

                                                        color: Colors.white
                                                      
                                                      ),

                                                    ),
                                                    

                                                  ),
                                                  
                                                ],

                                              ),

                                            ),

                                          ),
                                                                                    
                                        
                                        ),

                                      );

                                    },

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

            ]),

          ),

        );

      }),

    );

  }

}
