import 'package:flutter/widgets.dart';
import 'package:garen/servicos/editar_perfil_servico.dart';

class EditarPerfilManager extends ChangeNotifier {
  EditarPerfilManager() {
    // _getBanner();
  }

  EditarPerfilServico editarPerfilServico = new EditarPerfilServico();

  Future<void> getAtualiza(
      {String nome,
      String email,
      String image,
      String telefone,
      String cep,
      String estCod,
      String cidCod,
      Function onFail,
      Function onSuccess}) async {
    try {
      onSuccess(await editarPerfilServico.atualizarPerfil(
          nome: nome,
          email: email,
          image: image,
          telefone: telefone,
          cep: cep,
          estCod: estCod,
          cidCod: cidCod));
    } catch (e) {
      onFail(await editarPerfilServico.atualizarPerfil(
          nome: nome,
          email: email,
          image: image,
          telefone: telefone,
          cep: cep,
          estCod: estCod,
          cidCod: cidCod));
    }

    notifyListeners();
  }
}
