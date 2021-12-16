import 'package:garen/models/ibge_estado_model.dart';
import 'package:http/http.dart' as http;

class IbgeEstadoService {
  static Future<IgbeEstadoModel> fetchIBGE({String ibge}) async {
    final response = await http.get(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$ibge');
    if (response.statusCode == 200) {
      return IgbeEstadoModel.fromJson(response.body);
    } else {
      throw Exception('Requisição inválida!');
    }
  }
}
