import 'package:dio/dio.dart';
import 'package:garen/global/global.dart';
import 'dart:convert';
import 'package:garen/models/usuario_cadastro.dart';
import 'package:garen/utils/request.dart';

class UsuarioService {
  UsuarioCadastroModel instaladorModel = new UsuarioCadastroModel();
  RequestUtil _request = new RequestUtil();

  String teste, teste2;
  int codigo;

  Future<Map<String, dynamic>> carregaPerfil(
      {UsuarioCadastroModel instalador, String idInstalador}) async {
    Response response;

    Dio dio = new Dio();

    var data;

    print(idInstalador);
    if (idInstalador == "nulo") {
      idInstalador = await _request.obterIdInstaladorShared();
    }

    try {
      response = await dio.get(
          Global.linkGlobal + Global.endPointBuscarInstalador,
          queryParameters: {
            "ins_n_codigo": idInstalador,
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
