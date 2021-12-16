import 'package:garen/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOffService {
  LoginModel loginModel = new LoginModel();

  Future<String> logoff() async {
    loginModel = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('ins_n_codigo');
    prefs.remove('ins_c_email');
    prefs.remove('ins_b_garen_newuser');
    prefs.remove('ins_b_garen_program');
    prefs.remove('ins_c_image');
    prefs.remove('ins_c_nome');
    prefs.remove('ins_c_telefone');
    prefs.remove('ins_c_rg');
    prefs.remove('ins_c_cpf');
    prefs.remove('ins_c_cep');
    prefs.remove('ins_c_endereco');
    prefs.remove('ins_c_numero');
    prefs.remove('ins_c_uid');
    prefs.remove('ins_cid_n_codigo');
    prefs.remove('ins_est_n_codigo');
    prefs.remove('ins_c_key');
    prefs.remove('ins_fpi_n_codigo');
    prefs.remove('ins_b_online');
    prefs.remove('ins_c_token');
    prefs.remove('ins_b_novoCadastro');

    return 'Deslogado';
  }
}
