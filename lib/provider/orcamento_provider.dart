import 'package:flutter/widgets.dart';
import 'package:garen/servicos/orcamento_servico.dart';
import 'package:garen/models/orcamento_model.dart';

class OrcamantoManager extends ChangeNotifier {
  OrcamantoManager() {
    // _getOrcamento();
  }

  OrcamentoServico orcamentoService = new OrcamentoServico();

  Future<void> salvaOrcamento(
      {OrcamentoModel orcamento, Function onSuccess, Function onFail}) async {
    try {
      onSuccess(await orcamentoService.salvaOrcamento(orcamento: orcamento));
    } catch (e) {
      onFail(await orcamentoService.salvaOrcamento(orcamento: orcamento));
    }

    notifyListeners();
  }

  Future<void> getOrcamento(
      {OrcamentoModel orcamento, Function onSuccess, Function onFail}) async {
    try {
      onSuccess(await orcamentoService.getOrcamento(orcamento: orcamento));
    } catch (e) {
      onFail(await orcamentoService.getOrcamento(orcamento: orcamento));
    }

    notifyListeners();
  }

  Future<void> recuperaOrcamento(
      {OrcamentoModel orcamento, Function onSuccess, Function onFail}) async {
    try {
      onSuccess(await orcamentoService.recuperaOrcamento(orcamento: orcamento));
    } catch (e) {
      onFail(await orcamentoService.recuperaOrcamento(orcamento: orcamento));
    }

    notifyListeners();
  }

  Future<void> atualizaOrcamento(
      {OrcamentoModel orcamento, Function onSuccess, Function onFail}) async {
    try {
      onSuccess(await orcamentoService.atualizaOrcamento(orcamento: orcamento));
    } catch (e) {
      onFail(await orcamentoService.atualizaOrcamento(orcamento: orcamento));
    }

    notifyListeners();
  }

  Future<void> deletaOrcamento(
      {OrcamentoModel orcamento, Function onSuccess, Function onFail}) async {
    try {
      onSuccess(await orcamentoService.deletaOrcamento(orcamento: orcamento));
    } catch (e) {
      onFail(await orcamentoService.deletaOrcamento(orcamento: orcamento));
    }

    notifyListeners();
  }
}
