import 'package:flutter/widgets.dart';
import 'package:garen/servicos/esqueci_senha_servico.dart';

class AlteraSenhaManager extends ChangeNotifier {
  AlteraSenhaManager() {
    // _getBanner();
  }

  EsqueciSenhaServico esqueciSenhaServico = new EsqueciSenhaServico();

  Future<void> getEsqueciSenha(
      {email, Function onFail, Function onSuccess}) async {
    try {
      onSuccess(await esqueciSenhaServico.esqueciSenha(email: email));
    } catch (e) {
      onFail(await esqueciSenhaServico.esqueciSenha(email: email));
    }

    notifyListeners();
  }

  Future<void> getValidarToken(
      {email, validaToken, Function onFail, Function onSuccess}) async {
    try {
      onSuccess(await esqueciSenhaServico.validaToken(
          email: email, validaToken: validaToken));
    } catch (e) {
      onFail(await esqueciSenhaServico.validaToken(
          email: email, validaToken: validaToken));
    }

    notifyListeners();
  }

  Future<void> getAtualizarSenha(
      {email, atualizaSenha, Function onFail, Function onSuccess}) async {
    try {
      onSuccess(await esqueciSenhaServico.atualizaSenha(
          email: email, atualizaSenha: atualizaSenha));
    } catch (e) {
      onFail(await esqueciSenhaServico.atualizaSenha(
          email: email, atualizaSenha: atualizaSenha));
    }

    notifyListeners();
  }
}
