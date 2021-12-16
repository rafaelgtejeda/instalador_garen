class NotificacoesListModel {
  int notCMensagem;
  String dataCriacao;
  String dataModificacao;
  String notBLida;
  String notCOrigem;
  String notNCodigo;

  NotificacoesListModel({
    this.notCMensagem,
    this.dataCriacao,
    this.dataModificacao,
    this.notBLida,
    this.notCOrigem,
    this.notNCodigo,
  });

  NotificacoesListModel.fromJson(Map<String, dynamic> json) {
    notCMensagem = json['not_c_mensagem'];
    dataCriacao = json['data_criacao'];
    dataModificacao = json['data_modificacao'];
    notBLida = json['not_b_lida'];
    notCOrigem = json['not_c_origem'];
    notNCodigo = json['not_n_codigo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['not_c_mensagem'] = this.notCMensagem;
    data['data_criacao'] = this.dataCriacao;
    data['data_modificacao'] = this.dataModificacao;
    data['not_b_lida'] = this.notBLida;
    data['not_c_origem'] = this.notCOrigem;
    data['not_n_codigo'] = this.notNCodigo;
    return data;
  }
}
