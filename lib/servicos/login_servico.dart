import 'package:garen/models/login_model.dart';
import 'package:garen/global/global.dart';
import 'package:dio/dio.dart';

class LoginService {
  
  LoginModel loginModel = new LoginModel();

  Future<Map<String, dynamic>> login({LoginModel loginModel}) async {

    Response response;

    Dio dio = new Dio();

    var data;

    try {

      response = await dio.get(Global.linkGlobal + Global.endPointLogin,

        queryParameters: {

             "ins_c_email": loginModel.insCEmail,

          "ins_c_password": loginModel.insCPassword

        }

      );

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
