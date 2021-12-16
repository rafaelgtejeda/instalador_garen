import 'package:flutter/cupertino.dart';
import 'package:garen/models/distribuidor_model.dart';
import 'package:garen/servicos/distribuidor_servico.dart';

class DistribuidorManager extends ChangeNotifier {
  
  DistribuidorManager() {
    // _getBanner();
  }

  DistribuidorServico distribuidorServico = new DistribuidorServico();

  Future<void> getDistribuidor(

    {

      Function onSuccess,

      DistribuidorModel distribuidor,      

      Function onFail

    }

  ) async {

    try {

      onSuccess(await distribuidorServico.getDistribuidor());

    } catch (e) {

      onFail(await distribuidorServico.getDistribuidor());

    }

    // notifyListeners();
  }

  Future<void> getDistribuidorCidade(

    {

      String cidade,

      Function onSuccess,

      Function onFail        

    }

  ) async {

    try {

      onSuccess(await distribuidorServico.getDistribuidorCidade(cidade: cidade));

    } catch (e) {

      onFail(await distribuidorServico.getDistribuidorCidade(cidade: cidade));

    }

    // notifyListeners();

  }

}
