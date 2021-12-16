
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:garen/models/products_woocommerce_model.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:garen/components/item-produto.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/provider/woocomerce_provider.dart';
import 'package:garen/components/animation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class TelaBasculante extends StatefulWidget {
  
  final String categoria;
  final int categoriaId;
  final int ids;
  final String finalidade;

  TelaBasculante({
    Key key, 
    @required this.categoria,
    @required this.categoriaId, 
    @required this.finalidade,
    @required this.ids
  }) : super(key: key);

  @override
  _TelaBasculanteState createState() => _TelaBasculanteState();
}

class _TelaBasculanteState extends State<TelaBasculante> {

      LocalizacaoServico _locate = new LocalizacaoServico();
  final ScrollController _scrollController = ScrollController(); 

  int _page = 1;
  int index = 1;

  @override
  void initState() {

    _locate.iniciaLocalizacao(context);  

      var productsList = Provider.of<WoocommerceProvider>(context, listen: false);

      productsList.resetStream();
      productsList.fetchProducts(_page, categoryId: widget.categoriaId);
            
    super.initState();

    print('fui');

    loadMore(productsList);
   
  }

 
  loadMore(productsList) {

       _scrollController.addListener(() {
           
          var triggerFetchMoreSize = 0.9 * _scrollController.position.maxScrollExtent;

          if (_scrollController.position.pixels > triggerFetchMoreSize) {
            productsList.setLoadingState(LoadMoreStatus.LOADING);
            productsList.fetchProducts(++_page, categoryId: widget.categoriaId);     
            print('Cheguei');
          }          

      });
      
     

      

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

          body:

            Container(

              width: tamanho.width,

              height: tamanho.height,

              decoration: BoxDecoration(

                  gradient: LinearGradient(

                  stops: [

                    0.10, 

                    0.90,

                  ],

                  begin: Alignment.topCenter,

                  end: Alignment.bottomCenter,

                  colors: [

                    Color(0xFF2B1E6D), 

                    Color(0xFF301796), 

                  ],

                  )

                ),

                child: Consumer<WoocommerceProvider>(

                  builder: (_, productModel, __) {                    

                    if (productModel.allProducts != null && productModel.allProducts.length > 0 && productModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {  
                  
                      return SingleChildScrollView(

                          child: Column(

                            children: [

                              Padding(

                                padding: const EdgeInsets.all(8.0),
                                
                                child: Text(widget.finalidade,

                                  style: TextStyle(
                                
                                    color: Colors.white, 
                                
                                    fontSize: 20

                                  )

                                ),

                              ),

                              Padding(

                                padding: const EdgeInsets.all(8.0),

                                child: Text(widget.categoria,
                                    
                                    style: TextStyle(

                                        color: Colors.white,

                                        fontSize: 25,

                                        fontWeight: FontWeight.w900

                                    )

                                ),

                              ),
                                    
                              Column(

                                children: [

                                  ListView(

                                    controller: _scrollController, 
                                                                  
                                    shrinkWrap: true,

                                    physics: const NeverScrollableScrollPhysics(),

                                    children: productModel.allProducts.map((model) {  

                                      return listaCatalogo(
                                        model: model, 
                                        productModel: productModel
                                      );

                                    }).toList()

                                  ),  

                                  Visibility(

                                    child: Container(

                                      padding: EdgeInsets.all(5),

                                      width: 35,

                                      height: 35,

                                      child: CircularProgressIndicator(),

                                    ),

                                    visible: productModel.getLoadMoreStatus() == LoadMoreStatus.LOADING,

                                  )

                                ],

                              ),

                              SizedBox(
                                height: 30,
                              )

                            ],

                          ),

                        );

                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  }

                ),

              ),

        );
        
      }),

    );

  }  
  
  Widget listaCatalogo({model, productModel}) {
    
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

          index++,

          ItemCatalogo(

            nome: model.name ?? '',
            
            foto: model.images[0].src ?? "https://img2.gratispng.com/20180422/dlw/kisspng-photography-no-symbol-film-stock-5adc94910d0b03.2271530715244053930534.jpg",
            
            nomdetalhes: "Detalhes",

            detalhes: model.permalink.toString(),            
            
            nomvista: productModel?.allProducts[0]?.downloads[0]?.name ?? '' ,
            
            vista:productModel?.allProducts[0]?.downloads[0]?.file ?? '',

            nommanual: productModel?.allProducts[0]?.downloads[1]?.name ?? '',

            manual: productModel?.allProducts[0]?.downloads[1]?.file ?? '',

            onPressdetalhess: () => {},

            onPressmanual: () => {},

            onPressvista: () => {},

          )

        ),

      ),

    );
  }

}
