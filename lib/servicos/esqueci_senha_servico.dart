import 'package:garen/global/global.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class EsqueciSenhaServico {
  Future<Map<String, dynamic>> esqueciSenha({String email}) async {
    Response response;

    Dio dio = new Dio();

    var data;

    try {
      response = await dio.post(
        Global.linkGlobal + Global.endPointEsqueciSenha,
        data: {"ins_c_email": email},
      );

      if (response.statusCode == 200) {
        data = json.decode(response.data);
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

  Future<Map<String, dynamic>> atualizaSenha(
      {String email, String atualizaSenha}) async {
    Response response;

    Dio dio = new Dio();

    var data;

    try {
      response =
          await dio.post(Global.linkGlobal + Global.endPointUpdateSenha, data: {
        "ins_c_email": email,
        "ins_c_password": atualizaSenha,
      });

      if (response.statusCode == 200) {
        data = json.decode(response.data);
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

  Future<Map<String, dynamic>> validaToken(
      {String email, String validaToken}) async {
    Response response;

    Dio dio = new Dio();

    var data;

    try {
      response = await dio
          .post(Global.linkGlobal + Global.endPointValidarTokenSenha, data: {
        "ins_c_email": email,
        "ins_c_tokenValidacao": validaToken,
      });

      if (response.statusCode == 200) {
        data = json.decode(response.data);
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
