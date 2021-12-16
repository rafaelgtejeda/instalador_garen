import 'package:dio/dio.dart';
import 'package:garen/global/global.dart';
import 'package:garen/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:garen/models/usuario_cadastro.dart';
import 'package:garen/utils/request.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class CadastroService {
  var uuid = Uuid();

  UsuarioCadastroModel cadastroModel = new UsuarioCadastroModel();
  RequestUtil _requestUtil = new RequestUtil();

  Future<Map<String, dynamic>> cadastro(
      {UsuarioCadastroModel cadastroModel}) async {
    Dio dio = new Dio();

    Response response;

    var data;

    String token = await _requestUtil.obterTokenInstaladorShared();
    print("=====================");
    print(cadastroModel.toString());
    print("=====================");
    try {
      response = await dio.get(Global.linkGlobal + Global.endPointCadastro, queryParameters: {

        "ins_c_email": cadastroModel.insCEmail,
        "ins_c_password": cadastroModel.insCPassword,
        "ins_c_image": cadastroModel.insCImage,
        "ins_c_nome": cadastroModel.insCNome,
        "ins_c_telefone": cadastroModel.insCTelefone,
        "ins_est_n_codigo": cadastroModel.insEstNCodigo,
        "ins_cid_n_codigo": cadastroModel.insCidNCodigo,
        "ins_c_uid": cadastroModel.insCUid,
        "ins_c_key": uuid.v4(),
        "ins_c_token": token,
        "ins_c_cep": cadastroModel.insCCEP,
        "ins_c_idGoogle": cadastroModel.insCIdGoogle,
        "ins_b_redeSocial": cadastroModel.insBRedeSocia,
        "ins_c_idFacebook": cadastroModel.insCIdFacebook,
        "ins_b_novoCadastro": cadastroModel.insBNovoCadastro

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

  Future<Map<String, dynamic>> atualizaPerfil({UsuarioCadastroModel cadastroModel}) async {
    
    Response response;

    Dio dio = new Dio();

    var data;

    String token = await _requestUtil.obterTokenInstaladorShared();

    try {
      response = await dio.get(
        
        Global.linkGlobal 
        + 
        Global.endPointCadastro, 
        
        queryParameters: {

          "ins_c_nome": cadastroModel.insCNome,

          "ins_c_image": cadastroModel.insCImage,

          "ins_c_email": cadastroModel.insCEmail,

          "ins_c_telefone": cadastroModel.insCTelefone,

          "ins_est_n_codigo": cadastroModel.insEstNCodigo,

          "ins_cid_n_codigo": cadastroModel.insCidNCodigo,

          "ins_c_password": cadastroModel.insCPassword,

          "ins_c_uid": cadastroModel.insCUid,

          "ins_c_key": uuid.v4(),

          "ins_c_token": token,

          "ins_b_redeSocial": cadastroModel.insBRedeSocia,

          "ins_b_novoCadastro": cadastroModel.insBNovoCadastro,

          "ins_c_idFacebook": cadastroModel.insCIdFacebook,

          "ins_c_idGoogle": cadastroModel.insCIdGoogle

        }

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

  Future<Map<String, dynamic>> atualizaCadastro(
      {UsuarioCadastroModel cadastroModel}) async {
    Dio dio = new Dio();

    Response response;

    var data;

    String token = await _requestUtil.obterTokenInstaladorShared();
    String codigo = await _requestUtil.obterIdInstaladorShared();

    try {
      response = await dio
          .post(Global.linkGlobal + Global.endPointAtualizaCadastro, data: {
        "ins_n_codigo": codigo,
        "ins_c_email": cadastroModel.insCEmail,
        "ins_c_password": cadastroModel.insCPassword,
        "ins_c_image": cadastroModel.insCImage,
        "ins_c_nome": cadastroModel.insCNome,
        "ins_c_telefone": cadastroModel.insCTelefone,
        "ins_est_n_codigo": cadastroModel.insEstNCodigo,
        "ins_cid_n_codigo": cadastroModel.insCidNCodigo,
        "ins_c_uid": cadastroModel.insCUid,
        "ins_c_key": uuid.v4(),
        "ins_c_token": token,
        "ins_b_redeSocial": cadastroModel.insBRedeSocia,
        "ins_b_novoCadastro": cadastroModel.insBNovoCadastro,
        "ins_c_idFacebook": cadastroModel.insCIdFacebook,
        "ins_c_idGoogle": cadastroModel.insCIdGoogle,
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

  Future<void> salvaInstaladorCadastroSP(cadastro) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    LoginModel instalador = LoginModel.fromJson(cadastro);

    await prefs.setString('ins_n_codigo', instalador.insNCodigo);
    await prefs.setString('ins_c_email', instalador.insCEmail);
    await prefs.setString('ins_b_garen_newuser', instalador.insBGarenNewuser);
    await prefs.setString('ins_b_garen_program', instalador.insBGarenProgram);
    await prefs.setString('ins_c_image', instalador.insCImage);
    await prefs.setString('ins_c_nome', instalador.insCNome);
    await prefs.setString('ins_c_telefone', instalador.insCTelefone);
    await prefs.setString('ins_c_rg', instalador.insCRg);
    await prefs.setString('ins_c_cpf', instalador.insCCpf);
    await prefs.setString('ins_c_cep', instalador.insCCep);
    await prefs.setString('ins_c_endereco', instalador.insCEndereco);
    await prefs.setString('ins_c_numero', instalador.insCNumero);
    await prefs.setString('ins_c_uid', instalador.insCUid);
    await prefs.setString('ins_cid_n_codigo', instalador.insCidNCodigo);
    await prefs.setString('ins_est_n_codigo', instalador.insEstNCodigo);
    await prefs.setString('ins_c_key', instalador.insCKey);
    await prefs.setString('ins_fpi_n_codigo', instalador.insFpiNCodigo);
    await prefs.setString('ins_b_online', instalador.insBOnline);
  }
}
