
import 'package:dio/dio.dart';
import 'package:garen/global/global.dart';

class DistribuidorServico {

  // ignore: missing_return
  Future<List> getDistribuidor() async {

    Response response;

    Dio dio = new Dio();

    var data;

    try {
      
      response = await dio.get(

        Global.linkDistribuidor,

      );

      if (response.statusCode == 200) {

        data = response.data;

        return data;

      }

      return data;

    } on DioError catch (e) {

      print(e.request);

      print(e.message);
      
    }
  }

  // ignore: missing_return
  Future<List> getDistribuidorCidade( { String cidade } ) async {

    Response response;

    Dio dio = new Dio();

    var data;

    try {
      
      response = await dio.get(

        Global.linkDistribuidor, queryParameters: {

          'cidade': cidade,

        }

      );

      if (response.statusCode == 200) {

        data = response.data;

        return data;

      }

      return data;

    } on DioError catch (e) {

      print(e.request);

      print(e.message);
      
    }

  }

  // ignore: missing_return
  Future<List> getDistribuidorEstado( { String estado } ) async {

    Response response;

    Dio dio = new Dio();

    var data;

    try {
      
      response = await dio.get(

        Global.linkDistribuidor, queryParameters: {

          'estado': estado,

        }

      );

      if (response.statusCode == 200) {

        data = response.data;

        return data;

      }

      return data;

    } on DioError catch (e) {

      print(e.request);

      print(e.message);
      
    }
    
  }

}
