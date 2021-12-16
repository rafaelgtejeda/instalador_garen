import 'package:garen/models/login_model.dart';
import 'package:garen/global/global.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:garen/utils/request.dart';

class EditarPerfilServico {

  String id;

  RequestUtil _request = new RequestUtil();

  LoginModel loginModel = new LoginModel();

  Future<Map<String, dynamic>> atualizarPerfil(
    
    {

      String nome,

      String email,

      String image,

      String telefone,

      String cep,

      String estCod,

      String cidCod

    }

  ) async {

    id = await _request.obterIdInstaladorShared();

    Response response;

    Dio dio = new Dio();

    var data;

    try {

      response = await dio.post(Global.linkGlobal + Global.endPointAtualizaPerfil, data: {
        
        "ins_n_codigo": id,
        
        "ins_c_nome": nome,
        
        "ins_c_email": email,
        
        "ins_c_image": image,
        
        "ins_c_telefone": telefone,
        
        "ins_c_cep": cep,
        
        "ins_est_n_codigo": estCod,
                
        "ins_cid_n_codigo": cidCod

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
