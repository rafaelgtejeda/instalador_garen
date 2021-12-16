import 'package:dio/dio.dart';
import 'package:garen/global/global.dart';
import 'package:garen/utils/request.dart';

class RefreshTokenServico {
  RequestUtil _request = new RequestUtil();
  String _codigo;
  String _token;

  Future<void> getRefreshToken() async {
    _codigo = await _request.obterIdInstaladorShared();
    _token = await _request.obterTokenInstaladorShared();
    Response response;

    Dio dio = new Dio();

    var data;

    try {
      response = await dio.get(Global.linkGlobal + Global.endPointRefreshToken,
          queryParameters: {"ins_n_codigo": _codigo, "ins_c_token": _token});

      if (response.statusCode == 200) {
        data = response.data;
      }

      if (response.data == false) {
        data = null;
      }
    } on DioError catch (e) {
      print(e.request);
      print(e.message);
    }

    return data;
  }
}
