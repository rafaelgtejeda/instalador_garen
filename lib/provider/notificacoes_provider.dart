import 'package:flutter/widgets.dart';
import 'package:garen/servicos/notification_servico.dart';

class NotificacoesManager extends ChangeNotifier {
  // NotificacoesManager(){

  // }

  NotificacaoServico notificationService = new NotificacaoServico();

  Future<void> notificacaoContador(
      {String idInstalador, Function onFail, Function onSuccess}) async {
    try {
      onSuccess(await notificationService.getNotificationCount(
          idInstalador: idInstalador));
    } catch (e) {

      onFail(await notificationService

        .getNotificationCount(
          idInstalador: idInstalador
        )

      );

    }

    notifyListeners();
    
  }

  Future<void> getNotificacoes({Function onFail, Function onSuccess}) async {
    try {
      onSuccess(await notificationService.getNotificacoes());
    } catch (e) {
      onFail(await notificationService.getNotificacoes());
    }

    notifyListeners();
  }

// ignore: missing_return
  Future<bool> getExcluiNotificacao(
      {Function onFail, Function onSuccess, String idNotificacao}) async {
    try {
      onSuccess(await notificationService.getExcluiNotificacao(
          idNotificacao: idNotificacao));
    } catch (e) {
      onFail(await notificationService.getExcluiNotificacao(
          idNotificacao: idNotificacao));
    }

    notifyListeners();
  }

// ignore: missing_return
  Future<bool> setUpdateNotificacao(
      {Function onFail, Function onSuccess, String idNotificacao}) async {
    try {
      onSuccess(await notificationService.setUpdateNotificacao(
          idNotificacao: idNotificacao));
    } catch (e) {
      onFail(await notificationService.setUpdateNotificacao(
          idNotificacao: idNotificacao));
    }

    notifyListeners();
  }
}
