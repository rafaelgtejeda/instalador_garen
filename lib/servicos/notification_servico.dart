import 'package:dio/dio.dart';
import 'package:garen/global/global.dart';
import 'package:garen/models/notificacao_list_model.dart';
import 'package:garen/utils/request.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class NotificacaoServico {
  
  RequestUtil _request = new RequestUtil();

  String _codigo;

  var uuid = Uuid();

  Future<int> getNotificationCount(
      {String instaladorCodigo, String idInstalador}) async {
    if (idInstalador == "nulo") {
      idInstalador = await _request.obterIdInstaladorShared();
      _codigo = idInstalador;
    }

    Response response;

    Dio dio = new Dio();

    var data;

    try {
      response = await dio.get(
          Global.linkGlobal + Global.endPointCountNoticacoes,
          queryParameters: {"ins_n_codigo": _codigo});

      if (response.statusCode == 200 && response.data != false) {
        data = json.decode(response.data);
      }
    } on DioError catch (e) {
      print(e.request);
      print(e.message);
    }

    return response.data == false ? 0 : data["total"];
  }

  Future<Map<String, dynamic>> getNotificacoes(
      {NotificacoesListModel notificacoes, String idInstalador}) async {
    _codigo = await _request.obterIdInstaladorShared();
    Response response;

    Dio dio = new Dio();

    if (idInstalador == "nulo") {
      idInstalador = await _request.obterIdInstaladorShared();
      _codigo = idInstalador;
    }

    var data;

    try {
      response = await dio.get(
          Global.linkGlobal + Global.endPointBuscaNoticacoes,
          queryParameters: {"ins_n_codigo": _codigo});

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

  Future<bool> getExcluiNotificacao({String idNotificacao}) async {
    Response response;

    Dio dio = new Dio();

    var data;

    try {
      response = await dio.get(
          Global.linkGlobal + Global.endPointDeleteNotificacao,
          queryParameters: {"ins_c_uid": idNotificacao});

      if (response.statusCode == 200 && response.data != false) {
        data = response.data;
      }

      if (response.data == false) {
        data = false;
      }
    } on DioError catch (e) {
      print(e.request);
      print(e.message);
    }
    return data;
  }

  Future<bool> setUpdateNotificacao({String idNotificacao}) async {
    Response response;

    Dio dio = new Dio();

    var data;

    try {
      response = await dio.get(
          Global.linkGlobal + Global.endPointUpdateNotificacao,
          queryParameters: {"ins_c_uid": idNotificacao});

      if (response.statusCode == 200 && response.data != false) {
        data = response.data;
      }

      if (response.data == false) {
        data = false;
      }
    } on DioError catch (e) {
      print(e.request);
      print(e.message);
    }
    return data;
  }
}
