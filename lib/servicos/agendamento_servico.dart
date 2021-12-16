import 'package:dio/dio.dart';
import 'package:garen/global/global.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class AgendamentoService {
  var uuid = Uuid();

  Future<Map<String, dynamic>> getAgendamento() async {
    Response response;

    Dio dio = new Dio();

    var data;

    try {
      response = await dio.get(Global.linkGlobal + Global.endPointGetBanner,
          queryParameters: {});

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

    return json.decode(data);
  }
}
