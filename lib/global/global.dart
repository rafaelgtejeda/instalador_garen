class Global {
        static const String linkGlobal = "http://appgaren.portaliconnect.com.br/api";
     static const String linkWordpress = "https://garen.com.br/wp-json/api-instalador/v1";

  static const String linkDistribuidor = linkWordpress + "/distribuidores";
      static const String linkProdutos = linkWordpress + "/produtos";
      static const String linkCatalogo = linkWordpress + "/catalogo";

                 static const String controller = "/CadastroInstalador";

     static const String endPointSalvaOrcamento = controller + "/SalvaOrcamento";
     static const String endPointListaOrcamento = controller + "/ListaOrcamento";
  static const String endPointRecuperaOrcamento = controller + "/recuperaOrcamento";
  static const String endPointAtualizaOrcamento = controller + "/AtualizaOrcamento";
    static const String endPointDeletaOrcamento = controller + "/DeletaOrcamento";

          static const String endPointGetBanner = controller + "/getBanner";
    static const String endPointCountNoticacoes = controller + "/CountNoticacoes";
    static const String endPointBuscaNoticacoes = controller + "/BuscaNoticacoes";

              static const String endPointLogin = controller + "/login";

       static const String endPointEsqueciSenha = controller + "/EsqueciSenha";
        static const String endPointUpdateSenha = controller + "/UpdateSenha";
  static const String endPointValidarTokenSenha = controller + "/ValidaTokenSenha";

           static const String endPointCadastro = controller + "/SalvarCadastro";
   static const String endPointAtualizaCadastro = controller + "/AtualizaCadastro";
     static const String endPointAtualizaPerfil = controller + "/AtualizaPerfil";
   static const String endPointBuscarInstalador = controller + "/BuscarInstalador";

  static const String endPointDeleteNotificacao = controller + "/deleteNotificacao";
  static const String endPointUpdateNotificacao = controller + "/marcaComoLido";
       static const String endPointRefreshToken = controller + "/RefreshTokenInstalador";

                   static const String CorGaren = "004370";
                  static const String Copyright = "Todos os direito reservados.\n 2020";
                     static const String Versao = "v2.0.2";
}

class ConfigIdioma {

                     static const String ENGLISH_US = "en";
                  static const String ESPANOL_ESP = "es";
           static const String PORTUGUES_BRASIL = "pt";
        static const String ENGLISH_US_TOOLTIP = "English - US";
        static const String ESPANOL_ESP_TOOLTIP = "Español - España";
    static const String PORTUGUES_BRASIL_TOOLTIP = "Português - Brasil";

}
