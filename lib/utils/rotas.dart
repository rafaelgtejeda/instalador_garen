import 'package:flutter/material.dart';

class Rotas {
  static void vaParaLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/login");
  }

  static void vaParaCadastro(BuildContext context) {
    Navigator.pushNamed(context, "/cadastro");
  }

  static void vaParaNotificacao(BuildContext context) {
    Navigator.pop(context);
  }
}
