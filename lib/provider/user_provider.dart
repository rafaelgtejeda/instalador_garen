import 'package:flutter/widgets.dart';
import 'package:garen/models/login_model.dart';
import 'package:garen/servicos/usuario_servico.dart';
import 'package:garen/servicos/cadastro_servico.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:garen/models/usuario_cadastro.dart';
import 'package:garen/servicos/login_servico.dart';
import 'package:garen/utils/request.dart';

class UserManager extends ChangeNotifier {

  UserManager() {
    _carregaUsuario();
  }

  LoginModel login;

  LoginService loginService = new LoginService();
  CadastroService cadastroService = new CadastroService();
  UsuarioService usuarioService = new UsuarioService();

  RequestUtil _requestUtil = new RequestUtil();

  bool get isLoggedIn => login != null;

  Future<void> autenticar({LoginModel login, Function onFail, Function onSuccess}) async {
    try {
      onSuccess(await loginService.login(loginModel: login));

      if (await loginService.login(loginModel: login) != null) {
        _salvaInstaladorLoginSP(await loginService.login(loginModel: login));
      }
    } catch (e) {
      onFail(await loginService.login(loginModel: login));
    }
  }

  Future<void> cadastro({UsuarioCadastroModel cadastro, Function onFail, Function onSuccess}) async {
    try {
      onSuccess(await cadastroService.cadastro(cadastroModel: cadastro));

      if (await cadastroService.cadastro(cadastroModel: cadastro) != null) {
        _salvaInstaladorCadastroSP(
            await cadastroService.cadastro(cadastroModel: cadastro));
      }
    } catch (e) {
      onFail(await cadastroService.cadastro(cadastroModel: cadastro));
    }
  }

  Future<void> atualizaCadastro({UsuarioCadastroModel cadastro, Function onFail, Function onSuccess}) async {
    try {
      onSuccess(
          await cadastroService.atualizaCadastro(cadastroModel: cadastro));

      if (await cadastroService.cadastro(cadastroModel: cadastro) != null) {
        _salvaInstaladorCadastroSP(
            await cadastroService.atualizaCadastro(cadastroModel: cadastro));
      }
    } catch (e) {
      onFail(await cadastroService.atualizaCadastro(cadastroModel: cadastro));
    }
  }

  Future<void> _carregaUsuario() async {

    _requestUtil.obterNomeInstaladorShared();
    _requestUtil.obterEmailInstaladorShared();
    _requestUtil.obterTelefoneInstaladorShared();
    _requestUtil.obterImageIstaladorShared();
    _requestUtil.obterCepShared();

    notifyListeners();
  }

  Future<void> buscaInstalador({UsuarioCadastroModel instalador, Function onFail, Function onSuccess}) async {

    try {
      onSuccess(await usuarioService.carregaPerfil(instalador: instalador));
    } catch (e) {
      onFail(await usuarioService.carregaPerfil(instalador: instalador));
    }

  }

  void sair() {

     login = null;
    _removeUsuarioSP();
     notifyListeners();
  }

  Future<void> _salvaInstaladorLoginSP(login) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    LoginModel instalador = LoginModel.fromJson(login);

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

    notifyListeners();
  }

  Future<void> _salvaInstaladorCadastroSP(cadastro) async {
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

    notifyListeners();
  }

  Future<void> _removeUsuarioSP() async {
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
  }
}
