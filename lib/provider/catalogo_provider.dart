import 'package:flutter/widgets.dart';
import 'package:garen/servicos/catalogo_servico.dart';

class CatalogoManager extends ChangeNotifier {
  
  CatalogoManager() {
    //Catalogo
  }

  CatalogoServico categoService = new CatalogoServico();

  CatalogoServico catalogoService = new CatalogoServico();

  Future<void> getCatalogo({Function onFail, Function onSuccess}) async {

    try {
      onSuccess(await categoService.getCatalogo());
    } catch (e) {
      onFail(await categoService.getCatalogo());
    }

    // notifyListeners();

  }

  Future<void> getProdutos({Function onFail, Function onSuccess}) async {
    try {
      onSuccess(await categoService.getProdutos());
    } catch (e) {
      onFail(await categoService.getProdutos());
    }

    notifyListeners();
  }

  Future<void> getProdutosEspecificadores(
      {String abertura,
      String fluxo,
      String velocidade,
      String comprimento,
      Function onFail,
      Function onSuccess}) async {
    try {
      onSuccess(await categoService.getProdutosEspecificadores(
          abertura: abertura,
          fluxo: fluxo,
          velocidade: velocidade,
          comprimento: comprimento));
    } catch (e) {
      onFail(await categoService.getProdutosEspecificadores(
          abertura: abertura,
          fluxo: fluxo,
          velocidade: velocidade,
          comprimento: comprimento));
    }

    notifyListeners();
  }
}
