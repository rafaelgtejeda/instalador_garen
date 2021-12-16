import 'dart:io';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'package:garen/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:garen/components/alerta.dart';
import 'package:garen/components/carregando_alerta.dart';
import 'constantes/shared_preferences_constante.dart';

class RequestUtil {
  Dio dio = new Dio(BaseOptions(
      connectTimeout: 50000,
      receiveTimeout: 30000,
      baseUrl: Global.linkGlobal));

  Dio tokenDio = new Dio(BaseOptions(
      connectTimeout: 50000,
      receiveTimeout: 30000,
      baseUrl: Global.linkGlobal));

  String baseURL = Global.linkGlobal;

  Response response = new Response();
  Response response2 = new Response();

  var connectivityResult;
  bool _estaOnline = false;

  String instaladorId, instaladorEmail, instaladorToken, novoCadastro;
  String uuidSP;

  String ddi;
  String telefone;
  String codigoAtivacao;
  String idioma;
  String model;

  bool _isloading = false;

  Future<bool> verificaOnline() async {
    return await ConnectivityWrapper.instance.isConnected;
  }

  Future<String> obterIdInstaladorShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    instaladorId = prefs.getString("ins_n_codigo");
    return instaladorId;
  }

  saveIdInstaladorShared({codigoInstalador}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("ins_n_codigo", codigoInstalador);
  }

  Future<String> obterCepShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    instaladorId = prefs.getString("ins_c_cep");
    return instaladorId;
  }

  saveCepShared({codigoInstalador}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ins_c_cep', codigoInstalador);
  }

  Future<String> obterImageIstaladorShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    instaladorId = prefs.getString("ins_c_image");
    return instaladorId;
  }

  saveImageInstaladorShared({imageInstalador}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ins_c_image', imageInstalador);
  }

  Future<String> obterEmailInstaladorShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    instaladorEmail = prefs.getString("ins_c_email");
    return instaladorEmail;
  }

  Future<String> obterTokenInstaladorShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    instaladorToken = prefs.getString("ins_c_token");
    return instaladorToken;
  }

  saveTokenInstaladorShared({tokenInstalador}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ins_c_token', tokenInstalador);
  }

  saveEmailInstaladorShared({emailInstalador}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ins_c_email', emailInstalador);
  }

  Future<String> obterTelefoneInstaladorShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    instaladorEmail = prefs.getString("ins_c_telefone");
    return instaladorEmail;
  }

  saveTelefoneInstaladorShared({telefoneInstalador}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ins_c_telefone', telefoneInstalador);
  }

  Future<String> obterNomeInstaladorShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    instaladorEmail = prefs.getString("ins_c_nome");
    return instaladorEmail;
  }

  saveNomeInstaladorShared({nomeInstalador}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ins_c_nome', nomeInstalador);
  }

  saveNovoCadastroShared({cadastroInstalador}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ins_b_novoCadastro', cadastroInstalador.toString());
  }

  Future<String> obterNovoCadastroShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    novoCadastro = prefs.getString("ins_b_novoCadastro");
    return novoCadastro;
  }

  Future<String> obterRedeSocialInstaladorShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    instaladorEmail = prefs.getString("ins_c_nome");
    return instaladorEmail;
  }

  saveRedeSocialInstaladorShared({redeSocial}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ins_b_redeSocia', redeSocial);
  }

  getUUID() async {
    var uuid = Uuid();
    return uuid.v4();
  }

  Future<String> obterUUIDSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuidSP = prefs.getString(SharedPreference.UUID);
    return uuidSP;
  }

  Future<dynamic> _carregaConfigs() async {
    tokenDio.options = dio.options;

    _estaOnline = await verificaOnline();
  }

  Future<String> getDeviceModel() async {
    
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
      model = androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"s
      model = iosInfo.utsname.machine;
    }

    return model;
  }

  Future<dynamic> getReq(
      {@required String endpoint,
      @required dynamic data,
      BuildContext context,
      bool loading = false,
      String mensagemErro = '',
      bool ignorarArmazenamentoAutomatico = false,
      bool sincronizacao = false}) async {
    _isloading = loading;

    if (_isloading) CarregandoAlertaComponente().showCarregar(context);

    await _carregaConfigs();

    if (_estaOnline) {
      print('Estou Online');

      try {
        response = await dio.get(
          endpoint,
          queryParameters: data,
          options: Options(
              headers: {
                'Content-Type': 'application/json',
                //HttpHeaders.authorizationHeader: 'Bearer ' + token,
              },
              followRedirects: true,
              receiveDataWhenStatusError: true,
              validateStatus: (status) {
                return status <= 500;
              }),
        );

        if (response.statusCode == 401) {
          response = await dio.get(endpoint,
              queryParameters: data,
              options: Options(
                  headers: {
                    'Content-Type': 'application/json',
                    HttpHeaders.authorizationHeader:
                        'Bearer ' + response2.data['entidade']['token'],
                  },
                  followRedirects: true,
                  receiveDataWhenStatusError: true,
                  validateStatus: (status) {
                    // if(_isloading) CarregandoAlertaComponente().dismissCarregar(context);
                    return status <= 500;
                  }));

          print('401: ${response2.data['entidade']['token']}');

          if (_isloading) CarregandoAlertaComponente().dismissCarregar(context);
          if (response.data['entidade'] != {} ||
              response.data['entidade'] != null) {
            return response.data['entidade'];
          } else {
            return response;
          }
        } else if (response.statusCode == 400) {
          print(response);
          print(response.statusCode);
          // CarregandoAlertaComponente().dismissCarregar(context);
          AlertaComponente().showAlertaErro(
              context: context,
              mensagem: mensagemErro != '' ? mensagemErro : 'Erro400',
              localedMessage: mensagemErro != '' ? false : true);
          return response;
        } else {
          if (_isloading) CarregandoAlertaComponente().dismissCarregar(context);
          // print(response);
          // print(response.statusCode);
          if (response.data['entidade'] == {} ||
              response.data['entidade'] == null) {
            return response;
          } else {
            return response.data['entidade'];
          }
        }
      } catch (error, stacktrace) {
        // if (loading) CarregandoAlertaComponente().dismissCarregar(context);
        await AlertaComponente().showAlertaErro(
            context: context,
            mensagem: mensagemErro != '' ? mensagemErro : 'Erro400',
            localedMessage: mensagemErro == '');
        print("Uma excessção aconteceu: $error | StackTrace: $stacktrace");
        return response;
      }
    } else {
      debugPrint('Estou Offline');
    }
  }
}
