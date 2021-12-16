import 'package:flutter/widgets.dart';
import 'package:garen/servicos/refresh_token_servico.dart';

class RefreshTokenManager extends ChangeNotifier {
  // RefreshTokenManager(){

  // }

  RefreshTokenServico refreshTokenServico = new RefreshTokenServico();

  Future<void> getRefreshToken({Function onFail, Function onSuccess}) async {
    try {
      onSuccess(await refreshTokenServico.getRefreshToken());
    } catch (e) {
      onFail(await refreshTokenServico.getRefreshToken());
    }

    notifyListeners();
  }
}
