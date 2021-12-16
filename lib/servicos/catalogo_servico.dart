import 'package:garen/models/catalogo_model.dart';
import 'package:dio/dio.dart';
import 'package:garen/global/global.dart';

class CatalogoServico {

  Future<List> getCatalogo({String categoria, String finalidades}) async {

    Response response;

    Dio dio = new Dio();

    var data;

    try {

      response = await dio.get(Global.linkCatalogo, queryParameters: {

        'categoria_prod': categoria,

        'finalidades': finalidades

      });

      if (response.statusCode == 200) {

        data = response.data;

      }

      if (response.data == null) {

        data = null;

      }

    } on DioError catch (e) {

      print(e.request);

      print(e.message);

    }

    return data;
  }

  Future<List> getAutomatizadores(
    {
      String abertura, 
      String fluxo_de_uso, 
      String velocidade, 
      String comprimento_da_folha
    }) async {

    Response response;

    Dio dio = new Dio();

    var data;

    try {

      response = await dio.get(Global.linkCatalogo, queryParameters: {

        'abertura': abertura,
        'velocidade': velocidade,
        'fluxo_de_uso': fluxo_de_uso,
        'comprimento_da_folha': comprimento_da_folha

      });

      if (response.statusCode == 200) {

        data = response.data;

      }

      if (response.data == null) {

        data = null;

      }

    } on DioError catch (e) {

      print(e.request);

      print(e.message);

    }

    return data;
  }

  Future<List<CatalogoModel>> getProdutos({CatalogoModel catalogo}) async {

    Response response;

    Dio dio = new Dio();

    var data;

    try {
      response = await dio.get(Global.linkProdutos, queryParameters: {});

      if (response.statusCode == 200) {

        List<dynamic> jsonResponse = response.data;

        data = jsonResponse.map((job) => new CatalogoModel.fromJson(job)).toList();

      }

      if (response.data == null) {

        data = null;

      }

    } on DioError catch (e) {

      print(e.request);

      print(e.message);

    }

    return data;
  }

  Future<List<CatalogoModel>> getProduto({String catalogo}) async {
    
    Response response;

    Dio dio = new Dio();

    var data;

    try {
      response = await dio.get(Global.linkProdutos, queryParameters: {});

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = response.data;
        data =
            jsonResponse.map((job) => new CatalogoModel.fromJson(job)).toList();
      }

      if (response.data == null) {
        data = null;
      }
    } on DioError catch (e) {
      print(e.request);
      print(e.message);
    }

    return data;

  }

  Future<List<CatalogoModel>> getProdutosEspecificadores(
    
    {
      String abertura,
      String fluxo,
      String velocidade,
      String comprimento
    }

  ) async {

    Response response;

    Dio dio = new Dio();

    var data;

    try {

      response = await dio.get(Global.linkProdutos, queryParameters: {});

      if (response.statusCode == 200) {
        
        List<dynamic> jsonResponse = response.data;
        data = jsonResponse.map((job) => new CatalogoModel.fromJson(job)).toList();
      }

      if (response.data == null) {

        data = null;

      }

    } on DioError catch (e) {

      print(e.request);

      print(e.message);

    }

    return data;

  }

}
